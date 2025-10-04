# Database Migration Guide - Digital Menu Card System

## 🚀 Migration Overview

This guide provides step-by-step instructions for setting up and migrating the Digital Menu Card database schema.

## 📋 Prerequisites

- PostgreSQL 14+ installed
- Database user with CREATE privileges
- Redis 6+ (for caching and analytics)
- pgcrypto extension available

## 🔧 Initial Setup

### 1. Create Database
```sql
CREATE DATABASE digital_menu_card;
CREATE USER menu_app WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE digital_menu_card TO menu_app;
```

### 2. Connect to Database
```bash
psql -h localhost -U menu_app -d digital_menu_card
```

## 📊 Migration Execution Order

Execute the schema files in the following order to maintain referential integrity:

### Step 1: Core Extensions and Functions
```sql
-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
```

### Step 2: User Management Schema
```bash
psql -f database/schema/users-schema.sql
```
- Creates: roles, users, user_profiles, user_sessions, staff_members
- Dependencies: None

### Step 3: Restaurant and Menu Schema
```bash
psql -f database/schema/restaurants-schema.sql
```
- Creates: restaurants, menus, menu_items, qr_codes, etc.
- Dependencies: users table

### Step 4: Analytics Schema
```bash
psql -f database/schema/analytics-schema.sql
```
- Creates: qr_scans, analytics_events, customer_interactions
- Dependencies: restaurants, menus, qr_codes

### Step 5: Billing Schema
```bash
psql -f database/schema/payments-schema.sql
```
- Creates: billing_plans, subscriptions, payments, invoices
- Dependencies: users table

## 🗂️ Migration Files

### Individual Migration Scripts

#### 001_initial_setup.sql
```sql
-- Initial database setup with extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Create update trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
```

#### 002_user_tables.sql
Execute the users-schema.sql file

#### 003_restaurant_tables.sql
Execute the restaurants-schema.sql file

#### 004_analytics_tables.sql
Execute the analytics-schema.sql file

#### 005_billing_tables.sql
Execute the payments-schema.sql file

## 🧪 Verification Steps

### 1. Check Table Creation
```sql
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
```

### 2. Verify Foreign Key Constraints
```sql
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;
```

### 3. Check Indexes
```sql
SELECT schemaname, tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
```

## 📈 Performance Configuration

### PostgreSQL Configuration
Add to `postgresql.conf`:
```
# Memory settings
shared_buffers = 256MB
effective_cache_size = 1GB
work_mem = 4MB

# Connection settings
max_connections = 100

# Query planner
random_page_cost = 1.1
effective_io_concurrency = 200

# Write-ahead logging
wal_buffers = 16MB
checkpoint_completion_target = 0.9
```

### Connection Pooling with pgBouncer
```ini
[databases]
digital_menu_card = host=localhost port=5432 dbname=digital_menu_card

[pgbouncer]
listen_port = 6432
listen_addr = 127.0.0.1
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt
pool_mode = transaction
max_client_conn = 100
default_pool_size = 25
```

## 🔄 Rollback Procedures

### Individual Table Rollback
```sql
-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS qr_scans CASCADE;
DROP TABLE IF EXISTS analytics_events CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
-- ... continue in reverse order
```

### Complete Rollback
```sql
-- Drop all tables and start fresh
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO menu_app;
```

## 🔐 Security Setup

### Row Level Security
```sql
-- Enable RLS on sensitive tables
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE menus ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;

-- Create policies (example for restaurants)
CREATE POLICY restaurants_owner_policy ON restaurants
    FOR ALL TO authenticated_users
    USING (user_id = current_setting('app.current_user_id')::UUID);
```

### Database User Permissions
```sql
-- Create application-specific users
CREATE ROLE app_read;
CREATE ROLE app_write;

-- Grant permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_read;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_write;
```

## 📊 Monitoring Setup

### Enable Query Statistics
```sql
-- Enable pg_stat_statements
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Check slow queries
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

### Table Size Monitoring
```sql
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## 🚨 Troubleshooting

### Common Issues

1. **Permission Denied**
   ```sql
   GRANT ALL PRIVILEGES ON DATABASE digital_menu_card TO menu_app;
   GRANT ALL ON SCHEMA public TO menu_app;
   ```

2. **Extension Not Found**
   ```sql
   -- Install required extensions as superuser
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
   ```

3. **Foreign Key Violations**
   - Check migration order
   - Verify data integrity
   - Use `\d+ table_name` to inspect constraints

4. **Performance Issues**
   - Run `ANALYZE;` after large data imports
   - Check index usage with `EXPLAIN ANALYZE`
   - Monitor connection count

## 📝 Best Practices

1. **Always backup before migrations**
2. **Test migrations on staging first**
3. **Run migrations during low traffic periods**
4. **Monitor performance after schema changes**
5. **Keep migration scripts in version control**
6. **Document all custom functions and procedures**