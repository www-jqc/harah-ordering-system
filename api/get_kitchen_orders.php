<?php
/**
 * API Endpoint: Get Kitchen Orders
 * 
 * Returns orders that are relevant for kitchen staff (PAID, PREPARING, READY)
 */

// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Content-Type: application/json');

// Include database connection
require_once '../config/database.php';

// Enable error logging
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Log function for debugging
function logMessage($message) {
    $logFile = __DIR__ . '/kitchen_orders.log';
    $timestamp = date('Y-m-d H:i:s');
    file_put_contents($logFile, "[$timestamp] $message" . PHP_EOL, FILE_APPEND);
}

logMessage("Kitchen orders API called");

try {
    // Get orders relevant for the kitchen
    $stmt = $conn->prepare("
        SELECT o.*, t.table_number
        FROM orders o
        LEFT JOIN tables t ON o.table_id = t.table_id
        WHERE o.status IN ('PAID', 'PREPARING', 'READY')
        ORDER BY 
            CASE 
                WHEN o.status = 'PAID' THEN 1
                WHEN o.status = 'PREPARING' THEN 2
                WHEN o.status = 'READY' THEN 3
                ELSE 4
            END,
            o.created_at ASC
    ");
    $stmt->execute();
    $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);

    logMessage("Found " . count($orders) . " orders");
    
    // Process each order to get its items
    foreach ($orders as &$order) {
        logMessage("Processing order #" . $order['order_id']);
        
        // Get order items - removed product_code from query since it doesn't exist
        $itemsStmt = $conn->prepare("
            SELECT oi.*, p.name as product_name, p.price
            FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
            WHERE oi.order_id = ?
    ");
        $itemsStmt->execute([$order['order_id']]);
        $orderItems = $itemsStmt->fetchAll(PDO::FETCH_ASSOC);

        logMessage("Found " . count($orderItems) . " items for order #" . $order['order_id']);
        
        // Make sure items are properly formatted as array
        $order['items'] = $orderItems;
    }
    
    // Return orders as JSON
    echo json_encode([
        'success' => true,
        'orders' => $orders
    ]);

} catch (PDOException $e) {
    // Log and return error
    logMessage("Error: " . $e->getMessage());
    error_log('API Error: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'An error occurred while retrieving orders'
    ]);
}
?> 