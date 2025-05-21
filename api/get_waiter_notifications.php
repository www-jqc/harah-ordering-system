<?php
/**
 * API Endpoint: Get Waiter Notifications
 * 
 * Checks for order status changes that require waiter attention,
 * particularly orders that have been marked as COMPLETED by kitchen
 */

// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Content-Type: application/json');

// Include database connection
require_once '../config/database.php';

try {
    // Check for order notifications that need waiter attention
    // Looking for notifications of type ORDER_READY since that's what kitchen generates
    $stmt = $conn->prepare("
        SELECT n.*, o.order_id, o.table_id, o.status as order_status, t.table_number
        FROM notifications n
        JOIN orders o ON n.order_id = o.order_id
        JOIN tables t ON o.table_id = t.table_id
        WHERE n.type = 'ORDER_READY'
        AND n.is_read = 0
        ORDER BY n.created_at DESC
        LIMIT 10
    ");
    $stmt->execute();
    $notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Return status - if we have any unread ORDER_READY notifications,
    // indicate to the client that new orders are available
    echo json_encode([
        'success' => true,
        'new_orders' => count($notifications) > 0,
        'notifications' => $notifications
    ]);
    
} catch (PDOException $e) {
    // Log and return error
    error_log('API Error: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'An error occurred while retrieving waiter notifications'
    ]);
} 