<?php
// Check if user has admin role
function checkAdminRole() {
    if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'ADMIN') {
        header('Location: /sales_ordering_system-main/login.php');
        exit();
    }
}

// Format currency
function formatCurrency($amount) {
    return '₱ ' . number_format($amount, 2);
}

// Add anti-resubmission script
function addPreventResubmissionScript() {
    if (file_exists(__DIR__ . '/anti_resubmission.php')) {
        include __DIR__ . '/anti_resubmission.php';
    }
}

// Sanitize output
function h($string) {
    return htmlspecialchars($string, ENT_QUOTES, 'UTF-8');
}

// Log system activity
function logActivity($pdo, $userId, $action, $description) {
    $stmt = $pdo->prepare("
        INSERT INTO system_logs (user_id, action, description, ip_address)
        VALUES (?, ?, ?, ?)
    ");
    $stmt->execute([$userId, $action, $description, $_SERVER['REMOTE_ADDR']]);
}
?> 