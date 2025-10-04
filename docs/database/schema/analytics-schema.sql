-- Analytics & Tracking Schema
-- Digital Menu Card System
-- Tables: qr_scans, analytics_events, customer_interactions, page_views, item_popularity

-- QR code scan tracking - high-volume table
CREATE TABLE qr_scans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    qr_code_id UUID REFERENCES qr_codes(id) ON DELETE CASCADE,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    session_id VARCHAR(255) NOT NULL,
    ip_address INET,
    user_agent TEXT,
    device_type VARCHAR(50), -- mobile, tablet, desktop
    browser VARCHAR(100),
    operating_system VARCHAR(100),
    location JSONB, -- {city, country, lat, lng, accuracy}
    referrer TEXT,
    scanned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    -- Derived fields for faster queries
    scan_date DATE GENERATED ALWAYS AS (DATE(scanned_at)) STORED,
    scan_hour INTEGER GENERATED ALWAYS AS (EXTRACT(HOUR FROM scanned_at)) STORED,
    scan_day_of_week INTEGER GENERATED ALWAYS AS (EXTRACT(DOW FROM scanned_at)) STORED
) PARTITION BY RANGE (scanned_at);

-- Create monthly partitions for QR scans (example for 2025)
CREATE TABLE qr_scans_2025_01 PARTITION OF qr_scans
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
CREATE TABLE qr_scans_2025_02 PARTITION OF qr_scans
    FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

-- Analytics events for tracking user behavior
CREATE TABLE analytics_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    session_id VARCHAR(255) NOT NULL,
    event_type VARCHAR(100) NOT NULL, -- page_view, menu_view, item_view, search, etc.
    event_category VARCHAR(50), -- navigation, engagement, conversion
    event_action VARCHAR(100), -- click, scroll, search, share
    event_label VARCHAR(255),
    event_value DECIMAL(10,2),
    menu_id UUID REFERENCES menus(id) ON DELETE SET NULL,
    item_id UUID REFERENCES menu_items(id) ON DELETE SET NULL,
    category_id UUID REFERENCES menu_categories(id) ON DELETE SET NULL,
    page_url TEXT,
    page_title VARCHAR(255),
    user_agent TEXT,
    ip_address INET,
    device_info JSONB, -- {type, browser, os, screen_resolution}
    custom_dimensions JSONB DEFAULT '{}',
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    -- Derived fields
    event_date DATE GENERATED ALWAYS AS (DATE(timestamp)) STORED,
    event_hour INTEGER GENERATED ALWAYS AS (EXTRACT(HOUR FROM timestamp)) STORED
) PARTITION BY RANGE (timestamp);

-- Customer interaction tracking for detailed behavior analysis
CREATE TABLE customer_interactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id VARCHAR(255) NOT NULL,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    menu_id UUID REFERENCES menus(id) ON DELETE SET NULL,
    item_id UUID REFERENCES menu_items(id) ON DELETE SET NULL,
    interaction_type VARCHAR(50) NOT NULL, -- view, hover, click, scroll, search, filter
    interaction_data JSONB, -- specific interaction details
    duration_seconds INTEGER, -- time spent on item/page
    scroll_depth DECIMAL(5,2), -- percentage of page scrolled
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    -- Derived fields
    interaction_date DATE GENERATED ALWAYS AS (DATE(timestamp)) STORED
);

-- Page views for understanding navigation patterns
CREATE TABLE page_views (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id VARCHAR(255) NOT NULL,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    page_type VARCHAR(50) NOT NULL, -- menu, category, item, search, etc.
    page_url TEXT NOT NULL,
    page_title VARCHAR(255),
    referrer_url TEXT,
    menu_id UUID REFERENCES menus(id) ON DELETE SET NULL,
    category_id UUID REFERENCES menu_categories(id) ON DELETE SET NULL,
    item_id UUID REFERENCES menu_items(id) ON DELETE SET NULL,
    view_duration INTEGER, -- seconds spent on page
    bounce BOOLEAN DEFAULT false, -- single page session
    exit_page BOOLEAN DEFAULT false, -- last page in session
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    -- Derived fields
    view_date DATE GENERATED ALWAYS AS (DATE(timestamp)) STORED,
    view_hour INTEGER GENERATED ALWAYS AS (EXTRACT(HOUR FROM timestamp)) STORED
);

-- Item popularity tracking with aggregated metrics
CREATE TABLE item_popularity (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    view_count INTEGER DEFAULT 0,
    unique_views INTEGER DEFAULT 0,
    avg_view_duration DECIMAL(8,2) DEFAULT 0,
    search_appearances INTEGER DEFAULT 0,
    search_clicks INTEGER DEFAULT 0,
    social_shares INTEGER DEFAULT 0,
    popularity_score DECIMAL(8,4) DEFAULT 0, -- calculated metric
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(restaurant_id, item_id, date)
);

-- Session tracking for user journey analysis
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id VARCHAR(255) UNIQUE NOT NULL,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    first_scan_id UUID REFERENCES qr_scans(id) ON DELETE SET NULL,
    ip_address INET,
    user_agent TEXT,
    device_fingerprint VARCHAR(255),
    device_info JSONB,
    location_info JSONB,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    session_duration INTEGER, -- in seconds
    page_views_count INTEGER DEFAULT 0,
    menu_views_count INTEGER DEFAULT 0,
    item_views_count INTEGER DEFAULT 0,
    searches_count INTEGER DEFAULT 0,
    is_bounce BOOLEAN DEFAULT false,
    conversion_events JSONB DEFAULT '[]', -- track any conversion actions
    ended_at TIMESTAMP WITH TIME ZONE
);

-- Search queries tracking
CREATE TABLE search_queries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id VARCHAR(255) NOT NULL,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    query_text TEXT NOT NULL,
    results_count INTEGER DEFAULT 0,
    clicked_items JSONB DEFAULT '[]', -- array of item_ids clicked
    no_results BOOLEAN DEFAULT false,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    -- Derived fields
    search_date DATE GENERATED ALWAYS AS (DATE(timestamp)) STORED
);

-- Performance indexes for analytics tables
CREATE INDEX idx_qr_scans_qr_code_id ON qr_scans(qr_code_id);
CREATE INDEX idx_qr_scans_restaurant_id ON qr_scans(restaurant_id);
CREATE INDEX idx_qr_scans_session_id ON qr_scans(session_id);
CREATE INDEX idx_qr_scans_date ON qr_scans(scan_date);
CREATE INDEX idx_qr_scans_datetime ON qr_scans(scanned_at);

CREATE INDEX idx_analytics_events_restaurant_id ON analytics_events(restaurant_id);
CREATE INDEX idx_analytics_events_session_id ON analytics_events(session_id);
CREATE INDEX idx_analytics_events_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_events_date ON analytics_events(event_date);
CREATE INDEX idx_analytics_events_timestamp ON analytics_events(timestamp);

CREATE INDEX idx_customer_interactions_session_id ON customer_interactions(session_id);
CREATE INDEX idx_customer_interactions_restaurant_id ON customer_interactions(restaurant_id);
CREATE INDEX idx_customer_interactions_item_id ON customer_interactions(item_id);
CREATE INDEX idx_customer_interactions_date ON customer_interactions(interaction_date);

CREATE INDEX idx_page_views_session_id ON page_views(session_id);
CREATE INDEX idx_page_views_restaurant_id ON page_views(restaurant_id);
CREATE INDEX idx_page_views_date ON page_views(view_date);
CREATE INDEX idx_page_views_page_type ON page_views(page_type);

CREATE INDEX idx_item_popularity_restaurant_id ON item_popularity(restaurant_id);
CREATE INDEX idx_item_popularity_item_id ON item_popularity(item_id);
CREATE INDEX idx_item_popularity_date ON item_popularity(date);
CREATE INDEX idx_item_popularity_score ON item_popularity(popularity_score DESC);

CREATE INDEX idx_user_sessions_session_id ON user_sessions(session_id);
CREATE INDEX idx_user_sessions_restaurant_id ON user_sessions(restaurant_id);
CREATE INDEX idx_user_sessions_started_at ON user_sessions(started_at);

CREATE INDEX idx_search_queries_restaurant_id ON search_queries(restaurant_id);
CREATE INDEX idx_search_queries_text ON search_queries USING gin(to_tsvector('english', query_text));
CREATE INDEX idx_search_queries_date ON search_queries(search_date);

-- Function to calculate item popularity score
CREATE OR REPLACE FUNCTION calculate_popularity_score(
    views INTEGER,
    unique_views INTEGER,
    avg_duration DECIMAL,
    searches INTEGER,
    shares INTEGER
) RETURNS DECIMAL AS $$
BEGIN
    RETURN (
        (views * 1.0) +
        (unique_views * 2.0) +
        (LEAST(avg_duration / 30.0, 5.0) * 3.0) +
        (searches * 1.5) +
        (shares * 4.0)
    );
END;
$$ LANGUAGE plpgsql;

-- Trigger to update item popularity scores
CREATE OR REPLACE FUNCTION update_item_popularity_score()
RETURNS TRIGGER AS $$
BEGIN
    NEW.popularity_score = calculate_popularity_score(
        NEW.view_count,
        NEW.unique_views,
        NEW.avg_view_duration,
        NEW.search_appearances,
        NEW.social_shares
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_popularity_score
    BEFORE INSERT OR UPDATE ON item_popularity
    FOR EACH ROW EXECUTE FUNCTION update_item_popularity_score();

-- Trigger for updated_at timestamps
CREATE TRIGGER update_item_popularity_updated_at 
    BEFORE UPDATE ON item_popularity 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();