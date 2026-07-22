# Yarotech E-Commerce Production Deployment Guide

**Developed by:** Saeed Usman Abdullahi  
**Developed for:** Yarotech Group  

> **PROPRIETARY AND CONFIDENTIAL:** This software and documentation are industry software developed exclusively for Yarotech Group. No copy or use of any of its properties is allowed.

---

This document outlines the standard operating procedures for taking the Yarotech E-Commerce platform (Frontend + PHP Backend) to a live production environment.

## 1. Frontend Deployment (React / Vite)

The frontend is a Single Page Application (SPA) built with React, Vite, and TanStack Router.

### Build Steps
1. **Prerequisites**: Ensure you have Node.js (v18 or higher) installed on your build server.
2. **Environment Variables**: Create a `.env` file in the root directory (based on `.env.example`) and ensure the production variables are set:
   ```env
   VITE_API_BASE_URL="https://shop.y.yarotech.com.ng/yarotech-api/public/api"
   VITE_GOOGLE_CLIENT_ID="your_production_google_client_id"
   ```
3. **Install Dependencies**: 
   ```bash
   npm install
   ```
4. **Compile the App**:
   ```bash
   npm run build
   ```
   *This command creates an optimized production bundle inside the `dist/client` directory.*

### Hosting
- Upload the contents of the `dist/client` folder to your web server (e.g., cPanel, Hostinger, or a VPS).
- **Critical Requirement**: Because this is a Single Page Application, your server MUST redirect all unknown traffic to `index.html`. 
- *Note: If you are using an Apache server (like cPanel), the `.htaccess` file we provided in the `public/` directory will automatically handle this SPA routing for you.*

---

## 2. Backend Deployment (PHP API)

The backend handles all business logic, database connections, email dispatches, and payment verification.

### Setup Steps
1. **Prerequisites**: PHP 8.1+ and a MySQL/MariaDB database.
2. **Environment Configuration**: 
   Inside the `yarotech-api/` directory, copy your `.env.example` to `.env` and fill in your production credentials:
   - **Database**: Host, Name, User, Password
   - **JWT Secret**: Generate a strong random string for secure user sessions.
   - **SMTP Credentials**: Required for sending OTPs and receipts.
   - **Paystack Keys**: Ensure you use your **Live** Secret and Public keys.
3. **Document Root**: 
   Configure your web server so that the backend API URL (e.g., `/yarotech-api/public`) points directly to the `yarotech-api/public` folder. 
   *(Do not expose the entire `yarotech-api` folder to the web, only the `public` directory).*
4. **Permissions**: 
   If your backend framework writes logs or uploads files, ensure that the respective storage directories have write permissions (usually `chmod 775`).

---

## 3. External Services & SEO Configuration

Before officially launching the site, complete these external configuration steps.

### A. Google OAuth Setup
If users try to log in with Google and see a `401: invalid_client` error, it is because your live domain is not allowlisted.
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Navigate to **APIs & Services > Credentials**.
3. Edit your OAuth 2.0 Client ID.
4. Under **Authorized JavaScript origins**, add your exact production URL without a trailing slash (e.g., `https://shop.y.yarotech.com.ng`).

### B. Paystack Webhooks
To ensure orders are automatically marked as "Paid" if a user closes their browser too quickly during checkout:
1. Log in to your [Paystack Dashboard](https://dashboard.paystack.com/).
2. Go to **Settings > API Keys & Webhooks**.
3. Set your Live Webhook URL to: `https://shop.y.yarotech.com.ng/yarotech-api/public/api/payments/webhook`.

### C. Search Engine Optimization (SEO)
Your codebase is already highly optimized with Server-Side Rendering capabilities, dynamic meta-tags, and semantic HTML.
1. **Robots.txt**: We have already configured this file to block crawlers from your `/admin` panel while allowing access to products.
2. **Dynamic Sitemap**: The backend has been configured to dynamically generate an XML sitemap of all your live products.
3. **Google Search Console**:
   - Go to [Google Search Console](https://search.google.com/search-console).
   - Add your domain (`shop.y.yarotech.com.ng`) and verify ownership.
   - Navigate to the **Sitemaps** section and submit your sitemap URL: `https://shop.y.yarotech.com.ng/sitemap.xml`.
   - *This ensures Google instantly discovers all your products and any new products you add in the future.*
