-- Sample Menu Items Data for Digital Menu Card System
-- This file contains realistic menu items with detailed information

-- Insert sample menu items for Tasty Bites Bistro
INSERT INTO menu_items (id, menu_id, category_id, name, description, short_description, price, preparation_time, calories, spice_level, allergens, dietary_tags, ingredients, nutritional_info, is_available, is_featured, is_popular, display_order, created_at) VALUES

-- Tasty Bites Appetizers
('990e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 'Truffle Arancini', 'Crispy risotto balls filled with mushroom truffle, served with garlic aioli and microgreens', 'Crispy truffle risotto balls with garlic aioli', 14.99, 8, 320, 0, '["gluten", "dairy", "eggs"]', '["vegetarian"]', '["arborio rice", "truffle oil", "mushrooms", "parmesan", "breadcrumbs", "garlic", "mayonnaise"]', '{"protein": 8, "carbs": 42, "fat": 18, "fiber": 2}', true, true, true, 1, '2024-01-15 12:00:00+00'),

('990e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 'Buffalo Cauliflower Wings', 'Roasted cauliflower tossed in spicy buffalo sauce, served with vegan ranch dressing', 'Spicy buffalo cauliflower with vegan ranch', 11.99, 12, 180, 2, '[]', '["vegan", "gluten-free"]', '["cauliflower", "buffalo sauce", "cashews", "herbs", "spices"]', '{"protein": 4, "carbs": 20, "fat": 8, "fiber": 6}', true, false, true, 2, '2024-01-15 12:01:00+00'),

-- Tasty Bites Salads
('990e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440002', 'Quinoa Power Bowl', 'Tri-color quinoa with roasted vegetables, avocado, hemp seeds, and tahini dressing', 'Nutritious quinoa bowl with tahini dressing', 16.99, 5, 420, 0, '["sesame"]', '["vegan", "gluten-free"]', '["quinoa", "kale", "sweet potato", "avocado", "hemp seeds", "tahini"]', '{"protein": 14, "carbs": 52, "fat": 18, "fiber": 12}', true, true, false, 1, '2024-01-15 12:02:00+00'),

-- Tasty Bites Main Courses
('990e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440003', 'Pan-Seared Salmon', 'Atlantic salmon with lemon herb butter, seasonal vegetables, and quinoa pilaf', 'Fresh salmon with lemon herb butter', 28.99, 18, 580, 0, '["fish"]', '["gluten-free"]', '["salmon", "quinoa", "seasonal vegetables", "lemon", "herbs", "butter"]', '{"protein": 42, "carbs": 28, "fat": 24, "fiber": 6}', true, true, true, 1, '2024-01-15 12:03:00+00'),

('990e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440003', 'Grass-Fed Ribeye', '12oz grass-fed ribeye steak with roasted garlic mashed potatoes and grilled asparagus', 'Premium grass-fed ribeye steak', 39.99, 25, 720, 0, '["dairy"]', '[]', '["ribeye steak", "potatoes", "asparagus", "garlic", "butter", "herbs"]', '{"protein": 52, "carbs": 35, "fat": 38, "fiber": 4}', true, false, true, 2, '2024-01-15 12:04:00+00'),

-- La Fiesta Mexican Grill Items
('990e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440005', 'Guacamole Fresco', 'Fresh avocados mashed tableside with lime, cilantro, jalapeños, and served with warm tortilla chips', 'Fresh tableside guacamole with chips', 12.99, 5, 240, 1, '[]', '["vegan", "gluten-free"]', '["avocados", "lime", "cilantro", "jalapeños", "onions", "tomatoes", "tortilla chips"]', '{"protein": 4, "carbs": 20, "fat": 18, "fiber": 10}', true, true, true, 1, '2024-02-01 16:15:00+00'),

('990e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440006', 'Carnitas Tacos', 'Three soft corn tortillas with slow-cooked pork carnitas, onions, cilantro, and salsa verde', 'Traditional pork carnitas tacos', 15.99, 8, 480, 2, '[]', '["gluten-free"]', '["pork shoulder", "corn tortillas", "onions", "cilantro", "tomatillos", "chilies"]', '{"protein": 28, "carbs": 36, "fat": 22, "fiber": 6}', true, false, true, 1, '2024-02-01 16:16:00+00'),

('990e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440007', 'Mole Poblano', 'Traditional chicken mole with rich chocolate-spiced sauce, served with Mexican rice and beans', 'Classic chicken mole with chocolate sauce', 22.99, 20, 620, 2, '["nuts"]', '["gluten-free"]', '["chicken", "mole sauce", "chocolate", "chilies", "spices", "rice", "beans"]', '{"protein": 35, "carbs": 48, "fat": 26, "fiber": 8}', true, true, false, 1, '2024-02-01 16:17:00+00'),

-- Burger Haven Items
('990e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440008', 'Classic Haven Burger', 'Quarter-pound grass-fed beef patty with lettuce, tomato, onion, pickle, and our signature sauce', 'Classic burger with signature sauce', 16.99, 12, 580, 0, '["gluten", "dairy", "eggs"]', '[]', '["beef patty", "brioche bun", "lettuce", "tomato", "onion", "pickle", "signature sauce"]', '{"protein": 32, "carbs": 45, "fat": 28, "fiber": 3}', true, true, true, 1, '2024-02-15 11:00:00+00'),

('990e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440009', 'Truffle Mushroom Burger', 'Beyond meat patty with truffle mushrooms, caramelized onions, arugula, and vegan aioli', 'Plant-based truffle mushroom burger', 19.99, 15, 520, 0, '["gluten"]', '["vegan"]', '["beyond meat patty", "truffle mushrooms", "caramelized onions", "arugula", "vegan aioli"]', '{"protein": 22, "carbs": 48, "fat": 24, "fiber": 8}', true, true, false, 1, '2024-02-15 11:01:00+00'),

-- Zen Tea House Items
('990e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440010', 'Dragon Well Green Tea', 'Premium Longjing green tea from West Lake, China. Delicate and refreshing with sweet finish', 'Premium Chinese green tea', 8.99, 3, 0, 0, '[]', '["vegan", "gluten-free", "caffeine"]', '["dragon well tea leaves"]', '{"protein": 0, "carbs": 0, "fat": 0, "fiber": 0}', true, true, false, 1, '2024-03-01 13:30:00+00'),

('990e8400-e29b-41d4-a716-446655440012', '770e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440011', 'Earl Grey Supreme', 'Classic Earl Grey with cornflower petals and lavender. Bold bergamot flavor with floral notes', 'Classic Earl Grey with lavender', 7.99, 4, 0, 0, '[]', '["vegan", "gluten-free", "caffeine"]', '["black tea", "bergamot oil", "cornflower petals", "lavender"]', '{"protein": 0, "carbs": 0, "fat": 0, "fiber": 0}', true, false, true, 1, '2024-03-01 13:31:00+00'),

('990e8400-e29b-41d4-a716-446655440013', '770e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440012', 'Buddha Bowl', 'Quinoa, roasted vegetables, edamame, avocado, and tahini dressing. Mindful nutrition in every bite', 'Nutritious Buddha bowl with tahini', 18.99, 8, 450, 0, '["sesame"]', '["vegan", "gluten-free"]', '["quinoa", "roasted vegetables", "edamame", "avocado", "tahini", "seeds"]', '{"protein": 16, "carbs": 54, "fat": 20, "fiber": 14}', true, true, true, 1, '2024-03-01 13:32:00+00');

-- Insert sample QR codes for restaurants
INSERT INTO qr_codes (id, restaurant_id, code_data, table_identifier, description, is_active, created_at) VALUES
('aa0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'TB001-TABLE01', 'Table 1', 'Main dining room table 1', true, '2024-01-15 13:00:00+00'),
('aa0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', 'TB001-TABLE02', 'Table 2', 'Main dining room table 2', true, '2024-01-15 13:01:00+00'),
('aa0e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', 'TB001-BAR01', 'Bar Counter', 'Bar seating area', true, '2024-01-15 13:02:00+00'),

('aa0e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440002', 'LF002-MESA01', 'Mesa 1', 'Dining table 1', true, '2024-02-01 17:00:00+00'),
('aa0e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440002', 'LF002-PATIO01', 'Patio 1', 'Outdoor patio table 1', true, '2024-02-01 17:01:00+00'),

('aa0e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440003', 'BH003-BOOTH01', 'Booth 1', 'Corner booth seating', true, '2024-02-15 11:30:00+00'),
('aa0e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440003', 'BH003-COUNTER', 'Counter', 'Kitchen counter seating', true, '2024-02-15 11:31:00+00'),

('aa0e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440004', 'ZT004-ZEN01', 'Zen Corner', 'Peaceful corner seating', true, '2024-03-01 14:00:00+00'),
('aa0e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440004', 'ZT004-GARDEN', 'Garden View', 'Garden view table', true, '2024-03-01 14:01:00+00');

-- Insert sample item variations
INSERT INTO item_variations (id, item_id, name, type, is_required, display_order, created_at) VALUES
-- Burger size options
('bb0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440009', 'Patty Size', 'single', false, 1, '2024-02-15 11:15:00+00'),
-- Tea serving options
('bb0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440011', 'Serving Size', 'single', true, 1, '2024-03-01 13:45:00+00'),
-- Spice level for Mexican food
('bb0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440007', 'Spice Level', 'single', false, 1, '2024-02-01 16:30:00+00');

-- Insert variation options
INSERT INTO variation_options (id, variation_id, name, price_adjustment, is_default, display_order, created_at) VALUES
-- Burger patty sizes
('cc0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', 'Single (1/4 lb)', 0.00, true, 1, '2024-02-15 11:16:00+00'),
('cc0e8400-e29b-41d4-a716-446655440002', 'bb0e8400-e29b-41d4-a716-446655440001', 'Double (1/2 lb)', 4.99, false, 2, '2024-02-15 11:17:00+00'),

-- Tea serving sizes
('cc0e8400-e29b-41d4-a716-446655440003', 'bb0e8400-e29b-41d4-a716-446655440002', 'Individual Pot', 0.00, true, 1, '2024-03-01 13:46:00+00'),
('cc0e8400-e29b-41d4-a716-446655440004', 'bb0e8400-e29b-41d4-a716-446655440002', 'Sharing Pot (2-3 people)', 5.00, false, 2, '2024-03-01 13:47:00+00'),

-- Spice levels
('cc0e8400-e29b-41d4-a716-446655440005', 'bb0e8400-e29b-41d4-a716-446655440003', 'Mild', 0.00, true, 1, '2024-02-01 16:31:00+00'),
('cc0e8400-e29b-41d4-a716-446655440006', 'bb0e8400-e29b-41d4-a716-446655440003', 'Medium', 0.00, false, 2, '2024-02-01 16:32:00+00'),
('cc0e8400-e29b-41d4-a716-446655440007', 'bb0e8400-e29b-41d4-a716-446655440003', 'Hot', 0.00, false, 3, '2024-02-01 16:33:00+00'),
('cc0e8400-e29b-41d4-a716-446655440008', 'bb0e8400-e29b-41d4-a716-446655440003', 'Extra Hot', 0.00, false, 4, '2024-02-01 16:34:00+00');