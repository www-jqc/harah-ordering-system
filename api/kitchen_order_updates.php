<?php
/**
 * Server-Sent Events (SSE) endpoint for kitchen order updates
 * This script provides real-time order updates to the kitchen interface
 */

// Set headers for SSE
header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');
header('Connection: keep-alive');
header('X-Accel-Buffering: no'); // Disable buffering for Nginx

// Include database connection
require_once '../config/database.php';

// Flush headers
ob_implicit_flush(true);
ob_end_flush();

// Keep track of the last order id processed
$lastOrderId = getLastOrderId($conn);
$lastStatusUpdate = getLastStatusUpdate($conn);

// Send initial message
sendMessage('connected', ['message' => 'Kitchen SSE connected'], 'connection');

// Loop to check for updates
while (true) {
    // Get new orders
    $newOrders = checkForNewOrders($conn, $lastOrderId);
    if (!empty($newOrders)) {
        // Update the last order id
        $lastOrderId = max(array_column($newOrders, 'order_id'));
        
        // Send the new orders event
        sendMessage('new_orders', ['orders' => $newOrders], 'order_update');
    }
    
    // Check for status updates
    $statusUpdates = checkForStatusUpdates($conn, $lastStatusUpdate);
    if (!empty($statusUpdates)) {
        // Update the last status update time
        $lastStatusUpdate = max(array_column($statusUpdates, 'updated_at'));
        
        // Send the status updates event
        sendMessage('status_updates', ['updates' => $statusUpdates], 'order_update');
    }
    
    // Flush the output to make sure the data is sent to the client
    if (ob_get_level() > 0) {
        ob_flush();
    }
    flush();
    
    // Sleep for a second before checking again
    sleep(1);
    
    // Send a keep-alive comment to prevent connection timeouts
    echo ": keepalive\n\n";
    
    // Check if the client is still connected
    if (connection_aborted()) {
        break;
    }
}

/**
 * Send an SSE message
 * 
 * @param string $id Message ID
 * @param array $data Message data
 * @param string $event Event name
 */
function sendMessage($id, $data, $event = null) {
    echo "id: $id\n";
    if ($event) {
        echo "event: $event\n";
    }
    echo "data: " . json_encode($data) . "\n\n";
}

/**
 * Get the ID of the last order in the database
 * 
 * @param PDO $conn Database connection
 * @return int Last order ID
 */
function getLastOrderId($conn) {
    try {
        $stmt = $conn->query("SELECT MAX(order_id) as max_id FROM orders");
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['max_id'] ?? 0;
    } catch (PDOException $e) {
        error_log('Error getting last order ID: ' . $e->getMessage());
        return 0;
    }
}

/**
 * Get the timestamp of the last order status update
 * 
 * @param PDO $conn Database connection
 * @return string Last update timestamp
 */
function getLastStatusUpdate($conn) {
    try {
        $stmt = $conn->query("SELECT MAX(updated_at) as last_update FROM orders");
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['last_update'] ?? date('Y-m-d H:i:s');
    } catch (PDOException $e) {
        error_log('Error getting last status update: ' . $e->getMessage());
        return date('Y-m-d H:i:s');
    }
}

/**
 * Check for new orders
 * 
 * @param PDO $conn Database connection
 * @param int $lastOrderId Last processed order ID
 * @return array New orders
 */
function checkForNewOrders($conn, $lastOrderId) {
    try {
        $stmt = $conn->prepare("
            SELECT 
                o.*,
                t.table_number
            FROM orders o 
            LEFT JOIN tables t ON o.table_id = t.table_id 
            WHERE o.order_id > ? AND o.status IN ('PAID', 'PREPARING')
            ORDER BY o.created_at ASC
        ");
        $stmt->execute([$lastOrderId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        error_log('Error checking for new orders: ' . $e->getMessage());
        return [];
    }
}

/**
 * Check for order status updates
 * 
 * @param PDO $conn Database connection
 * @param string $lastUpdate Last update timestamp
 * @return array Status updates
 */
function checkForStatusUpdates($conn, $lastUpdate) {
    try {
        $stmt = $conn->prepare("
            SELECT 
                o.*,
                t.table_number
            FROM orders o 
            LEFT JOIN tables t ON o.table_id = t.table_id 
            WHERE o.updated_at > ? AND o.status IN ('PAID', 'PREPARING', 'COMPLETED')
            ORDER BY o.updated_at ASC
        ");
        $stmt->execute([$lastUpdate]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        error_log('Error checking for status updates: ' . $e->getMessage());
        return [];
    }
} 