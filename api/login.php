<?php
/**
 * Login API for Mobile App
 * 
 * Handles authentication for kitchen and waiter mobile app users
 */

// Set headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

// Include database connection
require_once '../config/database.php';

// Enable error reporting in case of issues
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Log function for debugging
function logMessage($message) {
    $logFile = __DIR__ . '/mobile_login.log';
    $timestamp = date('Y-m-d H:i:s');
    file_put_contents($logFile, "[$timestamp] $message" . PHP_EOL, FILE_APPEND);
}

logMessage("Login attempt received");
logMessage("REQUEST_METHOD: " . $_SERVER['REQUEST_METHOD']);

// Check request method
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method'
    ]);
    exit;
}

// Get POST data
$username = isset($_POST['username']) ? trim($_POST['username']) : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';
$requested_roles = isset($_POST['role']) ? $_POST['role'] : '';

logMessage("Login attempt for username: $username");
logMessage("Requested roles: $requested_roles");

// Validate input
if (empty($username) || empty($password)) {
    logMessage("Empty username or password");
    echo json_encode([
        'success' => false,
        'message' => 'Username and password are required'
    ]);
    exit;
}

try {
    // Simplified query - just get the user
    $stmt = $conn->prepare("
        SELECT * FROM users WHERE username = ?
    ");
    $stmt->execute([$username]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    logMessage("User found: " . ($user ? 'Yes' : 'No'));
    if ($user) {
        logMessage("User role: " . $user['role']);
        logMessage("Password hash: " . substr($user['password'], 0, 25) . "...");
    }
    
    // Verify user exists and password matches
    logMessage("Checking password: '$password' against stored hash");
    $passwordVerified = $user && password_verify($password, $user['password']);
    logMessage("Password verification result: " . ($passwordVerified ? "SUCCESS" : "FAILED"));
    
    if ($passwordVerified) {
        // Check role access if requested
        if (!empty($requested_roles)) {
            $allowed_roles = explode(',', $requested_roles);
            logMessage("Checking role access. User role: " . $user['role']);
            
            if (!in_array($user['role'], $allowed_roles)) {
                logMessage("Access denied. Role not allowed: " . $user['role']);
                echo json_encode([
                    'success' => false,
                    'message' => 'Access denied. Your role does not have permission to use this app.'
                ]);
                exit;
            }
        }
        
        // Create user data for response
        $userData = [
            'user_id' => (int)$user['user_id'],
            'username' => $user['username'],
            'role' => $user['role'],
            'employee_id' => 0, // Not using employee data
            'first_name' => '', // Not available
            'last_name' => ''   // Not available
        ];
        
        logMessage("Login successful for user: " . $user['username']);
        
        // Return success with user data
        echo json_encode([
            'success' => true,
            'message' => 'Login successful',
            'user' => $userData
        ]);
    } else {
        if (!$user) {
            logMessage("Login failed: User not found");
        } else {
            logMessage("Login failed: Invalid password");
        }
        
        echo json_encode([
            'success' => false,
            'message' => 'Invalid username or password'
        ]);
    }
} catch (PDOException $e) {
    logMessage("Database error: " . $e->getMessage());
    
    echo json_encode([
        'success' => false,
        'message' => 'An error occurred during authentication'
    ]);
} 