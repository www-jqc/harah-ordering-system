<?php
/**
 * WebSocket Event Trigger
 * This file provides functions to trigger WebSocket events from the PHP backend 
 * to notify connected mobile clients of state changes.
 */

// Base URL of the WebSocket server
$websocket_server_url = 'http://localhost:8080/trigger';

/**
 * Function to trigger a WebSocket event
 * 
 * @param string $eventType The type of event (e.g., 'new_order', 'order_status', 'table_status')
 * @param string $message A human-readable message describing the event
 * @param array $data Additional data related to the event
 * @return bool True if the event was successfully triggered, false otherwise
 */
function trigger_websocket_event($eventType, $message, $data = []) {
    global $websocket_server_url;
    
    $payload = [
        'type' => $eventType,
        'message' => $message,
        'data' => $data,
        'broadcast' => true,
        'timestamp' => date('c')
    ];
    
    // Initialize cURL
    $ch = curl_init($websocket_server_url);
    
    // Set cURL options
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
    ]);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5); // 5 second timeout
    
    // Execute cURL request
    $response = curl_exec($ch);
    $success = ($response !== false);
    
    // Check for errors
    if (!$success) {
        error_log('WebSocket Trigger Error: ' . curl_error($ch));
    }
    
    // Close cURL session
    curl_close($ch);
    
    return $success;
}

/**
 * Function to notify mobile clients about new orders
 * 
 * @param int $orderId The ID of the new order
 * @param string $tableNumber The table number (if applicable)
 * @return bool Success status
 */
function notify_new_order($orderId, $tableNumber = null) {
    $message = "New order #$orderId has been placed";
    if ($tableNumber) {
        $message .= " for Table $tableNumber";
    }
    
    return trigger_websocket_event('new_order', $message, [
        'order_id' => $orderId,
        'table_number' => $tableNumber
    ]);
}

/**
 * Function to notify mobile clients about order status changes
 * 
 * @param int $orderId The ID of the order
 * @param string $status The new status of the order
 * @param string $tableNumber The table number (if applicable)
 * @return bool Success status
 */
function notify_order_status_change($orderId, $status, $tableNumber = null) {
    $message = "Order #$orderId is now $status";
    if ($tableNumber) {
        $message .= " for Table $tableNumber";
    }
    
    return trigger_websocket_event('order_update', $message, [
        'order_id' => $orderId,
        'status' => $status,
        'table_number' => $tableNumber
    ]);
}

/**
 * Function to notify mobile clients about table status changes
 * 
 * @param int $tableId The ID of the table
 * @param string $tableNumber The table number
 * @param string $status The new status of the table
 * @return bool Success status
 */
function notify_table_status_change($tableId, $tableNumber, $status) {
    $readableStatus = ucfirst(strtolower($status));
    $message = "Table $tableNumber is now $readableStatus";
    
    return trigger_websocket_event('table_status', $message, [
        'table_id' => $tableId,
        'table_number' => $tableNumber,
        'status' => $status
    ]);
}

// If this file is called directly, return a 403 Forbidden response
if (basename($_SERVER['PHP_SELF']) === basename(__FILE__)) {
    http_response_code(403);
    exit('Direct access not permitted');
} 