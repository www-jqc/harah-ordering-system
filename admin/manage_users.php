<?php
require_once '../includes/session.php';
require_once '../config/database.php';

// Check if user is logged in and has admin role
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'ADMIN') {
    header('Location: ../login.php');
    exit();
}

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        if (isset($_POST['action'])) {
            switch ($_POST['action']) {
                case 'add':
                    // Check if username already exists
                    $stmt = $conn->prepare("SELECT COUNT(*) as count FROM users WHERE username = ?");
                    $stmt->execute([$_POST['username']]);
                    $result = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($result['count'] > 0) {
                        $_SESSION['error'] = "Username already exists!";
                    } else {
                        $hashed_password = password_hash($_POST['password'], PASSWORD_DEFAULT);
                        $stmt = $conn->prepare("INSERT INTO users (employee_id, username, password, role) VALUES (?, ?, ?, ?)");
                        $stmt->execute([
                            $_POST['employee_id'],
                            $_POST['username'],
                            $hashed_password,
                            $_POST['role']
                        ]);
                        $_SESSION['success'] = "User added successfully!";
                    }
                    break;

                case 'edit':
                    $updates = ["role = ?"];
                    $params = [$_POST['role']];

                    // Only update password if a new one is provided
                    if (!empty($_POST['password'])) {
                        $updates[] = "password = ?";
                        $params[] = password_hash($_POST['password'], PASSWORD_DEFAULT);
                    }

                    // Check if username is being changed
                    if ($_POST['original_username'] !== $_POST['username']) {
                        // Check if new username already exists
                        $stmt = $conn->prepare("SELECT COUNT(*) as count FROM users WHERE username = ?");
                        $stmt->execute([$_POST['username']]);
                        $result = $stmt->fetch(PDO::FETCH_ASSOC);
                        
                        if ($result['count'] > 0) {
                            $_SESSION['error'] = "Username already exists!";
                            break;
                        }
                        $updates[] = "username = ?";
                        $params[] = $_POST['username'];
                    }

                    $params[] = $_POST['user_id']; // For WHERE clause
                    $sql = "UPDATE users SET " . implode(", ", $updates) . " WHERE user_id = ?";
                    
                    $stmt = $conn->prepare($sql);
                    $stmt->execute($params);
                    $_SESSION['success'] = "User updated successfully!";
                    break;

                case 'delete':
                    // Prevent deleting self
                    if ($_POST['user_id'] == $_SESSION['user_id']) {
                        $_SESSION['error'] = "You cannot delete your own account!";
                        break;
                    }

                    $stmt = $conn->prepare("DELETE FROM users WHERE user_id = ?");
                    $stmt->execute([$_POST['user_id']]);
                    $_SESSION['success'] = "User deleted successfully!";
                    break;

                case 'toggle_status':
                    // Get user information and employee status
                    $stmt = $conn->prepare("
                        SELECT u.*, e.position, e.status as employee_status
                        FROM users u 
                        LEFT JOIN employees e ON u.employee_id = e.employee_id 
                        WHERE u.user_id = ?
                    ");
                    $stmt->execute([$_POST['user_id']]);
                    $user = $stmt->fetch(PDO::FETCH_ASSOC);

                    // Don't allow disabling admin users
                    if ($user['position'] === 'ADMIN') {
                        $_SESSION['error'] = "Admin users cannot be disabled";
                        break;
                    }

                    // Check if password is already inactive
                    $is_active = !str_starts_with($user['password'], 'INACT_');
                    
                    if ($is_active) {
                        // Disable user
                        $stmt = $conn->prepare("
                            UPDATE users 
                            SET password = CONCAT('INACT_', password)
                            WHERE user_id = ? AND password NOT LIKE 'INACT_%'
                        ");
                        $stmt->execute([$_POST['user_id']]);
                        $_SESSION['success'] = "User disabled successfully!";
                    } else {
                        // Check employee status before enabling user
                        if ($user['employee_status'] === 'INACTIVE') {
                            $_SESSION['error'] = "Cannot enable user account while employee is inactive";
                            break;
                        }
                        // Enable user
                        $stmt = $conn->prepare("
                            UPDATE users 
                            SET password = SUBSTRING(password, 7)
                            WHERE user_id = ? AND password LIKE 'INACT_%'
                        ");
                        $stmt->execute([$_POST['user_id']]);
                        $_SESSION['success'] = "User enabled successfully!";
                    }
                    break;
            }
        }
    } catch (PDOException $e) {
        $_SESSION['error'] = "Error: " . $e->getMessage();
    }
    
    header('Location: manage_users.php');
    exit();
}

// Get all users
try {
    // Get all users with employee information
    $stmt = $conn->query("
        SELECT u.*, e.first_name, e.last_name, e.position,
               CASE WHEN u.password LIKE 'INACT_%' THEN 'INACTIVE' ELSE 'ACTIVE' END as status
        FROM users u 
        LEFT JOIN employees e ON u.employee_id = e.employee_id 
        ORDER BY u.role, u.username
    ");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Get eligible employees (those without user accounts and with valid roles)
    $stmt = $conn->query("
        SELECT e.* 
        FROM employees e 
        LEFT JOIN users u ON e.employee_id = u.employee_id 
        WHERE u.user_id IS NULL 
        AND e.position IN ('Admin', 'Cashier', 'Kitchen', 'Waiter')
        ORDER BY e.last_name, e.first_name
    ");
    $eligible_employees = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    $error = "Database error: " . $e->getMessage();
}

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
    <title>Manage Users - Admin Dashboard</title>
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
        <?php if (isset($_SESSION['success'])): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <?php 
                    echo $_SESSION['success'];
                    unset($_SESSION['success']);
                ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <?php if (isset($_SESSION['error'])): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <?php 
                    echo $_SESSION['error'];
                    unset($_SESSION['error']);
                ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Manage Users</h5>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="fas fa-plus me-2"></i>Add New User
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Username</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($users as $user): ?>
                            <tr class="user-card">
                                <td class="align-middle">
                                    <?php echo h($user['username']); ?>
                                    <?php if ($user['first_name']): ?>
                                        <br>
                                        <small class="text-muted">
                                            <?php echo h($user['first_name'] . ' ' . $user['last_name']); ?>
                                        </small>
                                    <?php endif; ?>
                                </td>
                                <td class="align-middle">
                                    <span class="badge badge-<?php echo strtolower($user['role']); ?>">
                                        <?php echo ucfirst(strtolower($user['role'])); ?>
                                    </span>
                                </td>
                                <td class="align-middle">
                                    <small class="status-badge status-<?php echo strtolower($user['status']); ?>">
                                        <?php echo $user['status']; ?>
                                    </small>
                                </td>
                                <td class="align-middle">
                                    <?php if ($user['position'] !== 'ADMIN'): ?>
                                    <div class="form-check form-switch">
                                        <input type="checkbox" class="form-check-input" 
                                               <?php echo $user['status'] === 'ACTIVE' ? 'checked' : ''; ?>
                                               onchange="toggleUserStatus(<?php echo $user['user_id']; ?>, this.checked)">
                                    </div>
                                    <?php if ($user['user_id'] != $_SESSION['user_id']): ?>
                                    <button class="btn btn-icon btn-warning" 
                                            onclick="editUser(<?php echo h(json_encode($user)); ?>)">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <?php endif; ?>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Select Employee</label>
                            <select class="form-select" name="employee_id" id="employee_select" required onchange="updateRoleBasedOnPosition(this.value)">
                                <option value="">Select Employee</option>
                                <?php foreach ($eligible_employees as $employee): ?>
                                    <option value="<?php echo $employee['employee_id']; ?>" data-position="<?php echo $employee['position']; ?>">
                                        <?php echo h($employee['first_name'] . ' ' . $employee['last_name'] . ' (' . $employee['position'] . ')'); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Role</label>
                            <select class="form-select" name="role" id="role_select" required>
                                <option value="">Select Employee First</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="" method="POST">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="user_id" id="edit_user_id">
                    <input type="hidden" name="original_username" id="edit_original_username">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" name="username" id="edit_username" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-control" name="password">
                            <small class="text-muted">Leave empty to keep current password</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Role</label>
                            <select class="form-select" name="role" id="edit_role" required>
                                <option value="">Select Role</option>
                                <option value="ADMIN">Admin</option>
                                <option value="WAITER">Waiter</option>
                                <option value="KITCHEN">Kitchen Staff</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete User Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Delete User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="" method="POST">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="user_id" id="delete_user_id">
                    <div class="modal-body">
                        <p>Are you sure you want to delete <strong id="delete_user_name"></strong>?</p>
                        <p class="text-danger mb-0">This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateRoleBasedOnPosition(employeeId) {
            const employeeSelect = document.getElementById('employee_select');
            const roleSelect = document.getElementById('role_select');
            const selectedOption = employeeSelect.options[employeeSelect.selectedIndex];
            const position = selectedOption.getAttribute('data-position');

            // Clear existing options
            roleSelect.innerHTML = '';

            if (!employeeId) {
                roleSelect.innerHTML = '<option value="">Select Employee First</option>';
                return;
            }

            // Add only the role that matches the position
            const option = document.createElement('option');
            option.value = position;
            option.textContent = position.charAt(0) + position.slice(1).toLowerCase();
            roleSelect.appendChild(option);
            roleSelect.value = position;
        }

        function toggleUserStatus(userId, isActive) {
            const form = document.createElement('form');
            form.method = 'POST';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'toggle_status';
            
            const userIdInput = document.createElement('input');
            userIdInput.type = 'hidden';
            userIdInput.name = 'user_id';
            userIdInput.value = userId;
            
            form.appendChild(actionInput);
            form.appendChild(userIdInput);
            document.body.appendChild(form);
            
            form.submit();
        }

        function editUser(user) {
            // Don't allow editing admin users
            if (user.position === 'ADMIN') {
                alert('Admin users cannot be edited');
                return;
            }

            document.getElementById('edit_user_id').value = user.user_id;
            document.getElementById('edit_username').value = user.username;
            document.getElementById('edit_original_username').value = user.username;
            document.getElementById('edit_role').value = user.role;

            const editModal = new bootstrap.Modal(document.getElementById('editUserModal'));
            editModal.show();
        }
    </script>
</body>
</html> 