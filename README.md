# inventory — Inventory & Sales Management

> [Leer en Español](README.es.md)

A complete inventory and sales management web application built with **Ruby on Rails 8**. It allows multi-user management, real-time inventory tracking, categorization, stock decrement transactions, metric dashboards, and CSV report exports.

---

##  Features

**Multi-User Authentication:** Secure user registration, session management, and data isolation powered by `Devise`.
**Full Product CRUD:** Add, list, edit, and delete products with validations.
**Category System (1-to-N):** Organize products by user-defined categories.
**Live Search & Filters:** Filter products instantly by text search and category dropdowns.
**Stock & Sales Transactions:** Single-click "Sell 1" action with stock verification and atomic transactions.
 **Business Metrics Dashboard:** Real-time summary cards for:
 Total earnings from sales.
 Total monetary value of current inventory.
 Out-of-stock item counter.
 **CSV Export:** Download full inventory reports compatible with Microsoft Excel and Google Sheets.

---

##  Tech Stack

 **Backend:** Ruby on Rails 8
 **Database:** SQLite3
 **Authentication:** Devise
 **Data Export:** Ruby Standard Library (`csv`)
 **Frontend:** ERB, Responsive CSS

---


### Prerequisites

Ensure you have the following installed:
 **Ruby** (>= 3.3.0)
 **Rails** (>= 8.0)
 **Git**

### Render
https://shopify-z885.onrender.com/users/sign_in