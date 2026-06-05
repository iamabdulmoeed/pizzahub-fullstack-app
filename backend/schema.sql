-- Create Database
CREATE DATABASE IF NOT EXISTS pizza_hub_db;
USE pizza_hub_db;

-- Table structure for pizzas
CREATE TABLE IF NOT EXISTS pizzas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  imageUrl VARCHAR(500) NOT NULL,
  category VARCHAR(50) NOT NULL,
  availableOptions VARCHAR(255) NOT NULL
);

-- Table structure for orders
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

-- Insert initial Pizzas if table is empty
INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Margherita', 'Classic cheese and tomato pizza with fresh basil and olive oil.', 12.99, 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=2070&auto=format&fit=crop', 'Veg', 'Thin Crust,Pan Pizza,New York Style'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Margherita');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Pepperoni Feast', 'Loaded with spicy pepperoni, mozzarella cheese, and our signature sauce.', 15.99, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=1780&auto=format&fit=crop', 'Non-Veg', 'Thin Crust,Pan Pizza,New York Style'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Pepperoni Feast');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Tandoori Paneer', 'Indian fusion with spicy tandoori paneer, onions, and green peppers.', 14.99, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=2070&auto=format&fit=crop', 'Veg', 'Thin Crust,Pan Pizza,New York Style'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Tandoori Paneer');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'BBQ Chicken Deluxe', 'Smoky BBQ sauce, grilled chicken, red onions, and cilantro.', 16.99, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=1981&auto=format&fit=crop', 'Non-Veg', 'Thin Crust,Pan Pizza,New York Style'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'BBQ Chicken Deluxe');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Mexican Green Wave', 'Spicy jalapenos, bell peppers, and Mexican herbs.', 13.99, 'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?q=80&w=1935&auto=format&fit=crop', 'Veg', 'Thin Crust,Pan Pizza,New York Style'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Mexican Green Wave');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Meat Lovers', 'Fully loaded with pepperoni, sausage, ham, and bacon.', 18.99, 'https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?q=80&w=1925&auto=format&fit=crop', 'Non-Veg', 'Thin Crust,Pan Pizza,New York Style'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Meat Lovers');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Buffalo Wings', 'Spicy and tangy classic buffalo sauce wings.', 9.99, 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?q=80&w=1974&auto=format&fit=crop', 'Wings', 'Baked,Fried'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Buffalo Wings');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Honey BBQ Wings', 'Sweet and smoky honey glazed wings.', 10.99, 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?q=80&w=1974&auto=format&fit=crop', 'Wings', 'Baked,Fried'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Honey BBQ Wings');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Garlic Parmesan', 'Buttery wings tossed in garlic and parmesan cheese.', 11.49, 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=1770&auto=format&fit=crop', 'Wings', 'Baked,Fried'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Garlic Parmesan');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Lemon Pepper', 'Zesty lemon and cracked pepper seasoning.', 10.49, 'https://plus.unsplash.com/premium_photo-1669742915858-a5b6c8b9f1d0?q=80&w=2070&auto=format&fit=crop', 'Wings', 'Baked,Fried'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Lemon Pepper');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Coca Cola', 'The classic refreshing cola taste.', 1.49, 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?q=80&w=2070&auto=format&fit=crop', 'Beverages', 'Cold,No Ice'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Coca Cola');

INSERT INTO pizzas (name, description, price, imageUrl, category, availableOptions) 
SELECT 'Sprite', 'Crisp, lemon-lime flavored soda.', 1.49, 'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?q=80&w=1974&auto=format&fit=crop', 'Beverages', 'Cold,No Ice'
WHERE NOT EXISTS (SELECT 1 FROM pizzas WHERE name = 'Sprite');
