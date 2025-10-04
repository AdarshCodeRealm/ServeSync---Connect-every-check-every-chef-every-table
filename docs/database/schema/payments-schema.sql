-- Billing & Subscription Schema
-- Digital Menu Card System
-- Tables: billing_plans, subscriptions, payments, invoices, usage_metrics, discount_codes

-- Billing plans configuration
CREATE TABLE billing_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    billing_interval VARCHAR(20) NOT NULL CHECK (billing_interval IN ('monthly', 'yearly', 'one_time')),
    trial_period_days INTEGER DEFAULT 0,
    features JSONB NOT NULL DEFAULT '{}', -- {menu_items: 20, qr_codes: 1, analytics_days: 7}
    limits JSONB NOT NULL DEFAULT '{}', -- usage limits and restrictions
    stripe_price_id VARCHAR(255), -- Stripe price ID for integration
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- User subscriptions
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    plan_id UUID REFERENCES billing_plans(id),
    stripe_subscription_id VARCHAR(255) UNIQUE,
    stripe_customer_id VARCHAR(255),
    status VARCHAR(50) NOT NULL CHECK (status IN ('active', 'canceled', 'past_due', 'unpaid', 'trialing', 'incomplete')),
    current_period_start TIMESTAMP WITH TIME ZONE,
    current_period_end TIMESTAMP WITH TIME ZONE,
    trial_start TIMESTAMP WITH TIME ZONE,
    trial_end TIMESTAMP WITH TIME ZONE,
    canceled_at TIMESTAMP WITH TIME ZONE,
    ended_at TIMESTAMP WITH TIME ZONE,
    auto_renew BOOLEAN DEFAULT true,
    quantity INTEGER DEFAULT 1,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Payment history
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE SET NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    stripe_payment_intent_id VARCHAR(255) UNIQUE,
    stripe_charge_id VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'succeeded', 'failed', 'canceled', 'refunded')),
    payment_method VARCHAR(50), -- card, bank_transfer, paypal
    failure_reason TEXT,
    receipt_url TEXT,
    paid_at TIMESTAMP WITH TIME ZONE,
    refunded_at TIMESTAMP WITH TIME ZONE,
    refund_amount DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Invoice management
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    stripe_invoice_id VARCHAR(255) UNIQUE,
    invoice_number VARCHAR(100) UNIQUE NOT NULL,
    amount_due DECIMAL(10,2) NOT NULL,
    amount_paid DECIMAL(10,2) DEFAULT 0,
    amount_remaining DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(50) NOT NULL CHECK (status IN ('draft', 'open', 'paid', 'void', 'uncollectible')),
    subtotal DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    billing_period_start TIMESTAMP WITH TIME ZONE,
    billing_period_end TIMESTAMP WITH TIME ZONE,
    due_date TIMESTAMP WITH TIME ZONE,
    paid_at TIMESTAMP WITH TIME ZONE,
    invoice_pdf_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Usage metrics tracking for billing
CREATE TABLE usage_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE SET NULL,
    metric_type VARCHAR(100) NOT NULL, -- menu_items, qr_scans, api_calls, storage_mb
    metric_value INTEGER NOT NULL DEFAULT 0,
    period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, restaurant_id, metric_type, period_start)
);

-- Discount codes and promotions
CREATE TABLE discount_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('percentage', 'fixed_amount')),
    discount_value DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    applies_to VARCHAR(20) DEFAULT 'subscription' CHECK (applies_to IN ('subscription', 'upgrade', 'all')),
    minimum_amount DECIMAL(10,2),
    maximum_discount DECIMAL(10,2),
    usage_limit INTEGER,
    usage_count INTEGER DEFAULT 0,
    user_limit INTEGER DEFAULT 1, -- times per user
    valid_from TIMESTAMP WITH TIME ZONE,
    valid_until TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT true,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Discount code usage tracking
CREATE TABLE discount_usages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    discount_code_id UUID REFERENCES discount_codes(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE SET NULL,
    payment_id UUID REFERENCES payments(id) ON DELETE SET NULL,
    discount_amount DECIMAL(10,2) NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Subscription change history
CREATE TABLE subscription_changes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    change_type VARCHAR(50) NOT NULL, -- upgrade, downgrade, cancel, renew, pause
    from_plan_id UUID REFERENCES billing_plans(id),
    to_plan_id UUID REFERENCES billing_plans(id),
    from_status VARCHAR(50),
    to_status VARCHAR(50),
    reason TEXT,
    effective_date TIMESTAMP WITH TIME ZONE,
    prorated_amount DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Performance indexes
CREATE INDEX idx_billing_plans_active ON billing_plans(is_active);
CREATE INDEX idx_billing_plans_slug ON billing_plans(slug);
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_stripe_id ON subscriptions(stripe_subscription_id);
CREATE INDEX idx_subscriptions_period_end ON subscriptions(current_period_end);
CREATE INDEX idx_payments_subscription_id ON payments(subscription_id);
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_created_at ON payments(created_at);
CREATE INDEX idx_invoices_subscription_id ON invoices(subscription_id);
CREATE INDEX idx_invoices_user_id ON invoices(user_id);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_due_date ON invoices(due_date);
CREATE INDEX idx_usage_metrics_user_id ON usage_metrics(user_id);
CREATE INDEX idx_usage_metrics_restaurant_id ON usage_metrics(restaurant_id);
CREATE INDEX idx_usage_metrics_type_period ON usage_metrics(metric_type, period_start, period_end);
CREATE INDEX idx_discount_codes_code ON discount_codes(code);
CREATE INDEX idx_discount_codes_active ON discount_codes(is_active);
CREATE INDEX idx_discount_usages_code_id ON discount_usages(discount_code_id);
CREATE INDEX idx_discount_usages_user_id ON discount_usages(user_id);
CREATE INDEX idx_subscription_changes_subscription_id ON subscription_changes(subscription_id);

-- Insert default billing plans based on the pricing page
INSERT INTO billing_plans (name, slug, description, price, billing_interval, features, limits) VALUES
('Free Plan', 'free', 'Perfect for small cafes and food trucks testing the platform', 0.00, 'monthly', 
 '{"menu_items": 20, "categories": 3, "qr_codes": 1, "templates": 5, "analytics_days": 7, "support": "email_48h"}',
 '{"custom_branding": false, "image_uploads": false, "feedback_system": false, "multi_location": false, "watermark": true}'),

('Basic Plan', 'basic', 'Professional plan for small to medium restaurants', 19.00, 'monthly',
 '{"menu_items": 100, "categories": "unlimited", "qr_codes": 5, "templates": 15, "image_uploads": 50, "analytics_days": 30, "languages": 2, "support": "email_24h_chat"}',
 '{"multi_location": false, "api_access": false, "white_label": false}'),

('Basic Plan Yearly', 'basic-yearly', 'Professional plan for small to medium restaurants (yearly)', 180.00, 'yearly',
 '{"menu_items": 100, "categories": "unlimited", "qr_codes": 5, "templates": 15, "image_uploads": 50, "analytics_days": 30, "languages": 2, "support": "email_24h_chat"}',
 '{"multi_location": false, "api_access": false, "white_label": false}'),

('Advanced Plan', 'advanced', 'Enterprise solution for restaurant chains and large establishments', 49.00, 'monthly',
 '{"menu_items": "unlimited", "categories": "unlimited", "qr_codes": "unlimited", "templates": "unlimited", "image_uploads": "unlimited", "analytics_days": "unlimited", "languages": "unlimited", "support": "24_7_phone_dedicated_manager"}',
 '{}'),

('Advanced Plan Yearly', 'advanced-yearly', 'Enterprise solution for restaurant chains and large establishments (yearly)', 468.00, 'yearly',
 '{"menu_items": "unlimited", "categories": "unlimited", "qr_codes": "unlimited", "templates": "unlimited", "image_uploads": "unlimited", "analytics_days": "unlimited", "languages": "unlimited", "support": "24_7_phone_dedicated_manager"}',
 '{}');

-- Function to check usage limits
CREATE OR REPLACE FUNCTION check_usage_limit(
    p_user_id UUID,
    p_metric_type VARCHAR,
    p_current_usage INTEGER DEFAULT 1
) RETURNS BOOLEAN AS $$
DECLARE
    subscription_record RECORD;
    plan_limits JSONB;
    limit_value TEXT;
    numeric_limit INTEGER;
BEGIN
    -- Get current active subscription
    SELECT s.*, bp.limits, bp.features 
    INTO subscription_record
    FROM subscriptions s
    JOIN billing_plans bp ON s.plan_id = bp.id
    WHERE s.user_id = p_user_id 
    AND s.status = 'active'
    ORDER BY s.created_at DESC
    LIMIT 1;
    
    -- If no subscription found, default to free plan limits
    IF NOT FOUND THEN
        SELECT limits INTO plan_limits
        FROM billing_plans 
        WHERE slug = 'free';
    ELSE
        plan_limits := subscription_record.features;
    END IF;
    
    -- Get the limit for the specific metric
    limit_value := plan_limits ->> p_metric_type;
    
    -- If unlimited or no limit specified, allow
    IF limit_value IS NULL OR limit_value = 'unlimited' THEN
        RETURN TRUE;
    END IF;
    
    -- Convert to numeric and check
    BEGIN
        numeric_limit := limit_value::INTEGER;
        RETURN p_current_usage <= numeric_limit;
    EXCEPTION WHEN OTHERS THEN
        -- If conversion fails, assume unlimited
        RETURN TRUE;
    END;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at timestamps
CREATE TRIGGER update_billing_plans_updated_at BEFORE UPDATE ON billing_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_discount_codes_updated_at BEFORE UPDATE ON discount_codes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();