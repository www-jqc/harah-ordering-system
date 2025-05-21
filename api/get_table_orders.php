<?php
/**
 * API Endpoint: Get Table Orders
 * 
 * Returns orders for a specific table
 */

// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Content-Type: application/json');

// Include database connection
require_once '../config/database.php';

// Get table ID from query string
$table_id = isset($_GET['table_id']) ? intval($_GET['table_id']) : 0;

if ($table_id <= 0) {
    // Invalid table ID
    echo json_encode([
        'success' => false,
        'message' => 'Invalid table ID'
    ]);
    exit;
}

try {
    // Get table info
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
    
    // Get active orders for this table
    $ordersStmt = $conn->prepare("
        SELECT o.*
        FROM orders o
        WHERE o.table_id = ? 
        AND o.status IN ('PAID', 'PREPARING', 'READY', 'SERVED')
        ORDER BY o.created_at DESC
    ");
    $ordersStmt->execute([$table_id]);
    $orders = $ordersStmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Process each order to get its items
    foreach ($orders as &$order) {
        // Get order items
        $itemsStmt = $conn->prepare("
            SELECT oi.*, p.name as product_name, p.product_code
            FROM order_items oi
            JOIN products p ON oi.product_id = p.product_id
            WHERE oi.order_id = ?
        ");
        $itemsStmt->execute([$order['order_id']]);
        $order['items'] = $itemsStmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    // Return orders as JSON
    echo json_encode([
        'success' => true,
        'table' => $table,
        'orders' => $orders
    ]);
    
} catch (PDOException $e) {
    // Log and return error
    error_log('API Error: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'An error occurred while retrieving table orders'
    ]);
} 