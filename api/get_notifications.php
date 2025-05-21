<?php
/**
 * API Endpoint: Get Notifications
 * 
 * Returns notifications for kitchen or waiter staff
 */

// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Content-Type: application/json');

// Include database connection
require_once '../config/database.php';

try {
    // Get all recent notifications - no role filter since the column doesn't exist
    $stmt = $conn->prepare("
        SELECT * FROM notifications 
        ORDER BY created_at DESC
        LIMIT 20
    ");
    $stmt->execute();
    $notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Return notifications as JSON
    echo json_encode([
        'success' => true,
        'notifications' => $notifications
    ]);
    
} catch (PDOException $e) {
    // Log and return error
    error_log('API Error: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'An error occurred while retrieving notifications'
    ]);
} 