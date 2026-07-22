# YAROTECH E-Commerce User Manual

**Developed by:** Saeed Usman Abdullahi  
**Developed for:** Yarotech Group  

> **PROPRIETARY AND CONFIDENTIAL:** This software and manual are industry software developed exclusively for Yarotech Group. No copy or use of any of its properties is allowed.

---

## 1. Introduction

Welcome to the Yarotech E-Commerce platform! This unified system handles online retail sales, manual point-of-sale (POS) transactions, and centralized inventory management. 

This manual is divided into two sections:
1. **The Storefront**: How customers interact with the website.
2. **The Admin Dashboard**: How staff and administrators manage the business.

---

## 2. Storefront (Customer Experience)

### Browsing & Searching
Customers can browse the active catalog natively on the homepage or via the `Products` page. 
- Use the **Search Bar** to find specific items by name or SKU.
- Use the **Category Filters** to narrow down products (e.g., Solar Panels, Inverters).

### Purchasing & Checkout
1. **Add to Cart**: Click "Add to Cart" on any product. The system automatically verifies that the item is currently in stock.
2. **Checkout**: Proceed to the cart and hit checkout. The customer will provide their shipping details.
3. **Delivery Fees**: The system calculates delivery fees dynamically based on the selected region.
4. **Payment**: Customers pay securely via the Paystack gateway (Card, Bank Transfer, USSD).
5. **Confirmation**: Upon successful payment, an automated email receipt is sent, and the customer is redirected to a success page.

### Customer Dashboard
Registered customers can log in to view their **Order History**, check the live status of their deliveries, and manage their profile details.

---

## 3. Admin Dashboard (Staff Experience)

Administrators access the backend by navigating to `/admin` and logging in with an authorized account.

### 3.1 The Dashboard Home
Provides a real-time snapshot of the business:
- **Total Revenue**: Sum of all successful ecommerce and POS payments.
- **Net Profit**: Revenue minus the base cost of goods sold.
- **Total Successful Orders**: Count of fully paid transactions.
- **Inventory Value**: The total monetary worth of all items currently sitting in the warehouse.

### 3.2 Product Management
Navigate to the **Products** tab to manage the catalog.
- **Add Product**: Click "Add Product" to open the creation drawer. You must provide a Name, SKU, and Category.
- **Pricing**: Set the Cost Price and Selling Price. The system will automatically calculate your profit margin.
- **Inventory**: Set the initial stock. If stock drops below the `Minimum Stock` threshold, the system flags it as "Low Stock".
- **Visibility**: Toggle whether a product appears on the website (Online) or is hidden (Offline, perhaps only available for POS).

### 3.3 Order Management
Navigate to the **Orders & Users** tab.
- **View Orders**: See all placed orders. Click the "Eye" icon to view customer details, purchased items, and the exact fulfillment status.
- **Change Status**: Use the dropdown next to an order to update its status (e.g., from `Paid` to `Shipped` to `Delivered`). This triggers automated email notifications to the customer.
- **Print Receipts**: For any successfully paid order, click the document icon to generate and print a professional POS-style receipt ticket.

### 3.4 Point of Sale (POS)
Navigate to the **POS Terminal** tab to log manual, walk-in sales.
1. Scan or search for a product to add it to the POS cart.
2. The system checks live inventory to ensure you don't oversell.
3. Select the payment method (e.g., Cash, POS Terminal, Transfer).
4. Complete the sale. The inventory is instantly deducted, and the revenue is added to the dashboard totals.

### 3.5 Settings
Administrators can use the **Settings** tab to dynamically adjust the store's behavior without needing a developer:
- Adjust Contact Emails & Phone Numbers.
- Configure flat-rate or regional delivery fees.
- Toggle site-wide maintenance modes.
