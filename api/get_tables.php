<?php
/**
 * API Endpoint: Get Tables
 * 
 * Returns all tables with their status for the waiter app
 */

// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Content-Type: application/json');

// Include database connection
require_once '../config/database.php';

try {
    // Get all tables
    $stmt = $conn->prepare("
        SELECT * FROM tables
        ORDER BY table_number ASC
    ");
    $stmt->execute();
    $tables = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // For each table, check if there are active orders
    foreach ($tables as &$table) {
        $ordersStmt = $conn->prepare("
            SELECT o.* 
            FROM orders o
            WHERE o.table_id = ? 
            AND o.status IN ('PAID', 'PREPARING', 'READY')
        ");
        $ordersStmt->execute([$table['table_id']]);
        $activeOrders = $ordersStmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Add active orders to table data
        $table['active_orders'] = $activeOrders;
        
        // If any orders are READY, mark table as READY
        foreach ($activeOrders as $order) {
            if ($order['status'] === 'READY' && $table['status'] !== 'READY') {
                $table['status'] = 'READY';
                break;
            }
        }
    }
    
    // Return tables as JSON
    echo json_encode([
        'success' => true,
        'tables' => $tables
    ]);
    
} catch (PDOException $e) {
    // Log and return error
    error_log('API Error: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'An error occurred while retrieving tables'
    ]);
}
?> 