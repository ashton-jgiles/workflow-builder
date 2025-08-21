# Cloud Cost Dashboard - Unified Docker Setup

A real-time dashboard that analyzes AWS/GCP/Azure billing data, detects anomalies, and recommends cost-saving actions with AI.

This directory contains a unified Docker setup that combines the frontend, backend, and database into a single containerized solution for easy local development and demonstration.

## 🚀 Quick Start

### Prerequisites

- Docker Desktop installed and running
- Git (to clone the repository)

### Running the Application

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone <repository-url>
   cd cloud-cost
   ```

2. **Start all services**:
   ```bash
   docker-compose up -d
   ```

3. **Access the application**:
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:3000
   - Database: localhost:5432

### Stopping the Application

```bash
docker-compose down
```

To also remove the database volume:
```bash
docker-compose down -v
```

## 📁 Project Structure

```
cloud-cost/
├── docker-compose.yml      # Main orchestration file
├── init-db.sql            # Database initialization script
└── README.md              # This file

cloud-cost-site/           # React frontend
├── Dockerfile             # Frontend container configuration
├── nginx.conf             # Nginx configuration for serving React app
└── ...

cloud-cost-api/            # NestJS backend
├── Dockerfile             # Backend container configuration
└── ...
```

## 🔧 Services

### Frontend (React + Vite)
- **Port**: 5173
- **Technology**: React 19, TypeScript, Tailwind CSS, Vite
- **Container**: nginx-alpine serving built React app

### Backend (NestJS)
- **Port**: 3000
- **Technology**: NestJS, TypeScript, TypeORM
- **Database**: PostgreSQL with connection pooling
- **Features**: User API with CRUD operations

### Database (PostgreSQL)
- **Port**: 5432
- **Version**: PostgreSQL 15 Alpine
- **Database**: cloud_cost_db
- **User**: cloud_cost_user
- **Password**: cloud_cost_password

## 🧪 Testing the Setup

### 1. Frontend Test
Visit http://localhost:5173 to see the React dashboard.

### 2. Backend API Test
Test the user API endpoints:

```bash
# Get all users
curl http://localhost:3000/users

# Get a specific user
curl http://localhost:3000/users/1

# Create a new user
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User"}'
```

### 3. Database Test
Connect to the database to verify data:

```bash
# Connect to PostgreSQL container
docker exec -it cloud-cost-db psql -U cloud_cost_user -d cloud_cost_db

# List tables
\dt

# Query users
SELECT * FROM users;
```

## 🔍 Troubleshooting

### Common Issues

1. **Port conflicts**: If ports 3000, 5173, or 5432 are already in use, modify the `docker-compose.yml` file to use different ports.

2. **Database connection issues**: Ensure the database container is healthy before the backend starts. The setup includes health checks and proper dependency management.

3. **Build failures**: If builds fail, try:
   ```bash
   docker-compose down
   docker system prune -f
   docker-compose up --build
   ```

### Logs

View logs for specific services:
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres
```

### Health Checks

All services include health checks. Monitor them with:
```bash
docker-compose ps
```

## 🛠 Development

### Making Changes

1. **Frontend changes**: Edit files in `cloud-cost-site/`, then rebuild:
   ```bash
   docker-compose up --build frontend
   ```

2. **Backend changes**: Edit files in `cloud-cost-api/`, then rebuild:
   ```bash
   docker-compose up --build backend
   ```

3. **Database changes**: Edit `init-db.sql` and restart:
   ```bash
   docker-compose down -v
   docker-compose up
   ```

### Environment Variables

Key environment variables can be modified in `docker-compose.yml`:
- Database credentials
- API ports
- Frontend API URL

## 📊 Sample Data

The database is pre-populated with sample users:
- john.doe@example.com (John Doe)
- jane.smith@example.com (Jane Smith)
- bob.wilson@example.com (Bob Wilson)

## 🔒 Security Notes

- This setup is for development/demonstration purposes
- Database credentials are hardcoded for simplicity
- In production, use environment variables and secrets management
- Consider using Docker secrets or external configuration management

## 📝 License

This project is part of a demonstration portfolio. Please refer to individual component licenses for specific terms.