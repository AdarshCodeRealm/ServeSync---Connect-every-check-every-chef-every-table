-- Restaurant & Menu Management Schema
-- Digital Menu Card System
-- Tables: restaurants, restaurant_locations, menus, menu_categories, menu_items, item_images, menu_versions

-- Restaurants table - core restaurant information
CREATE TABLE restaurants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    cuisine_type VARCHAR(100),
    address JSONB, -- {street, city, state, zip, country, lat, lng}
    phone VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    logo_url TEXT,
    cover_image_url TEXT,
    business_hours JSONB, -- {monday: {open: "09:00", close: "22:00", closed: false}, ...}
    social_media JSONB, -- {facebook, instagram, twitter, etc.}
    settings JSONB DEFAULT '{"theme": "default", "currency": "USD", "tax_rate": 0}',
    subscription_plan VARCHAR(50) DEFAULT 'free' CHECK (subscription_plan IN ('free', 'basic', 'advanced')),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'draft')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Restaurant locations for multi-location restaurants
CREATE TABLE restaurant_locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    address JSONB NOT NULL,
    phone VARCHAR(20),
    manager_name VARCHAR(255),
    business_hours JSONB,
    is_primary BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'temporary_closed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Menus table - container for menu items
CREATE TABLE menus (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    location_id UUID REFERENCES restaurant_locations(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    menu_type VARCHAR(50) DEFAULT 'regular' CHECK (menu_type IN ('regular', 'breakfast', 'lunch', 'dinner', 'drinks', 'seasonal', 'special')),
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0,
    available_from TIME,
    available_until TIME,
    available_days JSONB DEFAULT '[1,2,3,4,5,6,7]', -- 1=Monday, 7=Sunday
    version INTEGER DEFAULT 1,
    published_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Menu categories for organizing items
CREATE TABLE menu_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    menu_id UUID REFERENCES menus(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES menu_categories(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Menu items - individual food/drink items
CREATE TABLE menu_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    menu_id UUID REFERENCES menus(id) ON DELETE CASCADE,
    category_id UUID REFERENCES menu_categories(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    short_description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    compare_at_price DECIMAL(10,2), -- For showing discounts
    cost_price DECIMAL(10,2), -- For profit calculations
    sku VARCHAR(100),
    barcode VARCHAR(100),
    preparation_time INTEGER, -- in minutes
    calories INTEGER,
    serving_size VARCHAR(50),
    spice_level INTEGER CHECK (spice_level BETWEEN 0 AND 5),
    allergens JSONB DEFAULT '[]', -- ["nuts", "dairy", "gluten", etc.]
    dietary_tags JSONB DEFAULT '[]', -- ["vegan", "vegetarian", "keto", etc.]
    ingredients JSONB DEFAULT '[]',
    nutritional_info JSONB, -- {protein: 20, carbs: 30, fat: 10, etc.}
    display_order INTEGER DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    is_popular BOOLEAN DEFAULT false,
    inventory_tracked BOOLEAN DEFAULT false,
    inventory_quantity INTEGER DEFAULT 0,
    low_stock_threshold INTEGER DEFAULT 5,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Item variations (size, toppings, customizations)
CREATE TABLE item_variations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL, -- "Size", "Toppings", "Extras"
    type VARCHAR(50) DEFAULT 'single' CHECK (type IN ('single', 'multiple')),
    is_required BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Variation options (Small/Medium/Large, specific toppings)
CREATE TABLE variation_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    variation_id UUID REFERENCES item_variations(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    price_adjustment DECIMAL(10,2) DEFAULT 0,
    is_default BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Item images for visual menu display
CREATE TABLE item_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0,
    image_metadata JSONB, -- {width, height, size, format, etc.}
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Menu versions for tracking changes and rollbacks
CREATE TABLE menu_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    menu_id UUID REFERENCES menus(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    change_summary TEXT,
    menu_data JSONB NOT NULL, -- Full menu snapshot
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(menu_id, version_number)
);

-- QR codes for table/location identification
CREATE TABLE qr_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    location_id UUID REFERENCES restaurant_locations(id) ON DELETE SET NULL,
    menu_id UUID REFERENCES menus(id) ON DELETE SET NULL,
    code_data TEXT UNIQUE NOT NULL,
    table_identifier VARCHAR(100), -- "Table 1", "Bar", "Patio", etc.
    description TEXT,
    qr_style JSONB DEFAULT '{"color": "#000000", "background": "#FFFFFF"}',
    is_active BOOLEAN DEFAULT true,
    usage_count INTEGER DEFAULT 0,
    last_scanned_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Performance indexes
CREATE INDEX idx_restaurants_user_id ON restaurants(user_id);
CREATE INDEX idx_restaurants_slug ON restaurants(slug);
CREATE INDEX idx_restaurants_status ON restaurants(status);
CREATE INDEX idx_restaurant_locations_restaurant_id ON restaurant_locations(restaurant_id);
CREATE INDEX idx_menus_restaurant_id ON menus(restaurant_id);
CREATE INDEX idx_menus_active ON menus(is_active);
CREATE INDEX idx_menu_categories_menu_id ON menu_categories(menu_id);
CREATE INDEX idx_menu_categories_parent_id ON menu_categories(parent_id);
CREATE INDEX idx_menu_items_menu_id ON menu_items(menu_id);
CREATE INDEX idx_menu_items_category_id ON menu_items(category_id);
CREATE INDEX idx_menu_items_available ON menu_items(is_available);
CREATE INDEX idx_menu_items_featured ON menu_items(is_featured);
CREATE INDEX idx_item_variations_item_id ON item_variations(item_id);
CREATE INDEX idx_variation_options_variation_id ON variation_options(variation_id);
CREATE INDEX idx_item_images_item_id ON item_images(item_id);
CREATE INDEX idx_menu_versions_menu_id ON menu_versions(menu_id);
CREATE INDEX idx_qr_codes_restaurant_id ON qr_codes(restaurant_id);
CREATE INDEX idx_qr_codes_code_data ON qr_codes(code_data);
CREATE INDEX idx_qr_codes_active ON qr_codes(is_active);

-- Add foreign key constraint for staff_members table
ALTER TABLE staff_members ADD CONSTRAINT fk_staff_restaurant 
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE;

-- Triggers for updated_at timestamps
CREATE TRIGGER update_restaurants_updated_at BEFORE UPDATE ON restaurants FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_restaurant_locations_updated_at BEFORE UPDATE ON restaurant_locations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_menus_updated_at BEFORE UPDATE ON menus FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_menu_categories_updated_at BEFORE UPDATE ON menu_categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_menu_items_updated_at BEFORE UPDATE ON menu_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_qr_codes_updated_at BEFORE UPDATE ON qr_codes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();