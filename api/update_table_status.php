<?php
/**
 * API Endpoint: Update Table Status
 * 
 * Updates the status of a table and notifies connected clients
 */

// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Content-Type: application/json');

// Include database connection and WebSocket functions
require_once '../config/database.php';
require_once 'websocket_trigger.php';

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method'
    ]);
    exit;
}

// Get table ID and status from POST data
$table_id = isset($_POST['table_id']) ? intval($_POST['table_id']) : 0;
$status = isset($_POST['status']) ? strtoupper($_POST['status']) : '';

// Validate input
if ($table_id <= 0) {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid table ID'
    ]);
    exit;
}

if (!in_array($status, ['AVAILABLE', 'OCCUPIED', 'READY', 'CLEANING'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid status value'
    ]);
    exit;
}

try {
    // Get table info before update
    $tableStmt = $conn->prepare("SELECT * FROM tables WHERE table_id = ?");
    $tableStmt->execute([$table_id]);
    $table = $tableStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$table) {
        // Table not found
        echo json_encode([
            'success' => false,
            'message' => 'Table not found'
        ]);
        exit;
    }
    
    // Only update if the status is different
    if ($table['status'] === $status) {
        echo json_encode([
            'success' => true,
            'message' => 'Table status is already ' . $status
        ]);
        exit;
    }
    
    // Special case: If setting table to AVAILABLE, check for active orders
    if ($status === 'AVAILABLE') {
        $ordersStmt = $conn->prepare("
            SELECT COUNT(*) as count FROM orders 
            WHERE table_id = ? AND status IN ('PAID', 'PREPARING', 'READY')
        ");
        $ordersStmt->execute([$table_id]);
        $orderCount = $ordersStmt->fetch(PDO::FETCH_ASSOC)['count'];
        
        if ($orderCount > 0) {
            echo json_encode([
                'success' => false,
                'message' => 'Cannot mark table as available while there are active orders'
            ]);
            exit;
        }
    }
    
    // Update table status
    $updateStmt = $conn->prepare("UPDATE tables SET status = ? WHERE table_id = ?");
    $result = $updateStmt->execute([$status, $table_id]);
    
    if ($result) {
        // Log the table status change
        $logStmt = $conn->prepare("
            INSERT INTO system_logs (action, description, ip_address)
            VALUES ('TABLE_STATUS', ?, ?)
        ");
        $logStmt->execute([
            "Table {$table['table_number']} status changed from {$table['status']} to {$status}",
            $_SERVER['REMOTE_ADDR']
        ]);
        
        // Notify connected clients about table status change
        notify_table_status_change($table_id, $table['table_number'], $status);
        
        // Return success response
        echo json_encode([
            'success' => true,
            'message' => 'Table status updated successfully',
            'old_status' => $table['status'],
            'new_status' => $status
        ]);
    } else {
        // Update failed
        echo json_encode([
            'success' => false,
            'message' => 'Failed to update table status'
        ]);
    }
    
} catch (PDOException $e) {
    // Log and return error
    error_log('API Error: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'An error occurred while updating table status'
    ]);
}
?> 