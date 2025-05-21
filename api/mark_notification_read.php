<?php
/**
 * API Endpoint: Mark Notification as Read
 * 
 * Updates a notification to mark it as read
 */

// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Content-Type: application/json');

// Include database connection
require_once '../config/database.php';

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method'
    ]);
    exit;
}

// Get notification ID from POST data
$notification_id = isset($_POST['notification_id']) ? intval($_POST['notification_id']) : 0;

// Validate input
if ($notification_id <= 0) {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid notification ID'
    ]);
    exit;
}

try {
    // Update notification to mark as read
    $stmt = $conn->prepare("UPDATE notifications SET is_read = 1 WHERE notification_id = ?");
    $result = $stmt->execute([$notification_id]);
    
    if ($result && $stmt->rowCount() > 0) {
        // Return success response
        echo json_encode([
            'success' => true,
            'message' => 'Notification marked as read'
        ]);
    } else {
        // Notification not found or already read
        echo json_encode([
            'success' => false,
            'message' => 'Notification not found or already read'
        ]);
    }
    
} catch (PDOException $e) {
    // Log and return error
    error_log('API Error: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'An error occurred while updating notification'
    ]);
} 