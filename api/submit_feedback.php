<?php
require_once '../config/database.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

try {
    $data = json_decode(file_get_contents('php://input'), true);

    // Validate required fields
    if (!isset($data['rating']) || !isset($data['comment'])) {
        throw new Exception('Missing required fields');
    }

    // Validate rating range
    $rating = intval($data['rating']);
    if ($rating < 1 || $rating > 5) {
        throw new Exception('Invalid rating value');
    }

    // Start transaction
    $conn->beginTransaction();

    try {
        // If no order_id is provided, create a new customer entry for direct feedback
        if (!isset($data['order_id']) || empty($data['order_id'])) {
            // Set default name if not provided
            $firstName = 'Anonymous';
            $lastName = 'Customer';
            
            if (isset($data['customerName']) && !empty(trim($data['customerName']))) {
                $nameParts = explode(' ', trim($data['customerName']));
                $firstName = $nameParts[0];
                $lastName = count($nameParts) > 1 ? end($nameParts) : '';
            }

            // Create a new customer entry with the provided name
            $stmt = $conn->prepare("
                INSERT INTO customers (first_name, last_name, created_at)
                VALUES (?, ?, NOW())
            ");
            $stmt->execute([$firstName, $lastName]);
            $customer_id = $conn->lastInsertId();

            // Create a dummy order for the feedback
            $stmt = $conn->prepare("
                INSERT INTO orders (customer_id, order_type, status, total_amount, created_at)
                VALUES (?, 'WALK_IN', 'COMPLETED', 0, NOW())
            ");
            $stmt->execute([$customer_id]);
            $order_id = $conn->lastInsertId();
        } else {
            // Get the customer_id from the order if order_id is provided
            $stmt = $conn->prepare("SELECT customer_id FROM orders WHERE order_id = ?");
            $stmt->execute([$data['order_id']]);
            $order = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$order) {
                throw new Exception('Order not found');
            }
            $customer_id = $order['customer_id'];
            $order_id = $data['order_id'];

            // Update customer name if provided
            $nameParts = explode(' ', trim($data['customerName']));
            $firstName = $nameParts[0];
            $lastName = count($nameParts) > 1 ? end($nameParts) : '';

            $stmt = $conn->prepare("
                UPDATE customers 
                SET first_name = ?, last_name = ? 
                WHERE customer_id = ?
            ");
            $stmt->execute([$firstName, $lastName, $customer_id]);
        }

        // Insert feedback
        $stmt = $conn->prepare("
            INSERT INTO customer_feedback (order_id, customer_id, rating, comment)
            VALUES (?, ?, ?, ?)
        ");

        $stmt->execute([
            $order_id,
            $customer_id,
            $rating,
            $data['comment']
        ]);

        // Commit transaction
        $conn->commit();

        echo json_encode([
            'success' => true,
            'message' => 'Feedback submitted successfully'
        ]);

    } catch (Exception $e) {
        // Rollback transaction on error
        $conn->rollBack();
        throw $e;
    }

} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
} 