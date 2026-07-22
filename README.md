# YAROTECH E-Commerce Platform

**Developed by:** Saeed Usman Abdullahi  
**Developed for:** Yarotech Group  

> **PROPRIETARY AND CONFIDENTIAL:** This system is an industry software developed exclusively for Yarotech Group. **No copy or use of any of its properties is allowed under any circumstances.** Unauthorized reproduction, distribution, or usage of this software or any portion of it is strictly prohibited.

---

## Overview

Full-stack, standalone YAROTECH ecommerce system powered by a **React 19** frontend and a **PHP 8.1+ & MySQL** backend. 

The platform operates as a completely decoupled, independent system with a unified database. It acts as the central source of truth for products, orders, customers, and inventory.

## System Functionality & Features

### 1. Product & Inventory Management
- **Centralized Products**: All product data (price, SKU, stock quantity, descriptions, specifications, warranty, images) is stored natively within the platform.
- **Inventory Tracking**: The system tracks stock changes via the `inventory_movements` table, securely reducing stock upon successful checkout or manual sale. Low stock boundaries trigger notifications.
- **Related Products & Reviews**: Allows cross-selling through related product associations and provides a customer review system with an approval workflow.

### 2. Shopping & Checkout
- **Cart Management**: Secure, session-based and user-based cart item storage.
- **Delivery Calculation**: Integrated delivery fee calculations based on region and settings.
- **Checkout & Payments**: Seamless checkout flow utilizing the Paystack API for secure, real-time payment processing. 
- **Stock Guard**: Validates that sufficient inventory exists before allowing a checkout to proceed.

### 3. Order Management & In-Store Sales
- **E-Commerce Orders**: Customers can track their placed orders, while administrators manage fulfillment states and delivery.
- **In-Store (Manual) Sales**: Administrators and staff can quickly log physical walk-in sales from the dashboard using various payment methods (Cash, POS Terminal, Transfer). These sales instantly deduct from the platform's central inventory.

### 4. Admin Dashboard & Analytics
- **Comprehensive Metrics**: View total revenue, recent orders, top-selling products, and stock alerts.
- **User Management**: Oversee registered users, admin roles, and audit their activity logs.
- **Settings & Configuration**: Dynamic control over store settings, delivery zones, and contact information without touching code.

### 5. Support & Communications
- **Contact Inbox**: Customers can send inquiries via the frontend Contact page, which flow directly into the Admin dashboard's message inbox.
- **Notifications**: In-app notifications for both Admins (e.g., new order, low stock) and Users (e.g., payment success, order shipped).
- **Email System**: SMTP-powered transactional emails (PHPMailer) for order confirmations, welcome emails, and password resets.

---

## Repository Structure

```text
yarotech-e-commerce/
|- src/                    # Frontend (React 19 + TanStack + Vite + TypeScript)
|- yarotech-api/           # Backend (Plain PHP 8.1+ + MySQL)
|- package.json            # Frontend scripts and dependencies
|- vite.config.ts          # Frontend build config
\- README.md               # Root documentation
```

## Tech Stack

**Frontend:**
- React 19, TypeScript
- TanStack Router, Zustand, React Query, Recharts
- Tailwind CSS 4

**Backend:**
- PHP 8.1+ (No heavy framework, custom lightweight routing)
- MySQL / MariaDB (InnoDB)
- PHPMailer (SMTP emails)
- Firebase JWT (Authentication)
- Dotenv (Environment configuration)

---

## Local Setup Guide

### 1. Database Initialization

The entire database architecture has been consolidated into a single unified schema file.

```bash
mysql -u root -e "CREATE DATABASE yarotech_pos_e-commerce;"
mysql -u root yarotech_pos_e-commerce < yarotech-api/database/schema.sql
```
*(Optional) You may seed the database with mock data if a `seed.sql` is provided.*

### 2. Backend Configuration

Navigate to the API folder and install dependencies:

```bash
cd yarotech-api
composer install
cp .env.example .env
```

Open `.env` and fill in your environment variables:
- `DB_*` (Database credentials)
- `JWT_SECRET_OR_APP_KEY` (Random string for tokens)
- `PAYSTACK_*` (Test or Live API keys)
- `MAIL_*` (SMTP credentials for transactional emails)
- `FRONTEND_URL` (e.g., `http://localhost:5173`)

**Serve Backend:**
Point your local Apache/Nginx document root to `yarotech-api/public/` or run PHP's built-in server:
```bash
cd yarotech-api/public
php -S localhost:8000
```
*Health check URL: `http://localhost:8000/api/health`*

### 3. Frontend Configuration

Navigate to the repository root:

```bash
npm install
```

Create a `.env` file for Vite if necessary (or set the URL directly in `src/api/client.ts`):
```env
VITE_API_BASE_URL=http://localhost:8000
```

Start the development server:
```bash
npm run dev
```

The storefront and admin panels will be accessible at `http://localhost:5173`.

---

## Security & Compliance
- **Authentication**: JWT-based stateless authentication for user and admin sessions.
- **Authorization**: Strict role-based middleware guards all admin dashboard endpoints.
- **SQL Injection Prevention**: 100% usage of PDO Prepared Statements across all models.
- **Audit Trails**: All significant actions (orders, payments, login failures) write to the `user_activity` and `notifications` logs.
- **CORS Protection**: Configured via backend middleware to only accept requests from trusted frontend URLs.

## Deployment Notes
1. Upload the `yarotech-api` code to a non-public directory on your server.
2. Symlink or expose **only** `yarotech-api/public` to the web (e.g., via a subdomain `api.yarotech.com.ng`).
3. Ensure `.htaccess` (provided) is active to route all API traffic to `index.php` and prevent cPanel from hijacking HTTP error codes.
4. Ensure the `public/uploads/` directory is writable by the web server user.
5. Build the React frontend (`npm run build`) and upload the `dist/` contents to your main domain public root.
