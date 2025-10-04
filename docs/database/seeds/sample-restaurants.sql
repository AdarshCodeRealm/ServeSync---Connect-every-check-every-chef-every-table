-- Sample Restaurant Data for Digital Menu Card System
-- This file contains realistic restaurant, menu, and menu item data for development and testing

-- Insert sample restaurants
INSERT INTO restaurants (id, user_id, name, slug, description, cuisine_type, address, phone, email, website, business_hours, settings, status, created_at) VALUES
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Tasty Bites Bistro', 'tasty-bites-bistro', 'A cozy neighborhood bistro serving fresh, locally-sourced American cuisine with a modern twist.', 'American', 
 '{"street": "123 Main Street", "city": "New York", "state": "NY", "zip": "10001", "country": "USA", "lat": 40.7589, "lng": -73.9851}',
 '+1-555-TASTY1', 'info@tastybites.com', 'https://tastybites.com',
 '{"monday": {"open": "11:00", "close": "22:00", "closed": false}, "tuesday": {"open": "11:00", "close": "22:00", "closed": false}, "wednesday": {"open": "11:00", "close": "22:00", "closed": false}, "thursday": {"open": "11:00", "close": "22:00", "closed": false}, "friday": {"open": "11:00", "close": "23:00", "closed": false}, "saturday": {"open": "10:00", "close": "23:00", "closed": false}, "sunday": {"open": "10:00", "close": "21:00", "closed": false}}',
 '{"theme": "modern", "currency": "USD", "tax_rate": 8.25, "primary_color": "#2563eb", "accent_color": "#f59e0b"}', 'active', '2024-01-15 10:30:00+00'),

('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'La Fiesta Mexican Grill', 'la-fiesta-mexican-grill', 'Authentic Mexican flavors with traditional recipes passed down through generations.', 'Mexican',
 '{"street": "456 Sunset Blvd", "city": "Los Angeles", "state": "CA", "zip": "90028", "country": "USA", "lat": 34.0522, "lng": -118.2437}',
 '+1-555-FIESTA', 'hola@lafiesta.com', 'https://lafiesta.com',
 '{"monday": {"open": "12:00", "close": "22:00", "closed": false}, "tuesday": {"open": "12:00", "close": "22:00", "closed": false}, "wednesday": {"open": "12:00", "close": "22:00", "closed": false}, "thursday": {"open": "12:00", "close": "22:00", "closed": false}, "friday": {"open": "12:00", "close": "23:00", "closed": false}, "saturday": {"open": "11:00", "close": "23:00", "closed": false}, "sunday": {"open": "11:00", "close": "21:00", "closed": false}}',
 '{"theme": "vibrant", "currency": "USD", "tax_rate": 9.5, "primary_color": "#dc2626", "accent_color": "#f59e0b"}', 'active', '2024-02-01 15:00:00+00'),

('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', 'Burger Haven', 'burger-haven', 'Gourmet burgers made with premium ingredients and house-made sauces.', 'American',
 '{"street": "789 Oak Avenue", "city": "Chicago", "state": "IL", "zip": "60601", "country": "USA", "lat": 41.8781, "lng": -87.6298}',
 '+1-555-BURGER', 'hello@burgerhaven.com', 'https://burgerhaven.com',
 '{"monday": {"open": "11:30", "close": "21:00", "closed": false}, "tuesday": {"open": "11:30", "close": "21:00", "closed": false}, "wednesday": {"open": "11:30", "close": "21:00", "closed": false}, "thursday": {"open": "11:30", "close": "21:00", "closed": false}, "friday": {"open": "11:30", "close": "22:00", "closed": false}, "saturday": {"open": "11:30", "close": "22:00", "closed": false}, "sunday": {"open": "12:00", "close": "20:00", "closed": false}}',
 '{"theme": "classic", "currency": "USD", "tax_rate": 10.25, "primary_color": "#7c2d12", "accent_color": "#f97316"}', 'active', '2024-02-15 09:45:00+00'),

('660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', 'Zen Tea House', 'zen-tea-house', 'A peaceful retreat offering premium teas, light bites, and mindful moments.', 'Asian',
 '{"street": "321 Bamboo Lane", "city": "San Francisco", "state": "CA", "zip": "94102", "country": "USA", "lat": 37.7749, "lng": -122.4194}',
 '+1-555-ZENTEA', 'peace@zenteahouse.com', 'https://zenteahouse.com',
 '{"monday": {"open": "08:00", "close": "20:00", "closed": false}, "tuesday": {"open": "08:00", "close": "20:00", "closed": false}, "wednesday": {"open": "08:00", "close": "20:00", "closed": false}, "thursday": {"open": "08:00", "close": "20:00", "closed": false}, "friday": {"open": "08:00", "close": "21:00", "closed": false}, "saturday": {"open": "08:00", "close": "21:00", "closed": false}, "sunday": {"open": "09:00", "close": "19:00", "closed": false}}',
 '{"theme": "zen", "currency": "USD", "tax_rate": 8.75, "primary_color": "#059669", "accent_color": "#fbbf24"}', 'active', '2024-03-01 12:15:00+00');

-- Insert sample menus
INSERT INTO menus (id, restaurant_id, name, description, menu_type, is_active, is_featured, display_order, created_at) VALUES
-- Tasty Bites Bistro Menus
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'Main Menu', 'Our signature dishes featuring fresh, locally-sourced ingredients', 'regular', true, true, 1, '2024-01-15 11:00:00+00'),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', 'Weekend Brunch', 'Special brunch items available Saturday and Sunday', 'breakfast', true, false, 2, '2024-01-15 11:15:00+00'),
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', 'Wine & Cocktails', 'Curated selection of wines and craft cocktails', 'drinks', true, false, 3, '2024-01-15 11:30:00+00'),

-- La Fiesta Mexican Grill Menus
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440002', 'Authentic Mexican', 'Traditional Mexican dishes made with authentic recipes', 'regular', true, true, 1, '2024-02-01 15:30:00+00'),
('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440002', 'Bebidas', 'Refreshing drinks and traditional Mexican beverages', 'drinks', true, false, 2, '2024-02-01 15:45:00+00'),

-- Burger Haven Menus
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440003', 'Gourmet Burgers', 'Premium burgers with house-made everything', 'regular', true, true, 1, '2024-02-15 10:15:00+00'),
('770e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440003', 'Sides & Shakes', 'Perfect accompaniments to our burgers', 'regular', true, false, 2, '2024-02-15 10:30:00+00'),

-- Zen Tea House Menus
('770e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440004', 'Premium Teas', 'Finest teas from around the world', 'drinks', true, true, 1, '2024-03-01 12:45:00+00'),
('770e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440004', 'Light Bites', 'Healthy snacks and light meals', 'regular', true, false, 2, '2024-03-01 13:00:00+00');

-- Insert sample menu categories
INSERT INTO menu_categories (id, menu_id, name, description, display_order, created_at) VALUES
-- Tasty Bites Main Menu Categories
('880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 'Appetizers', 'Start your meal with our delicious starters', 1, '2024-01-15 11:45:00+00'),
('880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', 'Salads', 'Fresh, crisp salads with premium ingredients', 2, '2024-01-15 11:46:00+00'),
('880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440001', 'Main Courses', 'Our signature entrees and hearty dishes', 3, '2024-01-15 11:47:00+00'),
('880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440001', 'Desserts', 'Sweet endings to your perfect meal', 4, '2024-01-15 11:48:00+00'),

-- La Fiesta Categories
('880e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440004', 'Antojitos', 'Traditional Mexican appetizers and small plates', 1, '2024-02-01 16:00:00+00'),
('880e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440004', 'Tacos', 'Authentic tacos with fresh ingredients', 2, '2024-02-01 16:01:00+00'),
('880e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440004', 'Platos Principales', 'Traditional main dishes', 3, '2024-02-01 16:02:00+00'),

-- Burger Haven Categories
('880e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440006', 'Classic Burgers', 'Our signature burger creations', 1, '2024-02-15 10:45:00+00'),
('880e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440006', 'Specialty Burgers', 'Unique and creative burger combinations', 2, '2024-02-15 10:46:00+00'),

-- Zen Tea House Categories
('880e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440008', 'Green Teas', 'Premium green tea selections', 1, '2024-03-01 13:15:00+00'),
('880e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440008', 'Black Teas', 'Rich and robust black tea varieties', 2, '2024-03-01 13:16:00+00'),
('880e8400-e29b-41d4-a716-446655440012', '770e8400-e29b-41d4-a716-446655440009', 'Healthy Bowls', 'Nutritious and satisfying bowl meals', 1, '2024-03-01 13:17:00+00');