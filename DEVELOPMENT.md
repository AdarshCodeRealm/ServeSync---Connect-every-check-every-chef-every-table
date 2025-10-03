# ServeSync - Development Setup & Contributing Guide

## 🚀 Quick Start for New Team Members

### Prerequisites
Before you begin, ensure you have the following installed:
- **Node.js** (v18+ recommended) - [Download here](https://nodejs.org/)
- **Git** - [Download here](https://git-scm.com/)
- **Docker** (for local database) - [Download here](https://docker.com/)
- **VS Code** (recommended) - [Download here](https://code.visualstudio.com/)

### Initial Setup (First Time Only)

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/servesync.git
   cd servesync
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your local configuration
   ```

4. **Start local database (Docker)**
   ```bash
   docker-compose up -d postgres redis
   ```

5. **Run database migrations**
   ```bash
   npm run db:migrate
   npm run db:seed
   ```

6. **Start development servers**
   ```bash
   # Terminal 1: Backend API
   npm run dev:api
   
   # Terminal 2: Frontend
   npm run dev:frontend
   
   # Terminal 3: Admin Dashboard
   npm run dev:admin
   ```

7. **Verify setup**
   - Frontend: http://localhost:3000
   - Admin Dashboard: http://localhost:3001
   - API Documentation: http://localhost:8000/docs

---

## 📁 Project Structure

```
servesync/
├── packages/
│   ├── frontend/          # Customer-facing menu interface
│   ├── admin/            # Restaurant admin dashboard
│   ├── api/              # Backend API server
│   ├── shared/           # Shared utilities and types
│   └── mobile/           # Future: Mobile app
├── docs/                 # Documentation
├── scripts/              # Build and deployment scripts
├── docker/               # Docker configurations
├── .github/              # GitHub Actions workflows
└── tools/                # Development tools and configs
```

---

## 🔧 Development Workflow

### Branch Naming Convention
- **Feature branches:** `feature/issue-123-brief-description`
- **Bug fixes:** `fix/issue-456-brief-description`
- **Hotfixes:** `hotfix/critical-bug-description`
- **Documentation:** `docs/update-readme`

### Commit Message Format
```
type(scope): brief description

Longer description if needed

Fixes #123
```

**Types:** feat, fix, docs, style, refactor, test, chore

**Examples:**
```
feat(menu): add dietary filter functionality

- Add vegan, gluten-free, nut-free filters
- Update menu component to support filtering
- Add filter state management

Fixes #045
```

### Pull Request Process

1. **Create feature branch**
   ```bash
   git checkout -b feature/issue-123-menu-filters
   ```

2. **Make your changes and commit**
   ```bash
   git add .
   git commit -m "feat(menu): add dietary filter functionality"
   ```

3. **Push and create PR**
   ```bash
   git push origin feature/issue-123-menu-filters
   ```

4. **PR Requirements:**
   - [ ] All tests pass
   - [ ] Code coverage maintained (80%+)
   - [ ] At least one approval from team lead
   - [ ] No merge conflicts
   - [ ] Documentation updated if needed

---

## 🧪 Testing Strategy

### Running Tests
```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run specific test suite
npm run test:frontend
npm run test:api
npm run test:e2e
```

### Test Types
- **Unit Tests:** Individual functions and components
- **Integration Tests:** API endpoints and database interactions
- **E2E Tests:** Full user workflows (Cypress)
- **Visual Regression Tests:** UI component screenshots

### Writing Tests
```javascript
// Example: Menu component test
describe('MenuCard Component', () => {
  it('should render menu items correctly', () => {
    const mockItems = [
      { id: 1, name: 'Pizza', price: 12.99 }
    ];
    
    render(<MenuCard items={mockItems} />);
    
    expect(screen.getByText('Pizza')).toBeInTheDocument();
    expect(screen.getByText('$12.99')).toBeInTheDocument();
  });
});
```

---

## 🎨 Code Style & Standards

### Formatting
- **Prettier** for code formatting (runs on save)
- **ESLint** for code quality (must pass before commit)
- **Husky** for pre-commit hooks

### TypeScript Guidelines
```typescript
// Use explicit types for public APIs
interface MenuItemProps {
  id: string;
  name: string;
  price: number;
  isAvailable: boolean;
}

// Use proper naming conventions
const calculateTotalPrice = (items: MenuItemProps[]): number => {
  return items.reduce((total, item) => total + item.price, 0);
};
```

### CSS/Styling
- **Tailwind CSS** for utility-first styling
- **CSS Modules** for component-specific styles
- **Design tokens** from the design system

---

## 🗄️ Database Guidelines

### Schema Changes
1. **Create migration file**
   ```bash
   npm run db:migration:create add_menu_categories
   ```

2. **Write migration**
   ```sql
   -- migrations/001_add_menu_categories.sql
   CREATE TABLE menu_categories (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     restaurant_id UUID NOT NULL REFERENCES restaurants(id),
     name VARCHAR(255) NOT NULL,
     display_order INTEGER DEFAULT 0,
     created_at TIMESTAMP DEFAULT NOW()
   );
   ```

3. **Test migration**
   ```bash
   npm run db:migrate:test
   ```

4. **Update TypeScript types**
   ```typescript
   interface MenuCategory {
     id: string;
     restaurantId: string;
     name: string;
     displayOrder: number;
     createdAt: Date;
   }
   ```

---

## 🔌 API Development

### Endpoint Structure
```typescript
// GET /api/v1/restaurants/:id/menu
export async function getMenu(req: Request, res: Response) {
  try {
    const { id } = req.params;
    const menu = await menuService.getByRestaurantId(id);
    
    res.json({
      success: true,
      data: menu,
      meta: {
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
}
```

### API Documentation
- **Swagger/OpenAPI** for endpoint documentation
- **Postman Collections** for testing
- **Example requests/responses** in docs

---

## 🐛 Debugging & Troubleshooting

### Common Issues

**Issue:** "Port 3000 already in use"
```bash
# Find and kill process using port
lsof -ti:3000 | xargs kill -9
# Or use different port
PORT=3001 npm run dev:frontend
```

**Issue:** Database connection fails
```bash
# Restart Docker containers
docker-compose down
docker-compose up -d
# Check logs
docker-compose logs postgres
```

**Issue:** NPM install fails
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

### Development Tools
- **React Developer Tools** - Browser extension
- **Redux DevTools** - State management debugging
- **Postman** - API testing
- **PgAdmin** - Database management

---

## 🚀 Deployment & CI/CD

### Environment Setup
- **Development:** Local machine
- **Staging:** Auto-deploy from `develop` branch
- **Production:** Manual deploy from `main` branch

### Deployment Commands
```bash
# Build for production
npm run build

# Deploy to staging
npm run deploy:staging

# Deploy to production (requires approval)
npm run deploy:production
```

### Environment Variables
```bash
# Required for all environments
DATABASE_URL=
REDIS_URL=
JWT_SECRET=
GOOGLE_MAPS_API_KEY=

# Production only
STRIPE_SECRET_KEY=
SENDGRID_API_KEY=
SENTRY_DSN=
```

---

## 📚 Learning Resources

### Required Reading
- [React Documentation](https://react.dev/)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [PostgreSQL Guide](https://www.postgresqltutorial.com/)
- [REST API Design](https://restfulapi.net/)

### Team Knowledge Base
- **Confluence/Notion:** Technical specifications
- **Slack:** Real-time communication
- **GitHub Discussions:** Architecture decisions
- **Weekly Tech Talks:** Knowledge sharing

---

## 🆘 Getting Help

### Escalation Path
1. **Check documentation** (this file, README, API docs)
2. **Search GitHub issues** for similar problems
3. **Ask in relevant Slack channel**
4. **Tag team lead** if urgent or blocking

### Contact Information
- **Technical Lead:** @tech-lead in Slack
- **DevOps:** @devops-team for infrastructure issues
- **Product Manager:** @pm for feature questions
- **Emergency:** +1-xxx-xxx-xxxx (production issues only)

---

## 🎯 Performance Guidelines

### Frontend Performance
- **Bundle size:** Keep under 250KB gzipped
- **Core Web Vitals:** LCP < 2.5s, FID < 100ms, CLS < 0.1
- **Image optimization:** Use WebP format, lazy loading
- **Code splitting:** Route-based and component-based

### Backend Performance
- **Response time:** API endpoints < 200ms average
- **Database queries:** Use indexes, avoid N+1 problems
- **Caching:** Redis for frequently accessed data
- **Rate limiting:** Protect against abuse

### Monitoring
- **Sentry:** Error tracking and performance monitoring
- **DataDog:** Infrastructure and application metrics
- **Google Analytics:** User behavior tracking
- **Uptime monitoring:** Pingdom/StatusPage

---

## 🔒 Security Guidelines

### Authentication & Authorization
- **JWT tokens:** Short-lived access tokens (15 min)
- **Refresh tokens:** Secure, HTTP-only cookies
- **Role-based access:** Restaurant owners, staff, admins
- **API rate limiting:** Prevent abuse

### Data Protection
- **HTTPS everywhere:** SSL/TLS for all communications
- **Input validation:** Sanitize all user inputs
- **SQL injection prevention:** Use parameterized queries
- **XSS protection:** Content Security Policy headers

### Code Security
- **Dependency scanning:** Regular vulnerability checks
- **Secret management:** Use environment variables
- **Code review:** Security-focused reviews for sensitive code
- **Principle of least privilege:** Minimal necessary permissions

Ready to build something amazing! 🚀