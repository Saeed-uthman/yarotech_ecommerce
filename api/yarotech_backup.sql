-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 22, 2026 at 02:03 PM
-- Server version: 10.11.18-MariaDB-cll-lve
-- PHP Version: 8.4.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `yarotech_pos_e-commerce`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `staff_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action_type` varchar(64) NOT NULL,
  `description` text NOT NULL,
  `reference_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `staff_id`, `action_type`, `description`, `reference_id`, `is_read`, `created_at`) VALUES
(1, NULL, 'pos_sale', 'Admin created POS sale YT-20260528-BB7C24 for NGN 271,250.00', 2, 1, '2026-05-28 09:53:35'),
(2, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-29 08:42:42'),
(3, NULL, 'pos_sale', 'Admin created POS sale YT-20260529-1FC250 for NGN 179,875.00', 5, 1, '2026-05-29 08:43:44'),
(4, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260529-1FC250) - Status: success', 6, 1, '2026-05-29 08:43:44'),
(5, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-29 08:46:05'),
(6, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-29 08:46:14'),
(7, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-29 08:50:33'),
(8, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-29 08:50:48'),
(9, NULL, 'user_contact_inquiry', 'User contact_inquiry - Status: success', NULL, 1, '2026-05-29 09:02:27'),
(10, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-29 09:02:41'),
(11, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-29 09:02:46'),
(12, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-29 09:03:50'),
(13, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-30 07:24:48'),
(14, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260530-41F4DC) - Status: success', 7, 1, '2026-05-30 07:26:16'),
(15, NULL, 'order_placed', 'Order YT-20260530-41F4DC placed successfully for NGN 177,375.00 (Ref: YT-PAY-YT2026053041F4DC-9BA36E0E)', 6, 1, '2026-05-30 07:26:30'),
(16, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260530-41F4DC) - Status: success', 7, 1, '2026-05-30 07:26:30'),
(17, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260530-41F4DC) - Status: success', 7, 1, '2026-05-30 07:26:30'),
(18, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-30 09:29:33'),
(19, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-30 09:35:13'),
(20, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-30 09:43:13'),
(21, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-30 09:43:28'),
(22, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-30 10:37:41'),
(23, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260530-034981) - Status: success', 7, 1, '2026-05-30 10:38:21'),
(24, NULL, 'order_placed', 'Order YT-20260530-034981 placed successfully for NGN 21,500.00 (Ref: YT-PAY-YT20260530034981-C3F419F5)', 7, 1, '2026-05-30 10:38:56'),
(25, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260530-034981) - Status: success', 7, 1, '2026-05-30 10:38:56'),
(26, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260530-034981) - Status: success', 7, 1, '2026-05-30 10:38:56'),
(27, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 10:38:59'),
(28, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-30 10:39:35'),
(29, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-30 15:54:55'),
(30, NULL, 'user_user_registered', 'User user_registered (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-05-30 15:59:05'),
(31, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-05-30 15:59:46'),
(32, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260530-CA0241) - Status: success', 8, 1, '2026-05-30 16:01:00'),
(33, NULL, 'order_placed', 'Order YT-20260530-CA0241 placed successfully for NGN 499,875.00 (Ref: YT-PAY-YT20260530CA0241-003B6B13)', 8, 1, '2026-05-30 16:01:13'),
(34, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260530-CA0241) - Status: success', 8, 1, '2026-05-30 16:01:13'),
(35, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260530-CA0241) - Status: success', 8, 1, '2026-05-30 16:01:13'),
(36, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-30 16:07:46'),
(37, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:11:25'),
(38, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:11:40'),
(39, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:11:55'),
(40, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:12:10'),
(41, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:12:36'),
(42, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:13:37'),
(43, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:14:26'),
(44, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:14:40'),
(45, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:14:55'),
(46, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:15:10'),
(47, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:15:25'),
(48, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:15:40'),
(49, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:15:55'),
(50, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:16:10'),
(51, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:16:36'),
(52, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:17:37'),
(53, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:18:37'),
(54, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:19:37'),
(55, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:20:37'),
(56, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:21:33'),
(57, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:21:40'),
(58, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:21:56'),
(59, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:22:10'),
(60, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:22:26'),
(61, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:22:41'),
(62, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:22:56'),
(63, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:23:11'),
(64, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:23:37'),
(65, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:24:36'),
(66, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:25:36'),
(67, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:26:37'),
(68, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:29:28'),
(69, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:29:41'),
(70, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:29:56'),
(71, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:30:11'),
(72, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:30:25'),
(73, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:30:41'),
(74, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:30:55'),
(75, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:31:11'),
(76, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:31:25'),
(77, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:32:37'),
(78, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:33:43'),
(79, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-30 16:35:28'),
(80, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-30 16:55:21'),
(81, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-30 18:09:39'),
(82, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-30 18:13:24'),
(83, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-30 18:13:25'),
(84, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-30 18:13:40'),
(85, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-30 18:15:35'),
(86, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-30 18:15:40'),
(87, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-30 18:32:49'),
(88, NULL, 'user_login_failed', 'User login_failed (saeeduthmanabdullahi@gmail.com) - Status: failed', NULL, 1, '2026-05-31 04:52:55'),
(89, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-05-31 04:53:15'),
(90, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-31 05:10:50'),
(91, NULL, 'user_login_failed', 'User login_failed (saeeduthmanabdullahi@gmail.com) - Status: failed', NULL, 1, '2026-05-31 05:30:50'),
(92, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-05-31 05:31:20'),
(93, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-31 05:32:21'),
(94, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:37:29'),
(95, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:37:44'),
(96, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:37:59'),
(97, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:38:14'),
(98, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:38:31'),
(99, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:39:31'),
(100, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:40:31'),
(101, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:41:31'),
(102, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:44:33'),
(103, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:44:44'),
(104, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:44:59'),
(105, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:45:14'),
(106, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:45:29'),
(107, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:46:31'),
(108, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:47:31'),
(109, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:50:35'),
(110, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-05-31 05:50:50'),
(111, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-31 05:51:42'),
(112, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 05:52:13'),
(113, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-31 05:54:58'),
(114, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-05-31 05:55:29'),
(115, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260531-1E7070) - Status: success', 8, 1, '2026-05-31 05:59:23'),
(116, NULL, 'order_placed', 'Order YT-20260531-1E7070 placed successfully for NGN 268,750.00 (Ref: YT-PAY-YT202605311E7070-3D15C1A9)', 9, 1, '2026-05-31 05:59:34'),
(117, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260531-1E7070) - Status: success', 8, 1, '2026-05-31 05:59:34'),
(118, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260531-1E7070) - Status: success', 8, 1, '2026-05-31 05:59:34'),
(119, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-05-31 05:59:35'),
(120, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-31 06:07:34'),
(121, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 06:09:36'),
(122, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 06:09:51'),
(123, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 06:10:06'),
(124, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 06:10:21'),
(125, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 06:10:36'),
(126, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-31 06:30:49'),
(127, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260531-AF8735) - Status: success', 7, 1, '2026-05-31 06:31:17'),
(128, NULL, 'order_placed', 'Order YT-20260531-AF8735 placed successfully for NGN 274,125.00 (Ref: YT-PAY-YT20260531AF8735-494F0CDA)', 10, 1, '2026-05-31 06:31:28'),
(129, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260531-AF8735) - Status: success', 7, 1, '2026-05-31 06:31:28'),
(130, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260531-AF8735) - Status: success', 7, 1, '2026-05-31 06:31:28'),
(131, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-31 07:48:55'),
(132, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-31 07:50:35'),
(133, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-05-31 15:10:04'),
(134, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-05-31 15:14:12'),
(135, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-05-31 15:14:18'),
(136, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-01 04:51:00'),
(137, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-01 13:25:55'),
(138, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 14:49:47'),
(139, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-06-01 14:51:22'),
(140, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260601-2D3D5D) - Status: success', 8, 1, '2026-06-01 14:53:51'),
(141, NULL, 'order_placed', 'Order YT-20260601-2D3D5D placed successfully for NGN 548,250.00 (Ref: YT-PAY-YT202606012D3D5D-E3AD2C1E)', 11, 1, '2026-06-01 14:54:16'),
(142, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260601-2D3D5D) - Status: success', 8, 1, '2026-06-01 14:54:16'),
(143, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260601-2D3D5D) - Status: success', 8, 1, '2026-06-01 14:54:16'),
(144, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-01 14:55:11'),
(145, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-06-01 15:02:03'),
(146, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 15:03:15'),
(147, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-01 15:04:28'),
(148, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-01 15:58:18'),
(149, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-01 16:08:17'),
(150, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:12:03'),
(151, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:12:18'),
(152, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:12:33'),
(153, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:12:50'),
(154, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:13:26'),
(155, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:14:09'),
(156, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-01 16:14:14'),
(157, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260601-B6B150) - Status: success', 8, 1, '2026-06-01 16:21:38'),
(158, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-06-01 16:21:51'),
(159, NULL, 'order_placed', 'Order YT-20260601-B6B150 placed successfully for NGN 240,000.00 (Ref: YT-PAY-YT20260601B6B150-306BEB32)', 12, 1, '2026-06-01 16:21:53'),
(160, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260601-B6B150) - Status: success', 8, 1, '2026-06-01 16:21:53'),
(161, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260601-B6B150) - Status: success', 8, 1, '2026-06-01 16:21:53'),
(162, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:22:24'),
(163, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:22:29'),
(164, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:33:06'),
(165, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 7, 1, '2026-06-01 16:33:25'),
(166, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-01 16:40:06'),
(167, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:41:37'),
(168, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-01 16:42:23'),
(169, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 8, 1, '2026-06-01 17:30:07'),
(170, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260601-90FA15) - Status: success', 8, 1, '2026-06-01 17:30:55'),
(171, NULL, 'order_placed', 'Order YT-20260601-90FA15 placed successfully for NGN 157,500.00 (Ref: YT-PAY-YT2026060190FA15-6BBC9CA3)', 13, 1, '2026-06-01 17:31:07'),
(172, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260601-90FA15) - Status: success', 8, 1, '2026-06-01 17:31:07'),
(173, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260601-90FA15) - Status: success', 8, 1, '2026-06-01 17:31:07'),
(174, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-02 06:43:55'),
(175, NULL, 'user_user_registered', 'User user_registered (saidusmanabdullahi7@gmail.com) - Status: success', 9, 1, '2026-06-03 08:06:12'),
(176, NULL, 'user_login_success', 'User login_success (saidusmanabdullahi7@gmail.com) - Status: success', 9, 1, '2026-06-03 08:06:57'),
(177, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260603-FF1BD3) - Status: success', 9, 1, '2026-06-03 08:07:13'),
(178, NULL, 'order_placed', 'Order YT-20260603-FF1BD3 placed successfully for NGN 53,750.00 (Ref: YT-PAY-YT20260603FF1BD3-2E235CDF)', 14, 1, '2026-06-03 08:07:25'),
(179, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260603-FF1BD3) - Status: success', 9, 1, '2026-06-03 08:07:25'),
(180, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260603-FF1BD3) - Status: success', 9, 1, '2026-06-03 08:07:25'),
(181, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-06-03 08:07:26'),
(182, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 6, 1, '2026-06-04 07:13:43'),
(183, NULL, 'user_user_registered', 'User user_registered (abdullahisammani2017@gmail.com) - Status: success', 10, 1, '2026-06-04 12:06:20'),
(184, NULL, 'user_login_failed', 'User login_failed (abdullahisammani2017@gmail.com) - Status: failed', NULL, 1, '2026-06-04 12:07:25'),
(185, NULL, 'user_login_success', 'User login_success (abdullahisammani2017@gmail.com) - Status: success', 10, 1, '2026-06-04 12:07:43'),
(186, NULL, 'user_user_registered', 'User user_registered (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-04 12:13:13'),
(187, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-04 12:13:35'),
(188, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-04 12:13:42'),
(189, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-04 12:14:54'),
(190, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-04 12:15:28'),
(191, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-04 12:15:37'),
(192, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-04 14:10:28'),
(193, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-04 14:10:50'),
(194, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-05 15:52:07'),
(195, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-05 15:52:15'),
(196, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-06 04:45:37'),
(197, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-10 11:59:33'),
(198, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-10 11:59:45'),
(199, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-10 12:00:16'),
(200, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-12 14:35:02'),
(201, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-12 16:21:33'),
(202, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-12 16:21:48'),
(203, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-12 16:22:03'),
(204, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-12 16:22:18'),
(205, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-12 16:22:33'),
(206, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-12 16:23:11'),
(207, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-13 04:30:27'),
(208, 11, 'pos_sale', 'Admin created POS sale YT-20260613-1F2023 for NGN 1,257,750.00', 15, 1, '2026-06-13 04:31:07'),
(209, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260613-1F2023) - Status: success', 11, 1, '2026-06-13 04:31:07'),
(210, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-15 07:12:51'),
(211, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-15 14:23:23'),
(212, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-15 14:23:34'),
(213, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-15 15:04:00'),
(214, NULL, 'user_user_registered', 'User user_registered (saidusmanabdullahi7@gmail.com) - Status: success', 12, 1, '2026-06-15 15:04:10'),
(215, NULL, 'user_login_success', 'User login_success (saidusmanabdullahi7@gmail.com) - Status: success', 12, 1, '2026-06-15 15:05:01'),
(216, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260615-814882) - Status: success', 12, 1, '2026-06-15 15:06:21'),
(217, NULL, 'order_placed', 'Order YT-20260615-814882 placed successfully for NGN 107,500.00 (Ref: YT-PAY-YT20260615814882-A01AF3DD)', 16, 1, '2026-06-15 15:06:48'),
(218, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260615-814882) - Status: success', 12, 1, '2026-06-15 15:06:48'),
(219, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260615-814882) - Status: success', 12, 1, '2026-06-15 15:06:48'),
(220, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260615-814882) - Status: success', 12, 1, '2026-06-15 15:07:02'),
(221, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-15 15:07:28'),
(222, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:54:05'),
(223, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:54:20'),
(224, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:54:35'),
(225, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:54:50'),
(226, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:55:05'),
(227, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:55:20'),
(228, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:55:35'),
(229, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:55:50'),
(230, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:56:05'),
(231, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:56:20'),
(232, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:56:35'),
(233, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:56:50'),
(234, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:57:05'),
(235, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:57:21'),
(236, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:57:35'),
(237, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:57:51'),
(238, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:58:06'),
(239, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:58:21'),
(240, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:58:36'),
(241, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 16:59:21'),
(242, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:00:22'),
(243, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:01:21'),
(244, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:04:17'),
(245, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:04:21'),
(246, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:04:36'),
(247, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:04:51'),
(248, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:05:06'),
(249, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:05:21'),
(250, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:05:36'),
(251, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:06:21'),
(252, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:07:21'),
(253, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:10:43'),
(254, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:10:51'),
(255, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:11:06'),
(256, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:11:21'),
(257, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:11:36'),
(258, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:11:51'),
(259, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:12:06'),
(260, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:12:21'),
(261, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:13:22'),
(262, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:14:21'),
(263, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:15:21'),
(264, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:16:21'),
(265, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:17:21'),
(266, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:23:11'),
(267, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:23:21'),
(268, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:23:36'),
(269, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:23:51'),
(270, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:24:06'),
(271, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:24:21'),
(272, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:25:07'),
(273, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:25:21'),
(274, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:25:36'),
(275, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:25:51'),
(276, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:26:21'),
(277, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:27:21'),
(278, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:27:36'),
(279, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:27:51'),
(280, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:28:06'),
(281, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:28:21'),
(282, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:28:42'),
(283, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:28:51'),
(284, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:29:06'),
(285, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:29:21'),
(286, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:29:36'),
(287, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:30:21'),
(288, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:31:21'),
(289, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:32:21'),
(290, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:33:21'),
(291, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:34:21'),
(292, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:35:22'),
(293, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:36:21'),
(294, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:37:56'),
(295, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:37:56'),
(296, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:37:56'),
(297, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:38:06'),
(298, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:38:21'),
(299, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:38:36'),
(300, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:38:51'),
(301, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:40:22'),
(302, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:41:22'),
(303, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-15 17:41:52'),
(304, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-15 17:42:05'),
(305, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-15 17:42:40'),
(306, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-15 18:31:10'),
(307, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-16 09:52:26'),
(308, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-16 13:10:50'),
(309, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-19 14:32:16'),
(310, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-20 11:18:09'),
(311, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-20 11:21:38'),
(312, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-20 11:21:38'),
(313, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-20 11:21:40'),
(314, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-20 11:21:56'),
(315, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-20 11:22:10'),
(316, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 11:48:43'),
(317, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 11:49:56'),
(318, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 12:30:00'),
(319, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-20 13:04:12'),
(320, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-20 13:12:38'),
(321, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 13:19:27'),
(322, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-20 13:20:12'),
(323, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 13:20:13'),
(324, 22, 'pos_sale', 'Staff created POS sale YT-20260620-832AB9 for NGN 258,000.00', 329, 1, '2026-06-20 13:21:09'),
(325, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 13:24:35'),
(326, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 14:38:09'),
(327, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 14:45:30'),
(328, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-06-20 14:45:37'),
(329, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-21 04:13:55'),
(330, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-22 14:38:53'),
(331, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-23 10:15:22'),
(332, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-24 16:10:46'),
(333, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-25 08:51:53'),
(334, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-25 10:29:30'),
(335, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-25 11:17:50'),
(336, 22, 'pos_sale', 'Staff created POS sale YT-20260625-6A864E for NGN 172,000.00', 330, 1, '2026-06-25 11:18:16'),
(337, NULL, 'user_login_success', 'User login_success (elsadeeq24@gmail.com) - Status: success', 20, 1, '2026-06-25 13:49:55'),
(338, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-26 14:43:12'),
(339, 22, 'pos_sale', 'Staff created POS sale YT-20260626-E1C082 for NGN 288,100.00', 331, 1, '2026-06-26 14:44:27'),
(340, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-26 15:01:40'),
(341, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-26 16:28:24'),
(342, NULL, 'user_login_success', 'User login_success (elsadeeq24@gmail.com) - Status: success', 20, 1, '2026-06-26 18:33:45'),
(343, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-27 10:42:39'),
(344, 22, 'pos_sale', 'Staff created POS sale YT-20260627-E5F6BF for NGN 172,000.00', 332, 1, '2026-06-27 10:43:50'),
(345, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-27 12:31:38'),
(346, 22, 'pos_sale', 'Staff created POS sale YT-20260627-7E411A for NGN 13,975.00', 333, 1, '2026-06-27 12:33:24'),
(347, NULL, 'user_login_success', 'User login_success (elsadeeq24@gmail.com) - Status: success', 20, 1, '2026-06-28 11:17:28'),
(348, NULL, 'user_login_success', 'User login_success (elsadeeq24@gmail.com) - Status: success', 20, 1, '2026-06-28 11:20:03'),
(349, 20, 'pos_sale', 'Staff created POS sale YT-20260628-504CB3 for NGN 86,000.00', 334, 1, '2026-06-28 11:21:06'),
(350, NULL, 'user_login_success', 'User login_success (elsadeeq24@gmail.com) - Status: success', 20, 1, '2026-06-28 11:21:18'),
(351, NULL, 'user_login_success', 'User login_success (elsadeeq24@gmail.com) - Status: success', 20, 1, '2026-06-28 11:23:57'),
(352, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-29 08:12:56'),
(353, 22, 'pos_sale', 'Staff created POS sale YT-20260629-467DDB for NGN 86,000.00', 335, 1, '2026-06-29 08:13:15'),
(354, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-29 11:51:13'),
(355, NULL, 'user_login_success', 'User login_success (yarotech@yarotech.com.ng) - Status: success', 18, 1, '2026-06-30 11:19:19'),
(356, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-30 11:26:29'),
(357, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-30 11:33:29'),
(358, 22, 'pos_sale', 'Staff created POS sale YT-20260630-604D2C for NGN 86,000.00', 336, 1, '2026-06-30 11:34:13'),
(359, 22, 'pos_sale', 'Staff created POS sale YT-20260630-B2F606 for NGN 344,000.00', 337, 1, '2026-06-30 11:34:40'),
(360, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-30 12:41:57'),
(361, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-30 12:44:15'),
(362, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-30 12:48:36'),
(363, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 12:48:52'),
(364, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:50:25'),
(365, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-30 12:50:53'),
(366, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:53:39'),
(367, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:53:39'),
(368, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:53:54'),
(369, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:53:54'),
(370, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:54:09'),
(371, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:54:09'),
(372, NULL, 'user_user_registered', 'User user_registered (yarotechnetworklimited@gmail.com) - Status: success', 23, 1, '2026-06-30 12:54:37'),
(373, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:54:47'),
(374, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:54:47'),
(375, NULL, 'user_login_success', 'User login_success (yarotechnetworklimited@gmail.com) - Status: success', 23, 1, '2026-06-30 12:55:22'),
(376, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260630-DD0B27) - Status: success', 23, 1, '2026-06-30 12:56:49'),
(377, NULL, 'order_placed', 'Order YT-20260630-DD0B27 placed successfully for NGN 1,316,875.00 (Ref: YT-PAY-YT20260630DD0B27-E437A8A6)', 338, 1, '2026-06-30 12:58:14'),
(378, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260630-DD0B27) - Status: success', 23, 1, '2026-06-30 12:58:14'),
(379, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260630-DD0B27) - Status: success', 23, 1, '2026-06-30 12:58:14'),
(380, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 12:59:59'),
(381, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:00:14'),
(382, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:00:29'),
(383, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:00:39'),
(384, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:01:14'),
(385, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 13:01:44'),
(386, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:02:47'),
(387, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:02:47'),
(388, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-30 13:02:49'),
(389, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:03:26'),
(390, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:03:47'),
(391, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:03:47'),
(392, NULL, 'user_login_success', 'User login_success (yarotechnetworklimited@gmail.com) - Status: success', 23, 1, '2026-06-30 13:03:52'),
(393, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-06-30 13:04:22'),
(394, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-30 13:04:44'),
(395, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 13:10:22'),
(396, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-06-30 13:12:21'),
(397, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:12:47'),
(398, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:12:47'),
(399, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:12:53'),
(400, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:13:08'),
(401, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:13:49'),
(402, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:13:49'),
(403, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-06-30 13:14:13'),
(404, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 13:20:09'),
(405, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:52:01'),
(406, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 13:52:20'),
(407, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 13:53:18'),
(408, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 14:05:45'),
(409, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 14:06:02'),
(410, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 14:22:44'),
(411, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 14:31:55'),
(412, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-06-30 15:21:59'),
(413, NULL, 'user_user_registered', 'User user_registered (saeeduthmanabdullahi@gmail.com) - Status: success', 24, 1, '2026-06-30 16:39:11'),
(414, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 24, 1, '2026-06-30 16:39:51'),
(415, NULL, 'user_payment_initialize', 'User payment_initialize (Order: YT-20260630-6E6B86) - Status: success', 24, 1, '2026-06-30 16:40:23');
INSERT INTO `activity_logs` (`id`, `staff_id`, `action_type`, `description`, `reference_id`, `is_read`, `created_at`) VALUES
(416, NULL, 'order_placed', 'Order YT-20260630-6E6B86 placed successfully for NGN 197,000.00 (Ref: YT-PAY-YT202606306E6B86-3A0A47DB)', 339, 1, '2026-06-30 16:41:05'),
(417, NULL, 'user_payment_success', 'User payment_success (Order: YT-20260630-6E6B86) - Status: success', 24, 1, '2026-06-30 16:41:05'),
(418, NULL, 'user_payment_verify', 'User payment_verify (Order: YT-20260630-6E6B86) - Status: success', 24, 1, '2026-06-30 16:41:05'),
(419, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-06-30 16:41:07'),
(420, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-06-30 16:42:46'),
(421, NULL, 'user_login_success', 'User login_success (saeeduthmanabdullahi@gmail.com) - Status: success', 24, 1, '2026-06-30 16:43:31'),
(422, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-01 10:11:08'),
(423, NULL, 'user_login_success', 'User login_success (elsadeeq24@gmail.com) - Status: success', 20, 1, '2026-07-01 15:22:29'),
(424, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-01 16:06:55'),
(425, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-01 16:43:45'),
(426, 22, 'pos_sale', 'Staff created POS sale YT-20260701-C50FDA for NGN 102,125.00', 340, 1, '2026-07-01 16:44:03'),
(427, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-02 10:03:53'),
(428, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-02 11:03:09'),
(429, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-02 11:28:34'),
(430, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-02 11:28:57'),
(431, 22, 'pos_sale', 'Staff created POS sale YT-20260702-CE7F92 for NGN 204,250.00', 341, 1, '2026-07-02 11:29:23'),
(432, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-02 11:51:13'),
(433, NULL, 'user_login_failed', 'User login_failed (elsadeeq24@gmail.com) - Status: failed', NULL, 1, '2026-07-02 12:02:16'),
(434, NULL, 'user_login_success', 'User login_success (elsadeeq24@gmail.com) - Status: success', 20, 1, '2026-07-02 12:03:16'),
(435, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-02 12:45:50'),
(436, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-02 13:12:40'),
(437, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-02 13:22:54'),
(438, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-02 13:34:34'),
(439, NULL, 'user_login_failed', 'User login_failed (saeed@gmail.com) - Status: failed', NULL, 1, '2026-07-02 14:28:54'),
(440, NULL, 'user_login_failed', 'User login_failed (saidu@yarotech.com.ng) - Status: failed', NULL, 1, '2026-07-02 14:29:08'),
(441, NULL, 'user_login_failed', 'User login_failed (info@yarotech.com.ng) - Status: failed', NULL, 1, '2026-07-02 14:29:18'),
(442, NULL, 'user_login_failed', 'User login_failed (saeed@gmail.com) - Status: failed', NULL, 1, '2026-07-02 14:29:24'),
(443, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-02 14:29:39'),
(444, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-02 21:57:46'),
(445, NULL, 'user_user_registered', 'User user_registered (saeedusmanabdullahi@gmail.com) - Status: success', 25, 1, '2026-07-02 22:02:45'),
(446, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 25, 1, '2026-07-02 22:03:26'),
(447, NULL, 'user_login_failed', 'User login_failed - Status: failed', NULL, 1, '2026-07-02 22:28:12'),
(448, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 25, 1, '2026-07-03 10:24:42'),
(449, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 25, 1, '2026-07-03 10:24:48'),
(450, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 10:24:52'),
(451, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 10:38:04'),
(452, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 10:38:19'),
(453, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-03 10:41:36'),
(454, 11, 'pos_sale', 'Admin created POS sale YT-20260703-62B898 for NGN 129,000.00', 342, 1, '2026-07-03 11:35:30'),
(455, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260703-62B898) - Status: success', 11, 1, '2026-07-03 11:35:30'),
(456, NULL, 'user_login_failed', 'User login_failed (saeed@yarotech.com.ng) - Status: failed', NULL, 1, '2026-07-03 14:29:22'),
(457, NULL, 'user_login_failed', 'User login_failed (engineer@yarotech.com.ng) - Status: failed', NULL, 1, '2026-07-03 14:29:28'),
(458, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:29:38'),
(459, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 25, 1, '2026-07-03 14:29:54'),
(460, NULL, 'user_login_success', 'User login_success (saeedusmanabdullahi@gmail.com) - Status: success', 25, 1, '2026-07-03 14:30:59'),
(461, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:31:59'),
(462, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:32:07'),
(463, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:32:38'),
(464, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:33:08'),
(465, NULL, 'user_login_failed', 'User login_failed (saeed@yarotech.com.ng) - Status: failed', NULL, 1, '2026-07-03 14:33:15'),
(466, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:33:21'),
(467, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:33:28'),
(468, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:33:37'),
(469, NULL, 'user_login_failed', 'User login_failed (info@yarotech.com.ng) - Status: failed', NULL, 1, '2026-07-03 14:34:05'),
(470, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:35:11'),
(471, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:35:12'),
(472, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:36:32'),
(473, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:36:35'),
(474, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:36:35'),
(475, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:37:13'),
(476, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:37:26'),
(477, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:37:49'),
(478, NULL, 'user_login_failed', 'User login_failed (saidua2018@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:39:02'),
(479, NULL, 'user_login_failed', 'User login_failed (saeed@gmail.com) - Status: failed', NULL, 1, '2026-07-03 14:40:07'),
(480, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 14:40:36'),
(481, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 15:00:36'),
(482, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 15:41:42'),
(483, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-03 16:19:51'),
(484, 22, 'pos_sale', 'Admin created POS sale YT-20260703-A3173A for NGN 86,000.00', 343, 1, '2026-07-03 16:23:04'),
(485, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260703-A3173A) - Status: success', 22, 1, '2026-07-03 16:23:04'),
(486, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 16:53:15'),
(487, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 16:53:24'),
(488, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-03 16:55:39'),
(489, 22, 'pos_sale', 'Admin created POS sale YT-20260703-39E29C for NGN 86,000.00', 344, 1, '2026-07-03 17:14:30'),
(490, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260703-39E29C) - Status: success', 22, 1, '2026-07-03 17:14:30'),
(491, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-07-03 23:38:04'),
(492, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-03 23:38:27'),
(493, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-07-03 23:38:59'),
(494, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-04 05:34:56'),
(495, 11, 'pos_sale', 'Admin created POS sale YT-20260704-C8839F for NGN 1,236,250.00', 345, 1, '2026-07-04 05:36:18'),
(496, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260704-C8839F) - Status: success', 11, 1, '2026-07-04 05:36:18'),
(497, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-04 05:37:35'),
(498, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-04 05:37:48'),
(499, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-04 06:05:21'),
(500, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-07 06:09:16'),
(501, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-07 06:13:29'),
(502, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-07 11:25:17'),
(503, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-07 11:56:55'),
(504, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-07 12:54:11'),
(505, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-07 13:06:07'),
(506, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-07 13:30:49'),
(507, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-07 13:32:51'),
(508, NULL, 'user_login_success', 'User login_success (saeed@yarotech.com.ng) - Status: success', 19, 1, '2026-07-07 13:33:00'),
(509, NULL, 'user_admin_auth_failed', 'User admin_auth_failed - Status: failed', NULL, 1, '2026-07-07 13:57:37'),
(510, NULL, 'user_login_success', 'User login_success (alhassanabubakarismail@gmail.com) - Status: success', 22, 1, '2026-07-07 14:02:56'),
(511, 22, 'pos_sale', 'Admin created POS sale YT-20260707-B095E6 for NGN 86,000.00', 346, 1, '2026-07-07 14:03:48'),
(512, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260707-B095E6) - Status: success', 22, 1, '2026-07-07 14:03:48'),
(513, 22, 'pos_sale', 'Admin created POS sale YT-20260707-2F49F6 for NGN 86,000.00', 347, 1, '2026-07-07 14:04:31'),
(514, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260707-2F49F6) - Status: success', 22, 1, '2026-07-07 14:04:31'),
(515, 22, 'pos_sale', 'Admin created POS sale YT-20260707-9D8A27 for NGN 1,462,000.00', 348, 0, '2026-07-07 14:05:32'),
(516, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260707-9D8A27) - Status: success', 22, 1, '2026-07-07 14:05:32'),
(517, 22, 'pos_sale', 'Admin created POS sale YT-20260707-97F335 for NGN 344,000.00', 349, 1, '2026-07-07 14:07:03'),
(518, NULL, 'user_pos_sale_created', 'User pos_sale_created (Order: YT-20260707-97F335) - Status: success', 22, 1, '2026-07-07 14:07:03'),
(519, NULL, 'user_login_success', 'User login_success (saidua2018@gmail.com) - Status: success', 11, 1, '2026-07-08 10:47:09');

-- --------------------------------------------------------

--
-- Table structure for table `auth_otps`
--

CREATE TABLE `auth_otps` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `code_hash` varchar(255) NOT NULL,
  `purpose` enum('verify_email','reset_password') NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_otps`
--

INSERT INTO `auth_otps` (`id`, `email`, `code_hash`, `purpose`, `expires_at`, `used_at`, `created_at`) VALUES
(1, 'saidua2018@gmail.com', '$2y$10$MB/3C1KikTt/lDEbTTwWW.rF1CB77E7ZRXTV7cyHPWbs2TfaNHp0.', 'verify_email', '2026-05-28 06:48:21', '2026-05-28 06:38:57', '2026-05-28 06:38:21'),
(2, 'saeedusmanabdullahi@gmail.com', '$2y$10$/arnngI.4AARsDtNNKENj.siyUBZZ17FTFxeBoub/LZGLI..he1dW', 'verify_email', '2026-05-28 11:28:34', '2026-05-28 11:19:02', '2026-05-28 11:18:34'),
(3, 'saeeduthmanabdullahi@gmail.com', '$2y$10$f7lDAGP3meA6UODwqwO6AOxlf/1YSt3drnPtjs5aaEv5o5IY1fjmm', 'verify_email', '2026-05-30 16:09:05', '2026-05-30 15:59:35', '2026-05-30 15:59:05'),
(4, 'saeedusmanabdullahi@gmail.com', '$2y$10$fjfhAGaFIpJTGmuk8x4K0u0CHkLXAWA0fd8qzqLDZW4scmYXROHbq', 'reset_password', '2026-05-30 17:21:15', '2026-05-30 17:12:45', '2026-05-30 17:11:15'),
(5, 'saeeduthmanabdullahi@gmail.com', '$2y$10$aTIh8uPwHFpJUGymR90kwOMBjqwuCRwFhAr6mxyrJY7xLkHskuUYy', 'reset_password', '2026-05-30 17:39:03', '2026-05-30 17:30:16', '2026-05-30 17:29:03'),
(6, 'saidusmanabdullahi7@gmail.com', '$2y$10$xmsbZH/U1hdCuNw68ihtOO8hXzZEfB.MyxRssnRyIelV2.0U7A9d.', 'verify_email', '2026-06-03 08:16:12', '2026-06-03 08:06:48', '2026-06-03 08:06:12'),
(7, 'abdullahisammani2017@gmail.com', '$2y$10$G7OzQmrGA774ZqSUF/xDG.PE33OwylPn.0rfpJ1oRAYjD6ez8RkzC', 'verify_email', '2026-06-04 12:16:20', '2026-06-04 12:06:34', '2026-06-04 12:06:20'),
(8, 'saidua2018@gmail.com', '$2y$10$YxpT6vcwBAaXUFssGPJjF.ZIlyP5i/A4h93DHV/voqo7eWpSUJlXO', 'verify_email', '2026-06-04 12:23:13', '2026-06-04 12:13:32', '2026-06-04 12:13:13'),
(9, 'saidusmanabdullahi7@gmail.com', '$2y$10$/XQojTJ8HDH.0LKF7Hylu.h1HjcVyRKYp.ZbEbP0lCtZFNh0QzGpW', 'verify_email', '2026-06-15 15:14:10', '2026-06-15 15:04:46', '2026-06-15 15:04:10'),
(10, 'yarotechnetworklimited@gmail.com', '$2y$10$zqWvILsNxgsiS.faYI6xceF6NM4xu/u8jX6nCw7XygBcQvaF3lG02', 'verify_email', '2026-06-30 13:04:37', '2026-06-30 12:55:06', '2026-06-30 12:54:37'),
(11, 'saeeduthmanabdullahi@gmail.com', '$2y$10$Ruyt8.p.ucIuGgiHk2z7keJ8G6WdsbkXiRx8lgoWNDHngsJSZlWPa', 'verify_email', '2026-06-30 16:49:11', '2026-06-30 16:39:37', '2026-06-30 16:39:11'),
(12, 'saeedusmanabdullahi@gmail.com', '$2y$10$JBLowv2V26pA41h7Xx7i.eq6kXwysNwu/IldJDmuyw0s.o3aC9inu', 'verify_email', '2026-07-02 22:12:46', '2026-07-02 22:03:15', '2026-07-02 22:02:46');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `session_token` varchar(64) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `user_id`, `session_token`, `status`, `created_at`, `updated_at`) VALUES
(5, 12, NULL, 'active', '2026-06-15 15:06:02', '2026-06-15 15:06:02'),
(6, 23, NULL, 'active', '2026-06-30 12:56:14', '2026-06-30 12:56:14'),
(7, 24, NULL, 'active', '2026-06-30 16:40:11', '2026-06-30 16:40:11');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cart_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `unit_price` decimal(12,2) DEFAULT NULL,
  `snapshot_name` varchar(190) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `product_id`, `quantity`, `unit_price`, `snapshot_name`, `created_at`) VALUES
(90, 6, 'PRD-038', 1, NULL, NULL, '2026-06-30 12:56:47'),
(91, 6, 'PRD-081', 1, NULL, NULL, '2026-06-30 12:56:47'),
(92, 6, 'PRD-024', 1, NULL, NULL, '2026-06-30 12:56:47'),
(95, 7, 'PRD-038', 1, NULL, NULL, '2026-06-30 16:40:23');

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `subject` varchar(190) DEFAULT NULL,
  `inquiry_type` enum('General Inquiry','Product Support','Delivery Support','Service Inquiry','Payment Issue','Complaint') NOT NULL DEFAULT 'General Inquiry',
  `service_type` enum('Not applicable','Solar Installation','CCTV Installation','Internet Networking','IT Services') DEFAULT NULL,
  `message` text NOT NULL,
  `status` enum('open','in_progress','resolved') NOT NULL DEFAULT 'open',
  `admin_reply` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `full_name`, `name`, `email`, `phone`, `subject`, `inquiry_type`, `service_type`, `message`, `status`, `admin_reply`, `created_at`, `updated_at`) VALUES
(1, 'Customer', 'SAIDU USMAN ABDULLAHI', 'saidua2018@gmail.com', '08133424701', NULL, 'General Inquiry', NULL, 'hgcvmhjbvfcgv ch vnh', 'resolved', 'how far', '2026-05-29 09:02:27', '2026-06-20 13:13:02');

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages_backup_20260615`
--

CREATE TABLE `contact_messages_backup_20260615` (
  `id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(150) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `subject` varchar(190) DEFAULT NULL,
  `inquiry_type` enum('General Inquiry','Product Support','Delivery Support','Service Inquiry','Payment Issue','Complaint') NOT NULL DEFAULT 'General Inquiry',
  `service_type` enum('Not applicable','Solar Installation','CCTV Installation','Internet Networking','IT Services') DEFAULT NULL,
  `message` text NOT NULL,
  `status` enum('new','read','responded','archived') NOT NULL DEFAULT 'new',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contact_messages_backup_20260615`
--

INSERT INTO `contact_messages_backup_20260615` (`id`, `name`, `email`, `phone`, `subject`, `inquiry_type`, `service_type`, `message`, `status`, `created_at`) VALUES
(1, 'SAIDU USMAN ABDULLAHI', 'saidua2018@gmail.com', '08133424701', NULL, 'General Inquiry', NULL, 'hgcvmhjbvfcgv ch vnh', 'new', '2026-05-29 09:02:27');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `email` varchar(190) DEFAULT NULL,
  `total_orders` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total_spent` decimal(14,2) NOT NULL DEFAULT 0.00,
  `first_order_at` datetime DEFAULT NULL,
  `last_order_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `delivery_zones`
--

CREATE TABLE `delivery_zones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `state` varchar(100) NOT NULL,
  `city_or_lga` varchar(100) NOT NULL,
  `zone_name` varchar(150) NOT NULL,
  `base_fee` decimal(12,2) NOT NULL DEFAULT 0.00,
  `extra_fee_per_kg` decimal(12,2) NOT NULL DEFAULT 0.00,
  `eta_text` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `delivery_zones`
--

INSERT INTO `delivery_zones` (`id`, `state`, `city_or_lga`, `zone_name`, `base_fee`, `extra_fee_per_kg`, `eta_text`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Lagos', 'Ikeja', 'Lagos Ikeja', 7000.00, 1.00, '3', 1, '2026-06-01 16:16:00', '2026-06-01 16:16:00');

-- --------------------------------------------------------

--
-- Table structure for table `email_logs`
--

CREATE TABLE `email_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `recipient_email` varchar(190) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `email_type` varchar(80) NOT NULL DEFAULT 'generic',
  `status` enum('sent','failed') NOT NULL DEFAULT 'sent',
  `error_message` text DEFAULT NULL,
  `related_entity_type` varchar(80) DEFAULT NULL,
  `related_entity_id` varchar(80) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `email_logs`
--

INSERT INTO `email_logs` (`id`, `recipient_email`, `subject`, `email_type`, `status`, `error_message`, `related_entity_type`, `related_entity_id`, `created_at`) VALUES
(1, 'saidua2018@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-05-28 06:38:21'),
(2, 'saidua2018@gmail.com', 'Your YAROTECH order YT-20260528-EC12B6 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '1', '2026-05-28 06:39:35'),
(3, 'saidua2018@gmail.com', 'Payment received for order YT-20260528-EC12B6', 'payment_confirmation', 'sent', NULL, 'payment', '1', '2026-05-28 06:39:35'),
(4, 'support@yarotech.ng', 'New paid order: YT-20260528-EC12B6 - NGN 301,000.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Thu, 28 May 2026 07:39:35 +0100 \r\n220-We do not authorize the use of this', 'order', '1', '2026-05-28 06:39:36'),
(5, 'saeedusmanabdullahi@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-05-28 11:18:35'),
(6, 'saeedusmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260528-C5E3C7 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '3', '2026-05-28 11:20:23'),
(7, 'saeedusmanabdullahi@gmail.com', 'Payment received for order YT-20260528-C5E3C7', 'payment_confirmation', 'sent', NULL, 'payment', '3', '2026-05-28 11:20:23'),
(8, 'support@yarotech.ng', 'New paid order: YT-20260528-C5E3C7 - NGN 376,250.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Thu, 28 May 2026 12:20:23 +0100 \r\n220-We do not authorize the use of this', 'order', '3', '2026-05-28 11:20:23'),
(9, 'saeedusmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260529-E30859 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '4', '2026-05-29 06:01:15'),
(10, 'saeedusmanabdullahi@gmail.com', 'Payment received for order YT-20260529-E30859', 'payment_confirmation', 'sent', NULL, 'payment', '4', '2026-05-29 06:01:15'),
(11, 'support@yarotech.ng', 'New paid order: YT-20260529-E30859 - NGN 326,000.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Fri, 29 May 2026 07:01:15 +0100 \r\n220-We do not authorize the use of this', 'order', '4', '2026-05-29 06:01:15'),
(12, 'saidua2018@gmail.com', 'YAROTECH support ticket TKT-20260529-000001 received', 'contact_ack', 'sent', NULL, 'contact_message', '1', '2026-05-29 09:02:27'),
(13, 'support@yarotech.ng', 'New contact inquiry: TKT-20260529-000001', 'contact_admin', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Fri, 29 May 2026 10:02:27 +0100 \r\n220-We do not authorize the use of this', 'contact_message', '1', '2026-05-29 09:02:27'),
(14, 'saeedusmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260530-41F4DC is confirmed', 'order_confirmation', 'sent', NULL, 'order', '6', '2026-05-30 07:26:30'),
(15, 'saeedusmanabdullahi@gmail.com', 'Payment received for order YT-20260530-41F4DC', 'payment_confirmation', 'sent', NULL, 'payment', '6', '2026-05-30 07:26:30'),
(16, 'support@yarotech.ng', 'New paid order: YT-20260530-41F4DC - NGN 177,375.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Sat, 30 May 2026 08:26:30 +0100 \r\n220-We do not authorize the use of this', 'order', '6', '2026-05-30 07:26:30'),
(17, 'saeedusmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260530-034981 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '7', '2026-05-30 10:38:55'),
(18, 'saeedusmanabdullahi@gmail.com', 'Payment received for order YT-20260530-034981', 'payment_confirmation', 'sent', NULL, 'payment', '7', '2026-05-30 10:38:56'),
(19, 'support@yarotech.ng', 'New paid order: YT-20260530-034981 - NGN 21,500.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Sat, 30 May 2026 11:38:56 +0100 \r\n220-We do not authorize the use of this', 'order', '7', '2026-05-30 10:38:56'),
(20, 'saeeduthmanabdullahi@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-05-30 15:59:05'),
(21, 'saeeduthmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260530-CA0241 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '8', '2026-05-30 16:01:13'),
(22, 'saeeduthmanabdullahi@gmail.com', 'Payment received for order YT-20260530-CA0241', 'payment_confirmation', 'sent', NULL, 'payment', '8', '2026-05-30 16:01:13'),
(23, 'support@yarotech.ng', 'New paid order: YT-20260530-CA0241 - NGN 499,875.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Sat, 30 May 2026 17:01:13 +0100 \r\n220-We do not authorize the use of this', 'order', '8', '2026-05-30 16:01:13'),
(24, 'saeedusmanabdullahi@gmail.com', 'YAROTECH Password Reset', 'forgot_password', 'sent', NULL, NULL, NULL, '2026-05-30 17:11:15'),
(25, 'saeeduthmanabdullahi@gmail.com', 'YAROTECH Password Reset', 'forgot_password', 'sent', NULL, NULL, NULL, '2026-05-30 17:29:03'),
(26, 'support@yarotech.ng', 'New Review: PRD-016 (5/5)', 'admin_new_review', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Sun, 31 May 2026 06:51:25 +0100 \r\n220-We do not authorize the use of this', 'review', '1', '2026-05-31 05:51:25'),
(27, 'saeeduthmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260531-1E7070 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '9', '2026-05-31 05:59:34'),
(28, 'saeeduthmanabdullahi@gmail.com', 'Payment received for order YT-20260531-1E7070', 'payment_confirmation', 'sent', NULL, 'payment', '9', '2026-05-31 05:59:34'),
(29, 'support@yarotech.ng', 'New paid order: YT-20260531-1E7070 - NGN 268,750.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Sun, 31 May 2026 06:59:34 +0100 \r\n220-We do not authorize the use of this', 'order', '9', '2026-05-31 05:59:34'),
(30, 'saeedusmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260531-AF8735 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '10', '2026-05-31 06:31:28'),
(31, 'saeedusmanabdullahi@gmail.com', 'Payment received for order YT-20260531-AF8735', 'payment_confirmation', 'sent', NULL, 'payment', '10', '2026-05-31 06:31:28'),
(32, 'support@yarotech.ng', 'New paid order: YT-20260531-AF8735 - NGN 274,125.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Sun, 31 May 2026 07:31:28 +0100 \r\n220-We do not authorize the use of this', 'order', '10', '2026-05-31 06:31:28'),
(33, 'saeeduthmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260601-2D3D5D is confirmed', 'order_confirmation', 'sent', NULL, 'order', '11', '2026-06-01 14:54:16'),
(34, 'saeeduthmanabdullahi@gmail.com', 'Payment received for order YT-20260601-2D3D5D', 'payment_confirmation', 'sent', NULL, 'payment', '11', '2026-06-01 14:54:16'),
(35, 'support@yarotech.ng', 'New paid order: YT-20260601-2D3D5D - NGN 548,250.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Mon, 01 Jun 2026 15:54:16 +0100 \r\n220-We do not authorize the use of this', 'order', '11', '2026-06-01 14:54:16'),
(36, 'saeeduthmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260601-B6B150 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '12', '2026-06-01 16:21:52'),
(37, 'saeeduthmanabdullahi@gmail.com', 'Payment received for order YT-20260601-B6B150', 'payment_confirmation', 'sent', NULL, 'payment', '12', '2026-06-01 16:21:53'),
(38, 'support@yarotech.ng', 'New paid order: YT-20260601-B6B150 - NGN 240,000.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Mon, 01 Jun 2026 17:21:53 +0100 \r\n220-We do not authorize the use of this', 'order', '12', '2026-06-01 16:21:53'),
(39, 'saeeduthmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260601-90FA15 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '13', '2026-06-01 17:31:06'),
(40, 'saeeduthmanabdullahi@gmail.com', 'Payment received for order YT-20260601-90FA15', 'payment_confirmation', 'sent', NULL, 'payment', '13', '2026-06-01 17:31:07'),
(41, 'support@yarotech.ng', 'New paid order: YT-20260601-90FA15 - NGN 157,500.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.2 #2 Mon, 01 Jun 2026 18:31:07 +0100 \r\n220-We do not authorize the use of this', 'order', '13', '2026-06-01 17:31:07'),
(42, 'saidusmanabdullahi7@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-06-03 08:06:13'),
(43, 'saidusmanabdullahi7@gmail.com', 'Your YAROTECH order YT-20260603-FF1BD3 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '14', '2026-06-03 08:07:24'),
(44, 'saidusmanabdullahi7@gmail.com', 'Payment received for order YT-20260603-FF1BD3', 'payment_confirmation', 'sent', NULL, 'payment', '14', '2026-06-03 08:07:24'),
(45, 'support@yarotech.ng', 'New paid order: YT-20260603-FF1BD3 - NGN 53,750.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.4 #2 Wed, 03 Jun 2026 09:07:24 +0100 \r\n220-We do not authorize the use of this', 'order', '14', '2026-06-03 08:07:25'),
(46, 'abdullahisammani2017@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-06-04 12:06:20'),
(47, 'saidua2018@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-06-04 12:13:14'),
(48, 'saidua2018@gmail.com', 'YAROTECH support reply: TKT-20260615-000001', 'support_reply', 'sent', NULL, 'contact_message', '1', '2026-06-15 14:24:20'),
(49, 'saidusmanabdullahi7@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-06-15 15:04:10'),
(50, 'saidusmanabdullahi7@gmail.com', 'Your YAROTECH order YT-20260615-814882 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '16', '2026-06-15 15:06:47'),
(51, 'saidusmanabdullahi7@gmail.com', 'Payment received for order YT-20260615-814882', 'payment_confirmation', 'sent', NULL, 'payment', '16', '2026-06-15 15:06:47'),
(52, 'support@yarotech.ng', 'New paid order: YT-20260615-814882 - NGN 107,500.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.4 #2 Mon, 15 Jun 2026 16:06:47 +0100 \r\n220-We do not authorize the use of this', 'order', '16', '2026-06-15 15:06:48'),
(53, 'saidua2018@gmail.com', 'YAROTECH support reply: TKT-20260619-000001', 'support_reply', 'sent', NULL, 'contact_message', '1', '2026-06-19 14:32:47'),
(54, 'saidua2018@gmail.com', 'YAROTECH support reply: TKT-20260620-000001', 'support_reply', 'sent', NULL, 'contact_message', '1', '2026-06-20 13:13:02'),
(55, 'yarotechnetworklimited@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-06-30 12:54:37'),
(56, 'yarotechnetworklimited@gmail.com', 'Your YAROTECH order YT-20260630-DD0B27 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '338', '2026-06-30 12:58:13'),
(57, 'yarotechnetworklimited@gmail.com', 'Payment received for order YT-20260630-DD0B27', 'payment_confirmation', 'sent', NULL, 'payment', '281', '2026-06-30 12:58:13'),
(58, 'support@yarotech.ng', 'New paid order: YT-20260630-DD0B27 - NGN 1,316,875.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.4 #2 Tue, 30 Jun 2026 13:58:13 +0100 \r\n220-We do not authorize the use of this', 'order', '338', '2026-06-30 12:58:14'),
(59, 'saeeduthmanabdullahi@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-06-30 16:39:12'),
(60, 'saeeduthmanabdullahi@gmail.com', 'Your YAROTECH order YT-20260630-6E6B86 is confirmed', 'order_confirmation', 'sent', NULL, 'order', '339', '2026-06-30 16:41:05'),
(61, 'saeeduthmanabdullahi@gmail.com', 'Payment received for order YT-20260630-6E6B86', 'payment_confirmation', 'sent', NULL, 'payment', '282', '2026-06-30 16:41:05'),
(62, 'support@yarotech.ng', 'New paid order: YT-20260630-6E6B86 - NGN 197,000.00', 'admin_new_order', 'failed', 'SMTP Error: The following recipients failed: support@yarotech.ng: The mail server could not deliver mail to support@yarotech.ng.  The account\r\nor domain may not exist, they may be blacklisted, or missing the proper dns\r\nentries.\r\n\n\n--- SMTP DEBUG TRACE ---\nConnection: opening to ssl://mail.yarotech.com.ng:465, timeout=10, options=array()\nConnection: opened\nSERVER -> CLIENT: 220-advanced2n.afeeshost.com ESMTP Exim 4.99.4 #2 Tue, 30 Jun 2026 17:41:05 +0100 \r\n220-We do not authorize the use of this', 'order', '339', '2026-06-30 16:41:05'),
(63, 'saeedusmanabdullahi@gmail.com', 'Verify your YAROTECH email', 'email_verification', 'sent', NULL, NULL, NULL, '2026-07-02 22:02:46');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_movements`
--

CREATE TABLE `inventory_movements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `movement_type` varchar(60) NOT NULL,
  `quantity` int(11) NOT NULL,
  `previous_stock` int(11) NOT NULL DEFAULT 0,
  `new_stock` int(11) NOT NULL,
  `reference_type` varchar(40) DEFAULT NULL,
  `reference_id` varchar(120) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` varchar(64) DEFAULT NULL,
  `created_by_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inventory_movements`
--

INSERT INTO `inventory_movements` (`id`, `product_id`, `movement_type`, `quantity`, `previous_stock`, `new_stock`, `reference_type`, `reference_id`, `note`, `created_by`, `created_by_user_id`, `created_at`) VALUES
(55, 'PRD-058', 'stock_adjustment', -20, 22, 2, 'adjustment', 'admin-adjustment:20260616131152', 'Manual stock adjustment', 'admin', NULL, '2026-06-16 13:11:52'),
(56, 'PRD-054', 'stock_adjustment', 1, 1, 2, 'adjustment', 'admin-adjustment:20260616131251', 'Manual stock adjustment', 'admin', NULL, '2026-06-16 13:12:51'),
(57, 'PRD-065', 'stock_adjustment', -10, 11, 1, 'adjustment', 'admin-adjustment:20260616131320', 'Manual stock adjustment', 'admin', NULL, '2026-06-16 13:13:20'),
(58, 'PRD-043', 'stock_adjustment', -120, 124, 4, 'adjustment', 'admin-adjustment:20260616131403', 'Manual stock adjustment', 'admin', NULL, '2026-06-16 13:14:03'),
(59, 'PRD-043', 'stock_adjustment', -1, 4, 3, 'adjustment', 'admin-adjustment:20260616131403', 'Manual stock adjustment', 'admin', NULL, '2026-06-16 13:14:03'),
(60, 'PRD-040', 'stock_adjustment', -5, 6, 1, 'adjustment', 'admin-adjustment:20260616131435', 'Manual stock adjustment', 'admin', NULL, '2026-06-16 13:14:35'),
(61, 'PRD-081', 'stock_adjustment', -1, 3, 2, 'adjustment', 'admin-adjustment:20260623101813', 'Manual stock adjustment', 'admin', NULL, '2026-06-23 10:18:13'),
(62, 'PRD-592420C6', 'stock_adjustment', 1, 0, 1, 'adjustment', 'admin-adjustment:20260625102353', 'Manual stock adjustment', 'admin', NULL, '2026-06-25 10:23:53'),
(63, 'PRD-054', 'correction', -1, 2, 1, 'correction', 'core-update:PRD-054', 'Stock correction via product core update', 'admin', NULL, '2026-06-30 11:20:16'),
(64, 'PRD-043', 'correction', 117, 3, 120, 'correction', 'core-update:PRD-043', 'Stock correction via product core update', 'admin', NULL, '2026-06-30 11:23:36'),
(65, 'PRD-038', 'stock_adjustment', 10, 2, 12, 'adjustment', 'admin-adjustment:20260630125259', 'Manual stock adjustment', 'admin', NULL, '2026-06-30 12:52:59'),
(66, 'PRD-038', 'stock_adjustment', -10, 12, 2, 'adjustment', 'admin-adjustment:20260630125307', 'Manual stock adjustment', 'admin', NULL, '2026-06-30 12:53:07'),
(67, 'PRD-038', 'ecommerce_sale', -1, 2, 1, 'order', 'YT-20260630-DD0B27', 'Ecommerce paid order stock deduction', 'user', 23, '2026-06-30 12:58:10'),
(68, 'PRD-081', 'ecommerce_sale', -1, 2, 1, 'order', 'YT-20260630-DD0B27', 'Ecommerce paid order stock deduction', 'user', 23, '2026-06-30 12:58:10'),
(69, 'PRD-024', 'ecommerce_sale', -1, 1, 0, 'order', 'YT-20260630-DD0B27', 'Ecommerce paid order stock deduction', 'user', 23, '2026-06-30 12:58:10'),
(70, 'PRD-043', 'stock_adjustment', -105, 120, 15, 'adjustment', 'admin-adjustment:20260630131912', 'Manual stock adjustment', 'admin', NULL, '2026-06-30 13:19:12'),
(71, 'PRD-043', 'stock_adjustment', 100, 15, 115, 'adjustment', 'admin-adjustment:20260630131923', 'Manual stock adjustment', 'admin', NULL, '2026-06-30 13:19:23'),
(72, 'PRD-038', 'ecommerce_sale', -1, 1, 0, 'order', 'YT-20260630-6E6B86', 'Ecommerce paid order stock deduction', 'user', 24, '2026-06-30 16:41:04'),
(73, 'PRD-C9F837A7', 'stock_adjustment', 2, 0, 2, 'adjustment', 'admin-adjustment:20260702101525', 'Manual stock adjustment', 'admin', NULL, '2026-07-02 10:15:25'),
(74, 'PRD-081', 'stock_adjustment', 1, 1, 2, 'adjustment', 'admin-adjustment:20260702115648', 'Manual stock adjustment', 'admin', NULL, '2026-07-02 11:56:48'),
(75, 'PRD-081', 'stock_adjustment', 3, 2, 5, 'adjustment', 'admin-adjustment:20260702115700', 'Manual stock adjustment', 'admin', NULL, '2026-07-02 11:57:00'),
(76, 'PRD-081', 'stock_adjustment', -2, 5, 3, 'adjustment', 'admin-adjustment:20260702115728', 'Manual stock adjustment', 'admin', NULL, '2026-07-02 11:57:28'),
(77, 'PRD-C9F837A7', 'pos_sale', -1, 2, 1, 'order', 'YT-20260703-62B898', 'POS sale stock deduction', 'admin', 11, '2026-07-03 11:35:30'),
(78, 'PRD-043', 'pos_sale', -1, 115, 114, 'order', 'YT-20260703-A3173A', 'POS sale stock deduction', 'admin', 22, '2026-07-03 16:23:04'),
(79, 'PRD-043', 'pos_sale', -1, 114, 113, 'order', 'YT-20260703-39E29C', 'POS sale stock deduction', 'admin', 22, '2026-07-03 17:14:30'),
(80, 'PRD-054', 'pos_sale', -1, 1, 0, 'order', 'YT-20260704-C8839F', 'POS sale stock deduction', 'admin', 11, '2026-07-04 05:36:18'),
(81, 'PRD-043', 'pos_sale', -1, 113, 112, 'order', 'YT-20260707-B095E6', 'POS sale stock deduction', 'admin', 22, '2026-07-07 14:03:48'),
(82, 'PRD-043', 'pos_sale', -1, 112, 111, 'order', 'YT-20260707-2F49F6', 'POS sale stock deduction', 'admin', 22, '2026-07-07 14:04:31'),
(83, 'PRD-043', 'pos_sale', -17, 111, 94, 'order', 'YT-20260707-9D8A27', 'POS sale stock deduction', 'admin', 22, '2026-07-07 14:05:32'),
(84, 'PRD-043', 'pos_sale', -4, 94, 90, 'order', 'YT-20260707-97F335', 'POS sale stock deduction', 'admin', 22, '2026-07-07 14:07:03');

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `company_address` varchar(255) DEFAULT NULL,
  `company_phone` varchar(50) DEFAULT NULL,
  `customer_name` varchar(255) NOT NULL,
  `issuer_name` varchar(255) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tax` decimal(12,2) NOT NULL DEFAULT 0.00,
  `vat_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `profit` decimal(12,2) NOT NULL DEFAULT 0.00,
  `products` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`products`)),
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `user_id`, `invoice_number`, `company_name`, `company_address`, `company_phone`, `customer_name`, `issuer_name`, `subtotal`, `tax`, `vat_rate`, `total`, `profit`, `products`, `created_at`) VALUES
('020af11c-a233-4cc5-8814-c931ca1d2d37', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-25312730', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khaleepha', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-18 14:15:13'),
('0937b56b-d4ac-477c-8bd0-a3e32629c1e6', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-15730034', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Umbil yola', 'alhassanabubakarismail@gmail.com', 100000.00, 7500.00, 7.50, 107500.00, 20000.00, '[{\"id\":\"a42a2153-f9b5-47fc-977c-7c5b373c04da\",\"name\":\"MIKROTIC RB951ui\",\"price\":100000,\"quantity\":1,\"companyPrice\":100000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":7500}]', '2026-03-19 09:22:10'),
('0a90b7f5-cfe8-4cbf-94db-a7375e6d4ac4', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-97996905', 'YAROTECH NETWORK  TPS', 'Farm center Kano, Nigeria', '+234 81 4024 4774', 'Umar sammani yaro', 'elsadeeq24@gmail.com', 440000.00, 33000.00, 0.00, 473000.00, 45584.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":4},{\"id\":\"9308423e-bce1-42a1-bc78-82daaf687eaa\",\"name\":\"Switch 8port Net-pro\",\"price\":100000,\"quantity\":1}]', '2026-02-04 08:39:56'),
('0ab6c6d0-8c26-458f-a382-7900ee7d9fbe', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-05855994', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Kalkala', 'elsadeeq24@gmail.com', 225000.00, 16875.00, 0.00, 241875.00, 15000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":75000,\"quantity\":3}]', '2026-02-11 09:30:53'),
('0be0c88a-20f7-4b02-a3c7-849ac00c6f76', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-67396429', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul Office work', 'alhassanabubakarismail@gmail.com', 130000.00, 9750.00, 0.00, 139750.00, 23396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":1},{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":1}]', '2026-03-01 11:16:36'),
('0cc8d420-303b-4f6b-823e-1d33da4c0777', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-28997509', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ishaq rabiu ', 'elsadeeq24@gmail.com', 20000.00, 1500.00, 0.00, 21500.00, 5000.00, '[{\"id\":\"7913d4cb-5c13-4464-882d-cebf9a86d99b\",\"name\":\"WIFI camera socket\",\"price\":20000,\"quantity\":1}]', '2026-03-12 14:23:18'),
('0dd6b1af-26b2-44ef-a7f8-a36a80550288', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-87837937', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-27 10:03:58'),
('0e26ccd4-47c0-4848-a1b6-73a7907a8440', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-78192736', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul Kaduna', 'alhassanabubakarismail@gmail.com', 85000.00, 6375.00, 0.00, 91375.00, 6396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":1}]', '2026-03-01 14:16:32'),
('103af74c-21d4-4f1a-86b2-87d11a1af657', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-90635915', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'AL-HASSAN', 45000.00, 0.00, 7.50, 45000.00, 17000.00, '[{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":1,\"companyPrice\":45000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-06-03 11:43:56'),
('1141df57-d1e4-4b61-9824-2afd55ea3023', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-98654671', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa', 'alhassanabubakarismail@gmail.com', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-03-28 10:50:55'),
('12b89046-628a-4a26-add8-c0dc7a7036a0', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-16820230', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk ', 'alhassanabubakarismail@gmail.com', 270000.00, 20250.00, 7.50, 290250.00, 34188.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":3,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":20250}]', '2026-03-29 19:40:20'),
('13cf0252-971a-4367-9e45-aecbd818fad8', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-44262477', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ausad Kaduna', 'alhassanabubakarismail@gmail.com', 285000.00, 21375.00, 7.50, 306375.00, 49188.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":95000,\"quantity\":3,\"companyPrice\":95000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":21375}]', '2026-03-18 13:31:02'),
('1536c71b-4d94-4c1d-91f9-3d53ef3fe27f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-30697641', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Umbil Yola', 'alhassanabubakarismail@gmail.com', 10000.00, 750.00, 0.00, 10750.00, 5300.00, '[{\"id\":\"1d1b3c74-78f7-4932-92bc-840dbe7b1ef5\",\"name\":\"cat6 20meter\",\"price\":10000,\"quantity\":1}]', '2026-03-04 12:24:58'),
('1beb23c4-019c-4cef-95d2-5d062ef28e14', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-61965869', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'MX Prime', 'AL-HASSAN', 125000.00, 9375.00, 7.50, 134375.00, 60800.00, '[{\"id\":\"1d1b3c74-78f7-4932-92bc-840dbe7b1ef5\",\"name\":\"cat6 20meter\",\"price\":10000,\"quantity\":4,\"companyPrice\":10000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":3000},{\"id\":\"d8a99a41-9611-4c89-b03a-51f4206724e6\",\"name\":\"Tenda N301\",\"price\":25000,\"quantity\":2,\"companyPrice\":25000,\"markup\":0,\"maxMarkup\":40000,\"vatEnabled\":true,\"vatAmount\":3750},{\"id\":\"7a940362-8d6e-47c1-b49e-ee1dd5f0cf7a\",\"name\":\"DLINK DIR-650IN\",\"price\":35000,\"quantity\":1,\"companyPrice\":35000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":2625}]', '2026-04-29 10:26:06'),
('1becd552-1ac6-45cc-b28b-ca3b5c3497d1', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-23018565', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Usman', 'alhassanabubakarismail@gmail.com', 95000.00, 7125.00, 0.00, 102125.00, 11696.00, '[{\"id\":\"1d1b3c74-78f7-4932-92bc-840dbe7b1ef5\",\"name\":\"cat6 20meter\",\"price\":10000,\"quantity\":1},{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":1}]', '2026-02-26 15:23:39'),
('1c8a6521-95a3-4bf8-b6e3-822447bf0d78', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-44150443', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Mr Brains Replaced ', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-16 11:55:50'),
('21833728-e256-4c30-a60f-e5188cb69b52', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-41634774', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Anas Jos', 'alhassanabubakarismail@gmail.com', 235000.00, 17625.00, 0.00, 252625.00, 49792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":95000,\"quantity\":2},{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":1}]', '2026-03-17 09:00:34'),
('21a85ea0-4cad-442e-98ae-d7c8486e2b31', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-24516857', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa', 'alhassanabubakarismail@gmail.com', 200000.00, 15000.00, 0.00, 215000.00, 44275.00, '[{\"id\":\"eee6a315-2547-452a-b0b7-c1fbd9251aeb\",\"name\":\"LAP-GPS\",\"price\":200000,\"quantity\":1}]', '2026-03-11 09:21:56'),
('232c3aaf-576c-4dcd-8380-ca9bdd8afca0', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-04538300', 'YAROTECH NETWORK LIMITED', '122 Lukoro Plaza Farm center GSM Market, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'alhassanabubakarismail@gmail.com', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-07 22:28:59'),
('235cf57a-822c-400e-93f7-2eaf6fa2e475', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-81861877', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Auwalu', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-14 14:51:02'),
('255138d4-874d-4b00-b47e-9dcdd4e03376', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-99176136', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Office work', 'AL-HASSAN', 40000.00, 3000.00, 7.50, 43000.00, 7000.00, '[{\"id\":\"27b56358-3b28-4487-b456-c6a86b3df7a5\",\"name\":\"Tiandy ip camera 4MP Outdoor\",\"price\":40000,\"quantity\":1,\"companyPrice\":40000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":3000}]', '2026-04-27 13:12:56'),
('26aa0d53-e644-424d-b316-3c77365d440d', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-08280999', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Malam Isa', 'alhassanabubakarismail@gmail.com', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-03-28 13:31:22'),
('28ab8f72-0fd2-4a89-8e3c-77794f7f7b60', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-74482840', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul Kaduna', 'alhassanabubakarismail@gmail.com', 1448250.00, 108618.75, 0.00, 1556868.75, 137968.00, '[{\"id\":\"333126e4-b4f8-4dad-b993-c4a67f1af392\",\"name\":\"STARLINK V4\",\"price\":540000,\"quantity\":1},{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":8},{\"id\":\"47e41f91-20b1-4689-bb9a-7b50f20b1d61\",\"name\":\"Switch 10port TPlink\",\"price\":130000,\"quantity\":1},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":50},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":95000,\"quantity\":1}]', '2026-02-22 14:34:43'),
('2b0f92ec-a621-435e-a176-33e0dfde6983', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-63745057', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Aliyu Huawei', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-30 14:42:25'),
('2ca8986e-f8f9-479b-b291-17c94ffa0721', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-94663105', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Sadeeq Customer', 'alhassanabubakarismail@gmail.com', 64000.00, 4800.00, 0.00, 68800.00, 14000.00, '[{\"id\":\"564b3400-0948-479c-96e2-3d03eff0d322\",\"name\":\"Tiandy NVR 4chl\",\"price\":50000,\"quantity\":1},{\"id\":\"2b376c63-d226-4d5d-8fcc-aa9afd703896\",\"name\":\"HDD 500GB\",\"price\":14000,\"quantity\":1}]', '2026-02-12 10:11:03'),
('2d7ee238-d4e3-4973-828d-dd4d03f516db', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-30433483', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk ', 'AL-HASSAN', 80000.00, 6000.00, 7.50, 86000.00, 10000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":1,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":6000}]', '2026-05-08 07:53:54'),
('2da2ea1a-b0dc-4ecc-9e90-923515d1290c', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-31773273', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Eng Abdul ', 'EL-SADEEQ', 252000.00, 18900.00, 7.50, 270900.00, 52000.00, '[{\"id\":\"b379af1b-fe38-45d3-8a78-bb33a94b6493\",\"name\":\"Tiandy 2mp Indoor\",\"price\":19000,\"quantity\":4,\"companyPrice\":19000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":5700},{\"id\":\"cb5ae788-bd21-4fda-9d4d-0a2baa48d4d6\",\"name\":\"Tiandy 2mp Outdoor\",\"price\":19000,\"quantity\":4,\"companyPrice\":19000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":5700},{\"id\":\"9308423e-bce1-42a1-bc78-82daaf687eaa\",\"name\":\"Switch 8port Net-pro\",\"price\":100000,\"quantity\":1,\"companyPrice\":100000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":7500}]', '2026-05-31 11:49:31'),
('2e40bc42-4637-4b51-bb7d-a90b630648a9', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-07466184', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Muhd Niger', 'AL-HASSAN', 240000.00, 18000.00, 7.50, 258000.00, 30000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":3,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":18000}]', '2026-06-03 16:24:26'),
('2e522722-605e-4f36-872a-d29667a484c1', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-41182821', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Opera', 'alhassanabubakarismail@gmail.com', 65000.00, 4875.00, 0.00, 69875.00, 20000.00, '[{\"id\":\"6d35b7f7-7597-4f3a-9725-0b75a9805eb3\",\"name\":\"U4 RACK\",\"price\":65000,\"quantity\":1}]', '2026-02-25 16:39:43'),
('2f8b4445-9ecb-46af-a904-d22133f8eef3', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-57634727', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Nazzara Taraba', 'AL-HASSAN', 935000.00, 60000.00, 7.50, 995000.00, 151000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":10,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":60000},{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":3,\"companyPrice\":45000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-06-06 13:53:55'),
('306df9db-afe2-4d6b-9359-f8fac9998616', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-75047503', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Muhammad Baba', 'alhassanabubakarismail@gmail.com', 100000.00, 7500.00, 0.00, 107500.00, 20000.00, '[{\"id\":\"a42a2153-f9b5-47fc-977c-7c5b373c04da\",\"name\":\"MIKROTIC RB951ui\",\"price\":100000,\"quantity\":1}]', '2026-02-28 09:37:27'),
('30a0e17c-2c42-4735-88f0-56acf41f6afb', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-23715673', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Office Work', 'alhassanabubakarismail@gmail.com', 75000.00, 5625.00, 0.00, 80625.00, 5000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":75000,\"quantity\":1}]', '2026-03-05 14:15:16'),
('359b227b-3b19-4dbf-82ac-5da0420a3ca6', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-73522791', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Mr Brain ', 'AL-HASSAN', 180000.00, 13500.00, 7.50, 193500.00, 22792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500}]', '2026-04-13 08:45:22'),
('37504356-a907-4908-941a-738317b1224a', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-04286695', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ishaq Rabiu', 'alhassanabubakarismail@gmail.com', 200000.00, 15000.00, 0.00, 215000.00, 25000.00, '[{\"id\":\"09798be8-6d9c-498e-88d7-a10b561c1276\",\"name\":\"Inverter Haisic 1.5kva\",\"price\":200000,\"quantity\":1}]', '2026-03-14 15:04:47'),
('3901fbce-6a30-4add-9e24-bc469c0cc933', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-48326133', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'AL-HASSAN', 375000.00, 0.00, 7.50, 375000.00, 14800.00, '[{\"id\":\"2258b873-0b62-4ffc-8084-3db0acc7740d\",\"name\":\"MUST battery 1kwh all in one\",\"price\":375000,\"quantity\":1,\"companyPrice\":375000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-04-30 10:25:26'),
('3a3dd17c-ba3c-41e9-aee4-f11c1583571d', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-20554722', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'AL-HASSAN', 156500.00, 11737.50, 7.50, 168237.50, 23500.00, '[{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":1,\"companyPrice\":75000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":5625},{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":1,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":6000},{\"id\":\"94440229-ed4b-442a-92ea-37e808199b38\",\"name\":\"cat6 2meter\",\"price\":1500,\"quantity\":1,\"companyPrice\":1500,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":112.5}]', '2026-05-18 15:09:11'),
('3a82cc27-cad1-42d8-95b6-4d0f576c5fe6', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-15515361', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'AL-HASSAN', 270000.00, 20250.00, 7.50, 290250.00, 34188.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":3,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":20250}]', '2026-05-25 12:25:13'),
('3ba7e915-4742-4ef3-bafc-e9151dd4d3e1', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-73674649', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa', 'alhassanabubakarismail@gmail.com', 130000.00, 9750.00, 0.00, 139750.00, 119000.00, '[{\"id\":\"28f05f87-805a-4585-8c4a-43c91a7e236f\",\"name\":\"Litebeam 5AC\",\"price\":130000,\"quantity\":1}]', '2026-03-09 15:27:54'),
('3bd60286-fa92-4c47-9415-ef2d606b521f', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-77859696', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Eng Abdul ', 'elsadeeq24@gmail.com', 380000.00, 28500.00, 7.50, 408500.00, 65584.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":95000,\"quantity\":4,\"companyPrice\":95000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":28500}]', '2026-03-23 13:57:40'),
('3eb38306-f881-45a3-9843-aa3b9d2a147a', '1be7cdeb-3b78-4cc9-8c43-acbe57675029', 'INV-58094690', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa ', 'yarotech@yarotech.com.ng', 133000.00, 9975.00, 0.00, 142975.00, 62000.00, '[{\"id\":\"7a940362-8d6e-47c1-b49e-ee1dd5f0cf7a\",\"name\":\"DLINK DIR-650IN\",\"price\":35000,\"quantity\":3},{\"id\":\"4a40b3c1-c1fd-447e-9e4f-b6ae28a1d38f\",\"name\":\"Ethernet Power Adaptor second used 24V\",\"price\":14000,\"quantity\":2}]', '2026-03-09 11:08:15'),
('3eb84d13-5d0b-41c5-8d1e-d32f7de1a42b', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-73131968', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Auwalu ', 'AL-HASSAN', 250000.00, 18750.00, 7.50, 268750.00, 0.00, '[{\"id\":\"e2102869-d7b5-48d0-a78c-3d83fff372be\",\"name\":\"HUAWEI S110 16PORT\",\"price\":250000,\"quantity\":1,\"companyPrice\":250000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":18750}]', '2026-04-13 08:38:52'),
('4324d238-93ee-45e2-8564-1e1d8ee8a33e', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-38100973', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa Customer ', 'alhassanabubakarismail@gmail.com', 425000.00, 31875.00, 0.00, 456875.00, 31980.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":5}]', '2026-02-16 09:35:01'),
('44958dff-af47-400c-8ca3-3b83c3d1a63f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-29277561', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Mr Jacky Skyrun', 'alhassanabubakarismail@gmail.com', 540000.00, 40500.00, 0.00, 580500.00, 41050.00, '[{\"id\":\"333126e4-b4f8-4dad-b993-c4a67f1af392\",\"name\":\"STARLINK V4\",\"price\":540000,\"quantity\":1}]', '2026-02-24 09:34:37'),
('44d0dd39-460d-49be-9bd3-895f6f6052e2', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-43439063', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Abu Jaafar', 'AL-HASSAN', 629475.00, 39335.63, 7.50, 668810.63, 94517.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500},{\"id\":\"da48c070-f3fa-4ac9-9c48-82764ed9e64b\",\"name\":\"HUAWEI S110 8PORT\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":105000,\"quantity\":1,\"companyPrice\":105000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0},{\"id\":\"94440229-ed4b-442a-92ea-37e808199b38\",\"name\":\"cat6 2meter\",\"price\":1500,\"quantity\":1,\"companyPrice\":1500,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":112.5},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":15,\"companyPrice\":65,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":73.1299999999999954525264911353588104248046875},{\"id\":\"4035a722-581f-4133-b7b8-d283c548e7f3\",\"name\":\"tiandy smart mini battery camera\",\"price\":72000,\"quantity\":1,\"companyPrice\":72000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":5400},{\"id\":\"d355c953-646b-4bd2-a37f-9479715fa2b1\",\"name\":\"Mikrotik AX2\",\"price\":140000,\"quantity\":1,\"companyPrice\":140000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":10500}]', '2026-04-17 15:30:39'),
('44e1438f-9ab3-419e-8e04-5e2e3734dd63', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-20022178', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ishaq rabiu ', 'elsadeeq24@gmail.com', 20000.00, 1500.00, 0.00, 21500.00, 5000.00, '[{\"id\":\"7913d4cb-5c13-4464-882d-cebf9a86d99b\",\"name\":\"WIFI camera socket\",\"price\":20000,\"quantity\":1}]', '2026-03-13 15:40:22'),
('46079161-4573-4474-a01f-eefb94e0a2a4', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-99195809', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa Customer ', 'alhassanabubakarismail@gmail.com', 85000.00, 6375.00, 0.00, 91375.00, 6396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":1}]', '2026-02-19 10:06:35'),
('471fa3d6-2345-4ddb-937f-29ef28354f4f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-84152017', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ishaq ', 'AL-HASSAN', 237600.00, 17820.00, 7.50, 255420.00, 33600.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":2,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":12000},{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":1,\"companyPrice\":75000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":5625},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":40,\"companyPrice\":65,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":195}]', '2026-06-13 19:55:53'),
('498ff19d-598c-4395-8566-16d5f01f4c3e', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-77549274', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Auwalu shehu Abubakar ', 'elsadeeq24@gmail.com', 315000.00, 23625.00, 0.00, 338625.00, 35000.00, '[{\"id\":\"9a7f6d72-8d10-469b-9ed8-5746d411b07b\",\"name\":\"Itel 1kwh battery all in one\",\"price\":315000,\"quantity\":1}]', '2026-03-16 15:12:29'),
('4b071ccb-4973-4be3-ac1d-76c1e258027f', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-24379148', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Dan Daura', 'elsadeeq24@gmail.com', 900000.00, 67500.00, 0.00, 967500.00, 143376.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":6},{\"id\":\"47e41f91-20b1-4689-bb9a-7b50f20b1d61\",\"name\":\"Switch 10port TPlink\",\"price\":130000,\"quantity\":3}]', '2026-02-11 14:39:36'),
('4be72d68-750a-46ee-abcd-1a4c7dea61b3', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-71466656', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Shamsu', 'alhassanabubakarismail@gmail.com', 95000.00, 7125.00, 7.50, 102125.00, 16396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":95000,\"quantity\":1,\"companyPrice\":95000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":7125}]', '2026-03-24 15:57:46'),
('4c788a28-c0c9-474c-96a6-fc0bb357f6b9', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-01462152', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul Kaduna', 'alhassanabubakarismail@gmail.com', 180000.00, 13500.00, 0.00, 193500.00, 22660.00, '[{\"id\":\"ff89786d-aecc-4c2d-ac8c-7bb31d4339bd\",\"name\":\"MIKROTIC LOO9\",\"price\":180000,\"quantity\":1}]', '2026-03-13 10:31:02'),
('4d9ffd83-16b2-42c1-b851-c1eef307ccb6', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-11608498', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Umbil Yola', 'alhassanabubakarismail@gmail.com', 100000.00, 7500.00, 0.00, 107500.00, 20000.00, '[{\"id\":\"a42a2153-f9b5-47fc-977c-7c5b373c04da\",\"name\":\"MIKROTIC RB951ui\",\"price\":100000,\"quantity\":1}]', '2026-03-13 13:20:08'),
('4dba0a5e-7417-427d-9c58-72c044c922d5', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-86962875', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'AA kuraye', 'AL-HASSAN', 555000.00, 33750.00, 7.50, 588750.00, 86000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":4,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":24000},{\"id\":\"da48c070-f3fa-4ac9-9c48-82764ed9e64b\",\"name\":\"HUAWEI S110 8PORT\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":105000,\"quantity\":1,\"companyPrice\":105000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-05-12 10:56:03'),
('4ff25578-4cf7-47be-aa3a-d1d9f21b69af', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-20683070', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Nazzara', 'AL-HASSAN', 96500.00, 7237.50, 7.50, 103737.50, 12896.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":100,\"companyPrice\":65,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":487.5}]', '2026-05-18 15:11:24'),
('50018351-11b1-4314-90a9-f2b8bc909c75', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-15531042', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'AL-HASSAN', 185000.00, 13875.00, 7.50, 198875.00, 26396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750},{\"id\":\"85673cec-91b2-4527-b53b-7fe628c1f2d4\",\"name\":\"LOCO 5AC\",\"price\":95000,\"quantity\":1,\"companyPrice\":95000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":7125}]', '2026-05-25 12:25:28'),
('58d3947f-57a3-41a1-8325-87246f020226', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-78092683', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'alhassanabubakarismail@gmail.com', 100000.00, 7500.00, 7.50, 107500.00, 16696.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750},{\"id\":\"1d1b3c74-78f7-4932-92bc-840dbe7b1ef5\",\"name\":\"cat6 20meter\",\"price\":10000,\"quantity\":1,\"companyPrice\":10000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":750}]', '2026-03-30 12:41:33'),
('5ad2ae67-75bc-4797-9ee2-61361275a3bc', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-44288609', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Mr Brain Gumel', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-10 17:04:49'),
('5b3140b3-3a18-48fe-925b-d3b82f00361b', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-56908102', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Nurul Fauz', 'alhassanabubakarismail@gmail.com', 198000.00, 14850.00, 7.50, 212850.00, 25792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500},{\"id\":\"c7790cc9-e758-4196-8974-d9e8025762d9\",\"name\":\"TPlink Switch 8 port non poe\",\"price\":18000,\"quantity\":1,\"companyPrice\":18000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":1350}]', '2026-04-07 09:15:08'),
('5be5982a-6523-48cc-a68e-d7c59d180b88', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-30801002', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'MR Brain Gumel', 'AL-HASSAN', 503250.00, 29868.75, 7.50, 533118.75, 71542.00, '[{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":1,\"companyPrice\":75000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":5625},{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":105000,\"quantity\":1,\"companyPrice\":105000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0},{\"id\":\"d355c953-646b-4bd2-a37f-9479715fa2b1\",\"name\":\"Mikrotik AX2\",\"price\":140000,\"quantity\":1,\"companyPrice\":140000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":10500},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":50,\"companyPrice\":65,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":243.75}]', '2026-04-10 13:20:01'),
('5dc90c1a-5f62-4b08-8cbf-630bc2afb77c', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-11846152', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Alanguboro maid', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-25 09:10:46'),
('5f130f6b-b518-4c61-8e14-97ae7950a367', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-10066758', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Aliyu Huawei', 'alhassanabubakarismail@gmail.com', 170000.00, 12750.00, 0.00, 182750.00, 12792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":2}]', '2026-02-27 15:34:26'),
('5feb1163-c8aa-405b-9b42-ca494dc0b759', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-70390929', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Abubakar Alhassan', 'alhassanabubakarismail@gmail.com', 170000.00, 12750.00, 0.00, 182750.00, 12792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":2}]', '2026-02-07 12:19:51'),
('62f83474-5a9e-4cc8-b03d-1bee37a257d2', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-74799246', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'AL-HASSAN', 530000.00, 39750.00, 7.50, 569750.00, 85000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":5,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":30000},{\"id\":\"47e41f91-20b1-4689-bb9a-7b50f20b1d61\",\"name\":\"Switch 10port TPlink\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750}]', '2026-06-11 09:46:39'),
('636f4ec9-97d2-4368-9385-2615a48a424d', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-98068677', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Yusuf ', 'AL-HASSAN', 645000.00, 40500.00, 7.50, 685500.00, 85000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":5,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":30000},{\"id\":\"d355c953-646b-4bd2-a37f-9479715fa2b1\",\"name\":\"Mikrotik AX2\",\"price\":140000,\"quantity\":1,\"companyPrice\":140000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":10500},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":105000,\"quantity\":1,\"companyPrice\":105000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-05-05 15:21:09'),
('6593f957-346e-443c-9b57-9bd66381676f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-21172690', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk Sammani Yaro', 'AL-HASSAN', 801500.00, 60112.50, 7.50, 861612.50, 100500.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":10,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":60000},{\"id\":\"94440229-ed4b-442a-92ea-37e808199b38\",\"name\":\"cat6 2meter\",\"price\":1500,\"quantity\":1,\"companyPrice\":1500,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":112.5}]', '2026-05-25 13:59:32'),
('6721e22a-08cc-4ad7-9156-9d5d31436727', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-23273378', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Bilal Solar', 'AL-HASSAN', 315000.00, 0.00, 7.50, 315000.00, 35000.00, '[{\"id\":\"9a7f6d72-8d10-469b-9ed8-5746d411b07b\",\"name\":\"Itel 1kwh battery all in one\",\"price\":315000,\"quantity\":1,\"companyPrice\":315000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-04-24 08:34:33'),
('6e10ab18-b1e2-47ec-afad-e79236d43a33', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-99658618', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Babangida gembu', 'alhassanabubakarismail@gmail.com', 75000.00, 5625.00, 0.00, 80625.00, 13000.00, '[{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":1}]', '2026-03-13 10:00:58'),
('6fbcd9d6-778d-4abb-a429-eacbb0e69805', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-88687520', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ahmad UMTK', 'AL-HASSAN', 150000.00, 11250.00, 7.50, 161250.00, 30000.00, '[{\"id\":\"28f05f87-805a-4585-8c4a-43c91a7e236f\",\"name\":\"Litebeam 5AC\",\"price\":150000,\"quantity\":1,\"companyPrice\":150000,\"markup\":0,\"maxMarkup\":200000,\"vatEnabled\":true,\"vatAmount\":11250}]', '2026-06-04 14:58:08'),
('746b9915-131e-47b4-9f2d-b3776eadf28b', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-21803579', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Abu ammar', 'AL-HASSAN', 180000.00, 13500.00, 7.50, 193500.00, 22792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500}]', '2026-05-02 10:36:44'),
('74969ce9-ed4d-41f0-a64b-3116015be412', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-77538881', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Auwalu shehu Abubakar ', 'elsadeeq24@gmail.com', 315000.00, 23625.00, 0.00, 338625.00, 35000.00, '[{\"id\":\"9a7f6d72-8d10-469b-9ed8-5746d411b07b\",\"name\":\"Itel 1kwh battery all in one\",\"price\":315000,\"quantity\":1}]', '2026-03-16 15:12:19'),
('74b8af9c-60ff-4e22-9070-ac3d722ac5e7', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-08898795', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'alhassanabubakarismail@gmail.com', 45000.00, 3375.00, 7.50, 48375.00, 17000.00, '[{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":1,\"companyPrice\":45000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":3375}]', '2026-03-28 13:41:39'),
('753c0700-ceec-4559-89dd-d535f381d7c9', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-10131756', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr ABDUL ', 'alhassanabubakarismail@gmail.com', 105000.00, 7875.00, 0.00, 112875.00, 21000.00, '[{\"id\":\"2b159cc3-d169-48f1-9fcf-88db6d92abbf\",\"name\":\"MEDIA-CONVERTER RJ45-FIBER\",\"price\":35000,\"quantity\":3}]', '2026-02-12 14:28:50'),
('753d79a2-5c70-495c-a419-24fd1b426924', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-12561169', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Muazzam Opera', 'elsadeeq24@gmail.com', 255000.00, 19125.00, 0.00, 274125.00, 19188.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":3}]', '2026-02-11 11:22:38'),
('77403f60-0535-4482-a75b-3d5dccb1dabc', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-71436674', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Haltech ICT', 'alhassanabubakarismail@gmail.com', 180000.00, 13500.00, 0.00, 193500.00, 22660.00, '[{\"id\":\"ff89786d-aecc-4c2d-ac8c-7bb31d4339bd\",\"name\":\"MIKROTIC LOO9\",\"price\":180000,\"quantity\":1}]', '2026-02-21 09:57:16'),
('77be7d6e-3a4a-4a97-b99a-8bf60677f89e', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-72720927', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk Sammani', 'AL-HASSAN', 80000.00, 6000.00, 7.50, 86000.00, 10000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":1,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":6000}]', '2026-05-30 19:25:21'),
('79093350-f328-49a8-8376-bb595476ebcb', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-80699174', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Nazzara Taraba', 'AL-HASSAN', 320000.00, 24000.00, 7.50, 344000.00, 40000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":4,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":24000}]', '2026-05-29 17:51:39'),
('7adde8bd-6b90-47b3-adc6-8f0a0b3b4e81', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-18647562', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'AL-HASSAN', 205065.00, 7504.88, 7.50, 212569.88, 32015.00, '[{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":105000,\"quantity\":1,\"companyPrice\":105000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":1,\"companyPrice\":65,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":4.87999999999999989341858963598497211933135986328125},{\"id\":\"e3c9abe5-e2fc-46d3-9c1e-69e3902b5df5\",\"name\":\"Tiandy NVR 20chl\",\"price\":100000,\"quantity\":1,\"companyPrice\":100000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":7500}]', '2026-06-01 11:57:27'),
('7cc0128e-f610-40d4-8e06-6ade6f48cba4', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-44243287', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul Adamawa', 'alhassanabubakarismail@gmail.com', 470000.00, 35250.00, 0.00, 505250.00, 60584.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":4},{\"id\":\"47e41f91-20b1-4689-bb9a-7b50f20b1d61\",\"name\":\"Switch 10port TPlink\",\"price\":130000,\"quantity\":1}]', '2026-02-17 15:04:01'),
('82cdc6a3-a514-46df-bc22-705d65819d7b', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-11069658', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Malam Usman Zuru', 'AL-HASSAN', 728250.00, 54618.75, 7.50, 782868.75, 100750.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":8,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":48000},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":50,\"companyPrice\":65,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":243.75},{\"id\":\"6d35b7f7-7597-4f3a-9725-0b75a9805eb3\",\"name\":\"U4 RACK\",\"price\":85000,\"quantity\":1,\"companyPrice\":85000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":6375}]', '2026-06-08 08:31:09'),
('847babf9-444e-475e-ba27-84be3c41085f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-22741319', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'alhassanabubakarismail@gmail.com', 235000.00, 17625.00, 7.50, 252625.00, 140696.00, '[{\"id\":\"28f05f87-805a-4585-8c4a-43c91a7e236f\",\"name\":\"Litebeam 5AC\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750},{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":95000,\"quantity\":1,\"companyPrice\":95000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":7125},{\"id\":\"1d1b3c74-78f7-4932-92bc-840dbe7b1ef5\",\"name\":\"cat6 20meter\",\"price\":10000,\"quantity\":1,\"companyPrice\":10000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":750}]', '2026-03-19 11:19:01'),
('848202e9-4735-4a27-a958-d539c11d7768', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-23580186', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Office Work', 'alhassanabubakarismail@gmail.com', 75000.00, 5625.00, 0.00, 80625.00, 13000.00, '[{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":1}]', '2026-03-05 14:13:00'),
('8678d7b3-0186-43c7-a28b-47c0ca601b02', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-31609016', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Abu ammar', 'AL-HASSAN', 320000.00, 24000.00, 7.50, 344000.00, 40000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":4,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":24000}]', '2026-05-31 11:46:50'),
('880dba5a-5fb9-4ce7-a0e0-801a99bb6345', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-15561411', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'AL-HASSAN', 110000.00, 8250.00, 7.50, 118250.00, 63000.00, '[{\"id\":\"feabd484-2b93-4a29-873f-f873132ae9cc\",\"name\":\"AP263\",\"price\":110000,\"quantity\":1,\"companyPrice\":110000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":8250}]', '2026-05-25 12:25:59'),
('8cadbb06-7f2b-40c6-b293-3d85110690d0', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-50961985', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Abdulrahman Geesat', 'AL-HASSAN', 35000.00, 2625.00, 7.50, 37625.00, 18000.00, '[{\"id\":\"7a940362-8d6e-47c1-b49e-ee1dd5f0cf7a\",\"name\":\"DLINK DIR-650IN\",\"price\":35000,\"quantity\":1,\"companyPrice\":35000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":2625}]', '2026-04-16 13:49:23'),
('90e5214c-ece1-473f-b715-41b6f60723fb', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-34266300', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Gombe', 'AL-HASSAN', 300000.00, 22500.00, 7.50, 322500.00, 60000.00, '[{\"id\":\"28f05f87-805a-4585-8c4a-43c91a7e236f\",\"name\":\"Litebeam 5AC\",\"price\":150000,\"quantity\":2,\"companyPrice\":150000,\"markup\":0,\"maxMarkup\":200000,\"vatEnabled\":true,\"vatAmount\":22500}]', '2026-05-09 12:44:27'),
('945c0ceb-b56f-4683-8f24-7ef93487c9aa', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-47171949', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Abdulrahman ', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-16 12:46:12'),
('94976677-262b-4f56-b738-8fecca6be3e6', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-51850529', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ishaq ', 'alhassanabubakarismail@gmail.com', 35000.00, 2625.00, 0.00, 37625.00, 5000.00, '[{\"id\":\"a7a32284-9a3b-452c-9abc-a83f74b27093\",\"name\":\"tiandy smart stand mini 355 camera\",\"price\":35000,\"quantity\":1}]', '2026-03-17 11:50:50'),
('95ec1130-f647-49ba-81fb-e9d4c1c9ba0e', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-01492487', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul ', 'alhassanabubakarismail@gmail.com', 190000.00, 14250.00, 0.00, 204250.00, 32792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":95000,\"quantity\":2}]', '2026-03-13 10:31:32'),
('9728a84c-ab76-46b9-bc45-3fb0815e4dd9', '1be7cdeb-3b78-4cc9-8c43-acbe57675029', 'INV-67745669', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Aliyu kaduna', 'yarotech@yarotech.com.ng', 350000.00, 26250.00, 0.00, 376250.00, 35000.00, '[{\"id\":\"6a094c93-02a6-4d03-9e93-60073e91057b\",\"name\":\"MIKROTIC RB4011\",\"price\":350000,\"quantity\":1}]', '2026-02-13 06:29:03'),
('98578dff-7035-42d9-806b-38db0cbff447', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-10948045', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa Customer', 'alhassanabubakarismail@gmail.com', 895000.00, 67125.00, 0.00, 962125.00, 64772.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":75000,\"quantity\":4},{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":7}]', '2026-02-12 14:42:26');
INSERT INTO `invoices` (`id`, `user_id`, `invoice_number`, `company_name`, `company_address`, `company_phone`, `customer_name`, `issuer_name`, `subtotal`, `tax`, `vat_rate`, `total`, `profit`, `products`, `created_at`) VALUES
('9a05597c-0324-412c-8a9e-bb93e41101c2', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-48940526', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'AL-HASSAN', 340000.00, 0.00, 7.50, 340000.00, 20000.00, '[{\"id\":\"12dfc0da-ea3f-4f64-bd6d-2309b613e3e6\",\"name\":\"Lutian 1kwh battery all in one\",\"price\":340000,\"quantity\":1,\"companyPrice\":340000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-04-30 10:35:40'),
('9a89edb0-ca71-447d-8ee7-634f83a5301b', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-70438187', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'VNET', 'AL-HASSAN', 270000.00, 20250.00, 7.50, 290250.00, 34188.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":3,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":20250}]', '2026-04-13 07:53:58'),
('9b67edfb-7cc2-45bf-94ed-6f85c385babd', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-35797149', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khaleephaa', 'AL-HASSAN', 95000.00, 7125.00, 7.50, 102125.00, 15000.00, '[{\"id\":\"85673cec-91b2-4527-b53b-7fe628c1f2d4\",\"name\":\"LOCO 5AC\",\"price\":95000,\"quantity\":1,\"companyPrice\":95000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":7125}]', '2026-04-09 10:56:37'),
('9dd249f9-15f4-4197-b29d-8f41dff909f6', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-83004067', 'YAROTECH NETWORK LIMITED', 'No 122 farm center, Kano, Nigeria', '+234 81 4024 4774', 'Aliyu Network', 'alhassanabubakarismail@gmail.com', 255000.00, 19125.00, 0.00, 274125.00, 19188.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":3}]', '2026-02-06 12:03:24'),
('9e77f5e1-c788-445a-9e93-2388d5ad67bf', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-21171026', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk Sammani Yaro', 'AL-HASSAN', 801500.00, 60112.50, 7.50, 861612.50, 100500.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":10,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":60000},{\"id\":\"94440229-ed4b-442a-92ea-37e808199b38\",\"name\":\"cat6 2meter\",\"price\":1500,\"quantity\":1,\"companyPrice\":1500,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":112.5}]', '2026-05-25 13:59:31'),
('a1366adb-0874-4e8c-8125-6e7720857809', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-96044147', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'AL-HASSAN', 25000.00, 1875.00, 7.50, 26875.00, 10800.00, '[{\"id\":\"d8a99a41-9611-4c89-b03a-51f4206724e6\",\"name\":\"Tenda N301\",\"price\":25000,\"quantity\":1,\"companyPrice\":25000,\"markup\":0,\"maxMarkup\":40000,\"vatEnabled\":true,\"vatAmount\":1875}]', '2026-05-05 14:47:24'),
('a496ec86-41ff-42aa-bda1-81992a83eade', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-23290257', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Tech Nova', 'alhassanabubakarismail@gmail.com', 45000.00, 3375.00, 0.00, 48375.00, 17000.00, '[{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":1}]', '2026-02-27 19:14:50'),
('a4c86d96-662b-46b8-8722-4d040b7ddadf', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-29259588', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Mr Jacky Skyrun', 'alhassanabubakarismail@gmail.com', 540000.00, 40500.00, 0.00, 580500.00, 41050.00, '[{\"id\":\"333126e4-b4f8-4dad-b993-c4a67f1af392\",\"name\":\"STARLINK V4\",\"price\":540000,\"quantity\":1}]', '2026-02-24 09:34:19'),
('a51755df-a9b2-4f40-992a-adb95dc7c4e5', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-72646228', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'AL-HASSAN', 150000.00, 11250.00, 7.50, 161250.00, 30000.00, '[{\"id\":\"28f05f87-805a-4585-8c4a-43c91a7e236f\",\"name\":\"Litebeam 5AC\",\"price\":150000,\"quantity\":1,\"companyPrice\":150000,\"markup\":0,\"maxMarkup\":200000,\"vatEnabled\":true,\"vatAmount\":11250}]', '2026-04-27 05:50:48'),
('a6647fbe-cb65-4511-a5dd-6fc2952ad840', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-01039318', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Umar Sammani Yaro', 'alhassanabubakarismail@gmail.com', 1410000.00, 105750.00, 7.50, 1515750.00, 185544.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":14,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":94500},{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":2,\"companyPrice\":75000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":11250}]', '2026-03-28 11:30:39'),
('ac62da02-2145-422d-8a2e-7aa121adc5d2', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-57533518', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'alhassanabubakarismail@gmail.com', 190000.00, 14250.00, 7.50, 204250.00, 25000.00, '[{\"id\":\"85673cec-91b2-4527-b53b-7fe628c1f2d4\",\"name\":\"LOCO 5AC\",\"price\":95000,\"quantity\":1,\"companyPrice\":95000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":7125},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":95000,\"quantity\":1,\"companyPrice\":95000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":7125}]', '2026-04-01 14:32:14'),
('acaa49c6-eb48-4117-9a70-ad27a31114d6', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-56868008', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Tanja', 'alhassanabubakarismail@gmail.com', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-07 09:14:28'),
('acde5683-da63-4b77-b60e-f5ef05cdda6f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-38901611', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ausad', 'AL-HASSAN', 160650.00, 12048.75, 7.50, 172698.75, 20150.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":2,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":12000},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":10,\"companyPrice\":65,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":48.75}]', '2026-06-08 16:15:01'),
('ae459226-2755-4587-9cf1-5574aabb98ce', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-72893144', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ahmad Taheer', 'alhassanabubakarismail@gmail.com', 285000.00, 21375.00, 0.00, 306375.00, 46396.00, '[{\"id\":\"85673cec-91b2-4527-b53b-7fe628c1f2d4\",\"name\":\"LOCO 5AC\",\"price\":95000,\"quantity\":2},{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":95000,\"quantity\":1}]', '2026-03-08 11:28:13'),
('ae701af4-9d7c-476b-aee1-02024d2126b2', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-63343317', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ishaq Rabiu', 'AL-HASSAN', 45000.00, 0.00, 7.50, 45000.00, 17000.00, '[{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":1,\"companyPrice\":45000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-06-04 07:55:43'),
('ae8d6ed9-f265-4462-b70f-987a6704f66c', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-65296673', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Mx prime', 'AL-HASSAN', 200000.00, 15000.00, 7.50, 215000.00, 20000.00, '[{\"id\":\"ff89786d-aecc-4c2d-ac8c-7bb31d4339bd\",\"name\":\"MIKROTIC L009\",\"price\":200000,\"quantity\":1,\"companyPrice\":200000,\"markup\":0,\"maxMarkup\":220000,\"vatEnabled\":true,\"vatAmount\":15000}]', '2026-04-29 11:21:36'),
('af8c50a5-6a4e-4929-a343-5268067bd42f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-22091018', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul ', 'alhassanabubakarismail@gmail.com', 680000.00, 51000.00, 0.00, 731000.00, 51168.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":8}]', '2026-02-25 11:21:31'),
('b07955e5-efa7-45cc-b419-af009338ff9d', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-43584349', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Musbahu Browsepoint', 'alhassanabubakarismail@gmail.com', 180000.00, 13500.00, 7.50, 193500.00, 22792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500}]', '2026-04-08 09:19:44'),
('b640170a-d7cf-4469-8179-ca358b13a827', '1be7cdeb-3b78-4cc9-8c43-acbe57675029', 'INV-99158471', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'ismail hasssan', 'admin@yarotech.com.ng', 180000.00, 13500.00, 0.00, 193500.00, 22660.00, '[{\"id\":\"ff89786d-aecc-4c2d-ac8c-7bb31d4339bd\",\"name\":\"MIKROTIC LOO9\",\"price\":180000,\"quantity\":1}]', '2026-02-05 12:45:58'),
('b8ae6afe-b6b2-4330-8d17-02eabc6a9e2c', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-45522918', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Sadeeq Ogadi', 'AL-HASSAN', 400000.00, 30000.00, 7.50, 430000.00, 50000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":5,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":30000}]', '2026-05-29 08:05:23'),
('be2dbdf4-0cef-4cc1-90ef-04f21ea5dcfe', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-25741854', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Abdullahi Abba', 'alhassanabubakarismail@gmail.com', 653250.00, 48993.75, 0.00, 702243.75, 77730.00, '[{\"id\":\"47e41f91-20b1-4689-bb9a-7b50f20b1d61\",\"name\":\"Switch 10port TPlink\",\"price\":130000,\"quantity\":1},{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":5},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":50},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":95000,\"quantity\":1}]', '2026-02-25 12:22:22'),
('be5d0673-9e02-4aa2-8231-0db9413c8edc', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-35741641', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ishaq', 'AL-HASSAN', 160000.00, 12000.00, 7.50, 172000.00, 20000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":2,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":12000}]', '2026-06-15 14:02:22'),
('bf9dc7f2-33c6-41b3-b64c-1c1b190519f5', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-93174880', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Sani Kaduna', 'alhassanabubakarismail@gmail.com', 203000.00, 15225.00, 0.00, 218225.00, 41000.00, '[{\"id\":\"a42a2153-f9b5-47fc-977c-7c5b373c04da\",\"name\":\"MIKROTIC RB951ui\",\"price\":100000,\"quantity\":2},{\"id\":\"94440229-ed4b-442a-92ea-37e808199b38\",\"name\":\"cat6 2meter\",\"price\":1500,\"quantity\":2}]', '2026-02-21 15:59:35'),
('c202fc72-f688-462f-a1c9-1ee5fc6a138a', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-56846259', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Holy daura', 'AL-HASSAN', 330000.00, 24750.00, 7.50, 354750.00, 48792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500},{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":2,\"companyPrice\":75000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":11250}]', '2026-04-29 09:00:46'),
('c5512d50-0642-4f59-8282-2afe41e7fad5', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-80375348', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Abdullahi Abba', 'alhassanabubakarismail@gmail.com', 340000.00, 25500.00, 0.00, 365500.00, 20000.00, '[{\"id\":\"12dfc0da-ea3f-4f64-bd6d-2309b613e3e6\",\"name\":\"Lutian 1kwh battery all in one\",\"price\":340000,\"quantity\":1}]', '2026-03-02 18:39:35'),
('c62976e8-cfdb-46b9-a02b-4795516f59dd', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-97319536', 'YAROTECH NETWORK  TPS', 'Farm center Kano, Nigeria', '+234 81 4024 4774', 'Umar sammani yaro', 'elsadeeq24@gmail.com', 340000.00, 25500.00, 0.00, 365500.00, 25584.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":4}]', '2026-02-04 08:28:39'),
('c6cc54b1-42d7-4466-baed-8a12e101c5b7', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-28525102', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'AL-HASSAN', 255000.00, 19125.00, 7.50, 274125.00, 35792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500},{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":1,\"companyPrice\":75000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":5625}]', '2026-04-25 13:48:45'),
('c80dd6d6-68d8-4ddc-b412-8655906a5c98', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-91374043', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk', 'AL-HASSAN', 130000.00, 9750.00, 7.50, 139750.00, 26000.00, '[{\"id\":\"da48c070-f3fa-4ac9-9c48-82764ed9e64b\",\"name\":\"HUAWEI S110 8PORT\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750}]', '2026-05-13 15:56:15'),
('ca978c4a-c63b-468f-aece-8271f3d5f01f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-21833347', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Kur', 'alhassanabubakarismail@gmail.com', 35000.00, 2625.00, 7.50, 37625.00, 5000.00, '[{\"id\":\"a7a32284-9a3b-452c-9abc-a83f74b27093\",\"name\":\"tiandy smart stand mini 355 camera\",\"price\":35000,\"quantity\":1,\"companyPrice\":35000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":2625}]', '2026-03-27 13:30:34'),
('cb175444-459e-4917-9c03-3d93a5063621', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-43503292', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Office work', 'alhassanabubakarismail@gmail.com', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-08 09:18:23'),
('cdc8c5c7-5d6f-4dc3-b35f-f95177307fbf', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-77463219', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'AA kuraye', 'AL-HASSAN', 1015000.00, 68250.00, 7.50, 1083250.00, 141000.00, '[{\"id\":\"da48c070-f3fa-4ac9-9c48-82764ed9e64b\",\"name\":\"HUAWEI S110 8PORT\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750},{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":8,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":48000},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":105000,\"quantity\":1,\"companyPrice\":105000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0},{\"id\":\"d355c953-646b-4bd2-a37f-9479715fa2b1\",\"name\":\"Mikrotik AX2\",\"price\":140000,\"quantity\":1,\"companyPrice\":140000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":10500}]', '2026-05-06 13:24:24'),
('ceddd8bc-d801-431d-a834-58e6bffb3fb6', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-09631928', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ahmad', 'AL-HASSAN', 75000.00, 5625.00, 7.50, 80625.00, 13000.00, '[{\"id\":\"cd1cc80e-9049-484b-89e5-a3336da82060\",\"name\":\"Dahua poe switch 8port\",\"price\":75000,\"quantity\":1,\"companyPrice\":75000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":5625}]', '2026-05-04 14:47:12'),
('d05bc2b4-9e9c-4464-9cb3-b50643b34d4c', '1be7cdeb-3b78-4cc9-8c43-acbe57675029', 'INV-99764241', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'hafizu adamu salisu', 'admin@yarotech.com.ng', 540000.00, 0.00, 0.00, 540000.00, 25000.00, '[{\"id\":\"333126e4-b4f8-4dad-b993-c4a67f1af392\",\"name\":\"STARLINK V4\",\"price\":540000,\"quantity\":1}]', '2026-02-05 12:56:03'),
('d2792933-92e5-41af-835e-d537920fc380', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-03862094', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul Nassarawa ', 'AL-HASSAN', 450000.00, 33750.00, 7.50, 483750.00, 66000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":4,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":24000},{\"id\":\"da48c070-f3fa-4ac9-9c48-82764ed9e64b\",\"name\":\"HUAWEI S110 8PORT\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750}]', '2026-05-19 14:17:43'),
('d323935a-84f7-4cf1-aba0-70e34a38e708', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-47190584', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk-Jos', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-23 11:26:31'),
('d3356990-a8b8-4d45-a5e7-c4f915bfb9d1', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-07776252', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khalifa Customer', 'alhassanabubakarismail@gmail.com', 180000.00, 13500.00, 0.00, 193500.00, 22660.00, '[{\"id\":\"ff89786d-aecc-4c2d-ac8c-7bb31d4339bd\",\"name\":\"MIKROTIC LOO9\",\"price\":180000,\"quantity\":1}]', '2026-02-19 12:29:36'),
('d3535f45-19dd-474c-8055-d1de158d48a9', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-84566051', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Mr Brain', 'AL-HASSAN', 375000.00, 20250.00, 7.50, 395250.00, 99396.00, '[{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":4,\"companyPrice\":45000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":13500},{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":105000,\"quantity\":1,\"companyPrice\":105000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0},{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-14 15:36:06'),
('d474e1e5-65ea-467c-b271-95e35fa4721e', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-90028131', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'AL-HASSAN', 400000.00, 30000.00, 7.50, 430000.00, 50000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":5,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":30000}]', '2026-06-03 11:33:48'),
('d5e48cc6-90c2-412c-a688-b2d468b8d694', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-84154920', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ahmad UMTK', 'AL-HASSAN', 160000.00, 12000.00, 7.50, 172000.00, 20000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":2,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":12000}]', '2026-06-04 13:42:35'),
('d5f13ada-6950-4960-b2d7-fe3914b0b050', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-06306302', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul Adamawa continue', 'alhassanabubakarismail@gmail.com', 95000.00, 7125.00, 0.00, 102125.00, 10000.00, '[{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":95000,\"quantity\":1}]', '2026-02-18 08:18:26'),
('d67f21b6-57df-45cb-a1b0-694afdb923fb', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-94511766', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Aliyu Huawei', 'alhassanabubakarismail@gmail.com', 190000.00, 14250.00, 0.00, 204250.00, 20000.00, '[{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":95000,\"quantity\":2}]', '2026-03-06 09:55:12'),
('d7880e90-a95c-4423-bc46-c51df4449ced', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-73147976', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Faruk Sammani', 'alhassanabubakarismail@gmail.com', 300000.00, 22500.00, 7.50, 322500.00, 50000.00, '[{\"id\":\"e2102869-d7b5-48d0-a78c-3d83fff372be\",\"name\":\"HUAWEI S110 16PORT\",\"price\":300000,\"quantity\":1,\"companyPrice\":300000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":22500}]', '2026-03-29 07:32:29'),
('d9bd161c-b785-4a42-9171-bd10dfdaa52d', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-33579879', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Aliyu Huawei', 'AL-HASSAN', 970000.00, 72750.00, 7.50, 1042750.00, 261168.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":8,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":54000},{\"id\":\"1f1437cb-5827-4925-a9f9-e87d979b4fcc\",\"name\":\"S110-24T2SR\",\"price\":250000,\"quantity\":1,\"companyPrice\":250000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":18750}]', '2026-04-09 10:19:40'),
('dbc78a66-7f90-407b-aafc-aec44df50ef8', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-79888134', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Nazzara', 'AL-HASSAN', 400000.00, 30000.00, 7.50, 430000.00, 50000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":5,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":30000}]', '2026-06-13 18:44:48'),
('de9ab71e-2f96-4243-ac5a-a369a101c051', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-97683016', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Alamin madina', 'AL-HASSAN', 80000.00, 6000.00, 7.50, 86000.00, 15000.00, '[{\"id\":\"ac37d62b-7393-44f1-8a5b-b782124b43f5\",\"name\":\"IP Tiandy ptz WIFI\",\"price\":80000,\"quantity\":1,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":6000}]', '2026-05-12 13:54:44'),
('dfaaea4a-a8a8-42af-a0fb-9334c81e538f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-71719067', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ahmad Nazifi ', 'alhassanabubakarismail@gmail.com', 170000.00, 12750.00, 0.00, 182750.00, 12792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":2}]', '2026-02-08 16:28:39'),
('dff0d485-ae10-4881-9ff3-b44643face6a', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-20030232', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ishaq rabiu ', 'elsadeeq24@gmail.com', 20000.00, 1500.00, 0.00, 21500.00, 5000.00, '[{\"id\":\"7913d4cb-5c13-4464-882d-cebf9a86d99b\",\"name\":\"WIFI camera socket\",\"price\":20000,\"quantity\":1}]', '2026-03-13 15:40:30'),
('e37de0a4-292d-45ea-a43f-1a9b3f45be44', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-08180050', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Sani Isa', 'alhassanabubakarismail@gmail.com', 5005.00, 375.38, 0.00, 5380.38, 1155.00, '[{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":77}]', '2026-02-19 12:36:20'),
('e3bdb395-1315-44fa-98b8-2324ceff91c4', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-76103512', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'ENGR ABDUL Yola', 'alhassanabubakarismail@gmail.com', 255000.00, 19125.00, 0.00, 274125.00, 19188.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":3}]', '2026-02-13 08:48:22'),
('e4998ddf-fb6f-4b2e-b5e5-0a08bb240892', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-58903708', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Aliyu Huawei ', 'AL-HASSAN', 80000.00, 6000.00, 7.50, 86000.00, 10000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":1,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":6000}]', '2026-05-14 10:41:43'),
('e53bba22-6f21-4e2a-861d-f59fbba02d9c', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-41069743', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Khaleepha', 'alhassanabubakarismail@gmail.com', 95000.00, 7125.00, 0.00, 102125.00, 16396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":95000,\"quantity\":1}]', '2026-03-04 15:17:50'),
('e5404afa-2e49-43e5-89e4-420dd0fc72b5', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-98194058', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Niger', 'alhassanabubakarismail@gmail.com', 180000.00, 13500.00, 0.00, 193500.00, 22660.00, '[{\"id\":\"ff89786d-aecc-4c2d-ac8c-7bb31d4339bd\",\"name\":\"MIKROTIC LOO9\",\"price\":180000,\"quantity\":1}]', '2026-03-14 13:23:14'),
('eb4a269a-04c8-40c5-8ae3-82e8c2010515', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-64474204', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul Camera Kaduna', 'alhassanabubakarismail@gmail.com', 1154000.00, 86550.00, 0.00, 1240550.00, 226000.00, '[{\"id\":\"b379af1b-fe38-45d3-8a78-bb33a94b6493\",\"name\":\"Tiandy 2mp Indoor\",\"price\":22000,\"quantity\":16},{\"id\":\"27b56358-3b28-4487-b456-c6a86b3df7a5\",\"name\":\"Tiandy ip camera 4MP Outdoor\",\"price\":40000,\"quantity\":6},{\"id\":\"21d95888-c3af-4cf6-92c9-49a08ca78c9f\",\"name\":\"Tiandy POE switch 4ports\",\"price\":45000,\"quantity\":3},{\"id\":\"e3c9abe5-e2fc-46d3-9c1e-69e3902b5df5\",\"name\":\"Tiandy NVR 20chl\",\"price\":100000,\"quantity\":1},{\"id\":\"85673cec-91b2-4527-b53b-7fe628c1f2d4\",\"name\":\"LOCO 5AC\",\"price\":95000,\"quantity\":3},{\"id\":\"4a40b3c1-c1fd-447e-9e4f-b6ae28a1d38f\",\"name\":\"Ethernet Power Adaptor second used 24V\",\"price\":14000,\"quantity\":3}]', '2026-02-23 15:34:34'),
('eca76743-0e22-497f-a154-b1e96df4035f', '41a6a98d-d735-49d8-98d3-5325a1a1c7ba', 'INV-26696979', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Eng Abdul CEO ', 'elsadeeq24@gmail.com', 180000.00, 13500.00, 7.50, 193500.00, 22792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":2,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":13500}]', '2026-04-08 04:38:17'),
('eece3f9c-f8b7-4d51-97ef-37b20d2de326', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-85031898', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Bilal Solar', 'AL-HASSAN', 315000.00, 0.00, 7.50, 315000.00, 35000.00, '[{\"id\":\"9a7f6d72-8d10-469b-9ed8-5746d411b07b\",\"name\":\"Itel 1kwh battery all in one\",\"price\":315000,\"quantity\":1,\"companyPrice\":315000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":false,\"vatAmount\":0}]', '2026-04-28 13:03:52'),
('f5aa94d6-0220-47ad-bb23-045a87c6716e', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-69688269', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Ahmad Nazifi', 'alhassanabubakarismail@gmail.com', 1190000.00, 89250.00, 0.00, 1279250.00, 89544.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":14}]', '2026-02-08 15:54:49'),
('f6097674-e377-4a4c-afb9-ecb1de2e686e', '1be7cdeb-3b78-4cc9-8c43-acbe57675029', 'INV-10636022', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Aliyu Network ', 'yarotech@yarotech.com.ng', 450000.00, 33750.00, 7.50, 483750.00, 56980.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":5,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":33750}]', '2026-03-30 21:43:56'),
('f789eee4-36a1-466e-9612-7ea7a99fd88b', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-56720496', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Rabe Daura', 'AL-HASSAN', 400000.00, 30000.00, 7.50, 430000.00, 60188.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":3,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":20250},{\"id\":\"da48c070-f3fa-4ac9-9c48-82764ed9e64b\",\"name\":\"HUAWEI S110 8PORT\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750}]', '2026-04-15 11:38:41'),
('fafb7709-2018-4ac6-b916-6a6d8d85e54d', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-94581924', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Muhammad A Abuja', 'alhassanabubakarismail@gmail.com', 101500.00, 7612.50, 0.00, 109112.50, 11500.00, '[{\"id\":\"01b0d610-1ba3-47dd-b270-e48ff36b839a\",\"name\":\"CAT6 OUTDOOR\",\"price\":95000,\"quantity\":1},{\"id\":\"24ed8703-25a3-4311-a443-a12ffca0400b\",\"name\":\"RJ45\",\"price\":65,\"quantity\":100}]', '2026-03-06 09:56:22'),
('fcd2267f-caf1-41b2-9b36-a12d1d792f15', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-90951578', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Gida Dubu', 'AL-HASSAN', 90000.00, 6750.00, 7.50, 96750.00, 11396.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":90000,\"quantity\":1,\"companyPrice\":90000,\"markup\":0,\"maxMarkup\":110000,\"vatEnabled\":true,\"vatAmount\":6750}]', '2026-04-21 16:02:32'),
('ff23c93e-9e53-4c17-bbb3-4a1a45ae3bf1', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-53621115', 'YAROTECH NETWORK LIMITED', 'No122. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Opera', 'alhassanabubakarismail@gmail.com', 170000.00, 12750.00, 0.00, 182750.00, 12792.00, '[{\"id\":\"3a4127fe-8496-4aed-8a1e-e73c311867b3\",\"name\":\"AP362\",\"price\":85000,\"quantity\":2}]', '2026-02-16 13:53:41'),
('ff2487c7-9243-4f24-a4c5-9eb9c31b353f', 'c5bc3766-2f88-41ad-b529-4eab47a70721', 'INV-36476830', 'YAROTECH NETWORK LIMITED', 'No23. farm center, Kano, Nigeria', '+234 81 4024 4774', 'Engr Abdul', 'AL-HASSAN', 610000.00, 45750.00, 7.50, 655750.00, 95000.00, '[{\"id\":\"915e3a15-9a18-4299-9625-c8bcd37eb9cf\",\"name\":\"AP361\",\"price\":80000,\"quantity\":6,\"companyPrice\":80000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":36000},{\"id\":\"47e41f91-20b1-4689-bb9a-7b50f20b1d61\",\"name\":\"Switch 10port TPlink\",\"price\":130000,\"quantity\":1,\"companyPrice\":130000,\"markup\":0,\"maxMarkup\":0,\"vatEnabled\":true,\"vatAmount\":9750}]', '2026-05-31 13:07:57');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role_target` varchar(20) NOT NULL DEFAULT 'user',
  `type` varchar(80) NOT NULL,
  `title` varchar(190) NOT NULL,
  `message` text DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `role_target`, `type`, `title`, `message`, `data`, `is_read`, `created_at`) VALUES
(15, NULL, 'admin', 'contact_inquiry', 'New contact inquiry received', 'SAIDU USMAN ABDULLAHI submitted a support inquiry.', '{\"ticket_id\":\"TKT-20260529-000001\",\"contact_id\":1,\"inquiry_type\":\"General Inquiry\"}', 1, '2026-05-29 09:02:27'),
(16, NULL, 'admin', 'order_created', 'New order YT-20260530-41F4DC placed', 'A payment of NGN 177,375.00 was confirmed.', '{\"order_number\":\"YT-20260530-41F4DC\",\"reference\":\"YT-PAY-YT2026053041F4DC-9BA36E0E\",\"user_id\":7}', 1, '2026-05-30 07:26:30'),
(19, NULL, 'admin', 'order_created', 'New order YT-20260530-034981 placed', 'A payment of NGN 21,500.00 was confirmed.', '{\"order_number\":\"YT-20260530-034981\",\"reference\":\"YT-PAY-YT20260530034981-C3F419F5\",\"user_id\":7}', 1, '2026-05-30 10:38:56'),
(24, NULL, 'admin', 'order_created', 'New order YT-20260530-CA0241 placed', 'A payment of NGN 499,875.00 was confirmed.', '{\"order_number\":\"YT-20260530-CA0241\",\"reference\":\"YT-PAY-YT20260530CA0241-003B6B13\",\"user_id\":8}', 1, '2026-05-30 16:01:13'),
(29, NULL, 'admin', 'order_created', 'New order YT-20260531-1E7070 placed', 'A payment of NGN 268,750.00 was confirmed.', '{\"order_number\":\"YT-20260531-1E7070\",\"reference\":\"YT-PAY-YT202605311E7070-3D15C1A9\",\"user_id\":8}', 1, '2026-05-31 05:59:34'),
(32, NULL, 'admin', 'order_created', 'New order YT-20260531-AF8735 placed', 'A payment of NGN 274,125.00 was confirmed.', '{\"order_number\":\"YT-20260531-AF8735\",\"reference\":\"YT-PAY-YT20260531AF8735-494F0CDA\",\"user_id\":7}', 1, '2026-05-31 06:31:28'),
(41, NULL, 'admin', 'order_created', 'New order YT-20260601-2D3D5D placed', 'A payment of NGN 548,250.00 was confirmed.', '{\"order_number\":\"YT-20260601-2D3D5D\",\"reference\":\"YT-PAY-YT202606012D3D5D-E3AD2C1E\",\"user_id\":8}', 1, '2026-06-01 14:54:16'),
(46, NULL, 'admin', 'order_created', 'New order YT-20260601-B6B150 placed', 'A payment of NGN 240,000.00 was confirmed.', '{\"order_number\":\"YT-20260601-B6B150\",\"reference\":\"YT-PAY-YT20260601B6B150-306BEB32\",\"user_id\":8}', 1, '2026-06-01 16:21:53'),
(50, NULL, 'admin', 'order_created', 'New order YT-20260601-90FA15 placed', 'A payment of NGN 157,500.00 was confirmed.', '{\"order_number\":\"YT-20260601-90FA15\",\"reference\":\"YT-PAY-YT2026060190FA15-6BBC9CA3\",\"user_id\":8}', 1, '2026-06-01 17:31:07'),
(53, NULL, 'admin', 'order_created', 'New order YT-20260603-FF1BD3 placed', 'A payment of NGN 53,750.00 was confirmed.', '{\"order_number\":\"YT-20260603-FF1BD3\",\"reference\":\"YT-PAY-YT20260603FF1BD3-2E235CDF\",\"user_id\":9}', 1, '2026-06-03 08:07:25'),
(56, NULL, 'admin', 'low_stock', 'Low stock alert: Hikvision attendance (fingerprint only)', 'Current stock is 0 unit(s).', '{\"product_id\":\"838960c9-e0c3-4af8-9c7e-fd39b4fb8e27\",\"sku\":\"SKU-838960c9\",\"stock_quantity\":0,\"minimum_stock\":0}', 1, '2026-06-13 04:31:07'),
(57, 11, 'user', 'admin_reply', 'Support reply received', 'Our support team replied to your inquiry ticket TKT-20260615-000001.', '{\"contact_message_id\":1,\"ticket_id\":\"TKT-20260615-000001\"}', 0, '2026-06-15 14:24:20'),
(58, NULL, 'admin', 'admin_reply', 'Support reply sent', 'Reply saved for support ticket TKT-20260615-000001.', '{\"contact_message_id\":1,\"ticket_id\":\"TKT-20260615-000001\"}', 1, '2026-06-15 14:24:20'),
(59, NULL, 'admin', 'low_stock', 'Low stock alert: TPlink archer C20', 'Current stock is 0 unit(s).', '{\"product_id\":\"fa16e244-dfeb-42a0-a999-1db993f58c6f\",\"sku\":\"SKU-fa16e244\",\"stock_quantity\":0,\"minimum_stock\":0}', 1, '2026-06-15 15:06:47'),
(60, NULL, 'admin', 'order_created', 'New order YT-20260615-814882 placed', 'A payment of NGN 107,500.00 was confirmed.', '{\"order_number\":\"YT-20260615-814882\",\"reference\":\"YT-PAY-YT20260615814882-A01AF3DD\",\"user_id\":12}', 1, '2026-06-15 15:06:48'),
(61, 12, 'user', 'order_created', 'Order YT-20260615-814882 confirmed', 'Thanks for your purchase. Your order has been confirmed.', '{\"order_number\":\"YT-20260615-814882\",\"link_url\":\"\\/dashboard\\/orders\\/YT-20260615-814882\"}', 1, '2026-06-15 15:06:48'),
(62, 12, 'user', 'payment_success', 'Payment successful', 'Your payment for order YT-20260615-814882 was successful.', '{\"order_number\":\"YT-20260615-814882\",\"reference\":\"YT-PAY-YT20260615814882-A01AF3DD\"}', 1, '2026-06-15 15:06:48'),
(63, NULL, 'admin', 'low_stock', 'Low stock alert: S310-24P4S', 'Current stock is 2 unit(s).', '{\"product_id\":\"PRD-058\",\"sku\":\"SKU-S310-24P4S\",\"stock_quantity\":2,\"minimum_stock\":5}', 1, '2026-06-16 13:11:52'),
(64, NULL, 'admin', 'low_stock', 'Low stock alert: 7.5kwh solar generator', 'Current stock is 2 unit(s).', '{\"product_id\":\"PRD-054\",\"sku\":\"SKU-75KWH-SOLAR-GENERATOR\",\"stock_quantity\":2,\"minimum_stock\":5}', 1, '2026-06-16 13:12:51'),
(65, NULL, 'admin', 'low_stock', 'Low stock alert: S110-24P2ST', 'Current stock is 1 unit(s).', '{\"product_id\":\"PRD-065\",\"sku\":\"SKU-S110-24P2ST\",\"stock_quantity\":1,\"minimum_stock\":5}', 1, '2026-06-16 13:13:20'),
(66, NULL, 'admin', 'low_stock', 'Low stock alert: AP361', 'Current stock is 4 unit(s).', '{\"product_id\":\"PRD-043\",\"sku\":\"SKU-AP361\",\"stock_quantity\":4,\"minimum_stock\":5}', 1, '2026-06-16 13:14:03'),
(67, NULL, 'admin', 'low_stock', 'Low stock alert: AP361', 'Current stock is 3 unit(s).', '{\"product_id\":\"PRD-043\",\"sku\":\"SKU-AP361\",\"stock_quantity\":3,\"minimum_stock\":5}', 1, '2026-06-16 13:14:03'),
(68, NULL, 'admin', 'low_stock', 'Low stock alert: HUAWEI S380 4PORT', 'Current stock is 1 unit(s).', '{\"product_id\":\"PRD-040\",\"sku\":\"SKU-HUAWEI-S380-4PORT\",\"stock_quantity\":1,\"minimum_stock\":5}', 1, '2026-06-16 13:14:35'),
(69, 11, 'user', 'admin_reply', 'Support reply received', 'Our support team replied to your inquiry ticket TKT-20260619-000001.', '{\"contact_message_id\":1,\"ticket_id\":\"TKT-20260619-000001\"}', 0, '2026-06-19 14:32:47'),
(70, NULL, 'admin', 'admin_reply', 'Support reply sent', 'Reply saved for support ticket TKT-20260619-000001.', '{\"contact_message_id\":1,\"ticket_id\":\"TKT-20260619-000001\"}', 1, '2026-06-19 14:32:47'),
(71, 11, 'user', 'admin_reply', 'Support reply received', 'Our support team replied to your inquiry ticket TKT-20260620-000001.', '{\"contact_message_id\":1,\"ticket_id\":\"TKT-20260620-000001\"}', 0, '2026-06-20 13:13:02'),
(72, NULL, 'admin', 'admin_reply', 'Support reply sent', 'Reply saved for support ticket TKT-20260620-000001.', '{\"contact_message_id\":1,\"ticket_id\":\"TKT-20260620-000001\"}', 1, '2026-06-20 13:13:02'),
(73, NULL, 'admin', 'low_stock', 'Low stock alert: MIKROTIC L009', 'Current stock is 2 unit(s).', '{\"product_id\":\"PRD-081\",\"sku\":\"SKU-MIKROTIC-L009\",\"stock_quantity\":2,\"minimum_stock\":5}', 1, '2026-06-23 10:18:13'),
(74, NULL, 'admin', 'low_stock', 'Low stock alert: TPlink router AX23', 'Current stock is 1 unit(s).', '{\"product_id\":\"PRD-592420C6\",\"sku\":\"YT-TPlink router\",\"stock_quantity\":1,\"minimum_stock\":5}', 1, '2026-06-25 10:23:53'),
(75, NULL, 'admin', 'low_stock', 'Low stock alert: 7.5kwh solar generator', 'Current stock is 1 unit(s).', '{\"product_id\":\"PRD-054\",\"sku\":\"SKU-75KWH-SOLAR-GENERATOR\",\"stock_quantity\":1,\"minimum_stock\":5}', 1, '2026-06-30 11:20:16'),
(76, NULL, 'admin', 'low_stock', 'Low stock alert: Hikvision attendance (fingerprint only)', 'Current stock is 2 unit(s).', '{\"product_id\":\"PRD-038\",\"sku\":\"SKU-HIKVISION-ATTENDANCE-FINGERPRI\",\"stock_quantity\":2,\"minimum_stock\":5}', 1, '2026-06-30 12:53:07'),
(77, NULL, 'admin', 'low_stock', 'Low stock alert: Hikvision attendance (fingerprint only)', 'Current stock is 1 unit(s).', '{\"product_id\":\"PRD-038\",\"sku\":\"SKU-HIKVISION-ATTENDANCE-FINGERPRI\",\"stock_quantity\":1,\"minimum_stock\":5}', 1, '2026-06-30 12:58:10'),
(78, NULL, 'admin', 'low_stock', 'Low stock alert: MIKROTIC L009', 'Current stock is 1 unit(s).', '{\"product_id\":\"PRD-081\",\"sku\":\"SKU-MIKROTIC-L009\",\"stock_quantity\":1,\"minimum_stock\":5}', 1, '2026-06-30 12:58:10'),
(79, NULL, 'admin', 'low_stock', 'Low stock alert: UDM-PRO', 'Current stock is 0 unit(s).', '{\"product_id\":\"PRD-024\",\"sku\":\"SKU-UDM-PRO\",\"stock_quantity\":0,\"minimum_stock\":5}', 1, '2026-06-30 12:58:10'),
(80, NULL, 'admin', 'order_created', 'New order YT-20260630-DD0B27 placed', 'A payment of NGN 1,316,875.00 was confirmed.', '{\"order_number\":\"YT-20260630-DD0B27\",\"reference\":\"YT-PAY-YT20260630DD0B27-E437A8A6\",\"user_id\":23}', 1, '2026-06-30 12:58:14'),
(81, 23, 'user', 'order_created', 'Order YT-20260630-DD0B27 confirmed', 'Thanks for your purchase. Your order has been confirmed.', '{\"order_number\":\"YT-20260630-DD0B27\",\"link_url\":\"\\/dashboard\\/orders\\/YT-20260630-DD0B27\"}', 0, '2026-06-30 12:58:14'),
(82, 23, 'user', 'payment_success', 'Payment successful', 'Your payment for order YT-20260630-DD0B27 was successful.', '{\"order_number\":\"YT-20260630-DD0B27\",\"reference\":\"YT-PAY-YT20260630DD0B27-E437A8A6\"}', 0, '2026-06-30 12:58:14'),
(83, 23, 'user', 'order_created', 'Order status updated', 'Order YT-20260630-DD0B27 is now ready_for_pickup.', '{\"order_number\":\"YT-20260630-DD0B27\",\"status\":\"ready_for_pickup\"}', 0, '2026-06-30 13:03:03'),
(84, NULL, 'admin', 'low_stock', 'Low stock alert: Hikvision attendance (fingerprint only)', 'Current stock is 0 unit(s).', '{\"product_id\":\"PRD-038\",\"sku\":\"SKU-HIKVISION-ATTENDANCE-FINGERPRI\",\"stock_quantity\":0,\"minimum_stock\":5}', 1, '2026-06-30 16:41:04'),
(85, NULL, 'admin', 'order_created', 'New order YT-20260630-6E6B86 placed', 'A payment of NGN 197,000.00 was confirmed.', '{\"order_number\":\"YT-20260630-6E6B86\",\"reference\":\"YT-PAY-YT202606306E6B86-3A0A47DB\",\"user_id\":24}', 1, '2026-06-30 16:41:05'),
(86, 24, 'user', 'order_created', 'Order YT-20260630-6E6B86 confirmed', 'Thanks for your purchase. Your order has been confirmed.', '{\"order_number\":\"YT-20260630-6E6B86\",\"link_url\":\"\\/dashboard\\/orders\\/YT-20260630-6E6B86\"}', 0, '2026-06-30 16:41:05'),
(87, 24, 'user', 'payment_success', 'Payment successful', 'Your payment for order YT-20260630-6E6B86 was successful.', '{\"order_number\":\"YT-20260630-6E6B86\",\"reference\":\"YT-PAY-YT202606306E6B86-3A0A47DB\"}', 0, '2026-06-30 16:41:05'),
(88, 24, 'user', 'order_created', 'Order status updated', 'Order YT-20260630-6E6B86 is now shipped.', '{\"order_number\":\"YT-20260630-6E6B86\",\"status\":\"shipped\"}', 0, '2026-06-30 16:43:13'),
(89, NULL, 'admin', 'low_stock', 'Low stock alert: Huawei AR180 Dual Band Wifi 7 Router', 'Current stock is 2 unit(s).', '{\"product_id\":\"PRD-C9F837A7\",\"sku\":\"YT-D-WIFI-RT\",\"stock_quantity\":2,\"minimum_stock\":5}', 1, '2026-07-02 10:15:25'),
(90, NULL, 'admin', 'low_stock', 'Low stock alert: MIKROTIC L009', 'Current stock is 2 unit(s).', '{\"product_id\":\"PRD-081\",\"sku\":\"SKU-MIKROTIC-L009\",\"stock_quantity\":2,\"minimum_stock\":5}', 1, '2026-07-02 11:56:48'),
(91, NULL, 'admin', 'low_stock', 'Low stock alert: MIKROTIC L009', 'Current stock is 5 unit(s).', '{\"product_id\":\"PRD-081\",\"sku\":\"SKU-MIKROTIC-L009\",\"stock_quantity\":5,\"minimum_stock\":5}', 1, '2026-07-02 11:57:00'),
(92, NULL, 'admin', 'low_stock', 'Low stock alert: MIKROTIC L009', 'Current stock is 3 unit(s).', '{\"product_id\":\"PRD-081\",\"sku\":\"SKU-MIKROTIC-L009\",\"stock_quantity\":3,\"minimum_stock\":5}', 1, '2026-07-02 11:57:28'),
(93, NULL, 'admin', 'low_stock', 'Low stock alert: Huawei AR180 Dual Band Wifi 7 Router', 'Current stock is 1 unit(s).', '{\"product_id\":\"PRD-C9F837A7\",\"sku\":\"YT-D-WIFI-RT\",\"stock_quantity\":1,\"minimum_stock\":5}', 1, '2026-07-03 11:35:30'),
(94, NULL, 'admin', 'low_stock', 'Low stock alert: 7.5kwh solar generator', 'Current stock is 0 unit(s).', '{\"product_id\":\"PRD-054\",\"sku\":\"SKU-75KWH-SOLAR-GENERATOR\",\"stock_quantity\":0,\"minimum_stock\":5}', 1, '2026-07-04 05:36:18');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_number` varchar(40) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `customer_name` varchar(150) NOT NULL,
  `customer_email` varchar(190) DEFAULT NULL,
  `customer_phone` varchar(40) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `fulfillment_method` varchar(40) NOT NULL DEFAULT 'delivery',
  `delivery_state` varchar(100) DEFAULT NULL,
  `delivery_city` varchar(100) DEFAULT NULL,
  `delivery_address` text DEFAULT NULL,
  `delivery_landmark` varchar(255) DEFAULT NULL,
  `delivery_phone` varchar(40) DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `tax_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(14,2) NOT NULL DEFAULT 0.00,
  `tax` decimal(14,2) NOT NULL DEFAULT 0.00,
  `delivery_fee` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(12,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'NGN',
  `order_status` enum('pending','paid','processing','ready_for_pickup','shipped','delivered','picked_up','cancelled','refunded','failed') NOT NULL DEFAULT 'pending',
  `payment_status` varchar(40) NOT NULL DEFAULT 'pending',
  `sale_channel` varchar(40) NOT NULL DEFAULT 'ecommerce',
  `pos_sync_status` varchar(40) NOT NULL DEFAULT 'pending',
  `payment_method` varchar(40) DEFAULT NULL,
  `created_by` varchar(40) NOT NULL DEFAULT 'user',
  `created_by_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `inventory_reduced_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `user_id`, `customer_id`, `customer_name`, `customer_email`, `customer_phone`, `notes`, `fulfillment_method`, `delivery_state`, `delivery_city`, `delivery_address`, `delivery_landmark`, `delivery_phone`, `subtotal`, `tax_amount`, `discount`, `tax`, `delivery_fee`, `total_amount`, `currency`, `order_status`, `payment_status`, `sale_channel`, `pos_sync_status`, `payment_method`, `created_by`, `created_by_user_id`, `inventory_reduced_at`, `created_at`, `updated_at`) VALUES
(74, 'INV-25312730', NULL, NULL, 'Khaleepha', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-18 15:15:13', '2026-04-18 15:15:13'),
(75, 'INV-15730034', NULL, NULL, 'Umbil yola', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 100000.00, 7500.00, 0.00, 0.00, 0.00, 107500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-19 10:22:10', '2026-03-19 10:22:10'),
(76, 'INV-97996905', NULL, NULL, 'Umar sammani yaro', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 440000.00, 33000.00, 0.00, 0.00, 0.00, 473000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-02-04 09:39:56', '2026-02-04 09:39:56'),
(77, 'INV-05855994', NULL, NULL, 'Kalkala', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 225000.00, 16875.00, 0.00, 0.00, 0.00, 241875.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-02-11 10:30:53', '2026-02-11 10:30:53'),
(78, 'INV-67396429', NULL, NULL, 'Engr Abdul Office work', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 130000.00, 9750.00, 0.00, 0.00, 0.00, 139750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-01 12:16:36', '2026-03-01 12:16:36'),
(79, 'INV-28997509', NULL, NULL, 'Ishaq rabiu ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 20000.00, 1500.00, 0.00, 0.00, 0.00, 21500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-03-12 15:23:18', '2026-03-12 15:23:18'),
(80, 'INV-87837937', NULL, NULL, 'Khalifa', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-27 11:03:58', '2026-04-27 11:03:58'),
(81, 'INV-78192736', NULL, NULL, 'Engr Abdul Kaduna', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 85000.00, 6375.00, 0.00, 0.00, 0.00, 91375.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-01 15:16:32', '2026-03-01 15:16:32'),
(82, 'INV-90635915', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 45000.00, 0.00, 0.00, 0.00, 0.00, 45000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-03 12:43:56', '2026-06-03 12:43:56'),
(83, 'INV-98654671', NULL, NULL, 'Khalifa', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-28 11:50:55', '2026-03-28 11:50:55'),
(84, 'INV-16820230', NULL, NULL, 'Faruk ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 270000.00, 20250.00, 0.00, 0.00, 0.00, 290250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-29 20:40:20', '2026-03-29 20:40:20'),
(85, 'INV-44262477', NULL, NULL, 'Ausad Kaduna', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 285000.00, 21375.00, 0.00, 0.00, 0.00, 306375.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-18 14:31:02', '2026-03-18 14:31:02'),
(86, 'INV-30697641', NULL, NULL, 'Umbil Yola', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 10000.00, 750.00, 0.00, 0.00, 0.00, 10750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-04 13:24:58', '2026-03-04 13:24:58'),
(87, 'INV-61965869', NULL, NULL, 'MX Prime', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 125000.00, 9375.00, 0.00, 0.00, 0.00, 134375.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-29 11:26:06', '2026-04-29 11:26:06'),
(88, 'INV-23018565', NULL, NULL, 'Usman', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 95000.00, 7125.00, 0.00, 0.00, 0.00, 102125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-26 16:23:39', '2026-02-26 16:23:39'),
(89, 'INV-44150443', NULL, NULL, 'Mr Brains Replaced ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-16 12:55:50', '2026-04-16 12:55:50'),
(90, 'INV-41634774', NULL, NULL, 'Anas Jos', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 235000.00, 17625.00, 0.00, 0.00, 0.00, 252625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-17 10:00:34', '2026-03-17 10:00:34'),
(91, 'INV-24516857', NULL, NULL, 'Khalifa', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 200000.00, 15000.00, 0.00, 0.00, 0.00, 215000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-11 10:21:56', '2026-03-11 10:21:56'),
(92, 'INV-04538300', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-04-07 23:28:59', '2026-04-07 23:28:59'),
(93, 'INV-81861877', NULL, NULL, 'Auwalu', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-14 15:51:02', '2026-04-14 15:51:02'),
(94, 'INV-99176136', NULL, NULL, 'Office work', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 40000.00, 3000.00, 0.00, 0.00, 0.00, 43000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-27 14:12:56', '2026-04-27 14:12:56'),
(95, 'INV-08280999', NULL, NULL, 'Malam Isa', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-28 14:31:22', '2026-03-28 14:31:22'),
(96, 'INV-74482840', NULL, NULL, 'Engr Abdul Kaduna', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 1448250.00, 108618.75, 0.00, 0.00, 0.00, 1556868.75, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-22 15:34:43', '2026-02-22 15:34:43'),
(97, 'INV-63745057', NULL, NULL, 'Aliyu Huawei', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-30 15:42:25', '2026-04-30 15:42:25'),
(99, 'INV-30433483', NULL, NULL, 'Faruk ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-08 08:53:54', '2026-05-08 08:53:54'),
(100, 'INV-31773273', NULL, NULL, 'Eng Abdul ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 252000.00, 18900.00, 0.00, 0.00, 0.00, 270900.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'EL-SADEEQ', NULL, NULL, '2026-05-31 12:49:31', '2026-05-31 12:49:31'),
(101, 'INV-07466184', NULL, NULL, 'Muhd Niger', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 240000.00, 18000.00, 0.00, 0.00, 0.00, 258000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-03 17:24:26', '2026-06-03 17:24:26'),
(102, 'INV-41182821', NULL, NULL, 'Opera', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 65000.00, 4875.00, 0.00, 0.00, 0.00, 69875.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-25 17:39:43', '2026-02-25 17:39:43'),
(103, 'INV-57634727', NULL, NULL, 'Nazzara Taraba', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 935000.00, 60000.00, 0.00, 0.00, 0.00, 995000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-06 14:53:55', '2026-06-06 14:53:55'),
(104, 'INV-75047503', NULL, NULL, 'Muhammad Baba', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 100000.00, 7500.00, 0.00, 0.00, 0.00, 107500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-28 10:37:27', '2026-02-28 10:37:27'),
(105, 'INV-23715673', NULL, NULL, 'Office Work', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 75000.00, 5625.00, 0.00, 0.00, 0.00, 80625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-05 15:15:16', '2026-03-05 15:15:16'),
(106, 'INV-73522791', NULL, NULL, 'Mr Brain ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-13 09:45:22', '2026-04-13 09:45:22'),
(107, 'INV-04286695', NULL, NULL, 'Ishaq Rabiu', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 200000.00, 15000.00, 0.00, 0.00, 0.00, 215000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-14 16:04:47', '2026-03-14 16:04:47'),
(108, 'INV-48326133', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 375000.00, 0.00, 0.00, 0.00, 0.00, 375000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-30 11:25:26', '2026-04-30 11:25:26'),
(109, 'INV-20554722', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 156500.00, 11737.50, 0.00, 0.00, 0.00, 168237.50, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-18 16:09:11', '2026-05-18 16:09:11'),
(110, 'INV-15515361', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 270000.00, 20250.00, 0.00, 0.00, 0.00, 290250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-25 13:25:13', '2026-05-25 13:25:13'),
(111, 'INV-73674649', NULL, NULL, 'Khalifa', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 130000.00, 9750.00, 0.00, 0.00, 0.00, 139750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-09 16:27:54', '2026-03-09 16:27:54'),
(112, 'INV-77859696', NULL, NULL, 'Eng Abdul ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 380000.00, 28500.00, 0.00, 0.00, 0.00, 408500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-03-23 14:57:40', '2026-03-23 14:57:40'),
(113, 'INV-58094690', NULL, NULL, 'Khalifa ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 133000.00, 9975.00, 0.00, 0.00, 0.00, 142975.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'yarotech@yarotech.com.ng', NULL, NULL, '2026-03-09 12:08:15', '2026-03-09 12:08:15'),
(114, 'INV-73131968', NULL, NULL, 'Auwalu ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 250000.00, 18750.00, 0.00, 0.00, 0.00, 268750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-13 09:38:52', '2026-04-13 09:38:52'),
(115, 'INV-38100973', NULL, NULL, 'Khalifa Customer ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 425000.00, 31875.00, 0.00, 0.00, 0.00, 456875.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-16 10:35:01', '2026-02-16 10:35:01'),
(116, 'INV-29277561', NULL, NULL, 'Mr Jacky Skyrun', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 540000.00, 40500.00, 0.00, 0.00, 0.00, 580500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-24 10:34:37', '2026-02-24 10:34:37'),
(117, 'INV-43439063', NULL, NULL, 'Abu Jaafar', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 629475.00, 39335.63, 0.00, 0.00, 0.00, 668810.63, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-17 16:30:39', '2026-04-17 16:30:39'),
(118, 'INV-20022178', NULL, NULL, 'Ishaq rabiu ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 20000.00, 1500.00, 0.00, 0.00, 0.00, 21500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-03-13 16:40:22', '2026-03-13 16:40:22'),
(119, 'INV-99195809', NULL, NULL, 'Khalifa Customer ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 85000.00, 6375.00, 0.00, 0.00, 0.00, 91375.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-19 11:06:35', '2026-02-19 11:06:35'),
(120, 'INV-84152017', NULL, NULL, 'Ishaq ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 237600.00, 17820.00, 0.00, 0.00, 0.00, 255420.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-13 20:55:53', '2026-06-13 20:55:53'),
(121, 'INV-77549274', NULL, NULL, 'Auwalu shehu Abubakar ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 315000.00, 23625.00, 0.00, 0.00, 0.00, 338625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-03-16 16:12:29', '2026-03-16 16:12:29'),
(122, 'INV-24379148', NULL, NULL, 'Dan Daura', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 900000.00, 67500.00, 0.00, 0.00, 0.00, 967500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-02-11 15:39:36', '2026-02-11 15:39:36'),
(123, 'INV-71466656', NULL, NULL, 'Shamsu', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 95000.00, 7125.00, 0.00, 0.00, 0.00, 102125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-24 16:57:46', '2026-03-24 16:57:46'),
(124, 'INV-01462152', NULL, NULL, 'Engr Abdul Kaduna', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-13 11:31:02', '2026-03-13 11:31:02'),
(125, 'INV-11608498', NULL, NULL, 'Umbil Yola', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 100000.00, 7500.00, 0.00, 0.00, 0.00, 107500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-13 14:20:08', '2026-03-13 14:20:08'),
(126, 'INV-86962875', NULL, NULL, 'AA kuraye', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 555000.00, 33750.00, 0.00, 0.00, 0.00, 588750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-12 11:56:03', '2026-05-12 11:56:03'),
(127, 'INV-20683070', NULL, NULL, 'Nazzara', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 96500.00, 7237.50, 0.00, 0.00, 0.00, 103737.50, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-18 16:11:24', '2026-05-18 16:11:24'),
(128, 'INV-15531042', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 185000.00, 13875.00, 0.00, 0.00, 0.00, 198875.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-25 13:25:28', '2026-05-25 13:25:28'),
(129, 'INV-78092683', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 100000.00, 7500.00, 0.00, 0.00, 0.00, 107500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-30 13:41:33', '2026-03-30 13:41:33'),
(130, 'INV-44288609', NULL, NULL, 'Mr Brain Gumel', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-10 18:04:49', '2026-04-10 18:04:49'),
(131, 'INV-56908102', NULL, NULL, 'Nurul Fauz', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 198000.00, 14850.00, 0.00, 0.00, 0.00, 212850.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-04-07 10:15:08', '2026-04-07 10:15:08'),
(132, 'INV-30801002', NULL, NULL, 'MR Brain Gumel', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 503250.00, 29868.75, 0.00, 0.00, 0.00, 533118.75, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-10 14:20:01', '2026-04-10 14:20:01'),
(133, 'INV-11846152', NULL, NULL, 'Alanguboro maid', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-25 10:10:46', '2026-04-25 10:10:46'),
(134, 'INV-10066758', NULL, NULL, 'Aliyu Huawei', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 170000.00, 12750.00, 0.00, 0.00, 0.00, 182750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-27 16:34:26', '2026-02-27 16:34:26'),
(135, 'INV-70390929', NULL, NULL, 'Abubakar Alhassan', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 170000.00, 12750.00, 0.00, 0.00, 0.00, 182750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-07 13:19:51', '2026-02-07 13:19:51'),
(136, 'INV-74799246', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 530000.00, 39750.00, 0.00, 0.00, 0.00, 569750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-11 10:46:39', '2026-06-11 10:46:39'),
(137, 'INV-98068677', NULL, NULL, 'Yusuf ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 645000.00, 40500.00, 0.00, 0.00, 0.00, 685500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-05 16:21:09', '2026-05-05 16:21:09'),
(138, 'INV-21172690', NULL, NULL, 'Faruk Sammani Yaro', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 801500.00, 60112.50, 0.00, 0.00, 0.00, 861612.50, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-25 14:59:32', '2026-05-25 14:59:32'),
(139, 'INV-23273378', NULL, NULL, 'Bilal Solar', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 315000.00, 0.00, 0.00, 0.00, 0.00, 315000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-24 09:34:33', '2026-04-24 09:34:33'),
(140, 'INV-99658618', NULL, NULL, 'Babangida gembu', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 75000.00, 5625.00, 0.00, 0.00, 0.00, 80625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-13 11:00:58', '2026-03-13 11:00:58'),
(141, 'INV-88687520', NULL, NULL, 'Ahmad UMTK', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 150000.00, 11250.00, 0.00, 0.00, 0.00, 161250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-04 15:58:08', '2026-06-04 15:58:08'),
(142, 'INV-21803579', NULL, NULL, 'Abu ammar', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-02 11:36:44', '2026-05-02 11:36:44'),
(143, 'INV-77538881', NULL, NULL, 'Auwalu shehu Abubakar ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 315000.00, 23625.00, 0.00, 0.00, 0.00, 338625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-03-16 16:12:19', '2026-03-16 16:12:19'),
(144, 'INV-08898795', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 45000.00, 3375.00, 0.00, 0.00, 0.00, 48375.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-28 14:41:39', '2026-03-28 14:41:39'),
(145, 'INV-10131756', NULL, NULL, 'Engr ABDUL ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 105000.00, 7875.00, 0.00, 0.00, 0.00, 112875.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-12 15:28:50', '2026-02-12 15:28:50'),
(146, 'INV-12561169', NULL, NULL, 'Muazzam Opera', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 255000.00, 19125.00, 0.00, 0.00, 0.00, 274125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-02-11 12:22:38', '2026-02-11 12:22:38'),
(147, 'INV-71436674', NULL, NULL, 'Haltech ICT', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-21 10:57:16', '2026-02-21 10:57:16'),
(148, 'INV-72720927', NULL, NULL, 'Faruk Sammani', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-30 20:25:21', '2026-05-30 20:25:21'),
(149, 'INV-80699174', NULL, NULL, 'Nazzara Taraba', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 320000.00, 24000.00, 0.00, 0.00, 0.00, 344000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-29 18:51:39', '2026-05-29 18:51:39'),
(150, 'INV-18647562', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 205065.00, 7504.88, 0.00, 0.00, 0.00, 212569.88, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-01 12:57:27', '2026-06-01 12:57:27'),
(151, 'INV-44243287', NULL, NULL, 'Engr Abdul Adamawa', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 470000.00, 35250.00, 0.00, 0.00, 0.00, 505250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-17 16:04:01', '2026-02-17 16:04:01'),
(152, 'INV-11069658', NULL, NULL, 'Malam Usman Zuru', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 728250.00, 54618.75, 0.00, 0.00, 0.00, 782868.75, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-08 09:31:09', '2026-06-08 09:31:09'),
(153, 'INV-22741319', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 235000.00, 17625.00, 0.00, 0.00, 0.00, 252625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-19 12:19:01', '2026-03-19 12:19:01'),
(154, 'INV-23580186', NULL, NULL, 'Office Work', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 75000.00, 5625.00, 0.00, 0.00, 0.00, 80625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-05 15:13:00', '2026-03-05 15:13:00'),
(155, 'INV-31609016', NULL, NULL, 'Abu ammar', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 320000.00, 24000.00, 0.00, 0.00, 0.00, 344000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-31 12:46:50', '2026-05-31 12:46:50'),
(156, 'INV-15561411', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 110000.00, 8250.00, 0.00, 0.00, 0.00, 118250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-25 13:25:59', '2026-05-25 13:25:59'),
(157, 'INV-50961985', NULL, NULL, 'Abdulrahman Geesat', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 35000.00, 2625.00, 0.00, 0.00, 0.00, 37625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-16 14:49:23', '2026-04-16 14:49:23'),
(158, 'INV-34266300', NULL, NULL, 'Gombe', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 300000.00, 22500.00, 0.00, 0.00, 0.00, 322500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-09 13:44:27', '2026-05-09 13:44:27'),
(159, 'INV-47171949', NULL, NULL, 'Abdulrahman ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-16 13:46:12', '2026-04-16 13:46:12'),
(160, 'INV-51850529', NULL, NULL, 'Ishaq ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 35000.00, 2625.00, 0.00, 0.00, 0.00, 37625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-17 12:50:50', '2026-03-17 12:50:50'),
(161, 'INV-01492487', NULL, NULL, 'Engr Abdul ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 190000.00, 14250.00, 0.00, 0.00, 0.00, 204250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-13 11:31:32', '2026-03-13 11:31:32'),
(162, 'INV-67745669', NULL, NULL, 'Aliyu kaduna', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 350000.00, 26250.00, 0.00, 0.00, 0.00, 376250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'yarotech@yarotech.com.ng', NULL, NULL, '2026-02-13 07:29:03', '2026-02-13 07:29:03'),
(163, 'INV-10948045', NULL, NULL, 'Khalifa Customer', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 895000.00, 67125.00, 0.00, 0.00, 0.00, 962125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-12 15:42:26', '2026-02-12 15:42:26'),
(164, 'INV-48940526', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 340000.00, 0.00, 0.00, 0.00, 0.00, 340000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-30 11:35:40', '2026-04-30 11:35:40'),
(165, 'INV-70438187', NULL, NULL, 'VNET', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 270000.00, 20250.00, 0.00, 0.00, 0.00, 290250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-13 08:53:58', '2026-04-13 08:53:58'),
(166, 'INV-35797149', NULL, NULL, 'Khaleephaa', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 95000.00, 7125.00, 0.00, 0.00, 0.00, 102125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-09 11:56:37', '2026-04-09 11:56:37'),
(167, 'INV-83004067', NULL, NULL, 'Aliyu Network', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 255000.00, 19125.00, 0.00, 0.00, 0.00, 274125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-06 13:03:24', '2026-02-06 13:03:24'),
(168, 'INV-21171026', NULL, NULL, 'Faruk Sammani Yaro', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 801500.00, 60112.50, 0.00, 0.00, 0.00, 861612.50, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-25 14:59:31', '2026-05-25 14:59:31'),
(169, 'INV-96044147', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 25000.00, 1875.00, 0.00, 0.00, 0.00, 26875.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-05 15:47:24', '2026-05-05 15:47:24'),
(170, 'INV-23290257', NULL, NULL, 'Tech Nova', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 45000.00, 3375.00, 0.00, 0.00, 0.00, 48375.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-27 20:14:50', '2026-02-27 20:14:50'),
(171, 'INV-29259588', NULL, NULL, 'Mr Jacky Skyrun', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 540000.00, 40500.00, 0.00, 0.00, 0.00, 580500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-24 10:34:19', '2026-02-24 10:34:19'),
(172, 'INV-72646228', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 150000.00, 11250.00, 0.00, 0.00, 0.00, 161250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-27 06:50:48', '2026-04-27 06:50:48'),
(173, 'INV-01039318', NULL, NULL, 'Umar Sammani Yaro', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 1410000.00, 105750.00, 0.00, 0.00, 0.00, 1515750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-28 12:30:39', '2026-03-28 12:30:39'),
(174, 'INV-57533518', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 190000.00, 14250.00, 0.00, 0.00, 0.00, 204250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-04-01 15:32:14', '2026-04-01 15:32:14'),
(175, 'INV-56868008', NULL, NULL, 'Tanja', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-04-07 10:14:28', '2026-04-07 10:14:28'),
(176, 'INV-38901611', NULL, NULL, 'Ausad', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 160650.00, 12048.75, 0.00, 0.00, 0.00, 172698.75, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-08 17:15:01', '2026-06-08 17:15:01'),
(177, 'INV-72893144', NULL, NULL, 'Ahmad Taheer', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 285000.00, 21375.00, 0.00, 0.00, 0.00, 306375.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-08 12:28:13', '2026-03-08 12:28:13'),
(178, 'INV-63343317', NULL, NULL, 'Ishaq Rabiu', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 45000.00, 0.00, 0.00, 0.00, 0.00, 45000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-04 08:55:43', '2026-06-04 08:55:43'),
(179, 'INV-65296673', NULL, NULL, 'Mx prime', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 200000.00, 15000.00, 0.00, 0.00, 0.00, 215000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-29 12:21:36', '2026-04-29 12:21:36'),
(180, 'INV-22091018', NULL, NULL, 'Engr Abdul ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 680000.00, 51000.00, 0.00, 0.00, 0.00, 731000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-25 12:21:31', '2026-02-25 12:21:31'),
(181, 'INV-43584349', NULL, NULL, 'Musbahu Browsepoint', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-04-08 10:19:44', '2026-04-08 10:19:44'),
(182, 'INV-99158471', NULL, NULL, 'ismail hasssan', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'admin@yarotech.com.ng', NULL, NULL, '2026-02-05 13:45:58', '2026-02-05 13:45:58'),
(183, 'INV-45522918', NULL, NULL, 'Sadeeq Ogadi', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 400000.00, 30000.00, 0.00, 0.00, 0.00, 430000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-29 09:05:23', '2026-05-29 09:05:23'),
(184, 'INV-25741854', NULL, NULL, 'Abdullahi Abba', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 653250.00, 48993.75, 0.00, 0.00, 0.00, 702243.75, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-25 13:22:22', '2026-02-25 13:22:22'),
(185, 'INV-35741641', NULL, NULL, 'Ishaq', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 160000.00, 12000.00, 0.00, 0.00, 0.00, 172000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-15 15:02:22', '2026-06-15 15:02:22'),
(186, 'INV-93174880', NULL, NULL, 'Sani Kaduna', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 203000.00, 15225.00, 0.00, 0.00, 0.00, 218225.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-21 16:59:35', '2026-02-21 16:59:35'),
(187, 'INV-56846259', NULL, NULL, 'Holy daura', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 330000.00, 24750.00, 0.00, 0.00, 0.00, 354750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-29 10:00:46', '2026-04-29 10:00:46'),
(188, 'INV-80375348', NULL, NULL, 'Abdullahi Abba', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 340000.00, 25500.00, 0.00, 0.00, 0.00, 365500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-02 19:39:35', '2026-03-02 19:39:35'),
(189, 'INV-97319536', NULL, NULL, 'Umar sammani yaro', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 340000.00, 25500.00, 0.00, 0.00, 0.00, 365500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-02-04 09:28:39', '2026-02-04 09:28:39'),
(190, 'INV-28525102', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 255000.00, 19125.00, 0.00, 0.00, 0.00, 274125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-25 14:48:45', '2026-04-25 14:48:45'),
(191, 'INV-91374043', NULL, NULL, 'Faruk', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 130000.00, 9750.00, 0.00, 0.00, 0.00, 139750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-13 16:56:15', '2026-05-13 16:56:15'),
(192, 'INV-21833347', NULL, NULL, 'Kur', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 35000.00, 2625.00, 0.00, 0.00, 0.00, 37625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-27 14:30:34', '2026-03-27 14:30:34'),
(193, 'INV-43503292', NULL, NULL, 'Office work', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-04-08 10:18:23', '2026-04-08 10:18:23'),
(194, 'INV-77463219', NULL, NULL, 'AA kuraye', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 1015000.00, 68250.00, 0.00, 0.00, 0.00, 1083250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-06 14:24:24', '2026-05-06 14:24:24'),
(195, 'INV-09631928', NULL, NULL, 'Ahmad', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 75000.00, 5625.00, 0.00, 0.00, 0.00, 80625.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-04 15:47:12', '2026-05-04 15:47:12'),
(196, 'INV-99764241', NULL, NULL, 'hafizu adamu salisu', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 540000.00, 0.00, 0.00, 0.00, 0.00, 540000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'admin@yarotech.com.ng', NULL, NULL, '2026-02-05 13:56:03', '2026-02-05 13:56:03'),
(197, 'INV-03862094', NULL, NULL, 'Engr Abdul Nassarawa ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 450000.00, 33750.00, 0.00, 0.00, 0.00, 483750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-19 15:17:43', '2026-05-19 15:17:43'),
(198, 'INV-47190584', NULL, NULL, 'Faruk-Jos', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-23 12:26:31', '2026-04-23 12:26:31'),
(199, 'INV-07776252', NULL, NULL, 'Khalifa Customer', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-19 13:29:36', '2026-02-19 13:29:36'),
(200, 'INV-84566051', NULL, NULL, 'Mr Brain', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 375000.00, 20250.00, 0.00, 0.00, 0.00, 395250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-14 16:36:06', '2026-04-14 16:36:06'),
(201, 'INV-90028131', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 400000.00, 30000.00, 0.00, 0.00, 0.00, 430000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-03 12:33:48', '2026-06-03 12:33:48'),
(202, 'INV-84154920', NULL, NULL, 'Ahmad UMTK', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 160000.00, 12000.00, 0.00, 0.00, 0.00, 172000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-04 14:42:35', '2026-06-04 14:42:35'),
(203, 'INV-06306302', NULL, NULL, 'Engr Abdul Adamawa continue', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 95000.00, 7125.00, 0.00, 0.00, 0.00, 102125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-18 09:18:26', '2026-02-18 09:18:26'),
(204, 'INV-94511766', NULL, NULL, 'Aliyu Huawei', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 190000.00, 14250.00, 0.00, 0.00, 0.00, 204250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-06 10:55:12', '2026-03-06 10:55:12'),
(205, 'INV-73147976', NULL, NULL, 'Faruk Sammani', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 300000.00, 22500.00, 0.00, 0.00, 0.00, 322500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-29 08:32:29', '2026-03-29 08:32:29'),
(206, 'INV-33579879', NULL, NULL, 'Aliyu Huawei', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 970000.00, 72750.00, 0.00, 0.00, 0.00, 1042750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-09 11:19:40', '2026-04-09 11:19:40'),
(207, 'INV-79888134', NULL, NULL, 'Nazzara', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 400000.00, 30000.00, 0.00, 0.00, 0.00, 430000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-06-13 19:44:48', '2026-06-13 19:44:48'),
(208, 'INV-97683016', NULL, NULL, 'Alamin madina', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-12 14:54:44', '2026-05-12 14:54:44'),
(209, 'INV-71719067', NULL, NULL, 'Ahmad Nazifi ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 170000.00, 12750.00, 0.00, 0.00, 0.00, 182750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-08 17:28:39', '2026-02-08 17:28:39'),
(210, 'INV-20030232', NULL, NULL, 'Ishaq rabiu ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 20000.00, 1500.00, 0.00, 0.00, 0.00, 21500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-03-13 16:40:30', '2026-03-13 16:40:30'),
(211, 'INV-08180050', NULL, NULL, 'Sani Isa', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 5005.00, 375.38, 0.00, 0.00, 0.00, 5380.38, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-19 13:36:20', '2026-02-19 13:36:20'),
(212, 'INV-76103512', NULL, NULL, 'ENGR ABDUL Yola', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 255000.00, 19125.00, 0.00, 0.00, 0.00, 274125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-13 09:48:22', '2026-02-13 09:48:22'),
(213, 'INV-58903708', NULL, NULL, 'Aliyu Huawei ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-14 11:41:43', '2026-05-14 11:41:43'),
(214, 'INV-41069743', NULL, NULL, 'Khaleepha', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 95000.00, 7125.00, 0.00, 0.00, 0.00, 102125.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-04 16:17:50', '2026-03-04 16:17:50'),
(215, 'INV-98194058', NULL, NULL, 'Niger', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-14 14:23:14', '2026-03-14 14:23:14'),
(216, 'INV-64474204', NULL, NULL, 'Engr Abdul Camera Kaduna', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 1154000.00, 86550.00, 0.00, 0.00, 0.00, 1240550.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-23 16:34:34', '2026-02-23 16:34:34'),
(217, 'INV-26696979', NULL, NULL, 'Eng Abdul CEO ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 180000.00, 13500.00, 0.00, 0.00, 0.00, 193500.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'elsadeeq24@gmail.com', NULL, NULL, '2026-04-08 05:38:17', '2026-04-08 05:38:17'),
(218, 'INV-85031898', NULL, NULL, 'Bilal Solar', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 315000.00, 0.00, 0.00, 0.00, 0.00, 315000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-28 14:03:52', '2026-04-28 14:03:52'),
(219, 'INV-69688269', NULL, NULL, 'Ahmad Nazifi', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 1190000.00, 89250.00, 0.00, 0.00, 0.00, 1279250.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-08 16:54:49', '2026-02-08 16:54:49'),
(220, 'INV-10636022', NULL, NULL, 'Aliyu Network ', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 450000.00, 33750.00, 0.00, 0.00, 0.00, 483750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'yarotech@yarotech.com.ng', NULL, NULL, '2026-03-30 22:43:56', '2026-03-30 22:43:56'),
(221, 'INV-56720496', NULL, NULL, 'Rabe Daura', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 400000.00, 30000.00, 0.00, 0.00, 0.00, 430000.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-15 12:38:41', '2026-04-15 12:38:41'),
(222, 'INV-94581924', NULL, NULL, 'Muhammad A Abuja', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 101500.00, 7612.50, 0.00, 0.00, 0.00, 109112.50, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-03-06 10:56:22', '2026-03-06 10:56:22'),
(223, 'INV-90951578', NULL, NULL, 'Gida Dubu', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 90000.00, 6750.00, 0.00, 0.00, 0.00, 96750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-04-21 17:02:32', '2026-04-21 17:02:32'),
(224, 'INV-53621115', NULL, NULL, 'Opera', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 170000.00, 12750.00, 0.00, 0.00, 0.00, 182750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'alhassanabubakarismail@gmail.com', NULL, NULL, '2026-02-16 14:53:41', '2026-02-16 14:53:41'),
(225, 'INV-36476830', NULL, NULL, 'Engr Abdul', NULL, '+234 81 4024 4774', NULL, 'delivery', NULL, NULL, NULL, NULL, NULL, 610000.00, 45750.00, 0.00, 0.00, 0.00, 655750.00, 'NGN', 'picked_up', 'success', 'pos', 'pending', NULL, 'AL-HASSAN', NULL, NULL, '2026-05-31 14:07:57', '2026-05-31 14:07:57'),
(329, 'YT-20260620-832AB9', NULL, NULL, 'Issad Gen', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 240000.00, 18000.00, 0.00, 0.00, 0.00, 258000.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-06-20 13:21:09', '2026-06-20 13:21:09', '2026-06-20 13:21:09'),
(330, 'YT-20260625-6A864E', NULL, NULL, 'Ishaq', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 160000.00, 12000.00, 0.00, 0.00, 0.00, 172000.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-06-25 11:18:16', '2026-06-25 11:18:16', '2026-06-25 11:18:16'),
(331, 'YT-20260626-E1C082', NULL, NULL, 'Faruk', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 268000.00, 20100.00, 0.00, 0.00, 0.00, 288100.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-06-26 14:44:27', '2026-06-26 14:44:27', '2026-06-26 14:44:27'),
(332, 'YT-20260627-E5F6BF', NULL, NULL, 'Sadeeq Ogadi', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 160000.00, 12000.00, 0.00, 0.00, 0.00, 172000.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-06-27 10:43:50', '2026-06-27 10:43:50', '2026-06-27 10:43:50'),
(333, 'YT-20260627-7E411A', NULL, NULL, 'Faruk', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 13000.00, 975.00, 0.00, 0.00, 0.00, 13975.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-06-27 12:33:24', '2026-06-27 12:33:24', '2026-06-27 12:33:24'),
(334, 'YT-20260628-504CB3', NULL, NULL, 'Sadeeq ogadi', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 20, '2026-06-28 11:21:06', '2026-06-28 11:21:06', '2026-06-28 11:21:06'),
(335, 'YT-20260629-467DDB', NULL, NULL, 'Sadeeq Ogadi', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-06-29 08:13:15', '2026-06-29 08:13:15', '2026-06-29 08:13:15'),
(336, 'YT-20260630-604D2C', NULL, NULL, 'Aliyu Huawei', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-06-30 11:34:13', '2026-06-30 11:34:13', '2026-06-30 11:34:13'),
(337, 'YT-20260630-B2F606', NULL, NULL, 'Aliyu Huawei', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 320000.00, 24000.00, 0.00, 0.00, 0.00, 344000.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-06-30 11:34:40', '2026-06-30 11:34:40', '2026-06-30 11:34:40');
INSERT INTO `orders` (`id`, `order_number`, `user_id`, `customer_id`, `customer_name`, `customer_email`, `customer_phone`, `notes`, `fulfillment_method`, `delivery_state`, `delivery_city`, `delivery_address`, `delivery_landmark`, `delivery_phone`, `subtotal`, `tax_amount`, `discount`, `tax`, `delivery_fee`, `total_amount`, `currency`, `order_status`, `payment_status`, `sale_channel`, `pos_sync_status`, `payment_method`, `created_by`, `created_by_user_id`, `inventory_reduced_at`, `created_at`, `updated_at`) VALUES
(338, 'YT-20260630-DD0B27', 23, 23, 'Yarotech Network Limited', 'yarotechnetworklimited@gmail.com', '09060595221', NULL, 'pickup', NULL, NULL, NULL, NULL, '09060595221', 1225000.00, 91875.00, 0.00, 0.00, 0.00, 1316875.00, 'NGN', 'ready_for_pickup', 'success', 'ecommerce', 'pending', 'paystack', 'user', 23, '2026-06-30 12:58:10', '2026-06-30 12:56:48', '2026-06-30 13:03:03'),
(339, 'YT-20260630-6E6B86', 24, 24, 'SAIDU USMAN ABDULLAHI', 'saeeduthmanabdullahi@gmail.com', '09060595221', NULL, 'delivery', 'Kano', 'Kano', 'No.719 Chiranchi Tudu', NULL, '09060595221', 160000.00, 12000.00, 0.00, 0.00, 25000.00, 197000.00, 'NGN', 'shipped', 'success', 'ecommerce', 'pending', 'paystack', 'user', 24, '2026-06-30 16:41:04', '2026-06-30 16:40:23', '2026-06-30 16:43:13'),
(340, 'YT-20260701-C50FDA', NULL, NULL, 'Ishaq Yola', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 95000.00, 7125.00, 0.00, 0.00, 0.00, 102125.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-07-01 16:44:03', '2026-07-01 16:44:03', '2026-07-01 16:44:03'),
(341, 'YT-20260702-CE7F92', NULL, NULL, 'Faruk', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 190000.00, 14250.00, 0.00, 0.00, 0.00, 204250.00, 'NGN', 'delivered', 'success', 'pos', 'pending', 'cash', 'staff', 22, '2026-07-02 11:29:23', '2026-07-02 11:29:23', '2026-07-02 11:29:23'),
(342, 'YT-20260703-62B898', NULL, NULL, 'Walk-in customer', NULL, '09060595221', NULL, 'pickup', NULL, NULL, NULL, NULL, '09060595221', 120000.00, 9000.00, 0.00, 0.00, 0.00, 129000.00, 'NGN', 'paid', 'success', 'pos', 'pending', 'cash', 'admin', 11, '2026-07-03 11:35:30', '2026-07-03 11:35:30', '2026-07-03 11:35:30'),
(343, 'YT-20260703-A3173A', NULL, NULL, 'Auwal Sucodi', NULL, '09060612104', 'All Goods are in perfect condition!', 'pickup', NULL, NULL, NULL, NULL, '09060612104', 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'paid', 'success', 'pos', 'pending', 'bank_transfer', 'admin', 22, '2026-07-03 16:23:04', '2026-07-03 16:23:04', '2026-07-03 16:23:04'),
(344, 'YT-20260703-39E29C', NULL, NULL, 'Auwalu Sucodi 2', NULL, '09060612104', NULL, 'pickup', NULL, NULL, NULL, NULL, '09060612104', 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'paid', 'success', 'pos', 'pending', 'bank_transfer', 'admin', 22, '2026-07-03 17:14:30', '2026-07-03 17:14:30', '2026-07-03 17:14:30'),
(346, 'YT-20260707-B095E6', NULL, NULL, 'Kurr', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'paid', 'success', 'pos', 'pending', 'cash', 'admin', 22, '2026-07-07 14:03:48', '2026-07-07 14:03:48', '2026-07-07 14:03:48'),
(347, 'YT-20260707-2F49F6', NULL, NULL, 'Aliyu Huawei', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 80000.00, 6000.00, 0.00, 0.00, 0.00, 86000.00, 'NGN', 'paid', 'success', 'pos', 'pending', 'other', 'admin', 22, '2026-07-07 14:04:31', '2026-07-07 14:04:31', '2026-07-07 14:04:31'),
(348, 'YT-20260707-9D8A27', NULL, NULL, 'Auwalu Sucodi', NULL, NULL, 'All goods are in good condition', 'pickup', NULL, NULL, NULL, NULL, NULL, 1360000.00, 102000.00, 0.00, 0.00, 0.00, 1462000.00, 'NGN', 'paid', 'success', 'pos', 'pending', 'bank_transfer', 'admin', 22, '2026-07-07 14:05:32', '2026-07-07 14:05:32', '2026-07-07 14:05:32'),
(349, 'YT-20260707-97F335', NULL, NULL, 'Aliyu Huawei Conti.', NULL, NULL, NULL, 'pickup', NULL, NULL, NULL, NULL, NULL, 320000.00, 24000.00, 0.00, 0.00, 0.00, 344000.00, 'NGN', 'paid', 'success', 'pos', 'pending', 'other', 'admin', 22, '2026-07-07 14:07:03', '2026-07-07 14:07:03', '2026-07-07 14:07:03');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `product_name_snapshot` varchar(190) NOT NULL,
  `sku_snapshot` varchar(80) DEFAULT NULL,
  `unit_price_snapshot` decimal(12,2) NOT NULL DEFAULT 0.00,
  `quantity` int(10) UNSIGNED NOT NULL,
  `line_total` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `product_name_snapshot`, `sku_snapshot`, `unit_price_snapshot`, `quantity`, `line_total`) VALUES
(800434, 74, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800435, 75, 'a42a2153-f9b5-47fc-977c-7c5b373c04da', 'MIKROTIC RB951ui', NULL, 100000.00, 1, 100000.00),
(800436, 76, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 4, 340000.00),
(800437, 76, '9308423e-bce1-42a1-bc78-82daaf687eaa', 'Switch 8port Net-pro', NULL, 100000.00, 1, 100000.00),
(800438, 77, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 75000.00, 3, 225000.00),
(800439, 78, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 1, 85000.00),
(800440, 78, '21d95888-c3af-4cf6-92c9-49a08ca78c9f', 'Tiandy POE switch 4ports', NULL, 45000.00, 1, 45000.00),
(800441, 79, '7913d4cb-5c13-4464-882d-cebf9a86d99b', 'WIFI camera socket', NULL, 20000.00, 1, 20000.00),
(800442, 80, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800443, 81, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 1, 85000.00),
(800444, 82, '21d95888-c3af-4cf6-92c9-49a08ca78c9f', 'Tiandy POE switch 4ports', NULL, 45000.00, 1, 45000.00),
(800445, 83, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800446, 84, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 3, 270000.00),
(800447, 85, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 95000.00, 3, 285000.00),
(800448, 86, '1d1b3c74-78f7-4932-92bc-840dbe7b1ef5', 'cat6 20meter', NULL, 10000.00, 1, 10000.00),
(800449, 87, '1d1b3c74-78f7-4932-92bc-840dbe7b1ef5', 'cat6 20meter', NULL, 10000.00, 4, 40000.00),
(800450, 87, 'd8a99a41-9611-4c89-b03a-51f4206724e6', 'Tenda N301', NULL, 25000.00, 2, 50000.00),
(800451, 87, '7a940362-8d6e-47c1-b49e-ee1dd5f0cf7a', 'DLINK DIR-650IN', NULL, 35000.00, 1, 35000.00),
(800452, 88, '1d1b3c74-78f7-4932-92bc-840dbe7b1ef5', 'cat6 20meter', NULL, 10000.00, 1, 10000.00),
(800453, 88, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 1, 85000.00),
(800454, 89, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800455, 90, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 95000.00, 2, 190000.00),
(800456, 90, '21d95888-c3af-4cf6-92c9-49a08ca78c9f', 'Tiandy POE switch 4ports', NULL, 45000.00, 1, 45000.00),
(800457, 91, 'eee6a315-2547-452a-b0b7-c1fbd9251aeb', 'LAP-GPS', NULL, 200000.00, 1, 200000.00),
(800458, 92, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800459, 93, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800460, 94, '27b56358-3b28-4487-b456-c6a86b3df7a5', 'Tiandy ip camera 4MP Outdoor', NULL, 40000.00, 1, 40000.00),
(800461, 95, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800462, 96, '333126e4-b4f8-4dad-b993-c4a67f1af392', 'STARLINK V4', NULL, 540000.00, 1, 540000.00),
(800463, 96, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 8, 680000.00),
(800464, 96, '47e41f91-20b1-4689-bb9a-7b50f20b1d61', 'Switch 10port TPlink', NULL, 130000.00, 1, 130000.00),
(800465, 96, '24ed8703-25a3-4311-a443-a12ffca0400b', 'RJ45', NULL, 65.00, 50, 3250.00),
(800466, 96, '01b0d610-1ba3-47dd-b270-e48ff36b839a', 'CAT6 OUTDOOR', NULL, 95000.00, 1, 95000.00),
(800467, 97, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800470, 99, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 1, 80000.00),
(800471, 100, 'b379af1b-fe38-45d3-8a78-bb33a94b6493', 'Tiandy 2mp Indoor', NULL, 19000.00, 4, 76000.00),
(800472, 100, 'cb5ae788-bd21-4fda-9d4d-0a2baa48d4d6', 'Tiandy 2mp Outdoor', NULL, 19000.00, 4, 76000.00),
(800473, 100, '9308423e-bce1-42a1-bc78-82daaf687eaa', 'Switch 8port Net-pro', NULL, 100000.00, 1, 100000.00),
(800474, 101, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 3, 240000.00),
(800475, 102, '6d35b7f7-7597-4f3a-9725-0b75a9805eb3', 'U4 RACK', NULL, 65000.00, 1, 65000.00),
(800476, 103, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 10, 800000.00),
(800477, 103, '21d95888-c3af-4cf6-92c9-49a08ca78c9f', 'Tiandy POE switch 4ports', NULL, 45000.00, 3, 135000.00),
(800478, 104, 'a42a2153-f9b5-47fc-977c-7c5b373c04da', 'MIKROTIC RB951ui', NULL, 100000.00, 1, 100000.00),
(800479, 105, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 75000.00, 1, 75000.00),
(800480, 106, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 2, 180000.00),
(800481, 107, '09798be8-6d9c-498e-88d7-a10b561c1276', 'Inverter Haisic 1.5kva', NULL, 200000.00, 1, 200000.00),
(800482, 108, '2258b873-0b62-4ffc-8084-3db0acc7740d', 'MUST battery 1kwh all in one', NULL, 375000.00, 1, 375000.00),
(800483, 109, 'cd1cc80e-9049-484b-89e5-a3336da82060', 'Dahua poe switch 8port', NULL, 75000.00, 1, 75000.00),
(800484, 109, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 1, 80000.00),
(800485, 109, '94440229-ed4b-442a-92ea-37e808199b38', 'cat6 2meter', NULL, 1500.00, 1, 1500.00),
(800486, 110, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 3, 270000.00),
(800487, 111, '28f05f87-805a-4585-8c4a-43c91a7e236f', 'Litebeam 5AC', NULL, 130000.00, 1, 130000.00),
(800488, 112, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 95000.00, 4, 380000.00),
(800489, 113, '7a940362-8d6e-47c1-b49e-ee1dd5f0cf7a', 'DLINK DIR-650IN', NULL, 35000.00, 3, 105000.00),
(800490, 113, '4a40b3c1-c1fd-447e-9e4f-b6ae28a1d38f', 'Ethernet Power Adaptor second used 24V', NULL, 14000.00, 2, 28000.00),
(800491, 114, 'e2102869-d7b5-48d0-a78c-3d83fff372be', 'HUAWEI S110 16PORT', NULL, 250000.00, 1, 250000.00),
(800492, 115, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 5, 425000.00),
(800493, 116, '333126e4-b4f8-4dad-b993-c4a67f1af392', 'STARLINK V4', NULL, 540000.00, 1, 540000.00),
(800494, 117, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 2, 180000.00),
(800495, 117, 'da48c070-f3fa-4ac9-9c48-82764ed9e64b', 'HUAWEI S110 8PORT', NULL, 130000.00, 1, 130000.00),
(800496, 117, '01b0d610-1ba3-47dd-b270-e48ff36b839a', 'CAT6 OUTDOOR', NULL, 105000.00, 1, 105000.00),
(800497, 117, '94440229-ed4b-442a-92ea-37e808199b38', 'cat6 2meter', NULL, 1500.00, 1, 1500.00),
(800498, 117, '24ed8703-25a3-4311-a443-a12ffca0400b', 'RJ45', NULL, 65.00, 15, 975.00),
(800499, 117, '4035a722-581f-4133-b7b8-d283c548e7f3', 'tiandy smart mini battery camera', NULL, 72000.00, 1, 72000.00),
(800500, 117, 'd355c953-646b-4bd2-a37f-9479715fa2b1', 'Mikrotik AX2', NULL, 140000.00, 1, 140000.00),
(800501, 118, '7913d4cb-5c13-4464-882d-cebf9a86d99b', 'WIFI camera socket', NULL, 20000.00, 1, 20000.00),
(800502, 119, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 1, 85000.00),
(800503, 120, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 2, 160000.00),
(800504, 120, 'cd1cc80e-9049-484b-89e5-a3336da82060', 'Dahua poe switch 8port', NULL, 75000.00, 1, 75000.00),
(800505, 120, '24ed8703-25a3-4311-a443-a12ffca0400b', 'RJ45', NULL, 65.00, 40, 2600.00),
(800506, 121, '9a7f6d72-8d10-469b-9ed8-5746d411b07b', 'Itel 1kwh battery all in one', NULL, 315000.00, 1, 315000.00),
(800507, 122, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 6, 510000.00),
(800508, 122, '47e41f91-20b1-4689-bb9a-7b50f20b1d61', 'Switch 10port TPlink', NULL, 130000.00, 3, 390000.00),
(800509, 123, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 95000.00, 1, 95000.00),
(800510, 124, 'ff89786d-aecc-4c2d-ac8c-7bb31d4339bd', 'MIKROTIC LOO9', NULL, 180000.00, 1, 180000.00),
(800511, 125, 'a42a2153-f9b5-47fc-977c-7c5b373c04da', 'MIKROTIC RB951ui', NULL, 100000.00, 1, 100000.00),
(800512, 126, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 4, 320000.00),
(800513, 126, 'da48c070-f3fa-4ac9-9c48-82764ed9e64b', 'HUAWEI S110 8PORT', NULL, 130000.00, 1, 130000.00),
(800514, 126, '01b0d610-1ba3-47dd-b270-e48ff36b839a', 'CAT6 OUTDOOR', NULL, 105000.00, 1, 105000.00),
(800515, 127, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800516, 127, '24ed8703-25a3-4311-a443-a12ffca0400b', 'RJ45', NULL, 65.00, 100, 6500.00),
(800517, 128, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800518, 128, '85673cec-91b2-4527-b53b-7fe628c1f2d4', 'LOCO 5AC', NULL, 95000.00, 1, 95000.00),
(800519, 129, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800520, 129, '1d1b3c74-78f7-4932-92bc-840dbe7b1ef5', 'cat6 20meter', NULL, 10000.00, 1, 10000.00),
(800521, 130, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800522, 131, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 2, 180000.00),
(800523, 131, 'c7790cc9-e758-4196-8974-d9e8025762d9', 'TPlink Switch 8 port non poe', NULL, 18000.00, 1, 18000.00),
(800524, 132, 'cd1cc80e-9049-484b-89e5-a3336da82060', 'Dahua poe switch 8port', NULL, 75000.00, 1, 75000.00),
(800525, 132, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 2, 180000.00),
(800526, 132, '01b0d610-1ba3-47dd-b270-e48ff36b839a', 'CAT6 OUTDOOR', NULL, 105000.00, 1, 105000.00),
(800527, 132, 'd355c953-646b-4bd2-a37f-9479715fa2b1', 'Mikrotik AX2', NULL, 140000.00, 1, 140000.00),
(800528, 132, '24ed8703-25a3-4311-a443-a12ffca0400b', 'RJ45', NULL, 65.00, 50, 3250.00),
(800529, 133, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800530, 134, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 2, 170000.00),
(800531, 135, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 2, 170000.00),
(800532, 136, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 5, 400000.00),
(800533, 136, '47e41f91-20b1-4689-bb9a-7b50f20b1d61', 'Switch 10port TPlink', NULL, 130000.00, 1, 130000.00),
(800534, 137, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 5, 400000.00),
(800535, 137, 'd355c953-646b-4bd2-a37f-9479715fa2b1', 'Mikrotik AX2', NULL, 140000.00, 1, 140000.00),
(800536, 137, '01b0d610-1ba3-47dd-b270-e48ff36b839a', 'CAT6 OUTDOOR', NULL, 105000.00, 1, 105000.00),
(800537, 138, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 10, 800000.00),
(800538, 138, '94440229-ed4b-442a-92ea-37e808199b38', 'cat6 2meter', NULL, 1500.00, 1, 1500.00),
(800539, 139, '9a7f6d72-8d10-469b-9ed8-5746d411b07b', 'Itel 1kwh battery all in one', NULL, 315000.00, 1, 315000.00),
(800540, 140, 'cd1cc80e-9049-484b-89e5-a3336da82060', 'Dahua poe switch 8port', NULL, 75000.00, 1, 75000.00),
(800541, 141, '28f05f87-805a-4585-8c4a-43c91a7e236f', 'Litebeam 5AC', NULL, 150000.00, 1, 150000.00),
(800542, 142, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 2, 180000.00),
(800543, 143, '9a7f6d72-8d10-469b-9ed8-5746d411b07b', 'Itel 1kwh battery all in one', NULL, 315000.00, 1, 315000.00),
(800544, 144, '21d95888-c3af-4cf6-92c9-49a08ca78c9f', 'Tiandy POE switch 4ports', NULL, 45000.00, 1, 45000.00),
(800545, 145, '2b159cc3-d169-48f1-9fcf-88db6d92abbf', 'MEDIA-CONVERTER RJ45-FIBER', NULL, 35000.00, 3, 105000.00),
(800546, 146, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 3, 255000.00),
(800547, 147, 'ff89786d-aecc-4c2d-ac8c-7bb31d4339bd', 'MIKROTIC LOO9', NULL, 180000.00, 1, 180000.00),
(800548, 148, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 1, 80000.00),
(800549, 149, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 4, 320000.00),
(800550, 150, '01b0d610-1ba3-47dd-b270-e48ff36b839a', 'CAT6 OUTDOOR', NULL, 105000.00, 1, 105000.00),
(800551, 150, '24ed8703-25a3-4311-a443-a12ffca0400b', 'RJ45', NULL, 65.00, 1, 65.00),
(800552, 150, 'e3c9abe5-e2fc-46d3-9c1e-69e3902b5df5', 'Tiandy NVR 20chl', NULL, 100000.00, 1, 100000.00),
(800553, 151, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 4, 340000.00),
(800554, 151, '47e41f91-20b1-4689-bb9a-7b50f20b1d61', 'Switch 10port TPlink', NULL, 130000.00, 1, 130000.00),
(800555, 152, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 8, 640000.00),
(800556, 152, '24ed8703-25a3-4311-a443-a12ffca0400b', 'RJ45', NULL, 65.00, 50, 3250.00),
(800557, 152, '6d35b7f7-7597-4f3a-9725-0b75a9805eb3', 'U4 RACK', NULL, 85000.00, 1, 85000.00),
(800558, 153, '28f05f87-805a-4585-8c4a-43c91a7e236f', 'Litebeam 5AC', NULL, 130000.00, 1, 130000.00),
(800559, 153, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 95000.00, 1, 95000.00),
(800560, 153, '1d1b3c74-78f7-4932-92bc-840dbe7b1ef5', 'cat6 20meter', NULL, 10000.00, 1, 10000.00),
(800561, 154, 'cd1cc80e-9049-484b-89e5-a3336da82060', 'Dahua poe switch 8port', NULL, 75000.00, 1, 75000.00),
(800562, 155, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 80000.00, 4, 320000.00),
(800563, 156, 'feabd484-2b93-4a29-873f-f873132ae9cc', 'AP263', NULL, 110000.00, 1, 110000.00),
(800564, 157, '7a940362-8d6e-47c1-b49e-ee1dd5f0cf7a', 'DLINK DIR-650IN', NULL, 35000.00, 1, 35000.00),
(800565, 158, '28f05f87-805a-4585-8c4a-43c91a7e236f', 'Litebeam 5AC', NULL, 150000.00, 2, 300000.00),
(800566, 159, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 90000.00, 1, 90000.00),
(800567, 160, 'a7a32284-9a3b-452c-9abc-a83f74b27093', 'tiandy smart stand mini 355 camera', NULL, 35000.00, 1, 35000.00),
(800568, 161, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 95000.00, 2, 190000.00),
(800569, 162, '6a094c93-02a6-4d03-9e93-60073e91057b', 'MIKROTIC RB4011', NULL, 350000.00, 1, 350000.00),
(800570, 163, '915e3a15-9a18-4299-9625-c8bcd37eb9cf', 'AP361', NULL, 75000.00, 4, 300000.00),
(800571, 163, '3a4127fe-8496-4aed-8a1e-e73c311867b3', 'AP362', NULL, 85000.00, 7, 595000.00),
(800572, 329, 'custom', '', '', 80000.00, 3, 240000.00),
(49595898, 330, 'custom', '', '', 80000.00, 2, 160000.00),
(49595899, 331, 'custom', '', '', 95000.00, 2, 190000.00),
(49595900, 331, 'custom', '', '', 75000.00, 1, 75000.00),
(49595901, 331, 'custom', '', '', 1500.00, 2, 3000.00),
(49595902, 332, 'custom', '', '', 80000.00, 2, 160000.00),
(49595903, 333, 'custom', '', '', 65.00, 200, 13000.00),
(49595904, 334, 'custom', '', '', 80000.00, 1, 80000.00),
(49595905, 335, 'custom', '', '', 80000.00, 1, 80000.00),
(49595906, 336, 'custom', '', '', 80000.00, 1, 80000.00),
(49595907, 337, 'custom', '', '', 80000.00, 4, 320000.00),
(49595908, 338, 'PRD-038', 'Hikvision attendance (fingerprint only)', 'SKU-HIKVISION-ATTENDANCE-FINGERPRI', 160000.00, 1, 160000.00),
(49595909, 338, 'PRD-081', 'MIKROTIC L009', 'SKU-MIKROTIC-L009', 215000.00, 1, 215000.00),
(49595910, 338, 'PRD-024', 'UDM-PRO', 'SKU-UDM-PRO', 850000.00, 1, 850000.00),
(49595911, 339, 'PRD-038', 'Hikvision attendance (fingerprint only)', 'SKU-HIKVISION-ATTENDANCE-FINGERPRI', 160000.00, 1, 160000.00),
(49595912, 340, 'custom', '', '', 95000.00, 1, 95000.00),
(49595913, 341, 'custom', '', '', 95000.00, 2, 190000.00),
(49595914, 342, 'PRD-C9F837A7', 'Huawei AR180 Dual Band Wifi 7 Router', 'YT-D-WIFI-RT', 120000.00, 1, 120000.00),
(49595915, 343, 'PRD-043', 'AP361', 'SKU-AP361', 80000.00, 1, 80000.00),
(49595916, 344, 'PRD-043', 'AP361', 'SKU-AP361', 80000.00, 1, 80000.00),
(49595918, 346, 'PRD-043', 'AP361', 'SKU-AP361', 80000.00, 1, 80000.00),
(49595919, 347, 'PRD-043', 'AP361', 'SKU-AP361', 80000.00, 1, 80000.00),
(49595920, 348, 'PRD-043', 'AP361', 'SKU-AP361', 80000.00, 17, 1360000.00),
(49595921, 349, 'PRD-043', 'AP361', 'SKU-AP361', 80000.00, 4, 320000.00);

-- --------------------------------------------------------

--
-- Table structure for table `order_tracking`
--

CREATE TABLE `order_tracking` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(64) NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_tracking`
--

INSERT INTO `order_tracking` (`id`, `order_id`, `status`, `title`, `description`, `created_at`) VALUES
(60, 329, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-20 13:21:09'),
(61, 330, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-25 11:18:16'),
(62, 331, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-26 14:44:27'),
(63, 332, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-27 10:43:50'),
(64, 333, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-27 12:33:24'),
(65, 334, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-28 11:21:06'),
(66, 335, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-29 08:13:15'),
(67, 336, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-30 11:34:13'),
(68, 337, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-06-30 11:34:40'),
(69, 338, 'awaiting_payment', 'Order created', 'Awaiting payment confirmation.', '2026-06-30 12:56:48'),
(70, 338, 'paid', 'Payment confirmed', 'Paystack reference YT-PAY-YT20260630DD0B27-E437A8A6 verified.', '2026-06-30 12:58:10'),
(71, 338, 'ready_for_pickup', 'Admin status update', 'Order status set to ready_for_pickup.', '2026-06-30 13:03:03'),
(72, 339, 'awaiting_payment', 'Order created', 'Awaiting payment confirmation.', '2026-06-30 16:40:23'),
(73, 339, 'paid', 'Payment confirmed', 'Paystack reference YT-PAY-YT202606306E6B86-3A0A47DB verified.', '2026-06-30 16:41:04'),
(74, 339, 'shipped', 'Admin status update', 'Order status set to shipped.', '2026-06-30 16:43:13'),
(75, 340, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-07-01 16:44:03'),
(76, 341, 'delivered', 'POS sale created', 'POS sale created from dashboard.', '2026-07-02 11:29:23'),
(77, 342, 'paid', 'POS sale created', 'POS sale created from dashboard.', '2026-07-03 11:35:30'),
(78, 343, 'paid', 'POS sale created', 'POS sale created from dashboard.', '2026-07-03 16:23:04'),
(79, 344, 'paid', 'POS sale created', 'POS sale created from dashboard.', '2026-07-03 17:14:30'),
(81, 346, 'paid', 'POS sale created', 'POS sale created from dashboard.', '2026-07-07 14:03:48'),
(82, 347, 'paid', 'POS sale created', 'POS sale created from dashboard.', '2026-07-07 14:04:31'),
(83, 348, 'paid', 'POS sale created', 'POS sale created from dashboard.', '2026-07-07 14:05:32'),
(84, 349, 'paid', 'POS sale created', 'POS sale created from dashboard.', '2026-07-07 14:07:03');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `provider` varchar(40) NOT NULL DEFAULT 'paystack',
  `channel` varchar(40) DEFAULT NULL,
  `payment_method` varchar(40) DEFAULT NULL,
  `reference` varchar(120) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'NGN',
  `status` enum('initialized','processing','success','failed','refunded') NOT NULL DEFAULT 'initialized',
  `raw_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`raw_response`)),
  `gateway_response` varchar(255) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `provider`, `channel`, `payment_method`, `reference`, `amount`, `currency`, `status`, `raw_response`, `gateway_response`, `paid_at`, `created_at`) VALUES
(17, 74, 'manual', 'pos', 'cash', 'MIG_POS_INV-25312730', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-18 15:15:13', '2026-04-18 15:15:13'),
(18, 75, 'manual', 'pos', 'cash', 'MIG_POS_INV-15730034', 107500.00, 'NGN', 'success', NULL, NULL, '2026-03-19 10:22:10', '2026-03-19 10:22:10'),
(19, 76, 'manual', 'pos', 'cash', 'MIG_POS_INV-97996905', 473000.00, 'NGN', 'success', NULL, NULL, '2026-02-04 09:39:56', '2026-02-04 09:39:56'),
(20, 77, 'manual', 'pos', 'cash', 'MIG_POS_INV-05855994', 241875.00, 'NGN', 'success', NULL, NULL, '2026-02-11 10:30:53', '2026-02-11 10:30:53'),
(21, 78, 'manual', 'pos', 'cash', 'MIG_POS_INV-67396429', 139750.00, 'NGN', 'success', NULL, NULL, '2026-03-01 12:16:36', '2026-03-01 12:16:36'),
(22, 79, 'manual', 'pos', 'cash', 'MIG_POS_INV-28997509', 21500.00, 'NGN', 'success', NULL, NULL, '2026-03-12 15:23:18', '2026-03-12 15:23:18'),
(23, 80, 'manual', 'pos', 'cash', 'MIG_POS_INV-87837937', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-27 11:03:58', '2026-04-27 11:03:58'),
(24, 81, 'manual', 'pos', 'cash', 'MIG_POS_INV-78192736', 91375.00, 'NGN', 'success', NULL, NULL, '2026-03-01 15:16:32', '2026-03-01 15:16:32'),
(25, 82, 'manual', 'pos', 'cash', 'MIG_POS_INV-90635915', 45000.00, 'NGN', 'success', NULL, NULL, '2026-06-03 12:43:56', '2026-06-03 12:43:56'),
(26, 83, 'manual', 'pos', 'cash', 'MIG_POS_INV-98654671', 96750.00, 'NGN', 'success', NULL, NULL, '2026-03-28 11:50:55', '2026-03-28 11:50:55'),
(27, 84, 'manual', 'pos', 'cash', 'MIG_POS_INV-16820230', 290250.00, 'NGN', 'success', NULL, NULL, '2026-03-29 20:40:20', '2026-03-29 20:40:20'),
(28, 85, 'manual', 'pos', 'cash', 'MIG_POS_INV-44262477', 306375.00, 'NGN', 'success', NULL, NULL, '2026-03-18 14:31:02', '2026-03-18 14:31:02'),
(29, 86, 'manual', 'pos', 'cash', 'MIG_POS_INV-30697641', 10750.00, 'NGN', 'success', NULL, NULL, '2026-03-04 13:24:58', '2026-03-04 13:24:58'),
(30, 87, 'manual', 'pos', 'cash', 'MIG_POS_INV-61965869', 134375.00, 'NGN', 'success', NULL, NULL, '2026-04-29 11:26:06', '2026-04-29 11:26:06'),
(31, 88, 'manual', 'pos', 'cash', 'MIG_POS_INV-23018565', 102125.00, 'NGN', 'success', NULL, NULL, '2026-02-26 16:23:39', '2026-02-26 16:23:39'),
(32, 89, 'manual', 'pos', 'cash', 'MIG_POS_INV-44150443', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-16 12:55:50', '2026-04-16 12:55:50'),
(33, 90, 'manual', 'pos', 'cash', 'MIG_POS_INV-41634774', 252625.00, 'NGN', 'success', NULL, NULL, '2026-03-17 10:00:34', '2026-03-17 10:00:34'),
(34, 91, 'manual', 'pos', 'cash', 'MIG_POS_INV-24516857', 215000.00, 'NGN', 'success', NULL, NULL, '2026-03-11 10:21:56', '2026-03-11 10:21:56'),
(35, 92, 'manual', 'pos', 'cash', 'MIG_POS_INV-04538300', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-07 23:28:59', '2026-04-07 23:28:59'),
(36, 93, 'manual', 'pos', 'cash', 'MIG_POS_INV-81861877', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-14 15:51:02', '2026-04-14 15:51:02'),
(37, 94, 'manual', 'pos', 'cash', 'MIG_POS_INV-99176136', 43000.00, 'NGN', 'success', NULL, NULL, '2026-04-27 14:12:56', '2026-04-27 14:12:56'),
(38, 95, 'manual', 'pos', 'cash', 'MIG_POS_INV-08280999', 96750.00, 'NGN', 'success', NULL, NULL, '2026-03-28 14:31:22', '2026-03-28 14:31:22'),
(39, 96, 'manual', 'pos', 'cash', 'MIG_POS_INV-74482840', 1556868.75, 'NGN', 'success', NULL, NULL, '2026-02-22 15:34:43', '2026-02-22 15:34:43'),
(40, 97, 'manual', 'pos', 'cash', 'MIG_POS_INV-63745057', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-30 15:42:25', '2026-04-30 15:42:25'),
(42, 99, 'manual', 'pos', 'cash', 'MIG_POS_INV-30433483', 86000.00, 'NGN', 'success', NULL, NULL, '2026-05-08 08:53:54', '2026-05-08 08:53:54'),
(43, 100, 'manual', 'pos', 'cash', 'MIG_POS_INV-31773273', 270900.00, 'NGN', 'success', NULL, NULL, '2026-05-31 12:49:31', '2026-05-31 12:49:31'),
(44, 101, 'manual', 'pos', 'cash', 'MIG_POS_INV-07466184', 258000.00, 'NGN', 'success', NULL, NULL, '2026-06-03 17:24:26', '2026-06-03 17:24:26'),
(45, 102, 'manual', 'pos', 'cash', 'MIG_POS_INV-41182821', 69875.00, 'NGN', 'success', NULL, NULL, '2026-02-25 17:39:43', '2026-02-25 17:39:43'),
(46, 103, 'manual', 'pos', 'cash', 'MIG_POS_INV-57634727', 995000.00, 'NGN', 'success', NULL, NULL, '2026-06-06 14:53:55', '2026-06-06 14:53:55'),
(47, 104, 'manual', 'pos', 'cash', 'MIG_POS_INV-75047503', 107500.00, 'NGN', 'success', NULL, NULL, '2026-02-28 10:37:27', '2026-02-28 10:37:27'),
(48, 105, 'manual', 'pos', 'cash', 'MIG_POS_INV-23715673', 80625.00, 'NGN', 'success', NULL, NULL, '2026-03-05 15:15:16', '2026-03-05 15:15:16'),
(49, 106, 'manual', 'pos', 'cash', 'MIG_POS_INV-73522791', 193500.00, 'NGN', 'success', NULL, NULL, '2026-04-13 09:45:22', '2026-04-13 09:45:22'),
(50, 107, 'manual', 'pos', 'cash', 'MIG_POS_INV-04286695', 215000.00, 'NGN', 'success', NULL, NULL, '2026-03-14 16:04:47', '2026-03-14 16:04:47'),
(51, 108, 'manual', 'pos', 'cash', 'MIG_POS_INV-48326133', 375000.00, 'NGN', 'success', NULL, NULL, '2026-04-30 11:25:26', '2026-04-30 11:25:26'),
(52, 109, 'manual', 'pos', 'cash', 'MIG_POS_INV-20554722', 168237.50, 'NGN', 'success', NULL, NULL, '2026-05-18 16:09:11', '2026-05-18 16:09:11'),
(53, 110, 'manual', 'pos', 'cash', 'MIG_POS_INV-15515361', 290250.00, 'NGN', 'success', NULL, NULL, '2026-05-25 13:25:13', '2026-05-25 13:25:13'),
(54, 111, 'manual', 'pos', 'cash', 'MIG_POS_INV-73674649', 139750.00, 'NGN', 'success', NULL, NULL, '2026-03-09 16:27:54', '2026-03-09 16:27:54'),
(55, 112, 'manual', 'pos', 'cash', 'MIG_POS_INV-77859696', 408500.00, 'NGN', 'success', NULL, NULL, '2026-03-23 14:57:40', '2026-03-23 14:57:40'),
(56, 113, 'manual', 'pos', 'cash', 'MIG_POS_INV-58094690', 142975.00, 'NGN', 'success', NULL, NULL, '2026-03-09 12:08:15', '2026-03-09 12:08:15'),
(57, 114, 'manual', 'pos', 'cash', 'MIG_POS_INV-73131968', 268750.00, 'NGN', 'success', NULL, NULL, '2026-04-13 09:38:52', '2026-04-13 09:38:52'),
(58, 115, 'manual', 'pos', 'cash', 'MIG_POS_INV-38100973', 456875.00, 'NGN', 'success', NULL, NULL, '2026-02-16 10:35:01', '2026-02-16 10:35:01'),
(59, 116, 'manual', 'pos', 'cash', 'MIG_POS_INV-29277561', 580500.00, 'NGN', 'success', NULL, NULL, '2026-02-24 10:34:37', '2026-02-24 10:34:37'),
(60, 117, 'manual', 'pos', 'cash', 'MIG_POS_INV-43439063', 668810.63, 'NGN', 'success', NULL, NULL, '2026-04-17 16:30:39', '2026-04-17 16:30:39'),
(61, 118, 'manual', 'pos', 'cash', 'MIG_POS_INV-20022178', 21500.00, 'NGN', 'success', NULL, NULL, '2026-03-13 16:40:22', '2026-03-13 16:40:22'),
(62, 119, 'manual', 'pos', 'cash', 'MIG_POS_INV-99195809', 91375.00, 'NGN', 'success', NULL, NULL, '2026-02-19 11:06:35', '2026-02-19 11:06:35'),
(63, 120, 'manual', 'pos', 'cash', 'MIG_POS_INV-84152017', 255420.00, 'NGN', 'success', NULL, NULL, '2026-06-13 20:55:53', '2026-06-13 20:55:53'),
(64, 121, 'manual', 'pos', 'cash', 'MIG_POS_INV-77549274', 338625.00, 'NGN', 'success', NULL, NULL, '2026-03-16 16:12:29', '2026-03-16 16:12:29'),
(65, 122, 'manual', 'pos', 'cash', 'MIG_POS_INV-24379148', 967500.00, 'NGN', 'success', NULL, NULL, '2026-02-11 15:39:36', '2026-02-11 15:39:36'),
(66, 123, 'manual', 'pos', 'cash', 'MIG_POS_INV-71466656', 102125.00, 'NGN', 'success', NULL, NULL, '2026-03-24 16:57:46', '2026-03-24 16:57:46'),
(67, 124, 'manual', 'pos', 'cash', 'MIG_POS_INV-01462152', 193500.00, 'NGN', 'success', NULL, NULL, '2026-03-13 11:31:02', '2026-03-13 11:31:02'),
(68, 125, 'manual', 'pos', 'cash', 'MIG_POS_INV-11608498', 107500.00, 'NGN', 'success', NULL, NULL, '2026-03-13 14:20:08', '2026-03-13 14:20:08'),
(69, 126, 'manual', 'pos', 'cash', 'MIG_POS_INV-86962875', 588750.00, 'NGN', 'success', NULL, NULL, '2026-05-12 11:56:03', '2026-05-12 11:56:03'),
(70, 127, 'manual', 'pos', 'cash', 'MIG_POS_INV-20683070', 103737.50, 'NGN', 'success', NULL, NULL, '2026-05-18 16:11:24', '2026-05-18 16:11:24'),
(71, 128, 'manual', 'pos', 'cash', 'MIG_POS_INV-15531042', 198875.00, 'NGN', 'success', NULL, NULL, '2026-05-25 13:25:28', '2026-05-25 13:25:28'),
(72, 129, 'manual', 'pos', 'cash', 'MIG_POS_INV-78092683', 107500.00, 'NGN', 'success', NULL, NULL, '2026-03-30 13:41:33', '2026-03-30 13:41:33'),
(73, 130, 'manual', 'pos', 'cash', 'MIG_POS_INV-44288609', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-10 18:04:49', '2026-04-10 18:04:49'),
(74, 131, 'manual', 'pos', 'cash', 'MIG_POS_INV-56908102', 212850.00, 'NGN', 'success', NULL, NULL, '2026-04-07 10:15:08', '2026-04-07 10:15:08'),
(75, 132, 'manual', 'pos', 'cash', 'MIG_POS_INV-30801002', 533118.75, 'NGN', 'success', NULL, NULL, '2026-04-10 14:20:01', '2026-04-10 14:20:01'),
(76, 133, 'manual', 'pos', 'cash', 'MIG_POS_INV-11846152', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-25 10:10:46', '2026-04-25 10:10:46'),
(77, 134, 'manual', 'pos', 'cash', 'MIG_POS_INV-10066758', 182750.00, 'NGN', 'success', NULL, NULL, '2026-02-27 16:34:26', '2026-02-27 16:34:26'),
(78, 135, 'manual', 'pos', 'cash', 'MIG_POS_INV-70390929', 182750.00, 'NGN', 'success', NULL, NULL, '2026-02-07 13:19:51', '2026-02-07 13:19:51'),
(79, 136, 'manual', 'pos', 'cash', 'MIG_POS_INV-74799246', 569750.00, 'NGN', 'success', NULL, NULL, '2026-06-11 10:46:39', '2026-06-11 10:46:39'),
(80, 137, 'manual', 'pos', 'cash', 'MIG_POS_INV-98068677', 685500.00, 'NGN', 'success', NULL, NULL, '2026-05-05 16:21:09', '2026-05-05 16:21:09'),
(81, 138, 'manual', 'pos', 'cash', 'MIG_POS_INV-21172690', 861612.50, 'NGN', 'success', NULL, NULL, '2026-05-25 14:59:32', '2026-05-25 14:59:32'),
(82, 139, 'manual', 'pos', 'cash', 'MIG_POS_INV-23273378', 315000.00, 'NGN', 'success', NULL, NULL, '2026-04-24 09:34:33', '2026-04-24 09:34:33'),
(83, 140, 'manual', 'pos', 'cash', 'MIG_POS_INV-99658618', 80625.00, 'NGN', 'success', NULL, NULL, '2026-03-13 11:00:58', '2026-03-13 11:00:58'),
(84, 141, 'manual', 'pos', 'cash', 'MIG_POS_INV-88687520', 161250.00, 'NGN', 'success', NULL, NULL, '2026-06-04 15:58:08', '2026-06-04 15:58:08'),
(85, 142, 'manual', 'pos', 'cash', 'MIG_POS_INV-21803579', 193500.00, 'NGN', 'success', NULL, NULL, '2026-05-02 11:36:44', '2026-05-02 11:36:44'),
(86, 143, 'manual', 'pos', 'cash', 'MIG_POS_INV-77538881', 338625.00, 'NGN', 'success', NULL, NULL, '2026-03-16 16:12:19', '2026-03-16 16:12:19'),
(87, 144, 'manual', 'pos', 'cash', 'MIG_POS_INV-08898795', 48375.00, 'NGN', 'success', NULL, NULL, '2026-03-28 14:41:39', '2026-03-28 14:41:39'),
(88, 145, 'manual', 'pos', 'cash', 'MIG_POS_INV-10131756', 112875.00, 'NGN', 'success', NULL, NULL, '2026-02-12 15:28:50', '2026-02-12 15:28:50'),
(89, 146, 'manual', 'pos', 'cash', 'MIG_POS_INV-12561169', 274125.00, 'NGN', 'success', NULL, NULL, '2026-02-11 12:22:38', '2026-02-11 12:22:38'),
(90, 147, 'manual', 'pos', 'cash', 'MIG_POS_INV-71436674', 193500.00, 'NGN', 'success', NULL, NULL, '2026-02-21 10:57:16', '2026-02-21 10:57:16'),
(91, 148, 'manual', 'pos', 'cash', 'MIG_POS_INV-72720927', 86000.00, 'NGN', 'success', NULL, NULL, '2026-05-30 20:25:21', '2026-05-30 20:25:21'),
(92, 149, 'manual', 'pos', 'cash', 'MIG_POS_INV-80699174', 344000.00, 'NGN', 'success', NULL, NULL, '2026-05-29 18:51:39', '2026-05-29 18:51:39'),
(93, 150, 'manual', 'pos', 'cash', 'MIG_POS_INV-18647562', 212569.88, 'NGN', 'success', NULL, NULL, '2026-06-01 12:57:27', '2026-06-01 12:57:27'),
(94, 151, 'manual', 'pos', 'cash', 'MIG_POS_INV-44243287', 505250.00, 'NGN', 'success', NULL, NULL, '2026-02-17 16:04:01', '2026-02-17 16:04:01'),
(95, 152, 'manual', 'pos', 'cash', 'MIG_POS_INV-11069658', 782868.75, 'NGN', 'success', NULL, NULL, '2026-06-08 09:31:09', '2026-06-08 09:31:09'),
(96, 153, 'manual', 'pos', 'cash', 'MIG_POS_INV-22741319', 252625.00, 'NGN', 'success', NULL, NULL, '2026-03-19 12:19:01', '2026-03-19 12:19:01'),
(97, 154, 'manual', 'pos', 'cash', 'MIG_POS_INV-23580186', 80625.00, 'NGN', 'success', NULL, NULL, '2026-03-05 15:13:00', '2026-03-05 15:13:00'),
(98, 155, 'manual', 'pos', 'cash', 'MIG_POS_INV-31609016', 344000.00, 'NGN', 'success', NULL, NULL, '2026-05-31 12:46:50', '2026-05-31 12:46:50'),
(99, 156, 'manual', 'pos', 'cash', 'MIG_POS_INV-15561411', 118250.00, 'NGN', 'success', NULL, NULL, '2026-05-25 13:25:59', '2026-05-25 13:25:59'),
(100, 157, 'manual', 'pos', 'cash', 'MIG_POS_INV-50961985', 37625.00, 'NGN', 'success', NULL, NULL, '2026-04-16 14:49:23', '2026-04-16 14:49:23'),
(101, 158, 'manual', 'pos', 'cash', 'MIG_POS_INV-34266300', 322500.00, 'NGN', 'success', NULL, NULL, '2026-05-09 13:44:27', '2026-05-09 13:44:27'),
(102, 159, 'manual', 'pos', 'cash', 'MIG_POS_INV-47171949', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-16 13:46:12', '2026-04-16 13:46:12'),
(103, 160, 'manual', 'pos', 'cash', 'MIG_POS_INV-51850529', 37625.00, 'NGN', 'success', NULL, NULL, '2026-03-17 12:50:50', '2026-03-17 12:50:50'),
(104, 161, 'manual', 'pos', 'cash', 'MIG_POS_INV-01492487', 204250.00, 'NGN', 'success', NULL, NULL, '2026-03-13 11:31:32', '2026-03-13 11:31:32'),
(105, 162, 'manual', 'pos', 'cash', 'MIG_POS_INV-67745669', 376250.00, 'NGN', 'success', NULL, NULL, '2026-02-13 07:29:03', '2026-02-13 07:29:03'),
(106, 163, 'manual', 'pos', 'cash', 'MIG_POS_INV-10948045', 962125.00, 'NGN', 'success', NULL, NULL, '2026-02-12 15:42:26', '2026-02-12 15:42:26'),
(107, 164, 'manual', 'pos', 'cash', 'MIG_POS_INV-48940526', 340000.00, 'NGN', 'success', NULL, NULL, '2026-04-30 11:35:40', '2026-04-30 11:35:40'),
(108, 165, 'manual', 'pos', 'cash', 'MIG_POS_INV-70438187', 290250.00, 'NGN', 'success', NULL, NULL, '2026-04-13 08:53:58', '2026-04-13 08:53:58'),
(109, 166, 'manual', 'pos', 'cash', 'MIG_POS_INV-35797149', 102125.00, 'NGN', 'success', NULL, NULL, '2026-04-09 11:56:37', '2026-04-09 11:56:37'),
(110, 167, 'manual', 'pos', 'cash', 'MIG_POS_INV-83004067', 274125.00, 'NGN', 'success', NULL, NULL, '2026-02-06 13:03:24', '2026-02-06 13:03:24'),
(111, 168, 'manual', 'pos', 'cash', 'MIG_POS_INV-21171026', 861612.50, 'NGN', 'success', NULL, NULL, '2026-05-25 14:59:31', '2026-05-25 14:59:31'),
(112, 169, 'manual', 'pos', 'cash', 'MIG_POS_INV-96044147', 26875.00, 'NGN', 'success', NULL, NULL, '2026-05-05 15:47:24', '2026-05-05 15:47:24'),
(113, 170, 'manual', 'pos', 'cash', 'MIG_POS_INV-23290257', 48375.00, 'NGN', 'success', NULL, NULL, '2026-02-27 20:14:50', '2026-02-27 20:14:50'),
(114, 171, 'manual', 'pos', 'cash', 'MIG_POS_INV-29259588', 580500.00, 'NGN', 'success', NULL, NULL, '2026-02-24 10:34:19', '2026-02-24 10:34:19'),
(115, 172, 'manual', 'pos', 'cash', 'MIG_POS_INV-72646228', 161250.00, 'NGN', 'success', NULL, NULL, '2026-04-27 06:50:48', '2026-04-27 06:50:48'),
(116, 173, 'manual', 'pos', 'cash', 'MIG_POS_INV-01039318', 1515750.00, 'NGN', 'success', NULL, NULL, '2026-03-28 12:30:39', '2026-03-28 12:30:39'),
(117, 174, 'manual', 'pos', 'cash', 'MIG_POS_INV-57533518', 204250.00, 'NGN', 'success', NULL, NULL, '2026-04-01 15:32:14', '2026-04-01 15:32:14'),
(118, 175, 'manual', 'pos', 'cash', 'MIG_POS_INV-56868008', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-07 10:14:28', '2026-04-07 10:14:28'),
(119, 176, 'manual', 'pos', 'cash', 'MIG_POS_INV-38901611', 172698.75, 'NGN', 'success', NULL, NULL, '2026-06-08 17:15:01', '2026-06-08 17:15:01'),
(120, 177, 'manual', 'pos', 'cash', 'MIG_POS_INV-72893144', 306375.00, 'NGN', 'success', NULL, NULL, '2026-03-08 12:28:13', '2026-03-08 12:28:13'),
(121, 178, 'manual', 'pos', 'cash', 'MIG_POS_INV-63343317', 45000.00, 'NGN', 'success', NULL, NULL, '2026-06-04 08:55:43', '2026-06-04 08:55:43'),
(122, 179, 'manual', 'pos', 'cash', 'MIG_POS_INV-65296673', 215000.00, 'NGN', 'success', NULL, NULL, '2026-04-29 12:21:36', '2026-04-29 12:21:36'),
(123, 180, 'manual', 'pos', 'cash', 'MIG_POS_INV-22091018', 731000.00, 'NGN', 'success', NULL, NULL, '2026-02-25 12:21:31', '2026-02-25 12:21:31'),
(124, 181, 'manual', 'pos', 'cash', 'MIG_POS_INV-43584349', 193500.00, 'NGN', 'success', NULL, NULL, '2026-04-08 10:19:44', '2026-04-08 10:19:44'),
(125, 182, 'manual', 'pos', 'cash', 'MIG_POS_INV-99158471', 193500.00, 'NGN', 'success', NULL, NULL, '2026-02-05 13:45:58', '2026-02-05 13:45:58'),
(126, 183, 'manual', 'pos', 'cash', 'MIG_POS_INV-45522918', 430000.00, 'NGN', 'success', NULL, NULL, '2026-05-29 09:05:23', '2026-05-29 09:05:23'),
(127, 184, 'manual', 'pos', 'cash', 'MIG_POS_INV-25741854', 702243.75, 'NGN', 'success', NULL, NULL, '2026-02-25 13:22:22', '2026-02-25 13:22:22'),
(128, 185, 'manual', 'pos', 'cash', 'MIG_POS_INV-35741641', 172000.00, 'NGN', 'success', NULL, NULL, '2026-06-15 15:02:22', '2026-06-15 15:02:22'),
(129, 186, 'manual', 'pos', 'cash', 'MIG_POS_INV-93174880', 218225.00, 'NGN', 'success', NULL, NULL, '2026-02-21 16:59:35', '2026-02-21 16:59:35'),
(130, 187, 'manual', 'pos', 'cash', 'MIG_POS_INV-56846259', 354750.00, 'NGN', 'success', NULL, NULL, '2026-04-29 10:00:46', '2026-04-29 10:00:46'),
(131, 188, 'manual', 'pos', 'cash', 'MIG_POS_INV-80375348', 365500.00, 'NGN', 'success', NULL, NULL, '2026-03-02 19:39:35', '2026-03-02 19:39:35'),
(132, 189, 'manual', 'pos', 'cash', 'MIG_POS_INV-97319536', 365500.00, 'NGN', 'success', NULL, NULL, '2026-02-04 09:28:39', '2026-02-04 09:28:39'),
(133, 190, 'manual', 'pos', 'cash', 'MIG_POS_INV-28525102', 274125.00, 'NGN', 'success', NULL, NULL, '2026-04-25 14:48:45', '2026-04-25 14:48:45'),
(134, 191, 'manual', 'pos', 'cash', 'MIG_POS_INV-91374043', 139750.00, 'NGN', 'success', NULL, NULL, '2026-05-13 16:56:15', '2026-05-13 16:56:15'),
(135, 192, 'manual', 'pos', 'cash', 'MIG_POS_INV-21833347', 37625.00, 'NGN', 'success', NULL, NULL, '2026-03-27 14:30:34', '2026-03-27 14:30:34'),
(136, 193, 'manual', 'pos', 'cash', 'MIG_POS_INV-43503292', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-08 10:18:23', '2026-04-08 10:18:23'),
(137, 194, 'manual', 'pos', 'cash', 'MIG_POS_INV-77463219', 1083250.00, 'NGN', 'success', NULL, NULL, '2026-05-06 14:24:24', '2026-05-06 14:24:24'),
(138, 195, 'manual', 'pos', 'cash', 'MIG_POS_INV-09631928', 80625.00, 'NGN', 'success', NULL, NULL, '2026-05-04 15:47:12', '2026-05-04 15:47:12'),
(139, 196, 'manual', 'pos', 'cash', 'MIG_POS_INV-99764241', 540000.00, 'NGN', 'success', NULL, NULL, '2026-02-05 13:56:03', '2026-02-05 13:56:03'),
(140, 197, 'manual', 'pos', 'cash', 'MIG_POS_INV-03862094', 483750.00, 'NGN', 'success', NULL, NULL, '2026-05-19 15:17:43', '2026-05-19 15:17:43'),
(141, 198, 'manual', 'pos', 'cash', 'MIG_POS_INV-47190584', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-23 12:26:31', '2026-04-23 12:26:31'),
(142, 199, 'manual', 'pos', 'cash', 'MIG_POS_INV-07776252', 193500.00, 'NGN', 'success', NULL, NULL, '2026-02-19 13:29:36', '2026-02-19 13:29:36'),
(143, 200, 'manual', 'pos', 'cash', 'MIG_POS_INV-84566051', 395250.00, 'NGN', 'success', NULL, NULL, '2026-04-14 16:36:06', '2026-04-14 16:36:06'),
(144, 201, 'manual', 'pos', 'cash', 'MIG_POS_INV-90028131', 430000.00, 'NGN', 'success', NULL, NULL, '2026-06-03 12:33:48', '2026-06-03 12:33:48'),
(145, 202, 'manual', 'pos', 'cash', 'MIG_POS_INV-84154920', 172000.00, 'NGN', 'success', NULL, NULL, '2026-06-04 14:42:35', '2026-06-04 14:42:35'),
(146, 203, 'manual', 'pos', 'cash', 'MIG_POS_INV-06306302', 102125.00, 'NGN', 'success', NULL, NULL, '2026-02-18 09:18:26', '2026-02-18 09:18:26'),
(147, 204, 'manual', 'pos', 'cash', 'MIG_POS_INV-94511766', 204250.00, 'NGN', 'success', NULL, NULL, '2026-03-06 10:55:12', '2026-03-06 10:55:12'),
(148, 205, 'manual', 'pos', 'cash', 'MIG_POS_INV-73147976', 322500.00, 'NGN', 'success', NULL, NULL, '2026-03-29 08:32:29', '2026-03-29 08:32:29'),
(149, 206, 'manual', 'pos', 'cash', 'MIG_POS_INV-33579879', 1042750.00, 'NGN', 'success', NULL, NULL, '2026-04-09 11:19:40', '2026-04-09 11:19:40'),
(150, 207, 'manual', 'pos', 'cash', 'MIG_POS_INV-79888134', 430000.00, 'NGN', 'success', NULL, NULL, '2026-06-13 19:44:48', '2026-06-13 19:44:48'),
(151, 208, 'manual', 'pos', 'cash', 'MIG_POS_INV-97683016', 86000.00, 'NGN', 'success', NULL, NULL, '2026-05-12 14:54:44', '2026-05-12 14:54:44'),
(152, 209, 'manual', 'pos', 'cash', 'MIG_POS_INV-71719067', 182750.00, 'NGN', 'success', NULL, NULL, '2026-02-08 17:28:39', '2026-02-08 17:28:39'),
(153, 210, 'manual', 'pos', 'cash', 'MIG_POS_INV-20030232', 21500.00, 'NGN', 'success', NULL, NULL, '2026-03-13 16:40:30', '2026-03-13 16:40:30'),
(154, 211, 'manual', 'pos', 'cash', 'MIG_POS_INV-08180050', 5380.38, 'NGN', 'success', NULL, NULL, '2026-02-19 13:36:20', '2026-02-19 13:36:20'),
(155, 212, 'manual', 'pos', 'cash', 'MIG_POS_INV-76103512', 274125.00, 'NGN', 'success', NULL, NULL, '2026-02-13 09:48:22', '2026-02-13 09:48:22'),
(156, 213, 'manual', 'pos', 'cash', 'MIG_POS_INV-58903708', 86000.00, 'NGN', 'success', NULL, NULL, '2026-05-14 11:41:43', '2026-05-14 11:41:43'),
(157, 214, 'manual', 'pos', 'cash', 'MIG_POS_INV-41069743', 102125.00, 'NGN', 'success', NULL, NULL, '2026-03-04 16:17:50', '2026-03-04 16:17:50'),
(158, 215, 'manual', 'pos', 'cash', 'MIG_POS_INV-98194058', 193500.00, 'NGN', 'success', NULL, NULL, '2026-03-14 14:23:14', '2026-03-14 14:23:14'),
(159, 216, 'manual', 'pos', 'cash', 'MIG_POS_INV-64474204', 1240550.00, 'NGN', 'success', NULL, NULL, '2026-02-23 16:34:34', '2026-02-23 16:34:34'),
(160, 217, 'manual', 'pos', 'cash', 'MIG_POS_INV-26696979', 193500.00, 'NGN', 'success', NULL, NULL, '2026-04-08 05:38:17', '2026-04-08 05:38:17'),
(161, 218, 'manual', 'pos', 'cash', 'MIG_POS_INV-85031898', 315000.00, 'NGN', 'success', NULL, NULL, '2026-04-28 14:03:52', '2026-04-28 14:03:52'),
(162, 219, 'manual', 'pos', 'cash', 'MIG_POS_INV-69688269', 1279250.00, 'NGN', 'success', NULL, NULL, '2026-02-08 16:54:49', '2026-02-08 16:54:49'),
(163, 220, 'manual', 'pos', 'cash', 'MIG_POS_INV-10636022', 483750.00, 'NGN', 'success', NULL, NULL, '2026-03-30 22:43:56', '2026-03-30 22:43:56'),
(164, 221, 'manual', 'pos', 'cash', 'MIG_POS_INV-56720496', 430000.00, 'NGN', 'success', NULL, NULL, '2026-04-15 12:38:41', '2026-04-15 12:38:41'),
(165, 222, 'manual', 'pos', 'cash', 'MIG_POS_INV-94581924', 109112.50, 'NGN', 'success', NULL, NULL, '2026-03-06 10:56:22', '2026-03-06 10:56:22'),
(166, 223, 'manual', 'pos', 'cash', 'MIG_POS_INV-90951578', 96750.00, 'NGN', 'success', NULL, NULL, '2026-04-21 17:02:32', '2026-04-21 17:02:32'),
(167, 224, 'manual', 'pos', 'cash', 'MIG_POS_INV-53621115', 182750.00, 'NGN', 'success', NULL, NULL, '2026-02-16 14:53:41', '2026-02-16 14:53:41'),
(168, 225, 'manual', 'pos', 'cash', 'MIG_POS_INV-36476830', 655750.00, 'NGN', 'success', NULL, NULL, '2026-05-31 14:07:57', '2026-05-31 14:07:57'),
(272, 329, 'internal', 'cash', 'cash', 'YT-POS-YT20260620832AB9-C27A67', 258000.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-20 13:21:09', '2026-06-20 13:21:09'),
(273, 330, 'internal', 'cash', 'cash', 'YT-POS-YT202606256A864E-EA2AC6', 172000.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-25 11:18:16', '2026-06-25 11:18:16'),
(274, 331, 'internal', 'cash', 'cash', 'YT-POS-YT20260626E1C082-A745A8', 288100.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-26 14:44:27', '2026-06-26 14:44:27'),
(275, 332, 'internal', 'cash', 'cash', 'YT-POS-YT20260627E5F6BF-5AA0DC', 172000.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-27 10:43:50', '2026-06-27 10:43:50'),
(276, 333, 'internal', 'cash', 'cash', 'YT-POS-YT202606277E411A-EDBBB4', 13975.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-27 12:33:24', '2026-06-27 12:33:24'),
(277, 334, 'internal', 'cash', 'cash', 'YT-POS-YT20260628504CB3-2F78EC', 86000.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-28 11:21:06', '2026-06-28 11:21:06'),
(278, 335, 'internal', 'cash', 'cash', 'YT-POS-YT20260629467DDB-26F4CF', 86000.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-29 08:13:15', '2026-06-29 08:13:15'),
(279, 336, 'internal', 'cash', 'cash', 'YT-POS-YT20260630604D2C-076C55', 86000.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-30 11:34:13', '2026-06-30 11:34:13'),
(280, 337, 'internal', 'cash', 'cash', 'YT-POS-YT20260630B2F606-DE1E78', 344000.00, 'NGN', 'success', NULL, 'POS sale', '2026-06-30 11:34:40', '2026-06-30 11:34:40'),
(281, 338, 'paystack', 'bank_transfer', 'paystack', 'YT-PAY-YT20260630DD0B27-E437A8A6', 1316875.00, 'NGN', 'success', NULL, 'Approved', '2026-06-30 12:57:27', '2026-06-30 12:56:49'),
(282, 339, 'paystack', 'bank_transfer', 'paystack', 'YT-PAY-YT202606306E6B86-3A0A47DB', 197000.00, 'NGN', 'success', NULL, 'Approved', '2026-06-30 16:40:33', '2026-06-30 16:40:23'),
(283, 340, 'internal', 'cash', 'cash', 'YT-POS-YT20260701C50FDA-4155EF', 102125.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-01 16:44:03', '2026-07-01 16:44:03'),
(284, 341, 'internal', 'cash', 'cash', 'YT-POS-YT20260702CE7F92-94211E', 204250.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-02 11:29:23', '2026-07-02 11:29:23'),
(285, 342, 'internal', 'cash', 'cash', 'YT-POS-YT2026070362B898-385384', 129000.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-03 11:35:30', '2026-07-03 11:35:30'),
(286, 343, 'internal', 'bank_transfer', 'bank_transfer', 'YT-POS-YT20260703A3173A-311FD9', 86000.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-03 16:23:04', '2026-07-03 16:23:04'),
(287, 344, 'internal', 'bank_transfer', 'bank_transfer', 'YT-POS-YT2026070339E29C-B052AB', 86000.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-03 17:14:30', '2026-07-03 17:14:30'),
(289, 346, 'internal', 'cash', 'cash', 'YT-POS-YT20260707B095E6-3CCBA5', 86000.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-07 14:03:48', '2026-07-07 14:03:48'),
(290, 347, 'internal', 'other', 'other', 'YT-POS-YT202607072F49F6-986346', 86000.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-07 14:04:31', '2026-07-07 14:04:31'),
(291, 348, 'internal', 'bank_transfer', 'bank_transfer', 'YT-POS-YT202607079D8A27-ED8703', 1462000.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-07 14:05:32', '2026-07-07 14:05:32'),
(292, 349, 'internal', 'other', 'other', 'YT-POS-YT2026070797F335-40511A', 344000.00, 'NGN', 'success', NULL, 'POS sale', '2026-07-07 14:07:03', '2026-07-07 14:07:03');

-- --------------------------------------------------------

--
-- Table structure for table `payment_events`
--

CREATE TABLE `payment_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `reference` varchar(120) NOT NULL,
  `event_type` varchar(64) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_events`
--

INSERT INTO `payment_events` (`id`, `payment_id`, `reference`, `event_type`, `payload`, `created_at`) VALUES
(43, 272, 'YT-POS-YT20260620832AB9-C27A67', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-20 13:21:09'),
(44, 273, 'YT-POS-YT202606256A864E-EA2AC6', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-25 11:18:16'),
(45, 274, 'YT-POS-YT20260626E1C082-A745A8', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-26 14:44:27'),
(46, 275, 'YT-POS-YT20260627E5F6BF-5AA0DC', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-27 10:43:50'),
(47, 276, 'YT-POS-YT202606277E411A-EDBBB4', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-27 12:33:24'),
(48, 277, 'YT-POS-YT20260628504CB3-2F78EC', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-28 11:21:06'),
(49, 278, 'YT-POS-YT20260629467DDB-26F4CF', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-29 08:13:15'),
(50, 279, 'YT-POS-YT20260630604D2C-076C55', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-30 11:34:13'),
(51, 280, 'YT-POS-YT20260630B2F606-DE1E78', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-06-30 11:34:40'),
(52, 281, 'YT-PAY-YT20260630DD0B27-E437A8A6', 'initialized', '{\"reference\":\"YT-PAY-YT20260630DD0B27-E437A8A6\",\"authorization_url\":\"https:\\/\\/checkout.paystack.com\\/dsvblcs5qwk5d6b\",\"access_code\":\"dsvblcs5qwk5d6b\"}', '2026-06-30 12:56:49'),
(53, 281, 'YT-PAY-YT20260630DD0B27-E437A8A6', 'verify.verify', '{\"status\":\"success\",\"amount\":1316875,\"channel\":\"bank_transfer\",\"paid_at\":\"2026-06-30T12:57:27.000Z\",\"gateway_response\":\"Approved\",\"currency\":\"NGN\",\"reference\":\"YT-PAY-YT20260630DD0B27-E437A8A6\",\"raw\":{\"id\":6313039931,\"domain\":\"test\",\"status\":\"success\",\"reference\":\"YT-PAY-YT20260630DD0B27-E437A8A6\",\"receipt_number\":null,\"amount\":131687500,\"message\":null,\"gateway_response\":\"Approved\",\"paid_at\":\"2026-06-30T12:57:27.000Z\",\"created_at\":\"2026-06-30T12:56:49.000Z\",\"channel\":\"bank_transfer\",\"currency\":\"NGN\",\"ip_address\":\"98.97.76.64\",\"metadata\":{\"order_number\":\"YT-20260630-DD0B27\",\"order_id\":\"338\",\"referrer\":\"https:\\/\\/shop.y.yarotech.com.ng\\/\"},\"log\":{\"start_time\":1782824232,\"time_spent\":49,\"attempts\":2,\"errors\":1,\"success\":true,\"mobile\":false,\"input\":[],\"history\":[{\"type\":\"action\",\"message\":\"Attempted to pay with card\",\"time\":5},{\"type\":\"error\",\"message\":\"Error: Insufficient Funds\",\"time\":9},{\"type\":\"action\",\"message\":\"Set payment method to: bank_transfer\",\"time\":11},{\"type\":\"success\",\"message\":\"Successfully paid with bank_transfer\",\"time\":16},{\"type\":\"action\",\"message\":\"Set payment method to: card\",\"time\":47},{\"type\":\"action\",\"message\":\"Attempted to pay with card\",\"time\":49},{\"type\":\"success\",\"message\":\"Successfully paid with card\",\"time\":50}]},\"fees\":200000,\"fees_split\":null,\"authorization\":{\"authorization_code\":\"AUTH_47qxl8jul6\",\"bin\":\"123XXX\",\"last4\":\"X890\",\"exp_month\":\"06\",\"exp_year\":\"2026\",\"channel\":\"bank_transfer\",\"card_type\":\"transfer\",\"bank\":null,\"country_code\":\"NG\",\"brand\":\"Managed Account\",\"reusable\":false,\"signature\":null,\"account_name\":null,\"sender_bank\":null,\"sender_country\":\"NG\",\"sender_bank_account_number\":\"XXXXXXX890\",\"sender_name\":\"TEST PAYER\",\"narration\":\"Test transaction\",\"receiver_bank_account_number\":null,\"receiver_bank\":null},\"customer\":{\"id\":379549821,\"first_name\":null,\"last_name\":null,\"email\":\"yarotechnetworklimited@gmail.com\",\"customer_code\":\"CUS_om8wkthxp1byn7f\",\"phone\":null,\"metadata\":null,\"risk_action\":\"default\",\"international_format_phone\":null},\"plan\":null,\"split\":[],\"order_id\":null,\"paidAt\":\"2026-06-30T12:57:27.000Z\",\"createdAt\":\"2026-06-30T12:56:49.000Z\",\"requested_amount\":131687500,\"pos_transaction_data\":null,\"source\":null,\"fees_breakdown\":null,\"connect\":null,\"transaction_date\":\"2026-06-30T12:56:49.000Z\",\"plan_object\":[],\"subaccount\":[]}}', '2026-06-30 12:58:10'),
(54, 281, 'YT-PAY-YT20260630DD0B27-E437A8A6', 'emails.sent', '{\"to\":\"yarotechnetworklimited@gmail.com\"}', '2026-06-30 12:58:14'),
(55, 282, 'YT-PAY-YT202606306E6B86-3A0A47DB', 'initialized', '{\"reference\":\"YT-PAY-YT202606306E6B86-3A0A47DB\",\"authorization_url\":\"https:\\/\\/checkout.paystack.com\\/zje9d924reb4sba\",\"access_code\":\"zje9d924reb4sba\"}', '2026-06-30 16:40:23'),
(56, 282, 'YT-PAY-YT202606306E6B86-3A0A47DB', 'verify.verify', '{\"status\":\"success\",\"amount\":197000,\"channel\":\"bank_transfer\",\"paid_at\":\"2026-06-30T16:40:33.000Z\",\"gateway_response\":\"Approved\",\"currency\":\"NGN\",\"reference\":\"YT-PAY-YT202606306E6B86-3A0A47DB\",\"raw\":{\"id\":6313520793,\"domain\":\"test\",\"status\":\"success\",\"reference\":\"YT-PAY-YT202606306E6B86-3A0A47DB\",\"receipt_number\":null,\"amount\":19700000,\"message\":null,\"gateway_response\":\"Approved\",\"paid_at\":\"2026-06-30T16:40:33.000Z\",\"created_at\":\"2026-06-30T16:40:23.000Z\",\"channel\":\"bank_transfer\",\"currency\":\"NGN\",\"ip_address\":\"98.97.76.64\",\"metadata\":{\"order_number\":\"YT-20260630-6E6B86\",\"order_id\":\"339\",\"referrer\":\"https:\\/\\/shop.y.yarotech.com.ng\\/\"},\"log\":{\"start_time\":1782837627,\"time_spent\":35,\"attempts\":1,\"errors\":0,\"success\":true,\"mobile\":true,\"input\":[],\"history\":[{\"type\":\"action\",\"message\":\"Set payment method to: bank_transfer\",\"time\":2},{\"type\":\"success\",\"message\":\"Successfully paid with bank_transfer\",\"time\":7},{\"type\":\"action\",\"message\":\"Set payment method to: null\",\"time\":32},{\"type\":\"action\",\"message\":\"Set payment method to: card\",\"time\":33},{\"type\":\"action\",\"message\":\"Attempted to pay with card\",\"time\":34},{\"type\":\"success\",\"message\":\"Successfully paid with card\",\"time\":35}]},\"fees\":200000,\"fees_split\":null,\"authorization\":{\"authorization_code\":\"AUTH_ri7o3xsv0p\",\"bin\":\"123XXX\",\"last4\":\"X890\",\"exp_month\":\"06\",\"exp_year\":\"2026\",\"channel\":\"bank_transfer\",\"card_type\":\"transfer\",\"bank\":null,\"country_code\":\"NG\",\"brand\":\"Managed Account\",\"reusable\":false,\"signature\":null,\"account_name\":null,\"sender_bank\":null,\"sender_country\":\"NG\",\"sender_bank_account_number\":\"XXXXXXX890\",\"sender_name\":\"TEST PAYER\",\"narration\":\"Test transaction\",\"receiver_bank_account_number\":null,\"receiver_bank\":null},\"customer\":{\"id\":370356871,\"first_name\":null,\"last_name\":null,\"email\":\"saeeduthmanabdullahi@gmail.com\",\"customer_code\":\"CUS_xgtj4wneu0f0eru\",\"phone\":null,\"metadata\":null,\"risk_action\":\"default\",\"international_format_phone\":null},\"plan\":null,\"split\":[],\"order_id\":null,\"paidAt\":\"2026-06-30T16:40:33.000Z\",\"createdAt\":\"2026-06-30T16:40:23.000Z\",\"requested_amount\":19700000,\"pos_transaction_data\":null,\"source\":null,\"fees_breakdown\":null,\"connect\":null,\"transaction_date\":\"2026-06-30T16:40:23.000Z\",\"plan_object\":[],\"subaccount\":[]}}', '2026-06-30 16:41:04'),
(57, 282, 'YT-PAY-YT202606306E6B86-3A0A47DB', 'emails.sent', '{\"to\":\"saeeduthmanabdullahi@gmail.com\"}', '2026-06-30 16:41:05'),
(58, 283, 'YT-POS-YT20260701C50FDA-4155EF', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-07-01 16:44:03'),
(59, 284, 'YT-POS-YT20260702CE7F92-94211E', 'pos_sale_created', '{\"created_by\":\"staff\",\"payment_method\":\"cash\"}', '2026-07-02 11:29:23'),
(60, 285, 'YT-POS-YT2026070362B898-385384', 'pos_sale_created', '{\"created_by\":\"admin\",\"payment_method\":\"cash\"}', '2026-07-03 11:35:30'),
(61, 286, 'YT-POS-YT20260703A3173A-311FD9', 'pos_sale_created', '{\"created_by\":\"admin\",\"payment_method\":\"bank_transfer\"}', '2026-07-03 16:23:04'),
(62, 287, 'YT-POS-YT2026070339E29C-B052AB', 'pos_sale_created', '{\"created_by\":\"admin\",\"payment_method\":\"bank_transfer\"}', '2026-07-03 17:14:30'),
(64, 289, 'YT-POS-YT20260707B095E6-3CCBA5', 'pos_sale_created', '{\"created_by\":\"admin\",\"payment_method\":\"cash\"}', '2026-07-07 14:03:48'),
(65, 290, 'YT-POS-YT202607072F49F6-986346', 'pos_sale_created', '{\"created_by\":\"admin\",\"payment_method\":\"other\"}', '2026-07-07 14:04:31'),
(66, 291, 'YT-POS-YT202607079D8A27-ED8703', 'pos_sale_created', '{\"created_by\":\"admin\",\"payment_method\":\"bank_transfer\"}', '2026-07-07 14:05:32'),
(67, 292, 'YT-POS-YT2026070797F335-40511A', 'pos_sale_created', '{\"created_by\":\"admin\",\"payment_method\":\"other\"}', '2026-07-07 14:07:03');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` varchar(64) NOT NULL,
  `name` varchar(190) NOT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `category` varchar(100) NOT NULL DEFAULT 'Uncategorized',
  `slug` varchar(190) NOT NULL,
  `short_description` text DEFAULT NULL,
  `full_description` longtext DEFAULT NULL,
  `cost_price` decimal(14,2) NOT NULL DEFAULT 0.00,
  `selling_price` decimal(14,2) NOT NULL DEFAULT 0.00,
  `stock_quantity` int(11) NOT NULL DEFAULT 0,
  `minimum_stock` int(11) NOT NULL DEFAULT 5,
  `warranty_info` varchar(255) DEFAULT NULL,
  `is_visible_online` tinyint(1) NOT NULL DEFAULT 1,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('active','inactive','archived') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `vat_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `max_markup` decimal(14,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `sku`, `category`, `slug`, `short_description`, `full_description`, `cost_price`, `selling_price`, `stock_quantity`, `minimum_stock`, `warranty_info`, `is_visible_online`, `is_featured`, `status`, `created_at`, `updated_at`, `vat_enabled`, `max_markup`) VALUES
('PRD-001', 'CAT6 OUTDOOR', 'SKU-CAT6-OUTDOOR', 'Other', 'cat6-outdoor', NULL, NULL, 85000.00, 105000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 08:58:58', '2026-06-16 14:09:42', 0, 0.00),
('PRD-002', 'Inverter Haisic 1.5kva', 'SKU-INVERTER-HAISIC-15KVA', 'Other', 'inverter-haisic-15kva', NULL, NULL, 175000.00, 200000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-25 16:37:11', '2026-06-16 14:09:42', 0, 0.00),
('PRD-003', 't AR730, 2*GE combo WAN, 1*10GE(SFP+) WAN, 8*GE LAN, 1*GE comb', 'SKU-T-AR730-2GE-COMBO-WAN-110GESFP', 'Other', 't-ar730-2ge-combo-wan-110gesfp-wan-8ge-lan-1ge-comb', NULL, NULL, 543600.00, 899999.00, 2, 5, NULL, 1, 0, 'active', '2026-04-14 16:50:04', '2026-06-16 14:09:42', 1, 0.00),
('PRD-004', 'Tiandy NVR 32chl', 'SKU-TIANDY-NVR-32CHL', 'Other', 'tiandy-nvr-32chl', NULL, NULL, 155000.00, 180000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 08:41:30', '2026-06-16 14:09:42', 1, 0.00),
('PRD-005', 'Lutian 1kwh battery all in one', 'SKU-LUTIAN-1KWH-BATTERY-ALL-IN-ONE', 'Other', 'lutian-1kwh-battery-all-in-one', NULL, NULL, 320000.00, 340000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-25 22:00:13', '2026-06-16 14:09:42', 0, 0.00),
('PRD-006', 'Inverter Must 6kva', 'SKU-INVERTER-MUST-6KVA', 'Other', 'inverter-must-6kva', '', '', 327600.00, 400000.00, 1, 5, '', 1, 0, 'active', '2026-02-25 16:38:24', '2026-06-22 14:41:12', 0, 0.00),
('PRD-007', 'FIRE EXTINGUISHER BALL', 'SKU-FIRE-EXTINGUISHER-BALL', 'Other', 'fire-extinguisher-ball', NULL, NULL, 22000.00, 30000.00, 4, 5, NULL, 1, 0, 'active', '2026-02-24 13:24:38', '2026-06-16 14:09:42', 1, 0.00),
('PRD-008', 'cat6 20meter', 'SKU-CAT6-20METER', 'Other', 'cat6-20meter', NULL, NULL, 4700.00, 10000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-14 16:43:53', '2026-06-16 14:09:42', 1, 0.00),
('PRD-009', 'Tiandy POE switch 4ports', 'SKU-TIANDY-POE-SWITCH-4PORTS', 'Other', 'tiandy-poe-switch-4ports', NULL, NULL, 28000.00, 45000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-23 16:22:37', '2026-06-16 14:09:42', 0, 0.00),
('PRD-010', 'MUST battery 1kwh all in one', 'SKU-MUST-BATTERY-1KWH-ALL-IN-ONE', 'Other', 'must-battery-1kwh-all-in-one', NULL, NULL, 360200.00, 375000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-26 09:22:27', '2026-06-16 14:09:42', 0, 0.00),
('PRD-011', 'Circuit Breaker DC 100A', 'SKU-CIRCUIT-BREAKER-DC-100A', 'Other', 'circuit-breaker-dc-100a', NULL, NULL, 7500.00, 11000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-24 16:07:28', '2026-06-16 14:09:42', 0, 0.00),
('PRD-012', 'RJ45', 'SKU-RJ45', 'Other', 'rj45', NULL, NULL, 50.00, 65.00, 1457, 5, NULL, 1, 0, 'active', '2026-02-04 06:45:50', '2026-06-16 14:09:42', 1, 0.00),
('PRD-013', 'Tiandy ip camera 4MP Outdoor', 'SKU-TIANDY-IP-CAMERA-4MP-OUTDOOR', 'Other', 'tiandy-ip-camera-4mp-outdoor', '', '', 33000.00, 40000.00, 0, 5, '12 month manufacturer warranty', 1, 1, 'active', '2026-02-11 23:33:40', '2026-06-30 13:49:25', 1, 0.00),
('PRD-014', 'Litebeam 5AC', 'SKU-LITEBEAM-5AC', 'Hardware', 'litebeam-5ac', NULL, NULL, 120000.00, 150000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:34:29', '2026-06-16 14:09:42', 1, 200000.00),
('PRD-015', 'MEDIA-CONVERTER RJ45-FIBER', 'SKU-MEDIA-CONVERTER-RJ45-FIBER', 'Hardware', 'media-converter-rj45-fiber', NULL, NULL, 28000.00, 35000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-04 06:44:00', '2026-06-16 14:09:42', 1, 0.00),
('PRD-016', 'HDD 500GB', 'SKU-HDD-500GB', 'Hardware', 'hdd-500gb', NULL, NULL, 12000.00, 14000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-04 08:48:55', '2026-06-16 14:09:42', 1, 0.00),
('PRD-017', 'TPlink archer C80', 'SKU-TPLINK-ARCHER-C80', 'Other', 'tplink-archer-c80', NULL, NULL, 120000.00, 130000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-04 08:47:20', '2026-06-16 14:09:42', 1, 0.00),
('PRD-018', 'AP761', 'SKU-AP761', 'Hardware', 'ap761', NULL, NULL, 250000.00, 280000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:16:40', '2026-06-16 14:09:42', 1, 0.00),
('PRD-019', 'STARLINK V4', 'SKU-STARLINK-V4', 'Hardware', 'starlink-v4', NULL, NULL, 498950.00, 540000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:18:09', '2026-06-16 14:09:42', 1, 0.00),
('PRD-020', 'Ubiquiti USW-Flex', 'SKU-UBIQUITI-USW-FLEX', 'Networking Devices', 'ubiquiti-usw-flex', '', '', 55000.00, 80000.00, 3, 5, '', 1, 0, 'active', '2026-04-01 15:37:25', '2026-06-22 14:41:47', 1, 100000.00),
('PRD-021', 'AP362', 'SKU-AP362', 'Uncategorized', 'ap362', NULL, NULL, 78604.00, 90000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:14:04', '2026-06-16 14:09:42', 1, 110000.00),
('PRD-022', 'tiandy smart mini battery camera', 'SKU-TIANDY-SMART-MINI-BATTERY-CAME', 'Other', 'tiandy-smart-mini-battery-camera', NULL, NULL, 62000.00, 72000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-13 18:54:12', '2026-06-16 14:09:42', 1, 0.00),
('PRD-023', 'Switch 10port TPlink', 'SKU-SWITCH-10PORT-TPLINK', 'Hardware', 'switch-10port-tplink', NULL, NULL, 95000.00, 130000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:41:24', '2026-06-16 14:09:42', 1, 0.00),
('PRD-024', 'UDM-PRO', 'SKU-UDM-PRO', 'Networking Devices', 'udm-pro', '', '', 710000.00, 850000.00, 0, 5, '24 months manufacturer warranty', 1, 1, 'active', '2026-04-15 12:38:01', '2026-06-30 12:58:10', 1, 0.00),
('PRD-025', 'Ethernet Power Adaptor second used 24V', 'SKU-ETHERNET-POWER-ADAPTOR-SECOND-', 'Other', 'ethernet-power-adaptor-second-used-24v', NULL, NULL, 10000.00, 14000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-05 15:36:32', '2026-06-16 14:09:42', 1, 0.00),
('PRD-026', 'Mikrotik RB952UI-5ac2nD-Tc', 'SKU-MIKROTIK-RB952UI-5AC2ND-TC', 'Networking Devices', 'mikrotik-rb952ui-5ac2nd-tc', '', '', 95000.00, 130000.00, 2, 5, '', 1, 0, 'active', '2026-04-01 15:41:45', '2026-06-22 14:40:32', 1, 200000.00),
('PRD-027', 'wireless intercome non display', 'SKU-WIRELESS-INTERCOME-NON-DISPLAY', 'IT Equipment', 'wireless-intercome-non-display', '', '', 36000.00, 45000.00, 2, 5, '', 1, 1, 'active', '2026-02-12 14:34:41', '2026-07-07 11:33:42', 1, 0.00),
('PRD-028', 'Tiandy NVR 4chl', 'SKU-TIANDY-NVR-4CHL', 'Other', 'tiandy-nvr-4chl', NULL, NULL, 38000.00, 50000.00, 4, 5, NULL, 1, 0, 'active', '2026-02-04 08:39:55', '2026-06-16 14:09:42', 1, 0.00),
('PRD-029', 'panasonic intercome wired display', 'SKU-PANASONIC-INTERCOME-WIRED-DISP', 'Other', 'panasonic-intercome-wired-display', NULL, NULL, 12000.00, 18000.00, 10, 5, NULL, 1, 0, 'active', '2026-02-12 14:28:39', '2026-06-16 14:09:42', 1, 0.00),
('PRD-030', 'TPlink archer AX23', 'SKU-TPLINK-ARCHER-AX23', 'Other', 'tplink-archer-ax23', NULL, NULL, 150000.00, 150000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-04 08:46:16', '2026-06-16 14:09:42', 1, 0.00),
('PRD-031', 'TPlink Omada EAP110 Outdoor', 'SKU-TPLINK-OMADA-EAP110-OUTDOOR', 'Other', 'tplink-omada-eap110-outdoor', NULL, NULL, 50000.00, 75000.00, 4, 5, NULL, 1, 0, 'active', '2026-02-04 08:43:51', '2026-06-16 14:09:42', 1, 0.00),
('PRD-032', 'MIKROTIC RB4011', 'SKU-MIKROTIC-RB4011', 'Hardware', 'mikrotic-rb4011', NULL, NULL, 315000.00, 350000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:48:54', '2026-06-16 14:09:42', 1, 0.00),
('PRD-033', 'Circuit Breaker DC/AC', 'SKU-CIRCUIT-BREAKER-DCAC', 'IT Equipment', 'circuit-breaker-dcac', '', '', 6500.00, 8000.00, 5, 5, '', 1, 0, 'active', '2026-02-24 16:05:39', '2026-06-25 09:25:54', 1, 0.00),
('PRD-034', 'U4 RACK', 'SKU-U4-RACK', 'Hardware', 'u4-rack', NULL, NULL, 65000.00, 85000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-04 06:24:19', '2026-06-16 14:09:42', 1, 0.00),
('PRD-035', 'Telephone sim card slot', 'SKU-TELEPHONE-SIM-CARD-SLOT', 'Other', 'telephone-sim-card-slot', NULL, NULL, 30000.00, 40000.00, 3, 5, NULL, 1, 0, 'active', '2026-03-27 15:26:45', '2026-06-16 14:09:42', 1, 50000.00),
('PRD-036', 'WIFI camera socket', 'SKU-WIFI-CAMERA-SOCKET', 'Hardware', 'wifi-camera-socket', NULL, NULL, 15000.00, 20000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-04 09:02:06', '2026-06-16 14:09:42', 1, 0.00),
('PRD-037', 'DLINK DIR-650IN', 'SKU-DLINK-DIR-650IN', 'Hardware', 'dlink-dir-650in', NULL, NULL, 17000.00, 35000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:36:11', '2026-06-16 14:09:42', 1, 0.00),
('PRD-038', 'Hikvision attendance (fingerprint only)', 'SKU-HIKVISION-ATTENDANCE-FINGERPRI', 'IT Equipment', 'hikvision-attendance-fingerprint-only', '', '', 120000.00, 160000.00, 0, 5, '6 months manufacturer warranty', 1, 1, 'active', '2026-04-01 15:46:26', '2026-06-30 16:41:04', 0, 0.00),
('PRD-039', 'LOCO 5AC', 'SKU-LOCO-5AC', 'Hardware', 'loco-5ac', NULL, NULL, 80000.00, 95000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:30:45', '2026-06-16 14:09:42', 1, 110000.00),
('PRD-040', 'HUAWEI S380 4PORT', 'SKU-HUAWEI-S380-4PORT', 'Other', 'huawei-s380-4port', '', '', 150000.00, 200000.00, 1, 5, '', 1, 0, 'active', '2026-02-04 08:44:59', '2026-06-16 13:14:37', 1, 0.00),
('PRD-041', 'Dahua ups 600va', 'SKU-DAHUA-UPS-600VA', 'Other', 'dahua-ups-600va', NULL, NULL, 45000.00, 65000.00, 3, 5, NULL, 1, 0, 'active', '2026-03-30 22:48:54', '2026-06-16 14:09:42', 0, 0.00),
('PRD-042', 'Tiandy NVR 8chl', 'SKU-TIANDY-NVR-8CHL', 'Other', 'tiandy-nvr-8chl', NULL, NULL, 48000.00, 65000.00, 3, 5, NULL, 1, 0, 'active', '2026-02-04 08:40:17', '2026-06-16 14:09:42', 1, 0.00),
('PRD-043', 'AP361', 'SKU-AP361', 'Networking Devices', 'ap361', '', '', 80000.00, 80000.00, 90, 5, '12 months manufacturer warranty', 1, 1, 'active', '2026-02-04 06:16:00', '2026-07-07 14:07:03', 1, 0.00),
('PRD-044', 'Switch 8port Net-pro', 'SKU-SWITCH-8PORT-NET-PRO', 'Hardware', 'switch-8port-net-pro', NULL, NULL, 80000.00, 100000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:20:16', '2026-06-16 14:09:42', 1, 0.00),
('PRD-045', 'cat6 2meter', 'SKU-CAT6-2METER', 'Other', 'cat6-2meter', NULL, NULL, 1000.00, 1500.00, 14, 5, NULL, 1, 0, 'active', '2026-02-14 16:43:16', '2026-06-16 14:09:42', 1, 0.00),
('PRD-046', 'intercome non display wired', 'SKU-INTERCOME-NON-DISPLAY-WIRED', 'Other', 'intercome-non-display-wired', NULL, NULL, 8000.00, 15000.00, 10, 5, NULL, 1, 0, 'active', '2026-02-12 14:32:47', '2026-06-16 14:09:42', 1, 0.00),
('PRD-047', 'Itel 1kwh battery all in one', 'SKU-ITEL-1KWH-BATTERY-ALL-IN-ONE', 'Other', 'itel-1kwh-battery-all-in-one', NULL, NULL, 280000.00, 315000.00, 0, 5, NULL, 1, 0, 'active', '2026-03-05 20:11:34', '2026-06-16 14:09:42', 0, 0.00),
('PRD-048', 'Ethernet Adaptor', 'SKU-ETHERNET-ADAPTOR', 'Hardware', 'ethernet-adaptor', NULL, NULL, 15000.00, 17000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-04 08:50:07', '2026-06-16 14:09:42', 1, 0.00),
('PRD-049', 'MIKROTIC RB951ui', 'SKU-MIKROTIC-RB951UI', 'Hardware', 'mikrotic-rb951ui', NULL, NULL, 80000.00, 100000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:40:24', '2026-06-16 14:09:42', 1, 0.00),
('PRD-050', 'tiandy smart stand mini 355 camera', 'SKU-TIANDY-SMART-STAND-MINI-355-CA', 'Other', 'tiandy-smart-stand-mini-355-camera', NULL, NULL, 30000.00, 35000.00, 3, 5, NULL, 1, 0, 'active', '2026-02-13 16:56:14', '2026-06-16 14:09:42', 1, 0.00),
('PRD-051', 'smart mini dc ups pro', 'SKU-SMART-MINI-DC-UPS-PRO', 'Other', 'smart-mini-dc-ups-pro', NULL, NULL, 35000.00, 40000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-18 23:29:36', '2026-06-16 14:09:42', 1, 0.00),
('PRD-052', 'IP Tiandy ptz WIFI', 'SKU-IP-TIANDY-PTZ-WIFI', 'Hardware', 'ip-tiandy-ptz-wifi', NULL, NULL, 65000.00, 80000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-04 08:52:52', '2026-06-16 14:09:42', 1, 0.00),
('PRD-053', 'Tiandy 2mp Indoor', 'SKU-TIANDY-2MP-INDOOR', 'Hardware', 'tiandy-2mp-indoor', NULL, NULL, 15000.00, 19000.00, 7, 5, NULL, 1, 0, 'active', '2026-02-04 08:37:54', '2026-06-16 14:09:42', 1, 0.00),
('PRD-054', '7.5kwh solar generator', 'SKU-75KWH-SOLAR-GENERATOR', 'Batteries', '75kwh-solar-generator', '', '', 1150000.00, 1150000.00, 0, 5, '', 1, 0, 'active', '2026-04-30 11:43:05', '2026-07-04 05:36:18', 0, 0.00),
('PRD-055', 'Hikvision attendance (face recognition and finger print)', 'SKU-HIKVISION-ATTENDANCE-FACE-RECO', 'IT Equipment', 'hikvision-attendance-face-recognition-and-finger-print', '', '', 130000.00, 170000.00, 3, 5, '12 months manufacturer warranty', 1, 1, 'active', '2026-04-01 15:45:32', '2026-06-25 09:11:04', 0, 0.00),
('PRD-056', 'TPlink Omada EAP225-Outdoor', 'SKU-TPLINK-OMADA-EAP225-OUTDOOR', 'Hardware', 'tplink-omada-eap225-outdoor', NULL, NULL, 150000.00, 140000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-04 08:57:31', '2026-06-16 14:09:42', 1, 0.00),
('PRD-057', 'TPlink Switch 8 port non poe', 'SKU-TPLINK-SWITCH-8-PORT-NON-POE', 'Hardware', 'tplink-switch-8-port-non-poe', NULL, NULL, 15000.00, 18000.00, 3, 5, NULL, 1, 0, 'active', '2026-02-04 08:55:53', '2026-06-16 14:09:42', 1, 0.00),
('PRD-058', 'S310-24P4S', 'SKU-S310-24P4S', 'Other', 's310-24p4s', '', '', 180000.00, 600000.00, 2, 5, '', 1, 0, 'active', '2026-04-07 08:49:39', '2026-06-16 13:11:54', 1, 0.00),
('PRD-059', 'wireless intercome display', 'SKU-WIRELESS-INTERCOME-DISPLAY', 'Other', 'wireless-intercome-display', NULL, NULL, 43000.00, 52000.00, 6, 5, NULL, 1, 0, 'active', '2026-02-12 14:34:07', '2026-06-16 14:09:42', 1, 0.00),
('PRD-060', 'Itel Power Go DC battery Bank', 'SKU-ITEL-POWER-GO-DC-BATTERY-BANK', 'Other', 'itel-power-go-dc-battery-bank', NULL, NULL, 100000.00, 120000.00, 2, 5, NULL, 1, 0, 'active', '2026-03-05 20:12:55', '2026-06-16 14:09:42', 0, 0.00),
('PRD-061', 'Tiandy 2mp Outdoor', 'SKU-TIANDY-2MP-OUTDOOR', 'Hardware', 'tiandy-2mp-outdoor', NULL, NULL, 15000.00, 19000.00, 6, 5, NULL, 1, 0, 'active', '2026-02-04 08:36:53', '2026-06-16 14:09:42', 1, 0.00),
('PRD-062', 'Dahua poe switch 8port', 'SKU-DAHUA-POE-SWITCH-8PORT', 'Other', 'dahua-poe-switch-8port', NULL, NULL, 62000.00, 75000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-11 23:29:44', '2026-06-16 14:09:42', 1, 0.00),
('PRD-063', '1U socket 8way', 'SKU-1U-SOCKET-8WAY', 'Other', '1u-socket-8way', NULL, NULL, 34260.00, 45000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-13 16:52:01', '2026-06-16 14:09:42', 1, 0.00),
('PRD-064', 'Mikrotik AX2', 'SKU-MIKROTIK-AX2', 'Networking Devices', 'mikrotik-ax2', '', '', 125000.00, 140000.00, 0, 5, '', 1, 1, 'active', '2026-03-18 13:11:33', '2026-06-23 10:54:44', 1, 0.00),
('PRD-065', 'S110-24P2ST', 'SKU-S110-24P2ST', 'Other', 's110-24p2st', '', '', 100000.00, 330000.00, 1, 5, '', 1, 0, 'active', '2026-04-02 14:24:13', '2026-06-16 13:13:31', 1, 400000.00),
('PRD-066', 'Tenda N301', 'SKU-TENDA-N301', 'Other', 'tenda-n301', NULL, NULL, 14200.00, 25000.00, 2, 5, NULL, 1, 0, 'active', '2026-03-30 22:38:38', '2026-06-16 14:09:42', 1, 40000.00),
('PRD-067', 'Smoke detector', 'SKU-SMOKE-DETECTOR', 'Other', 'smoke-detector', NULL, NULL, 9500.00, 15000.00, 10, 5, NULL, 1, 0, 'active', '2026-03-18 13:12:59', '2026-06-16 14:09:42', 1, 20000.00),
('PRD-068', 'HDD 1TB', 'SKU-HDD-1TB', 'Hardware', 'hdd-1tb', NULL, NULL, 35000.00, 40000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-24 13:22:11', '2026-06-16 14:09:42', 1, 0.00),
('PRD-069', 'HUAWEI S110 8PORT', 'SKU-HUAWEI-S110-8PORT', 'Hardware', 'huawei-s110-8port', NULL, NULL, 104000.00, 130000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-04 06:23:21', '2026-06-16 14:09:42', 1, 0.00),
('PRD-070', 'HUAWEI S110 16PORT', 'SKU-HUAWEI-S110-16PORT', 'Uncategorized', 'huawei-s110-16port', NULL, NULL, 250000.00, 250000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-04 06:21:36', '2026-06-16 14:09:42', 1, 0.00),
('PRD-071', 'Tiandy NVR 20chl', 'SKU-TIANDY-NVR-20CHL', 'Other', 'tiandy-nvr-20chl', NULL, NULL, 88000.00, 100000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 08:40:46', '2026-06-16 14:09:42', 1, 0.00),
('PRD-072', 'Ethernet Power Bank 24V', 'SKU-ETHERNET-POWER-BANK-24V', 'Other', 'ethernet-power-bank-24v', NULL, NULL, 38000.00, 50000.00, 2, 5, NULL, 1, 0, 'active', '2026-02-05 14:00:36', '2026-06-16 14:09:42', 1, 0.00),
('PRD-073', 'Tiandy NVR 80chl', 'SKU-TIANDY-NVR-80CHL', 'Other', 'tiandy-nvr-80chl', NULL, NULL, 800000.00, 900000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 08:42:05', '2026-06-16 14:09:42', 1, 0.00),
('PRD-074', 'TPlink 8port Gigabit Switch non poe', 'SKU-TPLINK-8PORT-GIGABIT-SWITCH-NO', 'Other', 'tplink-8port-gigabit-switch-non-poe', NULL, NULL, 22000.00, 30000.00, 1, 5, NULL, 1, 0, 'active', '2026-02-05 14:01:42', '2026-06-16 14:09:42', 1, 0.00),
('PRD-075', 'LAP-GPS', 'SKU-LAP-GPS', 'Hardware', 'lap-gps', NULL, NULL, 155725.00, 200000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:33:50', '2026-06-16 14:09:42', 1, 0.00),
('PRD-076', 'IP Solar Tiandy ptz sim slot', 'SKU-IP-SOLAR-TIANDY-PTZ-SIM-SLOT', 'Hardware', 'ip-solar-tiandy-ptz-sim-slot', '', '', 140000.00, 150000.00, 4, 5, '', 1, 0, 'active', '2026-02-04 08:54:03', '2026-07-02 12:22:01', 0, 0.00),
('PRD-077', 'CAT6 INDOOR', 'SKU-CAT6-INDOOR', 'Other', 'cat6-indoor', NULL, NULL, 100000.00, 140000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 09:00:48', '2026-06-16 14:09:42', 1, 0.00),
('PRD-078', 'TPlink archer C20', 'SKU-TPLINK-ARCHER-C20', 'Other', 'tplink-archer-c20', '', '', 80000.00, 100000.00, 1, 5, '12 months manufacturer', 1, 1, 'active', '2026-02-04 08:47:48', '2026-06-30 14:28:13', 1, 0.00),
('PRD-079', 'STARLINK MINI', 'SKU-STARLINK-MINI', 'Hardware', 'starlink-mini', NULL, NULL, 420000.00, 440000.00, 0, 5, NULL, 1, 0, 'active', '2026-02-04 06:18:55', '2026-06-16 14:09:42', 1, 0.00),
('PRD-080', 'AP263', 'SKU-AP263', 'Networking Devices', 'ap263', '', '', 47000.00, 110000.00, 1, 5, '', 1, 0, 'active', '2026-04-14 16:53:37', '2026-06-30 13:34:54', 1, 0.00),
('PRD-081', 'MIKROTIC L009', 'SKU-MIKROTIC-L009', 'Networking Devices', 'mikrotic-l009', '', '', 180000.00, 215000.00, 3, 5, '24 months manufacturer warranty', 1, 1, 'active', '2026-02-04 06:38:10', '2026-07-02 11:57:28', 1, 220000.00),
('PRD-592420C6', 'TPlink router AX23', 'YT-TPlink router', 'Networking Devices', 'tplink-router-ax23', '', '', 0.00, 0.00, 1, 5, '', 1, 0, 'active', '2026-06-25 10:22:27', '2026-06-25 10:23:53', 1, 0.00),
('PRD-C9F837A7', 'Huawei AR180 Dual Band Wifi 7 Router', 'YT-D-WIFI-RT', 'Networking Devices', 'huawei-ar180-dual-band-wifi-7-router', '', '', 100000.00, 120000.00, 1, 5, '12 Months manufacturer warranty', 1, 1, 'active', '2026-07-02 10:10:24', '2026-07-03 11:35:30', 1, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `alt_text` varchar(150) DEFAULT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` smallint(6) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `image_path`, `alt_text`, `is_primary`, `sort_order`, `created_at`) VALUES
(52, 'PRD-081', '/uploads/products/612a928fc0917324cc87220f.png', NULL, 1, 0, '2026-06-23 10:16:05'),
(53, 'PRD-081', '/uploads/products/d9a0d2f85db1d2f8ee470970.jpg', NULL, 0, 0, '2026-06-23 10:16:22'),
(54, 'PRD-081', '/uploads/products/007530441e107ee5e460ee7b.jpg', NULL, 0, 0, '2026-06-23 10:16:30'),
(55, 'PRD-024', '/uploads/products/ebd972cd6e88ed02d99a7c22.png', NULL, 1, 0, '2026-06-23 10:39:14'),
(56, 'PRD-024', '/uploads/products/60df654d30562a323351d5b6.png', NULL, 0, 0, '2026-06-23 10:39:21'),
(57, 'PRD-024', '/uploads/products/f22992e664e36aad8dd2e46a.png', NULL, 0, 0, '2026-06-23 10:39:28'),
(58, 'PRD-064', '/uploads/products/db95004a17bb2fc521aedbb7.png', NULL, 0, 0, '2026-06-23 10:50:25'),
(59, 'PRD-064', '/uploads/products/94ae1d937cc088dcf6e411b7.png', NULL, 1, 0, '2026-06-23 10:50:33'),
(60, 'PRD-064', '/uploads/products/142a0baf7873fab11c965651.png', NULL, 0, 0, '2026-06-23 10:50:42'),
(61, 'PRD-064', '/uploads/products/6c8002101bee39e992302a47.png', NULL, 0, 0, '2026-06-23 10:50:53'),
(62, 'PRD-055', '/uploads/products/495b8247a87053207a216dfa.jpg', NULL, 0, 0, '2026-06-25 09:00:04'),
(63, 'PRD-055', '/uploads/products/d9c651c06e29d6cd0672c381.jpg', NULL, 0, 0, '2026-06-25 09:00:15'),
(64, 'PRD-055', '/uploads/products/0f1dc48c765f634b3d21da3b.png', NULL, 0, 0, '2026-06-25 09:00:25'),
(65, 'PRD-038', '/uploads/products/38b5ea9b6a8d479744c53bcd.png', NULL, 1, 0, '2026-06-25 09:15:31'),
(66, 'PRD-038', '/uploads/products/f97dd7274d6ec63b0f2ef360.png', NULL, 0, 0, '2026-06-25 09:15:39'),
(67, 'PRD-038', '/uploads/products/524e68ae07157f49e70e821f.png', NULL, 0, 0, '2026-06-25 09:15:48'),
(68, 'PRD-043', '/uploads/products/5b9abbe9ce42983b9184e5f8.png', NULL, 0, 0, '2026-06-30 13:28:18'),
(69, 'PRD-043', '/uploads/products/4a1e0ace3a952a24c503e09a.jpg', NULL, 0, 0, '2026-06-30 13:29:03'),
(70, 'PRD-043', '/uploads/products/d9cec9ac8cd27218a8a5af3d.jpg', NULL, 0, 0, '2026-06-30 13:29:10'),
(71, 'PRD-013', '/uploads/products/bb57fa97fe8180b83624baf4.jpg', NULL, 0, 0, '2026-06-30 13:47:36'),
(72, 'PRD-013', '/uploads/products/268cca1a5ff85c11a67ca280.png', NULL, 1, 0, '2026-06-30 13:48:18'),
(73, 'PRD-013', '/uploads/products/01d1d150bf76d904081c5619.png', NULL, 0, 0, '2026-06-30 13:48:40'),
(74, 'PRD-078', '/uploads/products/6026883d74b11528ba49417b.jpg', NULL, 0, 0, '2026-06-30 14:23:09'),
(75, 'PRD-078', '/uploads/products/50afce8d5703d809202393d3.jpg', NULL, 0, 0, '2026-06-30 14:23:16'),
(76, 'PRD-078', '/uploads/products/98105f9bcfd30d9a19f50fb2.png', NULL, 1, 0, '2026-06-30 14:23:28'),
(77, 'PRD-078', '/uploads/products/b551896801eb77d342116ac8.jpg', NULL, 0, 0, '2026-06-30 14:23:41'),
(78, 'PRD-C9F837A7', '/uploads/products/1ab6bdec5e5db5e11b5b764a.jpg', NULL, 0, 0, '2026-07-02 10:23:43'),
(79, 'PRD-C9F837A7', '/uploads/products/14fbe149349e6a2dae4e3360.jpg', NULL, 0, 0, '2026-07-02 10:23:58'),
(80, 'PRD-C9F837A7', '/uploads/products/7f597c713fcd01b5eb35a4cb.jpg', NULL, 0, 0, '2026-07-02 10:24:15'),
(81, 'PRD-C9F837A7', '/uploads/products/ec3f86072120c9e88e271943.jpg', NULL, 1, 0, '2026-07-02 10:24:32'),
(82, 'PRD-027', '/uploads/products/df7f8884c290460b67074736.jpg', NULL, 1, 0, '2026-07-07 11:26:27'),
(83, 'PRD-027', '/uploads/products/79487b6842783bf4ec239cb3.jpg', NULL, 0, 0, '2026-07-07 11:31:06'),
(84, 'PRD-027', '/uploads/products/f631f1aa34a30346fd5085f7.png', NULL, 0, 0, '2026-07-07 11:33:30');

-- --------------------------------------------------------

--
-- Table structure for table `product_related`
--

CREATE TABLE `product_related` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `related_product_id` varchar(64) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_reviews`
--

CREATE TABLE `product_reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_name` varchar(150) DEFAULT NULL,
  `rating` tinyint(3) UNSIGNED NOT NULL,
  `review_text` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_specifications`
--

CREATE TABLE `product_specifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` varchar(64) NOT NULL,
  `spec_group` varchar(100) DEFAULT NULL,
  `spec_name` varchar(100) NOT NULL,
  `spec_value` varchar(255) NOT NULL,
  `sort_order` smallint(6) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_specifications`
--

INSERT INTO `product_specifications` (`id`, `product_id`, `spec_group`, `spec_name`, `spec_value`, `sort_order`, `created_at`) VALUES
(9019, 'PRD-024', NULL, 'Processor', '1.7 GHz ARM Cortex-A57 Quad-Core', 0, '2026-06-23 10:44:03'),
(9020, 'PRD-024', NULL, 'Throughput', 'Up to 3.5 Gbps IPS/IDS throughput', 1, '2026-06-23 10:44:03'),
(9021, 'PRD-024', NULL, 'Storage', '16 GB onboard eMMC flash; supports 2.5\" or 3.5\" hard drives for UniFi Protect NVR', 2, '2026-06-23 10:44:03'),
(9032, 'PRD-064', NULL, 'Dual-band, dual-chain radio', 'Offers improved wireless performance with a 4-4.5 dBi radio.', 0, '2026-06-23 10:54:44'),
(9033, 'PRD-064', NULL, '802.11ax standard', 'Supports Wave2 for enhanced speed and efficiency.', 1, '2026-06-23 10:54:44'),
(9034, 'PRD-064', NULL, 'CPU', 'Quad-core CPU running at 864 MHz', 2, '2026-06-23 10:54:44'),
(9035, 'PRD-064', NULL, 'RAM', '1 GB of RAM', 3, '2026-06-23 10:54:44'),
(9036, 'PRD-064', NULL, 'Storage', '128 MB NAND', 4, '2026-06-23 10:54:44'),
(9049, 'PRD-038', NULL, 'Fingerprint Recognition', 'Supports multiple authentication methods including   fingerprint, and PIN', 0, '2026-06-25 09:23:31'),
(9050, 'PRD-055', NULL, 'Face Recognition', 'Achieves face recognition in less than 0.2 seconds per user', 0, '2026-06-25 09:23:46'),
(9051, 'PRD-055', NULL, 'Fingerprint Recognition', 'Supports multiple authentication methods including face, fingerprint, and PIN', 1, '2026-06-25 09:23:46'),
(9052, 'PRD-055', NULL, 'Card Capacity', 'Supports up to 1,000 EM cards', 2, '2026-06-25 09:23:46'),
(9053, 'PRD-055', NULL, 'Screen', '2.4-inch LCD display', 3, '2026-06-25 09:23:46'),
(9058, 'PRD-043', NULL, 'Wi-Fi Standard', 'IEEE 802.11ax (Wi-Fi 6) for high-density indoor environments', 0, '2026-06-30 13:33:58'),
(9059, 'PRD-043', NULL, 'High-Speed Wireless Connectivity', 'Supports 802.11ac Wave 2 technology with a maximum throughput of up to 1.167 Gbps', 1, '2026-06-30 13:33:58'),
(9060, 'PRD-043', NULL, 'Scalable Solution', 'Ideal for small to medium-sized networks, with the ability to expand as your needs grow', 2, '2026-06-30 13:33:58'),
(9065, 'PRD-078', NULL, 'Antennas', 'Three fixed external antennas for optimal omnidirectional coverage', 0, '2026-06-30 14:28:35'),
(9066, 'PRD-078', NULL, 'Ethernet Ports', 'Four LAN ports (RJ-45) with 10/100 Mbps speeds and one WAN port ', 1, '2026-06-30 14:28:35'),
(9067, 'PRD-078', NULL, 'Modes', 'Can operate as a standard router, Access Point, or Range Extender', 2, '2026-06-30 14:28:35'),
(9068, 'PRD-078', NULL, 'Power', 'DC-in jack for power supply ', 3, '2026-06-30 14:28:35');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `setting_key` varchar(120) NOT NULL,
  `setting_group` varchar(50) NOT NULL DEFAULT 'general',
  `setting_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`setting_value`)),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_group`, `setting_value`, `updated_at`) VALUES
(1, 'store_name', 'general', '\"YAROTECH\"', '2026-05-28 07:31:27'),
(2, 'vat_percent', 'general', '0.075', '2026-05-31 06:58:12'),
(3, 'currency', 'general', '\"NGN\"', '2026-05-28 07:31:27');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','admin','staff') NOT NULL DEFAULT 'user',
  `account_type` enum('individual','business') DEFAULT NULL,
  `company_name` varchar(190) DEFAULT NULL,
  `email_verified_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `phone`, `password_hash`, `role`, `account_type`, `company_name`, `email_verified_at`, `last_login_at`, `created_at`, `updated_at`) VALUES
(11, 'SAIDU USMAN ABDULLAHI', 'saidua2018@gmail.com', NULL, '$2y$10$LFCYwiONbGOWA4twaT2p8ueErOoocaO4QjWkmOPKR1meY2t30LdYK', 'admin', NULL, NULL, '2026-06-04 12:13:32', NULL, '2026-06-04 12:13:13', '2026-06-04 13:15:10'),
(12, 'Said Usman', 'saidusmanabdullahi7@gmail.com', NULL, '$2y$10$z8yDNFKqOYt4BAfETeWAa.pWj696sVUUY.cAbNmmo.KrX262US7q6', 'user', NULL, NULL, '2026-06-15 15:04:46', NULL, '2026-06-15 15:04:10', '2026-06-15 15:04:46'),
(18, 'ENGINEER', 'yarotech@yarotech.com.ng', NULL, '$2y$10$N/ZMZBJT1kg08beCZGY4luO7ISqaaUl1YBbmmnSS0YRMMkENNECiq', 'admin', 'business', 'Yarotech', '2026-02-04 05:47:19', NULL, '2026-02-04 05:47:19', '2026-02-04 05:47:19'),
(19, 'SAIDU USMAN', 'saeed@yarotech.com.ng', NULL, '$2y$10$QS7WqJyfTHksCb21Zwpwz.y8f4cQhcbJOweq/0u8ePxBqyZWpbYZy', 'admin', 'business', 'Yarotech', '2026-04-09 06:37:00', NULL, '2026-04-09 06:37:00', '2026-06-20 12:22:16'),
(20, 'EL-SADEEQ', 'elsadeeq24@gmail.com', NULL, '$2y$10$Yk55ePd3UE5q/loEsKqza.mogssZQ5tn3KbKE0kstzWlHgVeEOr.O', 'staff', 'individual', NULL, '2026-02-04 09:08:29', NULL, '2026-02-04 09:08:29', '2026-02-04 09:08:29'),
(21, 'Abdullahi', 'abdullahisammani2017@gmail.com', NULL, '$2y$10$szJpBNG7bM9YqopHj9F5aOiI6ojgdJArTF8JYlDn2vd/XByt4ZeOu', 'admin', 'individual', NULL, '2026-02-12 11:34:22', NULL, '2026-02-12 11:34:22', '2026-02-12 11:34:22'),
(22, 'AL-HASSAN', 'alhassanabubakarismail@gmail.com', NULL, '$2y$10$LG9zzQRvGPNg0wPLE6mdUulPNXMUSShRbsk60gxu2O6WQfF6VfhJ6', 'admin', 'individual', NULL, '2026-02-06 13:01:43', NULL, '2026-02-06 13:01:43', '2026-06-30 13:50:15'),
(23, 'Yarotech Network Limited', 'yarotechnetworklimited@gmail.com', NULL, '$2y$10$YdCTuo6ulVXcycBbLpL8ludAe53RLPvSHTXuo5tJ45m.shonu6j6u', 'user', NULL, NULL, '2026-06-30 12:55:06', NULL, '2026-06-30 12:54:37', '2026-06-30 12:55:06'),
(24, 'SAIDU USMAN ABDULLAHI', 'saeeduthmanabdullahi@gmail.com', NULL, '$2y$10$2bOEAIC8O0FfMeabh.CSzOefjcjXnp5X3J9uyB8O8S0tUM.wQYOVy', 'user', NULL, NULL, '2026-06-30 16:39:37', NULL, '2026-06-30 16:39:11', '2026-06-30 16:39:37'),
(25, 'SAIDU USMAN ABDULLAHI', 'saeedusmanabdullahi@gmail.com', '+2348133424701', '$2y$10$KH.aSaqHaP3gszxsE1guUO3LPPgbjVmkoYXZ./IkcjneSZv/m.Gu6', 'user', NULL, NULL, '2026-07-02 22:03:15', NULL, '2026-07-02 22:02:45', '2026-07-02 22:03:15');

-- --------------------------------------------------------

--
-- Table structure for table `user_activity_logs`
--

CREATE TABLE `user_activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `activity_type` varchar(80) NOT NULL,
  `status` enum('success','failed') NOT NULL DEFAULT 'success',
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_activity_logs`
--

INSERT INTO `user_activity_logs` (`id`, `user_id`, `activity_type`, `status`, `ip_address`, `user_agent`, `metadata`, `created_at`) VALUES
(1, NULL, 'login_failed', 'failed', '102.91.102.242', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saeedusmanabdullahi@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-05-28 06:37:48'),
(7, NULL, 'login_failed', 'failed', '102.91.102.242', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-28 09:52:45'),
(10, NULL, 'admin_auth_failed', 'failed', '102.91.102.242', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 10:05:57'),
(11, NULL, 'admin_auth_failed', 'failed', '102.91.102.242', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 11:14:19'),
(12, NULL, 'login_failed', 'failed', '102.91.102.242', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saeedusmanabdullahi@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-05-28 11:14:26'),
(23, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:17:05'),
(24, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:17:20'),
(25, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:17:35'),
(26, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:17:50'),
(27, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:18:05'),
(28, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:18:20'),
(29, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:18:35'),
(30, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:18:50'),
(31, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:19:05'),
(32, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:19:25'),
(33, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:19:51'),
(34, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:20:54'),
(35, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:21:52'),
(36, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:27:37'),
(37, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:27:50'),
(38, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:28:05'),
(39, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:28:20'),
(40, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:28:35'),
(41, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:28:51'),
(42, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:29:52'),
(43, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:30:51'),
(44, NULL, 'admin_auth_failed', 'failed', '102.91.105.91', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-28 20:31:52'),
(49, NULL, 'login_failed', 'failed', '192.178.11.101', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-29 06:01:15'),
(52, NULL, 'login_failed', 'failed', '102.91.72.109', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-29 08:19:26'),
(54, NULL, 'admin_auth_failed', 'failed', '102.91.72.109', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-29 08:25:20'),
(58, NULL, 'admin_auth_failed', 'failed', '102.91.72.109', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-29 08:46:05'),
(60, NULL, 'admin_auth_failed', 'failed', '102.91.72.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36 EdgA/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-29 08:50:33'),
(61, NULL, 'admin_auth_failed', 'failed', '102.91.72.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36 EdgA/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-29 08:50:48'),
(62, NULL, 'contact_inquiry', 'success', '102.91.72.109', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"ticket_id\":\"TKT-20260529-000001\",\"inquiry_type\":\"General Inquiry\"}', '2026-05-29 09:02:27'),
(63, NULL, 'admin_auth_failed', 'failed', '102.91.72.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36 EdgA/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-29 09:02:41'),
(72, NULL, 'admin_auth_failed', 'failed', '102.91.77.199', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-30 09:43:13'),
(73, NULL, 'admin_auth_failed', 'failed', '102.91.77.199', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-30 09:43:28'),
(78, NULL, 'login_failed', 'failed', '66.249.83.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 10:38:59'),
(87, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:11:25'),
(88, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:11:40'),
(89, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:11:55'),
(90, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:12:10'),
(91, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:12:36'),
(92, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:13:37'),
(93, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:14:26'),
(94, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:14:40'),
(95, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:14:55'),
(96, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:15:10'),
(97, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:15:25'),
(98, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:15:40'),
(99, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:15:55'),
(100, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:16:10'),
(101, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:16:36'),
(102, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:17:37'),
(103, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:18:37'),
(104, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:19:37'),
(105, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:20:37'),
(106, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:21:33'),
(107, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:21:40'),
(108, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:21:56'),
(109, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:22:10'),
(110, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:22:26'),
(111, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:22:41'),
(112, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:22:56'),
(113, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:23:11'),
(114, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:23:37'),
(115, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:24:36'),
(116, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:25:36'),
(117, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:26:37'),
(118, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:29:28'),
(119, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:29:41'),
(120, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:29:56'),
(121, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:30:11'),
(122, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:30:25'),
(123, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:30:41'),
(124, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:30:55'),
(125, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:31:11'),
(126, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:31:25'),
(127, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:32:37'),
(128, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:33:43'),
(129, NULL, 'login_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-30 16:35:28'),
(132, NULL, 'admin_auth_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-30 18:13:24'),
(133, NULL, 'admin_auth_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-30 18:13:25'),
(134, NULL, 'admin_auth_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-30 18:13:40'),
(135, NULL, 'admin_auth_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-30 18:15:35'),
(136, NULL, 'admin_auth_failed', 'failed', '102.91.92.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-30 18:15:40'),
(138, NULL, 'login_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saeeduthmanabdullahi@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-05-31 04:52:55'),
(141, NULL, 'login_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saeeduthmanabdullahi@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-05-31 05:30:50'),
(144, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:37:29'),
(145, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:37:44'),
(146, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:37:59'),
(147, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:38:14'),
(148, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:38:31'),
(149, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:39:31'),
(150, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:40:31'),
(151, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:41:31'),
(152, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:44:33'),
(153, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:44:44'),
(154, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:44:59'),
(155, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:45:14'),
(156, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:45:29'),
(157, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:46:31'),
(158, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:47:31'),
(159, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:50:35'),
(162, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 05:52:13'),
(168, NULL, 'login_failed', 'failed', '192.178.11.100', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-05-31 05:59:35'),
(170, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 06:09:36'),
(171, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 06:09:51'),
(172, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 06:10:06'),
(173, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 06:10:21'),
(174, NULL, 'admin_auth_failed', 'failed', '102.91.77.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 06:10:36'),
(182, NULL, 'admin_auth_failed', 'failed', '102.91.93.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-05-31 15:14:12'),
(186, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 14:49:47'),
(193, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 15:03:15'),
(197, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:12:03'),
(198, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:12:18'),
(199, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:12:33'),
(200, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:12:50'),
(201, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:13:26'),
(202, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:14:09'),
(205, NULL, 'login_failed', 'failed', '192.178.11.102', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-06-01 16:21:51'),
(208, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:22:24'),
(209, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:22:29'),
(210, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:33:06'),
(213, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:41:37'),
(214, NULL, 'admin_auth_failed', 'failed', '98.97.77.160', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-01 16:42:23'),
(225, NULL, 'login_failed', 'failed', '192.178.11.100', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-06-03 08:07:26'),
(228, NULL, 'login_failed', 'failed', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '{\"email\":\"abdullahisammani2017@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-04 12:07:25'),
(230, 11, 'user_registered', 'success', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-04 12:13:13'),
(231, NULL, 'login_failed', 'failed', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-04 12:13:35'),
(232, 11, 'login_success', 'success', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-04 12:13:42'),
(233, 11, 'login_success', 'success', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-04 12:14:54'),
(234, NULL, 'login_failed', 'failed', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-04 12:15:28'),
(235, 11, 'login_success', 'success', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-04 12:15:37'),
(236, NULL, 'login_failed', 'failed', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-04 14:10:28'),
(237, 11, 'login_success', 'success', '98.97.79.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-04 14:10:50'),
(238, NULL, 'login_failed', 'failed', '102.90.99.179', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-05 15:52:07'),
(239, 11, 'login_success', 'success', '102.90.99.179', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-05 15:52:15'),
(240, 11, 'login_success', 'success', '197.210.70.219', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-06 04:45:37'),
(241, NULL, 'login_failed', 'failed', '98.97.76.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-10 11:59:33'),
(242, NULL, 'login_failed', 'failed', '98.97.76.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-10 11:59:45'),
(243, 11, 'login_success', 'success', '98.97.76.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-10 12:00:16'),
(244, 11, 'login_success', 'success', '143.105.174.248', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-12 14:35:02'),
(245, NULL, 'admin_auth_failed', 'failed', '98.97.79.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-12 16:21:33'),
(246, NULL, 'admin_auth_failed', 'failed', '98.97.79.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-12 16:21:48'),
(247, NULL, 'admin_auth_failed', 'failed', '98.97.79.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-12 16:22:03'),
(248, NULL, 'admin_auth_failed', 'failed', '98.97.79.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-12 16:22:18'),
(249, NULL, 'admin_auth_failed', 'failed', '98.97.79.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-12 16:22:33'),
(250, NULL, 'admin_auth_failed', 'failed', '98.97.79.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-12 16:23:11'),
(251, 11, 'login_success', 'success', '102.91.105.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-13 04:30:27'),
(252, 11, 'pos_sale_created', 'success', '102.91.105.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"order_number\":\"YT-20260613-1F2023\",\"customer_name\":\"Walk-in customer\",\"total_amount\":1257750}', '2026-06-13 04:31:07'),
(253, 11, 'login_success', 'success', '102.91.104.170', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-15 07:12:51'),
(254, NULL, 'login_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-15 14:23:23'),
(255, 11, 'login_success', 'success', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-15 14:23:34'),
(256, NULL, 'login_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-15 15:04:00'),
(257, 12, 'user_registered', 'success', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidusmanabdullahi7@gmail.com\"}', '2026-06-15 15:04:10'),
(258, 12, 'login_success', 'success', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidusmanabdullahi7@gmail.com\"}', '2026-06-15 15:05:01'),
(259, 12, 'payment_initialize', 'success', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"order_number\":\"YT-20260615-814882\",\"reference\":\"YT-PAY-YT20260615814882-A01AF3DD\"}', '2026-06-15 15:06:21'),
(260, 12, 'payment_success', 'success', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"order_number\":\"YT-20260615-814882\",\"reference\":\"YT-PAY-YT20260615814882-A01AF3DD\"}', '2026-06-15 15:06:48'),
(261, 12, 'payment_verify', 'success', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"reference\":\"YT-PAY-YT20260615814882-A01AF3DD\",\"order_number\":\"YT-20260615-814882\"}', '2026-06-15 15:06:48'),
(262, 12, 'payment_verify', 'success', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"reference\":\"YT-PAY-YT20260615814882-A01AF3DD\",\"order_number\":\"YT-20260615-814882\"}', '2026-06-15 15:07:02'),
(263, 11, 'login_success', 'success', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-15 15:07:28'),
(264, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:54:05'),
(265, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:54:20'),
(266, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:54:35'),
(267, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:54:50'),
(268, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:55:05'),
(269, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:55:20'),
(270, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:55:35'),
(271, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:55:50'),
(272, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:56:05'),
(273, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:56:20'),
(274, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:56:35'),
(275, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:56:50'),
(276, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:57:05'),
(277, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:57:21'),
(278, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:57:35'),
(279, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:57:51'),
(280, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:58:06'),
(281, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:58:21'),
(282, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:58:36');
INSERT INTO `user_activity_logs` (`id`, `user_id`, `activity_type`, `status`, `ip_address`, `user_agent`, `metadata`, `created_at`) VALUES
(283, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 16:59:21'),
(284, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:00:22'),
(285, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:01:21'),
(286, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:04:17'),
(287, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:04:21'),
(288, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:04:36'),
(289, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:04:51'),
(290, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:05:06'),
(291, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:05:21'),
(292, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:05:36'),
(293, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:06:21'),
(294, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:07:21'),
(295, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:10:43'),
(296, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:10:51'),
(297, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:11:06'),
(298, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:11:21'),
(299, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:11:36'),
(300, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:11:51'),
(301, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:12:06'),
(302, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:12:21'),
(303, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:13:22'),
(304, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:14:21'),
(305, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:15:21'),
(306, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:16:21'),
(307, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:17:21'),
(308, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:23:11'),
(309, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:23:21'),
(310, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:23:36'),
(311, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:23:51'),
(312, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:24:06'),
(313, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:24:21'),
(314, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:25:07'),
(315, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:25:21'),
(316, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:25:36'),
(317, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:25:51'),
(318, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:26:21'),
(319, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:27:21'),
(320, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:27:36'),
(321, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:27:51'),
(322, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:28:06'),
(323, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:28:21'),
(324, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:28:42'),
(325, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:28:51'),
(326, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:29:06'),
(327, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:29:21'),
(328, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:29:36'),
(329, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:30:21'),
(330, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:31:21'),
(331, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:32:21'),
(332, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:33:21'),
(333, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:34:21'),
(334, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:35:22'),
(335, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:36:21'),
(336, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:37:56'),
(337, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:37:56'),
(338, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:37:56'),
(339, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:38:06'),
(340, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:38:21'),
(341, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:38:36'),
(342, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:38:51'),
(343, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:40:22'),
(344, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:41:22'),
(345, NULL, 'admin_auth_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-15 17:41:52'),
(346, NULL, 'login_failed', 'failed', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-15 17:42:05'),
(347, 11, 'login_success', 'success', '102.91.105.187', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-15 17:42:40'),
(348, 11, 'login_success', 'success', '102.91.105.187', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-15 18:31:10'),
(349, 11, 'login_success', 'success', '197.210.53.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-16 09:52:26'),
(350, 11, 'login_success', 'success', '98.97.76.218', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-16 13:10:50'),
(351, 11, 'login_success', 'success', '102.91.92.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-19 14:32:16'),
(352, 11, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-20 11:18:09'),
(353, NULL, 'admin_auth_failed', 'failed', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-20 11:21:38'),
(354, NULL, 'admin_auth_failed', 'failed', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-20 11:21:38'),
(355, NULL, 'admin_auth_failed', 'failed', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-20 11:21:40'),
(356, NULL, 'admin_auth_failed', 'failed', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-20 11:21:56'),
(357, NULL, 'admin_auth_failed', 'failed', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-20 11:22:10'),
(358, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 11:48:43'),
(359, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 11:49:56'),
(360, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 12:30:00'),
(361, 22, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-20 13:04:12'),
(362, 11, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-20 13:12:38'),
(363, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 13:19:27'),
(364, 22, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-20 13:20:12'),
(365, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 13:20:13'),
(366, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 13:24:35'),
(367, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 14:38:09'),
(368, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 14:45:30'),
(369, 19, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-06-20 14:45:37'),
(370, 22, 'login_success', 'success', '102.91.4.166', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-21 04:13:55'),
(371, 11, 'login_success', 'success', '197.210.53.150', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-22 14:38:53'),
(372, 11, 'login_success', 'success', '98.97.76.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-23 10:15:22'),
(373, 11, 'login_success', 'success', '102.91.77.229', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-24 16:10:46'),
(374, 11, 'login_success', 'success', '102.91.92.59', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-25 08:51:53'),
(375, 11, 'login_success', 'success', '102.91.92.59', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-25 10:29:30'),
(376, 22, 'login_success', 'success', '102.91.77.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-25 11:17:50'),
(377, 20, 'login_success', 'success', '98.97.79.55', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\"}', '2026-06-25 13:49:55'),
(378, 22, 'login_success', 'success', '98.97.79.55', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-26 14:43:12'),
(379, 22, 'login_success', 'success', '98.97.79.55', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-26 15:01:40'),
(380, 22, 'login_success', 'success', '102.91.92.138', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-26 16:28:24'),
(381, 20, 'login_success', 'success', '102.91.102.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\"}', '2026-06-26 18:33:45'),
(382, 22, 'login_success', 'success', '98.97.79.87', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-27 10:42:39'),
(383, 22, 'login_success', 'success', '98.97.79.87', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-27 12:31:38'),
(384, 20, 'login_success', 'success', '102.91.104.202', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\"}', '2026-06-28 11:17:28'),
(385, 20, 'login_success', 'success', '102.91.104.202', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\"}', '2026-06-28 11:20:03'),
(386, 20, 'login_success', 'success', '102.91.104.202', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\"}', '2026-06-28 11:21:18'),
(387, 20, 'login_success', 'success', '102.91.104.202', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\"}', '2026-06-28 11:23:57'),
(388, 22, 'login_success', 'success', '98.97.76.50', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-29 08:12:56'),
(389, NULL, 'login_failed', 'failed', '102.91.92.6', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-29 11:51:13'),
(390, 18, 'login_success', 'success', '102.91.132.131', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"yarotech@yarotech.com.ng\"}', '2026-06-30 11:19:19'),
(391, 22, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-30 11:26:29'),
(392, 22, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-30 11:33:29'),
(393, 22, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-30 12:41:57'),
(394, 22, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-30 12:44:15'),
(395, NULL, 'login_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-30 12:48:36'),
(396, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 12:48:52'),
(397, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:50:25'),
(398, 22, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-30 12:50:53'),
(399, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:53:39'),
(400, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:53:39'),
(401, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:53:54'),
(402, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:53:54'),
(403, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:54:09'),
(404, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:54:09'),
(405, 23, 'user_registered', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"yarotechnetworklimited@gmail.com\"}', '2026-06-30 12:54:37'),
(406, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:54:47'),
(407, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:54:47'),
(408, 23, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"yarotechnetworklimited@gmail.com\"}', '2026-06-30 12:55:22'),
(409, 23, 'payment_initialize', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"order_number\":\"YT-20260630-DD0B27\",\"reference\":\"YT-PAY-YT20260630DD0B27-E437A8A6\"}', '2026-06-30 12:56:49'),
(410, 23, 'payment_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"order_number\":\"YT-20260630-DD0B27\",\"reference\":\"YT-PAY-YT20260630DD0B27-E437A8A6\"}', '2026-06-30 12:58:14'),
(411, 23, 'payment_verify', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reference\":\"YT-PAY-YT20260630DD0B27-E437A8A6\",\"order_number\":\"YT-20260630-DD0B27\"}', '2026-06-30 12:58:14'),
(412, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 12:59:59'),
(413, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:00:14'),
(414, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:00:29'),
(415, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:00:39'),
(416, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:01:14'),
(417, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 13:01:44'),
(418, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:02:47'),
(419, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:02:47'),
(420, 22, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-30 13:02:49'),
(421, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:03:26'),
(422, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:03:47'),
(423, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:03:47'),
(424, 23, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"yarotechnetworklimited@gmail.com\"}', '2026-06-30 13:03:52'),
(425, NULL, 'login_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-06-30 13:04:22'),
(426, 22, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-30 13:04:44'),
(427, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 13:10:22'),
(428, NULL, 'login_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-06-30 13:12:21'),
(429, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:12:47'),
(430, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:12:47'),
(431, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:12:53'),
(432, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:13:08'),
(433, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:13:49'),
(434, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:13:49'),
(435, 22, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-06-30 13:14:13'),
(436, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 13:20:09'),
(437, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:52:01'),
(438, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 13:52:20'),
(439, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 13:53:18'),
(440, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 14:05:45'),
(441, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 14:06:02'),
(442, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 14:22:44'),
(443, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 14:31:55'),
(444, NULL, 'admin_auth_failed', 'failed', '98.97.76.64', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-06-30 15:21:59'),
(445, 24, 'user_registered', 'success', '98.97.76.64', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeeduthmanabdullahi@gmail.com\"}', '2026-06-30 16:39:11'),
(446, 24, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeeduthmanabdullahi@gmail.com\"}', '2026-06-30 16:39:51'),
(447, 24, 'payment_initialize', 'success', '98.97.76.64', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"order_number\":\"YT-20260630-6E6B86\",\"reference\":\"YT-PAY-YT202606306E6B86-3A0A47DB\"}', '2026-06-30 16:40:23'),
(448, 24, 'payment_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"order_number\":\"YT-20260630-6E6B86\",\"reference\":\"YT-PAY-YT202606306E6B86-3A0A47DB\"}', '2026-06-30 16:41:05'),
(449, 24, 'payment_verify', 'success', '98.97.76.64', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"reference\":\"YT-PAY-YT202606306E6B86-3A0A47DB\",\"order_number\":\"YT-20260630-6E6B86\"}', '2026-06-30 16:41:05'),
(450, NULL, 'login_failed', 'failed', '66.102.8.132', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-06-30 16:41:07'),
(451, 11, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-06-30 16:42:46'),
(452, 24, 'login_success', 'success', '98.97.76.64', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeeduthmanabdullahi@gmail.com\"}', '2026-06-30 16:43:31'),
(453, 22, 'login_success', 'success', '129.222.206.71', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-01 10:11:08'),
(454, 20, 'login_success', 'success', '102.91.134.68', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\"}', '2026-07-01 15:22:29'),
(455, 22, 'login_success', 'success', '135.129.124.125', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-01 16:06:55'),
(456, 22, 'login_success', 'success', '135.129.124.125', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-01 16:43:45'),
(457, 11, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-02 10:03:53'),
(458, 11, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-02 11:03:09'),
(459, 22, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-02 11:28:34'),
(460, 22, 'login_success', 'success', '102.91.134.68', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-02 11:28:57'),
(461, 22, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-02 11:51:13'),
(462, NULL, 'login_failed', 'failed', '102.91.134.68', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-02 12:02:16'),
(463, 20, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"elsadeeq24@gmail.com\"}', '2026-07-02 12:03:16'),
(464, 11, 'login_success', 'success', '102.91.134.68', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-02 12:45:50'),
(465, 22, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-02 13:12:40'),
(466, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-02 13:22:54'),
(467, 22, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-02 13:34:34'),
(468, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-02 14:28:54'),
(469, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidu@yarotech.com.ng\",\"reason\":\"Invalid email or password\"}', '2026-07-02 14:29:08'),
(470, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"info@yarotech.com.ng\",\"reason\":\"Invalid email or password\"}', '2026-07-02 14:29:18'),
(471, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-02 14:29:24'),
(472, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-02 14:29:39'),
(473, 19, 'login_success', 'success', '102.91.71.199', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-02 21:57:46');
INSERT INTO `user_activity_logs` (`id`, `user_id`, `activity_type`, `status`, `ip_address`, `user_agent`, `metadata`, `created_at`) VALUES
(474, 25, 'user_registered', 'success', '102.91.71.199', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeedusmanabdullahi@gmail.com\"}', '2026-07-02 22:02:45'),
(475, 25, 'login_success', 'success', '102.91.71.199', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeedusmanabdullahi@gmail.com\"}', '2026-07-02 22:03:26'),
(476, NULL, 'login_failed', 'failed', '102.91.71.199', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":null,\"reason\":\"Missing bearer token on protected endpoint.\"}', '2026-07-02 22:28:12'),
(477, 25, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeedusmanabdullahi@gmail.com\"}', '2026-07-03 10:24:42'),
(478, 25, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeedusmanabdullahi@gmail.com\"}', '2026-07-03 10:24:48'),
(479, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 10:24:52'),
(480, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 10:38:04'),
(481, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 10:38:19'),
(482, 11, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-03 10:41:36'),
(483, 11, 'pos_sale_created', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"order_number\":\"YT-20260703-62B898\",\"customer_name\":\"Walk-in customer\",\"total_amount\":129000}', '2026-07-03 11:35:30'),
(484, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:29:22'),
(485, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"engineer@yarotech.com.ng\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:29:28'),
(486, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:29:38'),
(487, 25, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeedusmanabdullahi@gmail.com\"}', '2026-07-03 14:29:54'),
(488, 25, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeedusmanabdullahi@gmail.com\"}', '2026-07-03 14:30:59'),
(489, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:31:59'),
(490, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:32:07'),
(491, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:32:38'),
(492, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:33:08'),
(493, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:33:15'),
(494, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:33:21'),
(495, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:33:28'),
(496, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:33:37'),
(497, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"info@yarotech.com.ng\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:34:05'),
(498, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:35:11'),
(499, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:35:12'),
(500, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:36:32'),
(501, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:36:35'),
(502, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:36:35'),
(503, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:37:13'),
(504, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:37:26'),
(505, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:37:49'),
(506, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:39:02'),
(507, NULL, 'login_failed', 'failed', '98.97.77.70', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@gmail.com\",\"reason\":\"Invalid email or password\"}', '2026-07-03 14:40:07'),
(508, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 14:40:36'),
(509, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 15:00:36'),
(510, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 15:41:42'),
(511, 22, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-03 16:19:51'),
(512, 22, 'pos_sale_created', 'success', '98.97.77.70', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"order_number\":\"YT-20260703-A3173A\",\"customer_name\":\"Auwal Sucodi\",\"total_amount\":86000}', '2026-07-03 16:23:04'),
(513, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 16:53:15'),
(514, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 16:53:24'),
(515, 19, 'login_success', 'success', '98.97.77.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-03 16:55:39'),
(516, 22, 'pos_sale_created', 'success', '102.91.77.45', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"order_number\":\"YT-20260703-39E29C\",\"customer_name\":\"Auwalu Sucodi 2\",\"total_amount\":86000}', '2026-07-03 17:14:30'),
(517, NULL, 'admin_auth_failed', 'failed', '102.91.93.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-07-03 23:38:04'),
(518, 11, 'login_success', 'success', '102.91.93.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-03 23:38:27'),
(519, NULL, 'admin_auth_failed', 'failed', '102.91.93.139', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-07-03 23:38:59'),
(520, 11, 'login_success', 'success', '102.91.72.128', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-04 05:34:56'),
(521, 11, 'pos_sale_created', 'success', '102.91.72.128', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"order_number\":\"YT-20260704-C8839F\",\"customer_name\":\"Walk-in customer\",\"total_amount\":1236250}', '2026-07-04 05:36:18'),
(522, 19, 'login_success', 'success', '102.91.72.128', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-04 05:37:35'),
(523, 19, 'login_success', 'success', '102.91.72.128', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-04 05:37:48'),
(524, 19, 'login_success', 'success', '102.91.72.128', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-04 06:05:21'),
(525, 11, 'login_success', 'success', '102.91.105.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-07 06:09:16'),
(526, 19, 'login_success', 'success', '102.91.105.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-07 06:13:29'),
(527, 11, 'login_success', 'success', '98.97.76.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-07 11:25:17'),
(528, 19, 'login_success', 'success', '98.97.76.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-07 11:56:55'),
(529, 11, 'login_success', 'success', '98.97.76.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-07 12:54:11'),
(530, 19, 'login_success', 'success', '98.97.76.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-07 13:06:07'),
(531, 19, 'login_success', 'success', '98.97.76.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-07 13:30:49'),
(532, 19, 'login_success', 'success', '98.97.76.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-07 13:32:51'),
(533, 19, 'login_success', 'success', '98.97.76.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '{\"email\":\"saeed@yarotech.com.ng\"}', '2026-07-07 13:33:00'),
(534, NULL, 'admin_auth_failed', 'failed', '102.91.135.158', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '{\"reason\":\"Missing bearer token for admin endpoint\"}', '2026-07-07 13:57:37'),
(535, 22, 'login_success', 'success', '102.91.135.158', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"email\":\"alhassanabubakarismail@gmail.com\"}', '2026-07-07 14:02:56'),
(536, 22, 'pos_sale_created', 'success', '102.91.135.158', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"order_number\":\"YT-20260707-B095E6\",\"customer_name\":\"Kurr\",\"total_amount\":86000}', '2026-07-07 14:03:48'),
(537, 22, 'pos_sale_created', 'success', '102.91.135.158', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"order_number\":\"YT-20260707-2F49F6\",\"customer_name\":\"Aliyu Huawei\",\"total_amount\":86000}', '2026-07-07 14:04:31'),
(538, 22, 'pos_sale_created', 'success', '102.91.135.158', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"order_number\":\"YT-20260707-9D8A27\",\"customer_name\":\"Auwalu Sucodi\",\"total_amount\":1462000}', '2026-07-07 14:05:32'),
(539, 22, 'pos_sale_created', 'success', '102.91.135.158', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', '{\"order_number\":\"YT-20260707-97F335\",\"customer_name\":\"Aliyu Huawei Conti.\",\"total_amount\":344000}', '2026-07-07 14:07:03'),
(540, 11, 'login_success', 'success', '129.222.206.140', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '{\"email\":\"saidua2018@gmail.com\"}', '2026-07-08 10:47:09');

-- --------------------------------------------------------

--
-- Table structure for table `user_addresses`
--

CREATE TABLE `user_addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `label` varchar(60) DEFAULT NULL,
  `full_name` varchar(150) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `address_line1` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL DEFAULT 'Nigeria',
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_activity_logs_staff` (`staff_id`),
  ADD KEY `idx_activity_logs_read` (`is_read`);

--
-- Indexes for table `auth_otps`
--
ALTER TABLE `auth_otps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_auth_otps_email_purpose` (`email`,`purpose`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_carts_user` (`user_id`),
  ADD KEY `idx_carts_session` (`session_token`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_cart_product` (`cart_id`,`product_id`),
  ADD KEY `idx_cart_items_cart` (`cart_id`),
  ADD KEY `fk_cart_items_product` (`product_id`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact_status` (`status`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_customers_phone` (`phone`),
  ADD KEY `idx_customers_email` (`email`),
  ADD KEY `idx_customers_name` (`full_name`);

--
-- Indexes for table `delivery_zones`
--
ALTER TABLE `delivery_zones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_zone_state_city` (`state`,`city_or_lga`);

--
-- Indexes for table `email_logs`
--
ALTER TABLE `email_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email_logs_status` (`status`),
  ADD KEY `idx_email_logs_type` (`email_type`),
  ADD KEY `idx_email_logs_recipient` (`recipient_email`);

--
-- Indexes for table `inventory_movements`
--
ALTER TABLE `inventory_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_inv_mov_product` (`product_id`,`created_at`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_invoice_number` (`invoice_number`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_role` (`role_target`,`is_read`),
  ADD KEY `idx_notifications_user` (`user_id`,`is_read`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_orders_number` (`order_number`),
  ADD KEY `idx_orders_user` (`user_id`),
  ADD KEY `idx_orders_status` (`order_status`,`payment_status`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_items_order` (`order_id`);

--
-- Indexes for table `order_tracking`
--
ALTER TABLE `order_tracking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tracking_order` (`order_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_payments_reference` (`reference`),
  ADD KEY `idx_payments_order` (`order_id`);

--
-- Indexes for table `payment_events`
--
ALTER TABLE `payment_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_payment_events_ref` (`reference`),
  ADD KEY `idx_payment_events_pid` (`payment_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_products_slug` (`slug`),
  ADD UNIQUE KEY `uniq_products_sku` (`sku`),
  ADD KEY `idx_products_category` (`category`),
  ADD KEY `idx_products_status` (`status`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_images_product` (`product_id`,`is_primary`,`sort_order`);

--
-- Indexes for table `product_related`
--
ALTER TABLE `product_related`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_related_pair` (`product_id`,`related_product_id`),
  ADD KEY `idx_related_product` (`product_id`),
  ADD KEY `fk_related_p2` (`related_product_id`);

--
-- Indexes for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reviews_product` (`product_id`,`status`),
  ADD KEY `idx_reviews_user` (`user_id`);

--
-- Indexes for table `product_specifications`
--
ALTER TABLE `product_specifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_specs_product` (`product_id`,`sort_order`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_settings_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_users_email` (`email`);

--
-- Indexes for table `user_activity_logs`
--
ALTER TABLE `user_activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_activity` (`user_id`,`activity_type`);

--
-- Indexes for table `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_addresses_user` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=520;

--
-- AUTO_INCREMENT for table `auth_otps`
--
ALTER TABLE `auth_otps`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `delivery_zones`
--
ALTER TABLE `delivery_zones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `email_logs`
--
ALTER TABLE `email_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `inventory_movements`
--
ALTER TABLE `inventory_movements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=350;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49595922;

--
-- AUTO_INCREMENT for table `order_tracking`
--
ALTER TABLE `order_tracking`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=293;

--
-- AUTO_INCREMENT for table `payment_events`
--
ALTER TABLE `payment_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `product_related`
--
ALTER TABLE `product_related`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product_specifications`
--
ALTER TABLE `product_specifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9069;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `user_activity_logs`
--
ALTER TABLE `user_activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=541;

--
-- AUTO_INCREMENT for table `user_addresses`
--
ALTER TABLE `user_addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `fk_activity_logs_staff` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `fk_carts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cart_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inventory_movements`
--
ALTER TABLE `inventory_movements`
  ADD CONSTRAINT `fk_inv_mov_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_tracking`
--
ALTER TABLE `order_tracking`
  ADD CONSTRAINT `fk_tracking_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payment_events`
--
ALTER TABLE `payment_events`
  ADD CONSTRAINT `fk_payment_events_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `fk_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_related`
--
ALTER TABLE `product_related`
  ADD CONSTRAINT `fk_related_p1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_related_p2` FOREIGN KEY (`related_product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_specifications`
--
ALTER TABLE `product_specifications`
  ADD CONSTRAINT `fk_specs_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_activity_logs`
--
ALTER TABLE `user_activity_logs`
  ADD CONSTRAINT `fk_user_activity_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD CONSTRAINT `fk_addresses_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
