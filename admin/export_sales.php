<?php
session_start();
require_once '../config/database.php';

// Check if user is logged in and is an admin
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'ADMIN') {
    header('Location: ../login.php');
    exit();
}

// Get date range from request parameters
$start_date = isset($_GET['start_date']) ? $_GET['start_date'] : date('Y-m-d', strtotime('-30 days'));
$end_date = isset($_GET['end_date']) ? $_GET['end_date'] : date('Y-m-d');

// Get sales data with related information
$stmt = $conn->prepare("
    SELECT 
        s.*,
        o.order_type,
        pt.payment_method,
        pt.amount_paid,
        pt.change_amount,
        pt.transaction_reference
    FROM sales s
    JOIN orders o ON s.order_id = o.order_id
    JOIN payment_transactions pt ON s.payment_transaction_id = pt.transaction_id
    WHERE s.date BETWEEN ? AND ?
    ORDER BY s.date DESC, s.created_at DESC
");
$stmt->execute([$start_date, $end_date]);
$sales = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Set headers for CSV download
header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="sales_report_' . date('Y-m-d') . '.csv"');

// Create output stream
$output = fopen('php://output', 'w');

// Add CSV headers
fputcsv($output, [
    'Date',
    'Total Revenue',
    'Cash Revenue',
    'GCash Revenue',
    'Total Orders',
    'Cash Orders',
    'GCash Orders'
]);

// Add data rows
foreach ($sales as $sale) {
    fputcsv($output, [
        date('M d, Y', strtotime($sale['date'])),
        number_format($sale['total_revenue'], 2),
        number_format($sale['cash_revenue'], 2),
        number_format($sale['gcash_revenue'], 2),
        $sale['total_orders'],
        $sale['cash_orders'],
        $sale['gcash_orders']
    ]);
}

// Close the output stream
fclose($output); 