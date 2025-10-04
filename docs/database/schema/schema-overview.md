# Database Schema Overview - Digital Menu Card System

## 🏗️ Schema Architecture

The Digital Menu Card database follows a modular design with five core modules:

1. **User Management** - Authentication, roles, and user profiles
2. **Restaurant Management** - Multi-location restaurant data
3. **Menu Management** - Dynamic menu system with versioning
4. **Analytics & Tracking** - QR code scans and user behavior
5. **Billing & Subscriptions** - Payment processing and plan management

## 📊 Database Relationships Overview

```
Users (1:N) → Restaurants (1:N) → Menus (1:N) → Menu Items
  ↓                ↓                ↓
Subscriptions   QR Codes       Menu Categories
  ↓                ↓                ↓
Payments        QR Scans       Item Images
```

## 🔑 Primary Tables Summary

### Core Business Tables
| Table | Purpose | Key Relationships |
|-------|---------|------------------|
| `users` | User authentication & profiles | → restaurants, subscriptions |
| `restaurants` | Restaurant business data | → menus, qr_codes, locations |
| `menus` | Menu containers | → menu_items, menu_categories |
| `menu_items` | Individual food/drink items | → item_images, menu_categories |
| `qr_codes` | QR code management | → qr_scans, restaurants |

### Supporting Tables
| Table | Purpose | Key Relationships |
|-------|---------|------------------|
| `subscriptions` | User subscription plans | → users, billing_plans |
| `analytics_events` | User interaction tracking | → restaurants, menus |
| `item_images` | Menu item photography | → menu_items |
| `user_sessions` | Authentication sessions | → users |

## 🎯 Data Types & Standards

### Standardized Fields
- **IDs:** UUID v4 for all primary keys
- **Timestamps:** UTC timezone, ISO 8601 format
- **Prices:** DECIMAL(10,2) for currency values
- **Status Fields:** ENUM types for consistent states
- **JSON Fields:** For flexible metadata storage

### Naming Conventions
- **Tables:** Plural nouns (users, restaurants, menu_items)
- **Columns:** Snake_case (created_at, restaurant_id)
- **Indexes:** Table prefix + purpose (idx_users_email)
- **Foreign Keys:** Referenced table + _id (restaurant_id)

## 🔐 Security Implementation

### Row-Level Security (RLS)
```sql
-- Example: Users can only access their own restaurants
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
CREATE POLICY restaurants_user_policy ON restaurants
  FOR ALL TO authenticated_users
  USING (user_id = current_user_id());
```

### Data Encryption
- **PII Fields:** Encrypted at application layer
- **Payment Data:** Tokenized through payment processor
- **Sensitive Logs:** Encrypted storage with rotation

## 📈 Performance Optimizations

### Critical Indexes
```sql
-- QR code scanning (high frequency)
CREATE INDEX idx_qr_scans_code_timestamp ON qr_scans(qr_code_id, scanned_at);

-- Menu item searches
CREATE INDEX idx_menu_items_restaurant_status ON menu_items(restaurant_id, status);

-- Analytics queries
CREATE INDEX idx_analytics_restaurant_date ON analytics_events(restaurant_id, event_date);
```

### Partitioning Strategy
- **Analytics Tables:** Monthly partitions by date
- **QR Scans:** Weekly partitions for recent data
- **Archive Strategy:** Move old data to cold storage

## 🔄 Data Lifecycle Management

### Menu Versioning
- Track all menu changes for rollback capability
- Maintain history for analytics and compliance
- Soft delete approach for data integrity

### Analytics Retention
- **Real-time Data:** 90 days in hot storage
- **Aggregated Data:** 2 years in warm storage
- **Historical Data:** Archived to cold storage

### User Data Management
- **Active Users:** Full data retention
- **Inactive Users:** Data anonymization after 2 years
- **Deleted Accounts:** GDPR-compliant data removal

## 🚀 Scalability Design

### Horizontal Scaling Strategies
1. **Read Replicas:** Analytics and reporting queries
2. **Sharding:** Large restaurant chains by region
3. **Caching:** Redis for menu data and QR codes
4. **CDN Integration:** Image and static content delivery

### Vertical Scaling Considerations
- **Connection Pooling:** pgBouncer for efficient connections
- **Query Optimization:** Regular EXPLAIN ANALYZE reviews
- **Resource Monitoring:** CPU, memory, and I/O tracking

## 📋 Migration Strategy

### Version Control
- Sequential migration files with rollback scripts
- Automated testing for each migration
- Production deployment with zero-downtime approach

### Data Migration Phases
1. **Phase 1:** Core tables (users, restaurants)
2. **Phase 2:** Menu management system
3. **Phase 3:** Analytics and tracking
4. **Phase 4:** Billing and subscriptions

## 🧪 Testing Framework

### Schema Testing
- **Unit Tests:** Individual table constraints
- **Integration Tests:** Foreign key relationships
- **Performance Tests:** Query execution under load
- **Data Quality Tests:** Validation rules and consistency

### Test Data Strategy
- **Development:** Realistic sample data
- **Staging:** Anonymized production clone
- **Testing:** Generated data for edge cases