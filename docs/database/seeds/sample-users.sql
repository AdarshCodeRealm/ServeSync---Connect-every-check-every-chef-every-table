-- Sample Users Data for Digital Menu Card System
-- This file contains realistic sample data for development and testing

-- Insert sample users with different roles
INSERT INTO users (id, email, password_hash, role_id, status, email_verified, created_at) VALUES
-- Restaurant owners
('550e8400-e29b-41d4-a716-446655440001', 'john.smith@tastybites.com', '$2a$10$rOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5Yz', (SELECT id FROM roles WHERE name = 'restaurant_owner'), 'active', true, '2024-01-15 10:00:00+00'),
('550e8400-e29b-41d4-a716-446655440002', 'maria.gonzalez@lafiesta.com', '$2a$10$rOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5Yz', (SELECT id FROM roles WHERE name = 'restaurant_owner'), 'active', true, '2024-02-01 14:30:00+00'),
('550e8400-e29b-41d4-a716-446655440003', 'chef.david@burgerhaven.com', '$2a$10$rOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5Yz', (SELECT id FROM roles WHERE name = 'restaurant_owner'), 'active', true, '2024-02-15 09:15:00+00'),
('550e8400-e29b-41d4-a716-446655440004', 'sarah.chen@zenteahouse.com', '$2a$10$rOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5Yz', (SELECT id FROM roles WHERE name = 'restaurant_owner'), 'active', true, '2024-03-01 11:45:00+00'),

-- Restaurant managers
('550e8400-e29b-41d4-a716-446655440005', 'manager1@tastybites.com', '$2a$10$rOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5Yz', (SELECT id FROM roles WHERE name = 'restaurant_manager'), 'active', true, '2024-03-10 16:20:00+00'),
('550e8400-e29b-41d4-a716-446655440006', 'alex.manager@lafiesta.com', '$2a$10$rOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5Yz', (SELECT id FROM roles WHERE name = 'restaurant_manager'), 'active', true, '2024-03-15 12:00:00+00'),

-- Restaurant staff
('550e8400-e29b-41d4-a716-446655440007', 'staff1@tastybites.com', '$2a$10$rOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5Yz', (SELECT id FROM roles WHERE name = 'restaurant_staff'), 'active', true, '2024-04-01 08:30:00+00'),
('550e8400-e29b-41d4-a716-446655440008', 'waiter.carlos@lafiesta.com', '$2a$10$rOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5YzJdOzVzqOzZqGzJvqZ5Yz', (SELECT id FROM roles WHERE name = 'restaurant_staff'), 'active', true, '2024-04-05 13:15:00+00');

-- Insert user profiles
INSERT INTO user_profiles (user_id, first_name, last_name, phone, timezone, language, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'John', 'Smith', '+1-555-0101', 'America/New_York', 'en', '2024-01-15 10:05:00+00'),
('550e8400-e29b-41d4-a716-446655440002', 'Maria', 'Gonzalez', '+1-555-0102', 'America/Los_Angeles', 'es', '2024-02-01 14:35:00+00'),
('550e8400-e29b-41d4-a716-446655440003', 'David', 'Johnson', '+1-555-0103', 'America/Chicago', 'en', '2024-02-15 09:20:00+00'),
('550e8400-e29b-41d4-a716-446655440004', 'Sarah', 'Chen', '+1-555-0104', 'America/Los_Angeles', 'en', '2024-03-01 11:50:00+00'),
('550e8400-e29b-41d4-a716-446655440005', 'Michael', 'Brown', '+1-555-0105', 'America/New_York', 'en', '2024-03-10 16:25:00+00'),
('550e8400-e29b-41d4-a716-446655440006', 'Alex', 'Rodriguez', '+1-555-0106', 'America/Los_Angeles', 'es', '2024-03-15 12:05:00+00'),
('550e8400-e29b-41d4-a716-446655440007', 'Emily', 'Davis', '+1-555-0107', 'America/New_York', 'en', '2024-04-01 08:35:00+00'),
('550e8400-e29b-41d4-a716-446655440008', 'Carlos', 'Martinez', '+1-555-0108', 'America/Los_Angeles', 'es', '2024-04-05 13:20:00+00');