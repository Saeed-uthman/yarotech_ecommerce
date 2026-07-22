# YAROTECH E-Commerce API Documentation

**Developed by:** Saeed Usman Abdullahi  
**Developed for:** Yarotech Group  

> **PROPRIETARY AND CONFIDENTIAL:** This API and documentation are industry software developed exclusively for Yarotech Group. No copy or use of any of its properties is allowed.

---

## Overview

The Yarotech API is a RESTful backend written in plain PHP (8.1+) utilizing a custom lightweight routing engine. It strictly consumes and responds with JSON. 

**Base URL**: `https://api.y.yarotech.com.ng` (Production) or `http://localhost:8000` (Local)

## Authentication

The API uses **Stateless JSON Web Tokens (JWT)**.
Clients must include the token in the `Authorization` header of all protected requests.

```http
Authorization: Bearer <your_jwt_token>
```

Tokens are obtained by logging in via the `/api/auth/login` endpoint.

---

## Core Endpoints

### 1. Authentication

#### `POST /api/auth/register`
Creates a new customer account.
- **Payload**: `email`, `password`, `first_name`, `last_name`, `phone`
- **Response**: User object and access token (if verification isn't required immediately).

#### `POST /api/auth/login`
Authenticates a user and issues a JWT.
- **Payload**: `email`, `password`
- **Response**: JWT `token` and `user` object.

#### `POST /api/auth/google`
Authenticates or registers a user via Google Sign-In. New accounts must verify via OTP.
- **Payload**: `credential` (Google ID token)
- **Response**: JWT `token` or an OTP challenge requirement.

---

### 2. Products (Public)

#### `GET /api/products`
Retrieves a paginated list of active, online-visible products.
- **Query Params**: `page`, `limit`, `search`, `category`, `sort`
- **Response**: Array of product objects and pagination metadata.

#### `GET /api/products/:slug`
Retrieves a single product's detailed information by its unique slug.
- **Response**: Product object, specifications, gallery images, and reviews.

#### `GET /api/categories`
Retrieves a list of available product categories with counts.

---

### 3. Cart & Checkout (Protected / Guest)

#### `POST /api/checkout/preview`
Calculates totals, taxes, and delivery fees based on cart items before payment.
- **Payload**: `items` (array of sku/qty), `delivery_state`, `delivery_method`
- **Response**: Detailed breakdown of `subtotal`, `delivery_fee`, `vat`, `total`.

#### `POST /api/checkout/initialize`
Creates the order in `awaiting_payment` status and initializes the Paystack transaction.
- **Payload**: Customer details, delivery info, and `items`.
- **Response**: Order ID, `authorization_url`, and Paystack `reference`.

#### `POST /api/payment/verify`
Idempotent webhook or client-triggered endpoint to verify a Paystack reference.
- **Payload**: `reference`
- **Response**: Verifies payment, deducts stock, sets order to `paid`, and sends emails.

---

### 4. Admin Dashboard (Protected: Admin Only)

All routes under `/api/admin/*` require a JWT belonging to a user with the `admin` role.

#### `GET /api/admin/dashboard`
Fetches aggregate statistics for the dashboard UI.
- **Response**: `total_orders`, `total_revenue`, `net_profit`, `total_inventory_value`, `total_products`.

#### `GET /api/admin/products`
Retrieves all products (including inactive and offline) for admin management.

#### `POST /api/admin/products`
Creates a new product in the database.

#### `GET /api/admin/orders`
Retrieves all orders.

#### `PUT /api/admin/orders/:id/status`
Updates an order's status (e.g., from `paid` to `shipped`).
- **Payload**: `status`

#### `POST /api/admin/pos/sale`
Logs a manual in-store sale. Deducts inventory immediately.
- **Payload**: `items`, `payment_method`, `amount_paid`

---

## Error Handling

The API returns standard HTTP status codes along with a JSON body describing the error.

**Success format (2xx)**:
```json
{
  "status": "success",
  "data": { ... }
}
```

**Error format (4xx / 5xx)**:
```json
{
  "status": "error",
  "message": "Invalid email or password",
  "errors": { ... } // Optional field-level validation errors
}
```

### Common Status Codes:
- **200 OK**: Request succeeded.
- **201 Created**: Resource successfully created.
- **400 Bad Request**: Validation failed or malformed request.
- **401 Unauthorized**: Missing or invalid JWT.
- **403 Forbidden**: Authenticated, but missing required role (e.g., Admin).
- **404 Not Found**: Resource doesn't exist.
- **500 Internal Server Error**: Backend exception or database error.
