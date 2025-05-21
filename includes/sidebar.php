<ul class="nav flex-column">
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'dashboard' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/index.php">
            <i class="fas fa-tachometer-alt"></i>
            <span>Dashboard</span>
        </a>
    </li>
    
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'orders' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/manage_orders.php">
            <i class="fas fa-shopping-cart"></i>
            <span>Orders</span>
        </a>
    </li>
    
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'products' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/manage_products.php">
            <i class="fas fa-box"></i>
            <span>Products</span>
        </a>
    </li>
    
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'categories' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/manage_categories.php">
            <i class="fas fa-tags"></i>
            <span>Categories</span>
        </a>
    </li>
    
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'employees' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/manage_employees.php">
            <i class="fas fa-users"></i>
            <span>Employees</span>
        </a>
    </li>
    
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'tables' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/manage_tables.php">
            <i class="fas fa-chair"></i>
            <span>Tables</span>
        </a>
    </li>
    
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'sales' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/manage_sales.php">
            <i class="fas fa-chart-line"></i>
            <span>Sales</span>
        </a>
    </li>
    
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'feedback' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/manage_feedback.php">
            <i class="fas fa-comments"></i>
            <span>Customer Feedback</span>
        </a>
    </li>
    
    <li class="nav-item">
        <a class="nav-link <?php echo $page === 'settings' ? 'active' : ''; ?>" href="/sales_ordering_system-main/admin/settings.php">
            <i class="fas fa-cog"></i>
            <span>Settings</span>
        </a>
    </li>
</ul> 