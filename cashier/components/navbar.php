<?php if (!isset($page_title)) $page_title = "Cashier Dashboard"; ?>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="dashboard.php">
            <img src="../images-harah/logos.png" alt="Logo" width="30" height="30" class="d-inline-block align-text-top me-2">
            HarahQR Sales
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link <?php echo $page_title == 'Cashier Dashboard' ? 'active' : ''; ?>" href="dashboard.php">
                        <i class="fas fa-home me-2"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?php echo $page_title == 'Manage Orders' ? 'active' : ''; ?>" href="orders.php">
                        <i class="fas fa-shopping-cart me-2"></i>Orders
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?php echo $page_title == 'Table Reservations' ? 'active' : ''; ?>" href="table_reservations.php">
                        <i class="fas fa-calendar-alt me-2"></i>Reservations
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="../logout.php">
                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>