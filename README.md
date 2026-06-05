# PizzaHub - Full-Stack Pizza Ordering Application

PizzaHub is a premium, full-stack mobile application designed for ordering pizzas, sides (wings), and beverages. The project features a robust **Flutter frontend** with state management powered by **Provider**, and a backend built on **Node.js, Express, and MySQL** to handle RESTful operations for users, menu management, and order placement.

---

## 🚀 Key Features

*   **Responsive Browsing**: Filter items by categories (Veg, Non-Veg, Wings, Beverages) with real-time text-based search.
*   **Detailed Customization**: Choose preferences like crust styles (Thin Crust, Pan Pizza, New York Style), beverage options, and wings preparation styles.
*   **Order Management**: Complete workflow to place, edit, or cancel orders with real-time feedback.
*   **Admin Panel (Full CRUD)**: Dedicated management screen for administrators to add, update, list, and delete items from the menu.
*   **Robust Network Fallbacks**: Customized image error handling to render premium visual icons if network requests or external image URLs fail to load.
*   **User Authentication**: Sleek Login and Signup screens to manage user sessions.

---

## 🛠️ Technology Stack

*   **Frontend**: Flutter (Dart)
*   **State Management**: Provider (ChangeNotifier)
*   **Backend**: Node.js, Express.js
*   **Database**: MySQL
*   **API Protocol**: RESTful API (HTTP Client)

---

## 📂 Project Structure

```text
pizza-app/
├── backend/                  # Node.js backend server
│   ├── server.js             # Express application & DB connection pool
│   ├── schema.sql            # MySQL database schema & seed data
│   ├── package.json          # Node dependencies and npm scripts
│   └── .env                  # Port and Database environment variables
├── lib/                      # Flutter source code
│   ├── models/               # Data models (Pizza, Order)
│   ├── providers/            # State management classes (PizzaProvider, OrderProvider)
│   ├── screens/              # Screens (Login, SignUp, Home, Details, Profile, Admin, Form)
│   ├── widgets/              # Reusable UI components (PizzaCard)
│   └── utils/                # Configuration and styling (ApiConfig, AppTheme)
└── pubspec.yaml              # Flutter packages & dependencies configuration
```

---

## ⚙️ Setup and Installation Instructions

Follow these steps to configure and run PizzaHub locally:

### 1. Database Setup (MySQL)
1. Ensure you have a MySQL server running locally (e.g., via XAMPP, WAMP, or standalone installer) on port `3306`.
2. Import the database schema and seed data by running the SQL queries in `backend/schema.sql`.

### 2. Backend Server Setup (Node.js)
1. Navigate to the `backend/` directory:
   ```bash
   cd backend
   ```
2. Install npm dependencies:
   ```bash
   npm install
   ```
3. Configure your environmental variables by updating the `.env` file with your database credentials:
   ```env
   PORT=5000
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=YOUR_DB_PASSWORD
   DB_PORT=3306
   ```
4. Start the server:
   ```bash
   npm start
   ```
   *The console should print: `Server is running on port 5000` and `Database "pizza_hub_db" verified/created.`*

### 3. Frontend App Setup (Flutter)
1. Open a new terminal in the root directory.
2. Update the host server configuration inside `lib/utils/api_config.dart` with your computer's local network IP address (or `10.0.2.2` if testing solely on the default Android emulator).
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Clear the build cache (recommended for fresh compilation):
   ```bash
   flutter clean
   ```
5. Run the application:
   ```bash
   flutter run
   ```
