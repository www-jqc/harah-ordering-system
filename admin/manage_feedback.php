<?php
require_once '../includes/session.php';
require_once '../config/database.php';

// Check if user is logged in and is an admin
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'ADMIN') {
    header('Location: ../login.php');
    exit();
}

// Get feedback with related order and customer information
$query = "SELECT f.*, o.order_id, o.created_at as order_date, o.total_amount,
                 CONCAT(c.first_name, ' ', c.last_name) as customer_name
          FROM customer_feedback f
          JOIN orders o ON f.order_id = o.order_id
          JOIN customers c ON o.customer_id = c.customer_id
          ORDER BY f.created_at DESC";
$stmt = $conn->prepare($query);
$stmt->execute();
$feedbacks = $stmt->fetchAll();

// Calculate average rating
$avgQuery = "SELECT AVG(rating) as avg_rating, COUNT(*) as total_feedback
             FROM customer_feedback";
$avgStmt = $conn->prepare($avgQuery);
$avgStmt->execute();
$stats = $avgStmt->fetch();

// Add h() function if not available
if (!function_exists('h')) {
    function h($str) {
        return htmlspecialchars($str, ENT_QUOTES, 'UTF-8');
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Feedback - Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <?php include('components/styles.php'); ?>
</head>
<body>
    <?php include('components/navbar.php'); ?>

    <div class="container-fluid py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0 text-gray-800">Customer Feedback Management</h1>
        </div>

        <div class="row mb-4">
            <div class="col-xl-6 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon stat-products">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="stat-title">Average Rating</div>
                    <div class="stat-value"><?php echo number_format($stats['avg_rating'] ?? 0, 1); ?> / 5.0</div>
                </div>
            </div>
            <div class="col-xl-6 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon stat-orders">
                        <i class="fas fa-comments"></i>
                    </div>
                    <div class="stat-title">Total Feedback</div>
                    <div class="stat-value"><?php echo $stats['total_feedback'] ?? 0; ?> responses</div>
                </div>
            </div>
        </div>

        <div class="recent-orders">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Customer Feedback</h6>
            </div>
            <div class="card-body">
                <?php if (empty($feedbacks)): ?>
                    <div class="text-center py-4">
                        <i class="fas fa-comments fa-3x text-gray-300 mb-3"></i>
                        <p class="text-gray-500 mb-0">No feedback available at this time.</p>
                    </div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table table-bordered" id="feedbackTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>Customer Name</th>
                                    <th>Rating</th>
                                    <th>Comment</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                $query = "SELECT 
                                            cf.feedback_id,
                                            CONCAT(c.first_name, ' ', c.last_name) as customer_name,
                                            cf.rating,
                                            cf.comment,
                                            cf.created_at
                                        FROM customer_feedback cf
                                        JOIN customers c ON cf.customer_id = c.customer_id
                                        ORDER BY cf.created_at DESC";
                                
                                $result = $conn->query($query);

                                if ($result->rowCount() > 0) {
                                    while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
                                        echo "<tr>";
                                        echo "<td>" . htmlspecialchars($row['customer_name']) . "</td>";
                                        echo "<td>";
                                        // Display stars based on rating
                                        for ($i = 1; $i <= 5; $i++) {
                                            if ($i <= $row['rating']) {
                                                echo '<i class="fas fa-star text-warning"></i>';
                                            } else {
                                                echo '<i class="far fa-star text-warning"></i>';
                                            }
                                        }
                                        echo " (" . $row['rating'] . "/5)";
                                        echo "</td>";
                                        echo "<td>" . htmlspecialchars($row['comment']) . "</td>";
                                        echo "<td>" . date('M d, Y h:i A', strtotime($row['created_at'])) . "</td>";
                                        echo "</tr>";
                                    }
                                } else {
                                    echo "<tr><td colspan='4' class='text-center'>No feedback available</td></tr>";
                                }
                                ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>
</html>
