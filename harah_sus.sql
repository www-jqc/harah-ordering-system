-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2025 at 03:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `harah_sus`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_disabled` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`, `description`, `created_at`, `is_disabled`) VALUES
(1, 'Desserts', 'Usually sweet and sugary', '2025-03-13 12:48:14', 0),
(2, 'Breakfast', 'Early brunch', '2025-03-15 16:58:24', 0),
(3, 'Pizza', 'Savory and Tasty Pizza Pies', '2025-03-15 16:59:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `first_name`, `last_name`, `contact_number`, `email`, `created_at`) VALUES
(1, 'Walk-in', 'Customer', NULL, NULL, '2025-03-13 12:45:55'),
(2, 'Walk-in', 'Customer', NULL, NULL, '2025-03-13 12:49:42'),
(3, 'Elon', 'Musk', NULL, NULL, '2025-03-13 22:06:21'),
(4, 'Cedrick', 'Lamar', NULL, NULL, '2025-03-13 22:33:14'),
(5, 'QR', 'Customer', NULL, NULL, '2025-03-13 22:34:30'),
(6, 'QR', 'Customer', NULL, NULL, '2025-03-13 22:37:43'),
(7, 'QR', 'Customer', NULL, NULL, '2025-03-13 22:45:13'),
(8, 'QR', 'Customer', NULL, NULL, '2025-03-13 22:47:55'),
(9, 'QR', 'Customer', NULL, NULL, '2025-03-13 22:47:59'),
(10, 'Sigma', 'Boy', NULL, NULL, '2025-03-14 22:19:18'),
(11, 'QR', 'Customer', NULL, NULL, '2025-03-14 22:30:30'),
(12, 'Direct', 'Feedback', NULL, NULL, '2025-03-14 23:17:59'),
(13, 'T', '', NULL, NULL, '2025-03-14 23:22:06'),
(14, 'Johnbert', '', NULL, NULL, '2025-03-15 00:51:23'),
(15, 'QR', 'Customer', NULL, NULL, '2025-03-15 00:54:36'),
(16, 'QR', 'Customer', NULL, NULL, '2025-03-15 17:14:05'),
(17, 'Hello', 'World', '113125151', 'mpge@gmail.com', '2025-05-08 02:40:29'),
(18, 'QR', 'Customer', NULL, NULL, '2025-05-08 05:12:58'),
(19, 'QR', 'Customer', NULL, NULL, '2025-05-15 23:10:17'),
(20, 'QR', 'Customer', NULL, NULL, '2025-05-16 02:05:31'),
(21, 'QR', 'Customer', NULL, NULL, '2025-05-16 02:29:32'),
(22, 'QR', 'Customer', NULL, NULL, '2025-05-16 02:49:01'),
(23, 'QR', 'Customer', NULL, NULL, '2025-05-21 01:28:57');

-- --------------------------------------------------------

--
-- Table structure for table `customer_feedback`
--

CREATE TABLE `customer_feedback` (
  `feedback_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_feedback`
--

INSERT INTO `customer_feedback` (`feedback_id`, `order_id`, `customer_id`, `rating`, `comment`, `created_at`) VALUES
(1, 30, 12, 2, 'Good', '2025-03-14 23:17:59'),
(2, 31, 13, 5, '123', '2025-03-14 23:22:06'),
(3, 32, 14, 4, 'HEOHLEHLEHLEH', '2025-03-15 00:51:23');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `position` varchar(50) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `hire_date` date NOT NULL,
  `status` enum('ACTIVE','INACTIVE','ON_LEAVE','TERMINATED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `first_name`, `last_name`, `position`, `contact_number`, `email`, `address`, `hire_date`, `status`, `created_at`, `updated_at`) VALUES
(13, 'Margo', 'Admin', 'ADMIN', '09123456789', 'korosomag030@gmail.com', 'Manila', '2024-01-01', 'ACTIVE', '2025-03-13 12:30:32', '2025-03-13 23:06:40'),
(14, 'Clemens', 'Kitchen', 'KITCHEN', '09123456790', 'korosomag030@gmail.com', 'Manila', '2024-01-01', 'ACTIVE', '2025-03-13 12:30:32', '2025-03-13 23:06:44'),
(15, 'Francis', 'Cashier', 'CASHIER', '09123456791', 'korosomag030@gmail.com', 'Manila', '2024-01-01', 'ACTIVE', '2025-03-13 12:30:32', '2025-03-13 23:06:47'),
(16, 'Khendal', 'Waiter', 'WAITER', '09123456792', 'korosomag030@gmail.com', 'Manila', '2024-01-01', 'ACTIVE', '2025-03-13 12:30:32', '2025-03-13 23:06:49'),
(17, 'Cjay', 'Macuse', 'MAINTENANCE', '09134567', 'mekyus@gmail.com', '123', '2025-03-15', 'ACTIVE', '2025-03-15 02:25:08', '2025-03-15 02:25:08'),
(18, 'Crazy', 'Dave', 'KITCHEN', '0192354632', 'dave@gmail.com', '1233', '2020-12-04', 'ACTIVE', '2025-03-15 02:26:26', '2025-03-15 02:26:26'),
(19, 'PLants', 'Zombies', 'WAITER', '09234567', 'sigma@Gmail.com', '1er34575473', '2025-03-15', 'ACTIVE', '2025-03-15 02:29:00', '2025-03-15 03:06:03'),
(20, 'Cedrick', 'Virtudez', 'KITCHEN', '09152523', 'virtudez@gmail.com', 'CDO', '2025-03-15', 'ACTIVE', '2025-03-15 02:37:26', '2025-03-15 02:37:26');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `type` enum('ORDER_READY','TABLE_STATUS','PAYMENT') NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `order_id`, `message`, `type`, `is_read`, `created_at`) VALUES
(3, 36, 'New order received', 'ORDER_READY', 0, '2025-05-08 05:12:58'),
(4, 36, 'Order #36 has been paid and is ready for preparation', 'ORDER_READY', 0, '2025-05-08 05:13:23'),
(5, 36, 'Table 2 - Order #36 is ready for service', 'ORDER_READY', 0, '2025-05-15 23:09:28'),
(6, 36, 'Table 2 - Order #36 is ready for service', 'ORDER_READY', 0, '2025-05-15 23:09:28'),
(7, 37, 'New order received', 'ORDER_READY', 0, '2025-05-15 23:10:17'),
(8, 37, 'Order #37 has been paid and is ready for preparation', 'ORDER_READY', 0, '2025-05-15 23:10:32'),
(9, 37, 'Table 3 - Order #37 is ready for service', 'ORDER_READY', 0, '2025-05-15 23:10:54'),
(10, 37, 'Table 3 - Order #37 is ready for service', 'ORDER_READY', 0, '2025-05-15 23:10:54'),
(11, 38, 'New order received', 'ORDER_READY', 0, '2025-05-16 02:05:31'),
(12, 38, 'Order #38 has been paid and is ready for preparation', 'ORDER_READY', 0, '2025-05-16 02:05:52'),
(13, 38, 'Table 3 - Order #38 is being prepared', '', 0, '2025-05-16 02:11:41'),
(14, 38, 'Table 3 - Order #38 is being prepared', '', 0, '2025-05-16 02:11:43'),
(15, 39, 'New order received', 'ORDER_READY', 0, '2025-05-16 02:29:32'),
(16, 39, 'Order #39 has been paid and is ready for preparation', 'ORDER_READY', 0, '2025-05-16 02:33:19'),
(17, 39, 'Order #39 has been paid and is ready for preparation', 'ORDER_READY', 0, '2025-05-16 02:33:19'),
(18, 39, 'Table 3 - Order #39 is being prepared', '', 0, '2025-05-16 02:34:18'),
(19, 40, 'New order received', 'ORDER_READY', 0, '2025-05-16 02:49:01'),
(20, 40, 'Order #40 has been paid and is ready for preparation', 'ORDER_READY', 0, '2025-05-16 02:49:17'),
(21, 40, 'Table 3 - Order #40 is ready for service', 'ORDER_READY', 0, '2025-05-21 01:12:26'),
(22, 40, 'Table 3 - Order #40 is ready for service', 'ORDER_READY', 0, '2025-05-21 01:12:26'),
(23, 41, 'New order received', 'ORDER_READY', 0, '2025-05-21 01:28:57'),
(24, 41, 'Order #41 has been paid and is ready for preparation', 'ORDER_READY', 0, '2025-05-21 01:29:29'),
(25, 41, 'Kitchen is preparing Order #41', '', 0, '2025-05-21 01:29:37');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `table_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `order_type` enum('QR','WALK_IN') NOT NULL,
  `status` enum('PENDING','PAID','COMPLETED') DEFAULT 'PENDING',
  `total_amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `processed_by_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `table_id`, `customer_id`, `order_type`, `status`, `total_amount`, `created_at`, `updated_at`, `processed_by_id`) VALUES
(4, 2, 2, 'QR', 'COMPLETED', 30.00, '2025-03-13 13:20:41', '2025-03-13 14:11:09', NULL),
(5, 2, 2, 'QR', '', 10.00, '2025-03-13 13:22:36', '2025-03-13 13:23:25', NULL),
(6, 2, 2, 'QR', '', 10.00, '2025-03-13 13:29:39', '2025-03-13 13:49:01', NULL),
(7, 2, 2, 'QR', 'COMPLETED', 10.00, '2025-03-13 13:43:01', '2025-03-13 13:45:29', NULL),
(8, 2, 2, 'QR', 'COMPLETED', 10.00, '2025-03-13 13:47:28', '2025-03-13 13:48:37', NULL),
(9, 2, 2, 'QR', '', 20.00, '2025-03-13 13:50:43', '2025-03-13 13:51:19', NULL),
(10, 2, 2, 'QR', 'COMPLETED', 10.00, '2025-03-13 13:54:32', '2025-03-13 22:50:35', NULL),
(11, 2, 2, 'QR', 'COMPLETED', 80.00, '2025-03-13 14:01:08', '2025-03-13 22:48:58', NULL),
(12, 2, 2, 'QR', 'COMPLETED', 50.00, '2025-03-13 14:04:48', '2025-03-13 14:05:15', NULL),
(13, 2, 2, 'QR', 'COMPLETED', 10.00, '2025-03-13 14:10:57', '2025-03-13 15:04:42', NULL),
(14, 2, 2, 'QR', 'COMPLETED', 10.00, '2025-03-13 14:13:55', '2025-03-13 15:04:43', NULL),
(15, 2, 2, 'QR', 'COMPLETED', 10.00, '2025-03-13 14:20:49', '2025-03-13 15:04:43', NULL),
(16, 2, 2, 'QR', 'COMPLETED', 30.00, '2025-03-13 15:03:53', '2025-03-13 15:04:45', NULL),
(17, 2, 2, 'QR', 'COMPLETED', 10.00, '2025-03-13 15:09:34', '2025-03-13 22:43:34', NULL),
(18, 2, 2, 'QR', 'COMPLETED', 50.00, '2025-03-13 15:15:10', '2025-03-13 22:43:33', NULL),
(19, 2, 3, 'QR', 'COMPLETED', 30.00, '2025-03-13 22:06:26', '2025-03-13 22:43:31', NULL),
(20, 2, 3, 'QR', 'COMPLETED', 20.00, '2025-03-13 22:27:19', '2025-03-13 22:46:58', NULL),
(21, 2, 3, 'QR', 'COMPLETED', 20.00, '2025-03-13 22:29:48', '2025-03-13 22:46:57', NULL),
(22, 2, 4, 'QR', 'COMPLETED', 10.00, '2025-03-13 22:33:14', '2025-03-13 22:46:56', NULL),
(23, 2, 5, 'QR', 'COMPLETED', 10.00, '2025-03-13 22:34:30', '2025-03-13 22:46:54', NULL),
(24, 1, 6, 'QR', 'COMPLETED', 30.00, '2025-03-13 22:37:43', '2025-03-13 22:44:57', NULL),
(25, 1, 7, 'QR', 'COMPLETED', 30.00, '2025-03-13 22:45:13', '2025-03-13 22:48:11', NULL),
(26, 1, 8, 'QR', 'COMPLETED', 10.00, '2025-03-13 22:47:55', '2025-03-13 22:48:56', NULL),
(27, 1, 9, 'QR', 'COMPLETED', 40.00, '2025-03-13 22:47:59', '2025-03-13 22:51:37', NULL),
(28, 1, 10, 'QR', 'COMPLETED', 10.00, '2025-03-14 22:19:18', '2025-03-14 22:21:04', NULL),
(29, 1, 11, 'QR', 'COMPLETED', 10.00, '2025-03-14 22:30:30', '2025-03-14 22:31:04', NULL),
(30, NULL, 12, 'WALK_IN', 'COMPLETED', 0.00, '2025-03-14 23:17:59', '2025-03-14 23:17:59', NULL),
(31, NULL, 13, 'WALK_IN', 'COMPLETED', 0.00, '2025-03-14 23:22:06', '2025-03-14 23:22:06', NULL),
(32, NULL, 14, 'WALK_IN', 'COMPLETED', 0.00, '2025-03-15 00:51:23', '2025-03-15 00:51:23', NULL),
(33, 1, 15, 'QR', 'COMPLETED', 10.00, '2025-03-15 00:54:36', '2025-03-15 01:10:09', NULL),
(34, 1, 16, 'QR', 'COMPLETED', 30.00, '2025-03-15 17:14:05', '2025-03-15 17:19:02', NULL),
(35, 1, 17, 'QR', 'COMPLETED', 10.00, '2025-05-08 02:40:29', '2025-05-08 02:42:51', NULL),
(36, 2, 18, 'QR', 'COMPLETED', 10.00, '2025-05-08 05:12:58', '2025-05-15 23:09:28', NULL),
(37, 3, 19, 'QR', 'COMPLETED', 10.00, '2025-05-15 23:10:17', '2025-05-15 23:10:54', NULL),
(38, 3, 20, 'QR', '', 30.00, '2025-05-16 02:05:31', '2025-05-16 02:11:43', NULL),
(39, 3, 21, 'QR', '', 20.00, '2025-05-16 02:29:32', '2025-05-16 02:34:18', NULL),
(40, 3, 22, 'QR', 'COMPLETED', 10.00, '2025-05-16 02:49:01', '2025-05-21 01:12:26', NULL),
(41, 1, 23, 'QR', '', 30.00, '2025-05-21 01:28:57', '2025-05-21 01:29:37', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price`, `subtotal`, `created_at`) VALUES
(4, 4, 1, 3, 10.00, 30.00, '2025-03-13 13:20:41'),
(5, 5, 1, 1, 10.00, 10.00, '2025-03-13 13:22:36'),
(6, 6, 1, 1, 10.00, 10.00, '2025-03-13 13:29:39'),
(7, 7, 1, 1, 10.00, 10.00, '2025-03-13 13:43:01'),
(8, 8, 1, 1, 10.00, 10.00, '2025-03-13 13:47:28'),
(9, 9, 1, 2, 10.00, 20.00, '2025-03-13 13:50:43'),
(10, 10, 1, 1, 10.00, 10.00, '2025-03-13 13:54:32'),
(11, 11, 1, 8, 10.00, 80.00, '2025-03-13 14:01:08'),
(12, 12, 1, 5, 10.00, 50.00, '2025-03-13 14:04:48'),
(13, 13, 1, 1, 10.00, 10.00, '2025-03-13 14:10:57'),
(14, 14, 1, 1, 10.00, 10.00, '2025-03-13 14:13:55'),
(15, 15, 1, 1, 10.00, 10.00, '2025-03-13 14:20:49'),
(16, 16, 1, 3, 10.00, 30.00, '2025-03-13 15:03:53'),
(17, 17, 1, 1, 10.00, 10.00, '2025-03-13 15:09:34'),
(18, 18, 1, 5, 10.00, 50.00, '2025-03-13 15:15:10'),
(19, 19, 1, 3, 10.00, 30.00, '2025-03-13 22:06:26'),
(20, 20, 1, 2, 10.00, 20.00, '2025-03-13 22:27:19'),
(21, 21, 1, 2, 10.00, 20.00, '2025-03-13 22:29:48'),
(22, 22, 1, 1, 10.00, 10.00, '2025-03-13 22:33:14'),
(23, 23, 1, 1, 10.00, 10.00, '2025-03-13 22:34:30'),
(24, 24, 1, 3, 10.00, 30.00, '2025-03-13 22:37:43'),
(25, 25, 1, 3, 10.00, 30.00, '2025-03-13 22:45:13'),
(26, 26, 1, 1, 10.00, 10.00, '2025-03-13 22:47:55'),
(27, 27, 1, 4, 10.00, 40.00, '2025-03-13 22:47:59'),
(28, 28, 1, 1, 10.00, 10.00, '2025-03-14 22:19:18'),
(29, 29, 1, 1, 10.00, 10.00, '2025-03-14 22:30:30'),
(30, 33, 1, 1, 10.00, 10.00, '2025-03-15 00:54:36'),
(31, 34, 1, 3, 10.00, 30.00, '2025-03-15 17:14:05'),
(32, 35, 1, 1, 10.00, 10.00, '2025-05-08 02:40:29'),
(33, 36, 1, 1, 10.00, 10.00, '2025-05-08 05:12:58'),
(34, 37, 1, 1, 10.00, 10.00, '2025-05-15 23:10:17'),
(35, 38, 1, 3, 10.00, 30.00, '2025-05-16 02:05:31'),
(36, 39, 1, 2, 10.00, 20.00, '2025-05-16 02:29:32'),
(37, 40, 1, 1, 10.00, 10.00, '2025-05-16 02:49:01'),
(38, 41, 1, 3, 10.00, 30.00, '2025-05-21 01:28:57');

-- --------------------------------------------------------

--
-- Table structure for table `payment_transactions`
--

CREATE TABLE `payment_transactions` (
  `transaction_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `change_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_method` enum('CASH','GCASH') NOT NULL,
  `status` enum('PENDING','COMPLETED','FAILED') NOT NULL DEFAULT 'PENDING',
  `transaction_reference` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `cashier_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_transactions`
--

INSERT INTO `payment_transactions` (`transaction_id`, `order_id`, `total_amount`, `amount_paid`, `change_amount`, `payment_method`, `status`, `transaction_reference`, `created_at`, `cashier_id`) VALUES
(1, 18, 50.00, 222.00, 172.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 15:15:18', NULL),
(2, 19, 30.00, 100.00, 70.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:06:58', NULL),
(3, 24, 30.00, 111.00, 81.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:39:50', NULL),
(4, 25, 30.00, 111.00, 81.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:45:43', NULL),
(5, 23, 10.00, 123.00, 113.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:45:46', NULL),
(6, 22, 10.00, 55.00, 45.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:45:49', NULL),
(7, 21, 20.00, 555.00, 535.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:45:52', NULL),
(8, 20, 20.00, 111.00, 91.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:45:57', NULL),
(9, 27, 40.00, 111.00, 71.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:48:23', NULL),
(10, 26, 10.00, 21512.00, 21502.00, 'CASH', 'COMPLETED', NULL, '2025-03-13 22:48:26', NULL),
(11, 28, 10.00, 500.00, 490.00, 'CASH', 'COMPLETED', NULL, '2025-03-14 22:19:34', NULL),
(12, 29, 10.00, 122.00, 112.00, 'CASH', 'COMPLETED', NULL, '2025-03-14 22:30:39', 15),
(13, 33, 10.00, 555.00, 545.00, 'CASH', 'COMPLETED', NULL, '2025-03-15 01:09:25', 15),
(14, 34, 30.00, 599.00, 569.00, 'CASH', 'COMPLETED', NULL, '2025-03-15 17:17:33', 15),
(15, 35, 10.00, 10.00, 0.00, 'CASH', 'COMPLETED', NULL, '2025-05-08 02:40:53', 15),
(16, 36, 10.00, 10.00, 0.00, 'CASH', 'COMPLETED', NULL, '2025-05-08 05:13:23', 15),
(17, 37, 10.00, 111.00, 101.00, 'CASH', 'COMPLETED', NULL, '2025-05-15 23:10:32', 15),
(18, 38, 30.00, 1111.00, 1081.00, 'CASH', 'COMPLETED', NULL, '2025-05-16 02:05:52', 15),
(19, 39, 20.00, 100.00, 80.00, 'CASH', 'COMPLETED', NULL, '2025-05-16 02:33:19', 15),
(20, 39, 20.00, 100.00, 80.00, 'CASH', 'COMPLETED', NULL, '2025-05-16 02:33:19', 15),
(21, 40, 10.00, 111.00, 101.00, 'CASH', 'COMPLETED', NULL, '2025-05-16 02:49:17', 15),
(22, 41, 30.00, 3535.00, 3505.00, 'CASH', 'COMPLETED', NULL, '2025-05-21 01:29:29', 15);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_disabled` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_code`, `category_id`, `name`, `description`, `price`, `image_url`, `is_available`, `created_at`, `is_disabled`) VALUES
(1, 'IC1', 1, 'Ice Cream', 'Yummy Coned Dessert', 10.00, 'uploads/products/67d5b10d3e559.jpg', 1, '2025-03-13 12:48:52', 0);

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `reservation_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `table_id` int(11) NOT NULL,
  `reservation_date` date NOT NULL,
  `reservation_time` time NOT NULL,
  `number_of_guests` int(11) NOT NULL,
  `status` enum('PENDING','CONFIRMED','CANCELLED','COMPLETED') NOT NULL DEFAULT 'PENDING',
  `special_requests` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sale_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_transaction_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `total_revenue` decimal(10,2) NOT NULL,
  `cash_revenue` decimal(10,2) NOT NULL DEFAULT 0.00,
  `gcash_revenue` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `processed_by_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`sale_id`, `order_id`, `payment_transaction_id`, `date`, `total_revenue`, `cash_revenue`, `gcash_revenue`, `created_at`, `updated_at`, `processed_by_id`) VALUES
(1, 28, 11, '2025-03-14', 10.00, 10.00, 0.00, '2025-03-14 22:19:34', '2025-03-14 22:19:34', NULL),
(2, 29, 12, '2025-03-14', 10.00, 10.00, 0.00, '2025-03-14 22:30:39', '2025-03-14 22:30:39', 15),
(3, 33, 13, '2025-03-15', 10.00, 10.00, 0.00, '2025-03-15 01:09:25', '2025-03-15 01:09:25', 15),
(4, 34, 14, '2025-03-15', 30.00, 30.00, 0.00, '2025-03-15 17:17:33', '2025-03-15 17:17:33', 15),
(5, 35, 15, '2025-05-08', 10.00, 10.00, 0.00, '2025-05-08 02:40:53', '2025-05-08 02:40:53', 15),
(6, 36, 16, '2025-05-08', 10.00, 10.00, 0.00, '2025-05-08 05:13:23', '2025-05-08 05:13:23', 15),
(7, 37, 17, '2025-05-16', 10.00, 10.00, 0.00, '2025-05-15 23:10:32', '2025-05-15 23:10:32', 15),
(8, 38, 18, '2025-05-16', 30.00, 30.00, 0.00, '2025-05-16 02:05:52', '2025-05-16 02:05:52', 15),
(9, 39, 19, '2025-05-16', 20.00, 20.00, 0.00, '2025-05-16 02:33:19', '2025-05-16 02:33:19', 15),
(10, 39, 20, '2025-05-16', 20.00, 20.00, 0.00, '2025-05-16 02:33:19', '2025-05-16 02:33:19', 15),
(11, 40, 21, '2025-05-16', 10.00, 10.00, 0.00, '2025-05-16 02:49:17', '2025-05-16 02:49:17', 15),
(12, 41, 22, '2025-05-21', 30.00, 30.00, 0.00, '2025-05-21 01:29:29', '2025-05-21 01:29:29', 15);

-- --------------------------------------------------------

--
-- Table structure for table `shift_schedules`
--

CREATE TABLE `shift_schedules` (
  `schedule_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shift_schedules`
--

INSERT INTO `shift_schedules` (`schedule_id`, `name`, `start_time`, `end_time`, `created_at`) VALUES
(1, 'Shift A', '08:45:00', '18:40:00', '2025-03-13 15:45:56');

-- --------------------------------------------------------

--
-- Table structure for table `staff_shifts`
--

CREATE TABLE `staff_shifts` (
  `staff_shift_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `schedule_id` int(11) NOT NULL,
  `shift_date` date NOT NULL,
  `status` enum('PRESENT','ABSENT','LATE','HALF_DAY') NOT NULL DEFAULT 'PRESENT',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff_shifts`
--

INSERT INTO `staff_shifts` (`staff_shift_id`, `employee_id`, `schedule_id`, `shift_date`, `status`, `created_at`) VALUES
(1, 15, 1, '2025-03-14', 'PRESENT', '2025-03-13 21:52:07');

-- --------------------------------------------------------

--
-- Table structure for table `system_logs`
--

CREATE TABLE `system_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_logs`
--

INSERT INTO `system_logs` (`log_id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES
(1, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:30:50'),
(2, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:31:57'),
(3, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:36:01'),
(4, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:38:48'),
(5, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:39:51'),
(6, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:40:09'),
(7, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:45:18'),
(8, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:45:26'),
(9, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:45:49'),
(10, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:49:07'),
(11, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:49:31'),
(12, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 12:55:48'),
(13, 15, 'PROCESS_PAYMENT', 'Processed payment for order #1 using CASH', '::1', '2025-03-13 13:02:33'),
(14, 15, 'PROCESS_PAYMENT', 'Processed payment for order #1 using CASH', '::1', '2025-03-13 13:02:33'),
(15, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:04:39'),
(16, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:08:08'),
(17, 15, 'PROCESS_PAYMENT', 'Processed payment for order #2 using CASH', '::1', '2025-03-13 13:08:25'),
(18, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:08:46'),
(19, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:09:06'),
(20, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:09:17'),
(21, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:09:17'),
(22, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:09:53'),
(23, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:14:54'),
(24, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:17:19'),
(25, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:20:11'),
(26, 15, 'PROCESS_PAYMENT', 'Processed payment for order #4 using CASH', '::1', '2025-03-13 13:21:05'),
(27, 15, 'PROCESS_PAYMENT', 'Processed payment for order #5 using CASH', '::1', '2025-03-13 13:22:49'),
(28, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:23:10'),
(29, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:23:45'),
(30, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:24:01'),
(31, 15, 'PROCESS_PAYMENT', 'Processed payment for order #6 using CASH', '::1', '2025-03-13 13:29:47'),
(32, 15, 'PROCESS_PAYMENT', 'Processed payment for order #7 using CASH', '::1', '2025-03-13 13:45:29'),
(33, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:47:19'),
(34, 15, 'PROCESS_PAYMENT', 'Processed payment for order #8 using CASH', '::1', '2025-03-13 13:48:37'),
(35, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:48:53'),
(36, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:49:17'),
(37, 15, 'PROCESS_PAYMENT', 'Processed payment for order #9 using CASH', '::1', '2025-03-13 13:50:50'),
(38, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:51:13'),
(39, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:51:36'),
(40, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:52:10'),
(41, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:52:47'),
(42, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:54:24'),
(43, 15, 'PROCESS_PAYMENT', 'Processed payment for order #10 using CASH', '::1', '2025-03-13 13:54:39'),
(44, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:55:01'),
(45, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 13:55:15'),
(46, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:01:15'),
(47, 15, 'PROCESS_PAYMENT', 'Processed payment for order #11 using CASH', '::1', '2025-03-13 14:01:24'),
(48, 15, 'PROCESS_PAYMENT', 'Processed payment for order #11 using CASH', '::1', '2025-03-13 14:01:34'),
(49, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:01:55'),
(50, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:02:11'),
(51, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:02:30'),
(52, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:04:54'),
(53, 15, 'PROCESS_PAYMENT', 'Processed payment for order #12 using CASH', '::1', '2025-03-13 14:05:04'),
(54, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:05:12'),
(55, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:05:45'),
(56, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:11:26'),
(57, 15, 'PROCESS_PAYMENT', 'Processed payment for order #13 using CASH', '::1', '2025-03-13 14:11:34'),
(58, 15, 'PROCESS_PAYMENT', 'Processed payment for order #14 using CASH', '::1', '2025-03-13 14:18:45'),
(59, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:33:18'),
(60, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 14:53:26'),
(61, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 15:03:33'),
(62, 15, 'PROCESS_PAYMENT', 'Processed payment for order #16 using CASH', '::1', '2025-03-13 15:04:05'),
(63, 15, 'PROCESS_PAYMENT', 'Processed payment for order #15 using CASH', '::1', '2025-03-13 15:04:12'),
(64, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 15:04:24'),
(65, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 15:05:03'),
(66, 15, 'PROCESS_PAYMENT', 'Processed payment for order #17 using CASH', '::1', '2025-03-13 15:09:42'),
(67, 15, 'PROCESS_PAYMENT', 'Processed payment for order #18 using CASH. Total: 50, Paid: 222, Change: 172', '::1', '2025-03-13 15:15:18'),
(68, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 15:23:33'),
(69, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 15:32:07'),
(70, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 15:33:13'),
(71, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 21:49:42'),
(72, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:06:11'),
(73, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:06:42'),
(74, 15, 'PROCESS_PAYMENT', 'Processed payment for order #19 using CASH. Total: 30, Paid: 100, Change: 70', '::1', '2025-03-13 22:06:58'),
(75, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:27:39'),
(76, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:39:42'),
(77, 15, 'PROCESS_PAYMENT', 'Processed payment for order #24 using CASH. Total: 30, Paid: 111, Change: 81', '::1', '2025-03-13 22:39:50'),
(78, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:42:20'),
(79, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:43:22'),
(80, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:45:18'),
(81, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:45:33'),
(82, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:45:39'),
(83, 15, 'PROCESS_PAYMENT', 'Processed payment for order #25 using CASH. Total: 30, Paid: 111, Change: 81', '::1', '2025-03-13 22:45:43'),
(84, 15, 'PROCESS_PAYMENT', 'Processed payment for order #23 using CASH. Total: 10, Paid: 123, Change: 113', '::1', '2025-03-13 22:45:46'),
(85, 15, 'PROCESS_PAYMENT', 'Processed payment for order #22 using CASH. Total: 10, Paid: 55, Change: 45', '::1', '2025-03-13 22:45:49'),
(86, 15, 'PROCESS_PAYMENT', 'Processed payment for order #21 using CASH. Total: 20, Paid: 555, Change: 535', '::1', '2025-03-13 22:45:52'),
(87, 15, 'PROCESS_PAYMENT', 'Processed payment for order #20 using CASH. Total: 20, Paid: 111, Change: 91', '::1', '2025-03-13 22:45:57'),
(88, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:46:10'),
(89, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:48:17'),
(90, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:48:17'),
(91, 15, 'PROCESS_PAYMENT', 'Processed payment for order #27 using CASH. Total: 40, Paid: 111, Change: 71', '::1', '2025-03-13 22:48:23'),
(92, 15, 'PROCESS_PAYMENT', 'Processed payment for order #26 using CASH. Total: 10, Paid: 21512, Change: 21502', '::1', '2025-03-13 22:48:26'),
(93, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:48:31'),
(94, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:48:50'),
(95, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-13 22:51:45'),
(96, 15, 'PROCESS_PAYMENT', 'Processed payment for order #28 using CASH. Total: 10, Paid: 500, Change: 490', '::1', '2025-03-14 22:19:34'),
(97, 15, 'PROCESS_PAYMENT', 'Processed payment for order #29 using CASH. Total: 10, Paid: 122, Change: 112', '::1', '2025-03-14 22:30:39'),
(98, 15, 'PROCESS_PAYMENT', 'Processed payment for order #33 using CASH. Total: 10, Paid: 555, Change: 545', '::1', '2025-03-15 01:09:25'),
(99, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-15 02:21:15'),
(100, 18, 'LOGIN', 'User logged in successfully', '::1', '2025-03-15 02:29:46'),
(101, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-15 16:53:26'),
(102, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-15 17:10:24'),
(103, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-15 17:15:22'),
(104, 15, 'PROCESS_PAYMENT', 'Processed payment for order #34 using CASH. Total: 30, Paid: 599, Change: 569', '::1', '2025-03-15 17:17:33'),
(105, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-03-15 17:18:24'),
(106, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-15 17:19:22'),
(107, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-03-18 01:19:28'),
(108, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-03-18 02:03:44'),
(109, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-03-18 02:15:28'),
(110, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-05-07 23:46:21'),
(111, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-05-08 00:08:32'),
(112, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-05-08 02:33:01'),
(113, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-05-08 02:34:03'),
(114, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-05-08 02:36:37'),
(115, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-05-08 02:36:47'),
(116, 15, 'PROCESS_PAYMENT', 'Processed payment for order #35 using CASH. Total: 10, Paid: 10, Change: 0', '::1', '2025-05-08 02:40:53'),
(117, 15, 'PROCESS_PAYMENT', 'Processed payment for order #36 using CASH. Total: 10, Paid: 10, Change: 0', '::1', '2025-05-08 05:13:23'),
(118, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-05-15 23:09:27'),
(119, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-05-15 23:10:05'),
(120, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-05-15 23:10:27'),
(121, 15, 'PROCESS_PAYMENT', 'Processed payment for order #37 using CASH. Total: 10, Paid: 111, Change: 101', '::1', '2025-05-15 23:10:32'),
(122, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-05-15 23:10:51'),
(123, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:00:41'),
(124, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:05:21'),
(125, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:05:47'),
(126, 15, 'PROCESS_PAYMENT', 'Processed payment for order #38 using CASH. Total: 30, Paid: 1111, Change: 1081', '::1', '2025-05-16 02:05:52'),
(127, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:06:06'),
(128, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:14:46'),
(129, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:32:50'),
(130, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:33:07'),
(131, 15, 'PROCESS_PAYMENT', 'Processed payment for order #39 using CASH. Total: 20, Paid: 100, Change: 80', '::1', '2025-05-16 02:33:19'),
(132, 15, 'PROCESS_PAYMENT', 'Processed payment for order #39 using CASH. Total: 20, Paid: 100, Change: 80', '::1', '2025-05-16 02:33:19'),
(133, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:36:26'),
(134, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:49:13'),
(135, 15, 'PROCESS_PAYMENT', 'Processed payment for order #40 using CASH. Total: 10, Paid: 111, Change: 101', '::1', '2025-05-16 02:49:17'),
(136, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:49:36'),
(137, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-05-16 02:57:52'),
(138, 14, 'LOGIN', 'User logged in successfully', '::1', '2025-05-21 01:08:51'),
(139, 16, 'LOGIN', 'User logged in successfully', '::1', '2025-05-21 01:12:40'),
(140, NULL, 'TABLE_STATUS', 'Table 3 status changed from OCCUPIED to AVAILABLE', '::1', '2025-05-21 01:15:31'),
(141, NULL, 'TABLE_STATUS', 'Table 3 status changed from AVAILABLE to OCCUPIED', '::1', '2025-05-21 01:16:50'),
(142, NULL, 'TABLE_STATUS', 'Table 3 status changed from OCCUPIED to AVAILABLE', '::1', '2025-05-21 01:16:51'),
(143, 13, 'LOGIN', 'User logged in successfully', '::1', '2025-05-21 01:28:39'),
(144, 15, 'LOGIN', 'User logged in successfully', '::1', '2025-05-21 01:29:15'),
(145, 15, 'PROCESS_PAYMENT', 'Processed payment for order #41 using CASH. Total: 30, Paid: 3535, Change: 3505', '::1', '2025-05-21 01:29:29');

-- --------------------------------------------------------

--
-- Table structure for table `tables`
--

CREATE TABLE `tables` (
  `table_id` int(11) NOT NULL,
  `table_number` varchar(10) NOT NULL,
  `qr_code` varchar(255) NOT NULL,
  `status` enum('AVAILABLE','OCCUPIED','READY','CLEANING') DEFAULT 'AVAILABLE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tables`
--

INSERT INTO `tables` (`table_id`, `table_number`, `qr_code`, `status`, `created_at`) VALUES
(1, '1', 'table_1_67d2d38198ab5', 'OCCUPIED', '2025-03-13 12:45:53'),
(2, '2', 'table_2_67d2da3381171', 'OCCUPIED', '2025-03-13 13:14:27'),
(3, '3', 'table_3_67d3a457eec2c', 'AVAILABLE', '2025-03-14 03:36:55'),
(4, '4', 'table_4_681bf46601c5b', 'AVAILABLE', '2025-05-08 00:01:42');

-- --------------------------------------------------------

--
-- Table structure for table `two_factor_auth_codes`
--

CREATE TABLE `two_factor_auth_codes` (
  `code_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `code` varchar(6) NOT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `two_factor_auth_codes`
--

INSERT INTO `two_factor_auth_codes` (`code_id`, `user_id`, `code`, `is_used`, `expires_at`, `created_at`) VALUES
(1, 13, '262503', 1, '2025-03-15 16:54:39', '2025-03-15 16:53:26'),
(2, 13, '458815', 1, '2025-03-15 17:10:43', '2025-03-15 17:10:24'),
(3, 15, '348907', 1, '2025-03-15 17:15:51', '2025-03-15 17:15:22'),
(4, 14, '687601', 1, '2025-03-15 17:18:38', '2025-03-15 17:18:24'),
(5, 16, '610413', 1, '2025-03-15 17:19:38', '2025-03-15 17:19:22'),
(6, 15, '925797', 1, '2025-03-18 01:20:34', '2025-03-18 01:19:28'),
(7, 16, '184243', 0, '2025-03-18 02:08:44', '2025-03-18 02:03:44'),
(8, 16, '334832', 0, '2025-03-17 19:18:07', '2025-03-18 02:13:07'),
(9, 13, '975773', 1, '2025-03-18 02:15:57', '2025-03-18 02:15:28'),
(10, 13, '018990', 1, '2025-05-07 23:46:56', '2025-05-07 23:46:21'),
(11, 15, '012626', 1, '2025-05-08 00:09:02', '2025-05-08 00:08:32');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','CASHIER','KITCHEN','WAITER') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `employee_id`, `username`, `password`, `role`, `created_at`) VALUES
(13, 13, 'margo', '$2y$10$v0EYhYBlLdySusdcweETx.28ZRK.paxSv/.Iz9aAym4pXPDo7XKza', 'ADMIN', '2025-03-13 12:30:32'),
(14, 14, 'clemens', '$2y$10$v0EYhYBlLdySusdcweETx.28ZRK.paxSv/.Iz9aAym4pXPDo7XKza', 'KITCHEN', '2025-03-13 12:30:32'),
(15, 15, 'francis', '$2y$10$v0EYhYBlLdySusdcweETx.28ZRK.paxSv/.Iz9aAym4pXPDo7XKza', 'CASHIER', '2025-03-13 12:30:32'),
(16, 16, 'khendal', '$2y$10$v0EYhYBlLdySusdcweETx.28ZRK.paxSv/.Iz9aAym4pXPDo7XKza', 'WAITER', '2025-03-13 12:30:32'),
(17, 18, 'dave', '$2y$10$ciRzMjK.WZpGFYVbDZokp.RVS.vqrNFqlnztb/xRBdfhSVzds2cvm', 'KITCHEN', '2025-03-15 02:26:50'),
(18, 19, 'plants', '$2y$10$PkYe0xn2RCPa10Gaqzlf1O9rtkmojNIr7I/tMq.pmeTQMwNvrGGVi', 'WAITER', '2025-03-15 02:29:26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `customer_feedback`
--
ALTER TABLE `customer_feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `table_id` (`table_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `processed_by_id` (`processed_by_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `payment_transactions`
--
ALTER TABLE `payment_transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `cashier_id` (`cashier_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `idx_product_code` (`product_code`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`reservation_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `table_id` (`table_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sale_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `payment_transaction_id` (`payment_transaction_id`),
  ADD KEY `processed_by_id` (`processed_by_id`);

--
-- Indexes for table `shift_schedules`
--
ALTER TABLE `shift_schedules`
  ADD PRIMARY KEY (`schedule_id`);

--
-- Indexes for table `staff_shifts`
--
ALTER TABLE `staff_shifts`
  ADD PRIMARY KEY (`staff_shift_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `schedule_id` (`schedule_id`);

--
-- Indexes for table `system_logs`
--
ALTER TABLE `system_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`table_id`),
  ADD UNIQUE KEY `table_number` (`table_number`);

--
-- Indexes for table `two_factor_auth_codes`
--
ALTER TABLE `two_factor_auth_codes`
  ADD PRIMARY KEY (`code_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `employee_id` (`employee_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `customer_feedback`
--
ALTER TABLE `customer_feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `payment_transactions`
--
ALTER TABLE `payment_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `reservation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `shift_schedules`
--
ALTER TABLE `shift_schedules`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `staff_shifts`
--
ALTER TABLE `staff_shifts`
  MODIFY `staff_shift_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `system_logs`
--
ALTER TABLE `system_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=146;

--
-- AUTO_INCREMENT for table `tables`
--
ALTER TABLE `tables`
  MODIFY `table_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `two_factor_auth_codes`
--
ALTER TABLE `two_factor_auth_codes`
  MODIFY `code_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer_feedback`
--
ALTER TABLE `customer_feedback`
  ADD CONSTRAINT `customer_feedback_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `customer_feedback_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`processed_by_id`) REFERENCES `employees` (`employee_id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `payment_transactions`
--
ALTER TABLE `payment_transactions`
  ADD CONSTRAINT `payment_transactions_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `payment_transactions_ibfk_2` FOREIGN KEY (`cashier_id`) REFERENCES `employees` (`employee_id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`payment_transaction_id`) REFERENCES `payment_transactions` (`transaction_id`),
  ADD CONSTRAINT `sales_ibfk_3` FOREIGN KEY (`processed_by_id`) REFERENCES `employees` (`employee_id`);

--
-- Constraints for table `staff_shifts`
--
ALTER TABLE `staff_shifts`
  ADD CONSTRAINT `staff_shifts_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  ADD CONSTRAINT `staff_shifts_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `shift_schedules` (`schedule_id`);

--
-- Constraints for table `system_logs`
--
ALTER TABLE `system_logs`
  ADD CONSTRAINT `system_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `two_factor_auth_codes`
--
ALTER TABLE `two_factor_auth_codes`
  ADD CONSTRAINT `two_factor_auth_codes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
