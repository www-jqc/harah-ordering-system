<?php
$page_title = "Table Reservations";
require_once '../includes/session.php';
require_once '../config/database.php';

// Check if user is logged in and has cashier role
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'CASHIER') {
    header('Location: ../login.php');
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Table Reservations - HarahQR Sales</title>
    <link rel="icon" href="../images-harah/logos.png" type="image/png">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Flatpickr for Date/Time -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
            --light-color: #f8f9fc;
            --dark-color: #5a5c69;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-color);
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color), #224abe);
            padding: 1rem;
        }

        .navbar-brand {
            color: white !important;
            font-weight: 600;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8) !important;
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: white !important;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            margin-bottom: 2rem;
        }

        .card-header {
            background-color: white;
            border-bottom: 1px solid #e3e6f0;
            padding: 1rem 1.25rem;
            border-radius: 15px 15px 0 0 !important;
        }

        .card-title {
            color: var(--dark-color);
            font-weight: 600;
            margin: 0;
        }

        .table-status {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 5px;
        }
        .status-available { background-color: #28a745; }
        .status-occupied { background-color: #dc3545; }
        .status-reserved { background-color: #ffc107; }
        .reservation-card {
            transition: all 0.3s ease;
        }
        .reservation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.php">
                <i class="fas fa-qrcode me-2"></i>HarahQR Sales
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="orders.php">
                            <i class="fas fa-clipboard-list me-1"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="table_reservations.php">
                            <i class="fas fa-calendar-alt me-1"></i>Reservations
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../logout.php">
                            <i class="fas fa-sign-out-alt me-1"></i>Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <?php 
        if (isset($_SESSION['success_message'])) {
            echo '<div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>' . $_SESSION['success_message'] . '
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                  </div>';
            unset($_SESSION['success_message']);
        }
        
        if (isset($_SESSION['error_message'])) {
            echo '<div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>' . $_SESSION['error_message'] . '
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                  </div>';
            unset($_SESSION['error_message']);
        }
        ?>

        <div class="row">
            <!-- Table Layout Section -->
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title">
                            <i class="fas fa-th me-2"></i>Table Layout
                        </h5>
                        <div class="legend d-flex gap-3">
                            <small><span class="table-status status-available"></span> Available</small>
                            <small><span class="table-status status-occupied"></span> Occupied</small>
                            <small><span class="table-status status-reserved"></span> Reserved</small>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <?php for($i = 1; $i <= 12; $i++): ?>
                            <div class="col-md-3">
                                <div class="card text-center p-3">
                                    <h6 class="mb-2">Table <?php echo $i; ?></h6>
                                    <span class="table-status status-<?php echo rand(0,2) == 0 ? 'available' : (rand(0,1) == 0 ? 'occupied' : 'reserved'); ?> mx-auto"></span>
                                    <small class="mt-2">4 Seats</small>
                                </div>
                            </div>
                            <?php endfor; ?>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reservation Form Section -->
            <div class="col-md-6 mb-4">
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title">
                            <i class="fas fa-plus-circle me-2"></i>New Reservation
                        </h5>
                    </div>
                    <div class="card-body">
                        <form id="reservationForm">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Customer Name</label>
                                    <input type="text" class="form-control" name="customer_name" placeholder="Enter customer name" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Contact Number</label>
                                    <input type="tel" class="form-control" name="contact_number" placeholder="Enter contact number" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Reservation Date</label>
                                    <input type="date" class="form-control flatpickr-date" name="reservation_date" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Reservation Time</label>
                                    <input type="time" class="form-control flatpickr-time" name="reservation_time" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Number of Guests</label>
                                    <input type="number" class="form-control" name="number_of_guests" min="1" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Table</label>
                                    <select class="form-select" name="table_id" required>
                                        <option value="">Select Table</option>
                                        <?php for($i = 1; $i <= 12; $i++): ?>
                                        <option value="<?php echo $i; ?>">Table <?php echo $i; ?></option>
                                        <?php endfor; ?>
                                    </select>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Status</label>
                                    <select class="form-select" name="status" required>
                                        <option value="PENDING">Pending</option>
                                        <option value="CONFIRMED">Confirmed</option>
                                        <option value="CANCELLED">Cancelled</option>
                                        <option value="COMPLETED">Completed</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Special Requests</label>
                                    <textarea class="form-control" name="special_requests" rows="3" placeholder="Enter any special requests"></textarea>
                                </div>
                                <div class="col-12">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Save Reservation
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Today's Reservations -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title">
                            <i class="fas fa-calendar-day me-2"></i>Today's Reservations
                        </h5>
                        <button class="btn btn-sm btn-outline-primary" onclick="viewAllReservations()">
                            <i class="fas fa-calendar me-2"></i>View All
                        </button>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Customer</th>
                                        <th>Table</th>
                                        <th>Date & Time</th>
                                        <th>Guests</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php for($i = 1; $i <= 5; $i++): ?>
                                    <tr>
                                        <td>#<?php echo $i; ?></td>
                                        <td>John Doe</td>
                                        <td>Table <?php echo $i; ?></td>
                                        <td><?php echo date('M d, Y', strtotime('+'.($i-1).' days')) ?><br>
                                            <small class="text-muted"><?php echo date('h:i A', strtotime('18:'.($i*10))); ?></small>
                                        </td>
                                        <td><?php echo ($i + 1); ?></td>
                                        <td>
                                            <span class="badge bg-<?php 
                                                echo $i % 4 == 0 ? 'success' : 
                                                    ($i % 3 == 0 ? 'danger' : 
                                                        ($i % 2 == 0 ? 'warning' : 'info')); 
                                            ?>">
                                                <?php 
                                                echo $i % 4 == 0 ? 'COMPLETED' : 
                                                    ($i % 3 == 0 ? 'CANCELLED' : 
                                                        ($i % 2 == 0 ? 'PENDING' : 'CONFIRMED')); 
                                                ?>
                                            </span>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-info" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-warning" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <?php if($i % 4 != 0 && $i % 3 != 0): ?>
                                            <button type="button" class="btn btn-sm btn-success" title="Confirm">
                                                <i class="fas fa-check"></i>
                                            </button>
                                            <?php endif; ?>
                                            <?php if($i % 2 == 0 || $i % 1 == 0): ?>
                                            <button type="button" class="btn btn-sm btn-danger" title="Cancel">
                                                <i class="fas fa-times"></i>
                                            </button>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                    <?php endfor; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Flatpickr JS -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        // Initialize date and time pickers
        flatpickr(".flatpickr-date", {
            minDate: "today",
            dateFormat: "Y-m-d"
        });

        flatpickr(".flatpickr-time", {
            enableTime: true,
            noCalendar: true,
            dateFormat: "H:i",
            minTime: "10:00",
            maxTime: "22:00"
        });

        function viewAllReservations() {
            // Placeholder function for viewing all reservations
            alert('View all reservations functionality will be implemented here');
        }
    </script>
</body>
</html>