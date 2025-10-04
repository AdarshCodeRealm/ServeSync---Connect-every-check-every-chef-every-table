#!/bin/bash
# Quick Database Setup Script for Digital Menu Card System
# This script sets up the complete database with sample data

echo "🚀 Setting up Digital Menu Card Database..."

# Database configuration
DB_NAME="digital_menu_card"
DB_USER="menu_app"
DB_HOST="localhost"
DB_PORT="5432"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if PostgreSQL is running
if ! pg_isready -h $DB_HOST -p $DB_PORT > /dev/null 2>&1; then
    print_error "PostgreSQL is not running on $DB_HOST:$DB_PORT"
    print_status "Please start PostgreSQL and try again"
    exit 1
fi

print_success "PostgreSQL is running"

# Check if database exists
if psql -h $DB_HOST -p $DB_PORT -U postgres -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    print_warning "Database '$DB_NAME' already exists"
    read -p "Do you want to drop and recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Dropping existing database..."
        dropdb -h $DB_HOST -p $DB_PORT -U postgres $DB_NAME
        print_success "Database dropped"
    else
        print_status "Using existing database"
    fi
fi

# Create database if it doesn't exist
if ! psql -h $DB_HOST -p $DB_PORT -U postgres -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    print_status "Creating database '$DB_NAME'..."
    createdb -h $DB_HOST -p $DB_PORT -U postgres $DB_NAME
    print_success "Database created"
fi

# Create user if it doesn't exist
if ! psql -h $DB_HOST -p $DB_PORT -U postgres -t -c "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then
    print_status "Creating database user '$DB_USER'..."
    psql -h $DB_HOST -p $DB_PORT -U postgres -c "CREATE USER $DB_USER WITH PASSWORD 'your_secure_password';"
    psql -h $DB_HOST -p $DB_PORT -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
    print_success "Database user created"
else
    print_status "Database user '$DB_USER' already exists"
fi

# Execute schema files in order
print_status "Creating database schema..."

schema_files=(
    "database/schema/users-schema.sql"
    "database/schema/restaurants-schema.sql"
    "database/schema/analytics-schema.sql"
    "database/schema/payments-schema.sql"
)

for file in "${schema_files[@]}"; do
    if [ -f "$file" ]; then
        print_status "Executing $file..."
        if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file" > /dev/null 2>&1; then
            print_success "✓ $file executed successfully"
        else
            print_error "✗ Failed to execute $file"
            exit 1
        fi
    else
        print_error "Schema file not found: $file"
        exit 1
    fi
done

# Load sample data
print_status "Loading sample data..."

seed_files=(
    "database/seeds/sample-users.sql"
    "database/seeds/sample-restaurants.sql"
    "database/seeds/sample-menus.sql"
)

for file in "${seed_files[@]}"; do
    if [ -f "$file" ]; then
        print_status "Loading $file..."
        if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file" > /dev/null 2>&1; then
            print_success "✓ $file loaded successfully"
        else
            print_error "✗ Failed to load $file"
            exit 1
        fi
    else
        print_warning "Seed file not found: $file (skipping)"
    fi
done

# Verify installation
print_status "Verifying installation..."

table_count=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
user_count=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM users;" 2>/dev/null || echo "0")
restaurant_count=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM restaurants;" 2>/dev/null || echo "0")

print_success "Database setup completed!"
echo
echo "📊 Installation Summary:"
echo "  • Database: $DB_NAME"
echo "  • Tables created: $(echo $table_count | tr -d ' ')"
echo "  • Sample users: $(echo $user_count | tr -d ' ')"
echo "  • Sample restaurants: $(echo $restaurant_count | tr -d ' ')"
echo
echo "🔗 Connection Details:"
echo "  • Host: $DB_HOST"
echo "  • Port: $DB_PORT"
echo "  • Database: $DB_NAME"
echo "  • Username: $DB_USER"
echo
echo "🚀 Next Steps:"
echo "  1. Update your application's database configuration"
echo "  2. Test the connection with your application"
echo "  3. Review the sample data and customize as needed"
echo "  4. Set up your web application to connect to this database"
echo
print_success "Your Digital Menu Card database is ready to use!"