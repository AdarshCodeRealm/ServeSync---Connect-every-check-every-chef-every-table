# Entity Relationship Diagrams - Digital Menu Card System

## 📊 ER Diagram Overview

This document describes the Entity Relationship diagrams for the Digital Menu Card system. The diagrams are organized by functional modules to maintain clarity and readability.

## 🗂️ Diagram Files

### Complete System Diagram
- **File:** `complete-er.png`
- **Description:** Full system overview showing all entities and relationships
- **Use Case:** System architecture understanding, onboarding new developers

### Module-Specific Diagrams
- **File:** `user-management-er.png`
- **Description:** User authentication, roles, and profile management
- **File:** `menu-management-er.png`  
- **Description:** Restaurant, menu, and item management system
- **File:** `analytics-er.png`
- **Description:** QR code tracking and analytics system
- **File:** `billing-er.png`
- **Description:** Subscription and payment management

## 🏗️ Entity Relationship Details

### 1. User Management Module

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    USERS    │────▶│USER_PROFILES│     │    ROLES    │
│             │     │             │     │             │
│ id (PK)     │     │ user_id(FK) │     │ id (PK)     │
│ email       │     │ first_name  │     │ name        │
│ password    │     │ last_name   │     │ permissions │
│ role_id(FK) │     │ phone       │     │ created_at  │
│ status      │     │ avatar_url  │     └─────────────┘
│ created_at  │     │ timezone    │           │
│ updated_at  │     │ language    │           │
└─────────────┘     │ created_at  │           │
       │            └─────────────┘           │
       └────────────────────────────────────────┘
```

**Key Relationships:**
- Users → User_Profiles (1:1) - Extended user information
- Users → Roles (N:1) - Role-based permissions
- Users → Restaurants (1:N) - Restaurant ownership
- Users → User_Sessions (1:N) - Authentication tracking

### 2. Restaurant & Menu Management Module

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│RESTAURANTS  │────▶│    MENUS    │────▶│ MENU_ITEMS  │
│             │     │             │     │             │
│ id (PK)     │     │ id (PK)     │     │ id (PK)     │
│ user_id(FK) │     │ restaurant_id│     │ menu_id(FK) │
│ name        │     │ name        │     │ category_id │
│ slug        │     │ description │     │ name        │
│ address     │     │ is_active   │     │ description │
│ phone       │     │ version     │     │ price       │
│ website     │     │ created_at  │     │ image_url   │
│ logo_url    │     │ updated_at  │     │ allergens   │
│ settings    │     └─────────────┘     │ is_available│
│ created_at  │           │             │ created_at  │
└─────────────┘           │             └─────────────┘
       │                  │                     │
       │                  ▼                     │
       │         ┌─────────────┐                │
       │         │MENU_CATEGORIES│               │
       │         │             │                │
       │         │ id (PK)     │                │
       │         │ menu_id(FK) │◀───────────────┘
       │         │ name        │
       │         │ description │
       │         │ sort_order  │
       │         │ parent_id   │
       │         └─────────────┘
       │
       ▼
┌─────────────┐
│  QR_CODES   │
│             │
│ id (PK)     │
│ restaurant_id│
│ code_data   │
│ table_name  │
│ is_active   │
│ created_at  │
└─────────────┘
```

**Key Relationships:**
- Restaurants → Menus (1:N) - Multiple menus per restaurant
- Menus → Menu_Items (1:N) - Items belong to specific menus
- Menus → Menu_Categories (1:N) - Hierarchical categorization
- Menu_Categories → Menu_Items (1:N) - Items organized by category
- Restaurants → QR_Codes (1:N) - Multiple QR codes per location

### 3. Analytics & Tracking Module

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  QR_CODES   │────▶│  QR_SCANS   │     │ANALYTICS_   │
│             │     │             │     │  EVENTS     │
│ id (PK)     │     │ id (PK)     │     │             │
│ restaurant_id│     │ qr_code_id  │     │ id (PK)     │
│ code_data   │     │ scanned_at  │     │ restaurant_id│
│ table_name  │     │ ip_address  │     │ event_type  │
│ location    │     │ user_agent  │     │ event_data  │
│ is_active   │     │ session_id  │     │ user_id     │
└─────────────┘     │ location    │     │ timestamp   │
                    │ device_type │     │ ip_address  │
                    └─────────────┘     └─────────────┘
                           │                   │
                           ▼                   │
                    ┌─────────────┐           │
                    │CUSTOMER_    │           │
                    │INTERACTIONS │◀──────────┘
                    │             │
                    │ id (PK)     │
                    │ session_id  │
                    │ menu_id     │
                    │ item_id     │
                    │ action_type │
                    │ duration    │
                    │ timestamp   │
                    └─────────────┘
```

**Key Relationships:**
- QR_Codes → QR_Scans (1:N) - Track all QR code usage
- QR_Scans → Customer_Interactions (1:N) - Detailed user behavior
- Restaurants → Analytics_Events (1:N) - General event tracking
- Analytics_Events → Customer_Interactions (1:N) - Detailed interaction data

### 4. Billing & Subscription Module

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    USERS    │────▶│SUBSCRIPTIONS│────▶│   PAYMENTS  │
│             │     │             │     │             │
│ id (PK)     │     │ id (PK)     │     │ id (PK)     │
│ email       │     │ user_id(FK) │     │ subscription│
│ created_at  │     │ plan_id(FK) │     │ amount      │
└─────────────┘     │ status      │     │ currency    │
                    │ starts_at   │     │ stripe_id   │
                    │ ends_at     │     │ status      │
                    │ auto_renew  │     │ paid_at     │
                    │ created_at  │     │ created_at  │
                    └─────────────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │BILLING_PLANS│
                    │             │
                    │ id (PK)     │
                    │ name        │
                    │ price       │
                    │ currency    │
                    │ features    │
                    │ limits      │
                    │ is_active   │
                    └─────────────┘
```

**Key Relationships:**
- Users → Subscriptions (1:N) - Multiple subscription history
- Subscriptions → Billing_Plans (N:1) - Plan details and pricing
- Subscriptions → Payments (1:N) - Payment history tracking

## 🔑 Cardinality Legend

- **1:1** - One to One relationship
- **1:N** - One to Many relationship  
- **N:M** - Many to Many relationship (via junction table)
- **PK** - Primary Key
- **FK** - Foreign Key

## 📊 Advanced Relationships

### Many-to-Many Relationships
1. **Users ↔ Restaurants** (via staff_members table)
   - Multiple staff can manage one restaurant
   - One user can work at multiple restaurants

2. **Menu_Items ↔ Allergens** (via item_allergens table)
   - Items can have multiple allergens
   - Same allergen applies to multiple items

### Self-Referencing Relationships
1. **Menu_Categories.parent_id** → Menu_Categories.id
   - Hierarchical category structure
   - Support for nested subcategories

## 🎯 Diagram Creation Tools

### Recommended Tools
- **Draw.io** - Free online diagramming tool
- **Lucidchart** - Professional diagramming software
- **dbdiagram.io** - Database-specific ER diagram tool
- **PlantUML** - Text-based diagram generation

### Export Formats
- **PNG** - For documentation and presentations
- **SVG** - For scalable web display
- **PDF** - For print documentation
- **SQL** - For database generation from diagrams

## 🔄 Diagram Maintenance

### Update Process
1. **Schema Changes** - Update diagrams when tables change
2. **New Features** - Add new entities and relationships
3. **Version Control** - Track diagram changes with git
4. **Documentation Sync** - Keep diagrams aligned with code

### Review Schedule
- **Weekly** - Check for schema drift
- **Monthly** - Comprehensive diagram review
- **Quarterly** - Major architecture validation