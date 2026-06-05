const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// MySQL connection configuration
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  port: parseInt(process.env.DB_PORT || '3306')
};

let pool;

async function initializeDatabase() {
  try {
    // 1. Connect without selecting database to check/create it
    console.log('Connecting to MySQL host...');
    const connection = await mysql.createConnection(dbConfig);
    
    await connection.query('CREATE DATABASE IF NOT EXISTS pizza_hub_db;');
    await connection.end();
    console.log('Database "pizza_hub_db" verified/created.');

    // 2. Establish connection pool with selected database
    pool = mysql.createPool({
      ...dbConfig,
      database: 'pizza_hub_db',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });

    // 3. Create Pizzas Table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS pizzas (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        price DECIMAL(10, 2) NOT NULL,
        imageUrl VARCHAR(500) NOT NULL,
        category VARCHAR(50) NOT NULL,
        availableOptions VARCHAR(255) NOT NULL
      );
    `);
    console.log('Table "pizzas" verified/created.');

    // 4. Create Orders Table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS orders (
        id INT AUTO_INCREMENT PRIMARY KEY,
        customerName VARCHAR(255) NOT NULL,
        customerAddress TEXT NOT NULL,
        customerPhone VARCHAR(50) NOT NULL,
        pizzaName VARCHAR(255) NOT NULL,
        crustOption VARCHAR(100) NOT NULL,
        quantity INT NOT NULL DEFAULT 1,
        price DECIMAL(10, 2) NOT NULL,
        orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log('Table "orders" verified/created.');

    // 5. Seed Pizzas if empty
    const [rows] = await pool.query('SELECT COUNT(*) as count FROM pizzas;');
    if (rows[0].count === 0) {
      console.log('Seeding initial pizza database items...');
      const seedPizzas = [
        ['Margherita', 'Classic cheese and tomato pizza with fresh basil and olive oil.', 12.99, 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=2070&auto=format&fit=crop', 'Veg', 'Thin Crust,Pan Pizza,New York Style'],
        ['Pepperoni Feast', 'Loaded with spicy pepperoni, mozzarella cheese, and our signature sauce.', 15.99, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=1780&auto=format&fit=crop', 'Non-Veg', 'Thin Crust,Pan Pizza,New York Style'],
        ['Tandoori Paneer', 'Indian fusion with spicy tandoori paneer, onions, and green peppers.', 14.99, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=2070&auto=format&fit=crop', 'Veg', 'Thin Crust,Pan Pizza,New York Style'],
        ['BBQ Chicken Deluxe', 'Smoky BBQ sauce, grilled chicken, red onions, and cilantro.', 16.99, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=1981&auto=format&fit=crop', 'Non-Veg', 'Thin Crust,Pan Pizza,New York Style'],
        ['Mexican Green Wave', 'Spicy jalapenos, bell peppers, and Mexican herbs.', 13.99, 'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?q=80&w=1935&auto=format&fit=crop', 'Veg', 'Thin Crust,Pan Pizza,New York Style'],
        ['Meat Lovers', 'Fully loaded with pepperoni, sausage, ham, and bacon.', 18.99, 'https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?q=80&w=1925&auto=format&fit=crop', 'Non-Veg', 'Thin Crust,Pan Pizza,New York Style'],
        ['Buffalo Wings', 'Spicy and tangy classic buffalo sauce wings.', 9.99, 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?q=80&w=1974&auto=format&fit=crop', 'Wings', 'Baked,Fried'],
        ['Honey BBQ Wings', 'Sweet and smoky honey glazed wings.', 10.99, 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?q=80&w=1974&auto=format&fit=crop', 'Wings', 'Baked,Fried'],
        ['Garlic Parmesan', 'Buttery wings tossed in garlic and parmesan cheese.', 11.49, 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=1770&auto=format&fit=crop', 'Wings', 'Baked,Fried'],
        ['Lemon Pepper', 'Zesty lemon and cracked pepper seasoning.', 10.49, 'https://plus.unsplash.com/premium_photo-1669742915858-a5b6c8b9f1d0?q=80&w=2070&auto=format&fit=crop', 'Wings', 'Baked,Fried'],
        ['Coca Cola', 'The classic refreshing cola taste.', 1.49, 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?q=80&w=2070&auto=format&fit=crop', 'Beverages', 'Cold,No Ice'],
        ['Sprite', 'Crisp, lemon-lime flavored soda.', 1.49, 'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?q=80&w=1974&auto=format&fit=crop', 'Beverages', 'Cold,No Ice']
      ];
      
      const insertQuery = `INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) VALUES ?;`;
      await pool.query(insertQuery, [seedPizzas]);
      console.log('Pizzas seeded successfully.');
    }
  } catch (error) {
    console.error('Database initialization failed:', error.message);
    console.log('Make sure your MySQL Server is running locally on port 3306.');
  }
}

// ----------------------------------------------------
// PIZZAS API ENDPOINTS (CRUD for Module 1)
// ----------------------------------------------------

// 1. READ ALL
app.get('/api/pizzas', async (req, res) => {
  try {
    const [pizzas] = await pool.query('SELECT * FROM pizzas ORDER BY id DESC');
    res.json(pizzas);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 2. READ SINGLE
app.get('/api/pizzas/:id', async (req, res) => {
  try {
    const [pizzas] = await pool.query('SELECT * FROM pizzas WHERE id = ?', [req.params.id]);
    if (pizzas.length === 0) return res.status(404).json({ error: 'Pizza not found' });
    res.json(pizzas[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 3. CREATE
app.post('/api/pizzas', async (req, res) => {
  const { name, description, price, imageUrl, category, availableOptions } = req.body;
  if (!name || !price || !category) {
    return res.status(400).json({ error: 'Name, price, and category are required' });
  }
  try {
    const [result] = await pool.query(
      'INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) VALUES (?, ?, ?, ?, ?, ?)',
      [name, description || '', price, imageUrl || '', category, availableOptions || '']
    );
    res.status(201).json({ id: result.insertId, name, description, price, imageUrl, category, availableOptions });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 4. UPDATE
app.put('/api/pizzas/:id', async (req, res) => {
  const { name, description, price, imageUrl, category, availableOptions } = req.body;
  try {
    const [result] = await pool.query(
      'UPDATE pizzas SET name = ?, description = ?, price = ?, imageUrl = ?, category = ?, availableOptions = ? WHERE id = ?',
      [name, description, price, imageUrl, category, availableOptions, req.params.id]
    );
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Pizza not found' });
    res.json({ message: 'Pizza updated successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 5. DELETE
app.delete('/api/pizzas/:id', async (req, res) => {
  try {
    const [result] = await pool.query('DELETE FROM pizzas WHERE id = ?', [req.params.id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Pizza not found' });
    res.json({ message: 'Pizza deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ----------------------------------------------------
// ORDERS API ENDPOINTS (CRUD for Module 2)
// ----------------------------------------------------

// 1. READ ALL
app.get('/api/orders', async (req, res) => {
  try {
    const [orders] = await pool.query('SELECT * FROM orders ORDER BY orderDate DESC');
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 2. READ SINGLE
app.get('/api/orders/:id', async (req, res) => {
  try {
    const [orders] = await pool.query('SELECT * FROM orders WHERE id = ?', [req.params.id]);
    if (orders.length === 0) return res.status(404).json({ error: 'Order not found' });
    res.json(orders[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 3. CREATE
app.post('/api/orders', async (req, res) => {
  const { customerName, customerAddress, customerPhone, pizzaName, crustOption, quantity, price } = req.body;
  if (!customerName || !customerAddress || !customerPhone || !pizzaName || !crustOption || !quantity || !price) {
    return res.status(400).json({ error: 'Missing required order fields' });
  }
  try {
    const [result] = await pool.query(
      'INSERT INTO orders (customerName, customerAddress, customerPhone, pizzaName, crustOption, quantity, price) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [customerName, customerAddress, customerPhone, pizzaName, crustOption, quantity, price]
    );
    res.status(201).json({ id: result.insertId, customerName, customerAddress, customerPhone, pizzaName, crustOption, quantity, price });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 4. UPDATE
app.put('/api/orders/:id', async (req, res) => {
  const { customerName, customerAddress, customerPhone, pizzaName, crustOption, quantity, price } = req.body;
  try {
    const [result] = await pool.query(
      'UPDATE orders SET customerName = ?, customerAddress = ?, customerPhone = ?, pizzaName = ?, crustOption = ?, quantity = ?, price = ? WHERE id = ?',
      [customerName, customerAddress, customerPhone, pizzaName, crustOption, quantity, price, req.params.id]
    );
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Order not found' });
    res.json({ message: 'Order updated successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 5. DELETE
app.delete('/api/orders/:id', async (req, res) => {
  try {
    const [result] = await pool.query('DELETE FROM orders WHERE id = ?', [req.params.id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Order not found' });
    res.json({ message: 'Order deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start Server
app.listen(PORT, async () => {
  await initializeDatabase();
  console.log(`Server is running on port ${PORT}`);
});
