# 🐳 Docker Deployment Guide - Ying Floral

Hướng dẫn deploy Ying Floral với Docker cho cả Frontend và Backend.

## 📋 Yêu cầu

- Docker (version 20.10+)
- Docker Compose (version 2.0+)
- 2GB RAM tối thiểu
- 10GB disk space

## 🚀 Quick Start

### 1. Clone và Setup

```bash
cd /home/pathtech/Downloads/dena/YingFloral

# Copy environment variables
cp .env.example .env

# Chỉnh sửa .env với thông tin của bạn
nano .env
```

### 2. Chạy toàn bộ stack

```bash
# Build và start tất cả services
docker-compose up -d

# Xem logs
docker-compose logs -f
```

### 3. Khởi tạo database (lần đầu)

```bash
# Chạy migrations và seed data
docker-compose exec backend npm run seed:flower
```

### 4. Truy cập ứng dụng

- **Frontend (Storefront)**: http://localhost:8000
- **Backend API**: http://localhost:9000
- **Admin Dashboard**: http://localhost:9000/app
- **Database**: localhost:5432

## 📦 Services

### PostgreSQL (Database)
- Port: 5432
- User: medusa (configurable)
- Database: medusa-db
- Data được lưu trong Docker volume `postgres_data`

### Backend (Medusa)
- Port: 9000
- Framework: Medusa v2
- Node: 20
- API Docs: http://localhost:9000/docs

### Frontend (Next.js)
- Port: 8000
- Framework: Next.js 15
- Node: 20

## 🔧 Commands

### Quản lý services

```bash
# Start tất cả
docker-compose up -d

# Stop tất cả
docker-compose down

# Restart một service
docker-compose restart frontend
docker-compose restart backend

# Xem logs
docker-compose logs -f
docker-compose logs -f backend
docker-compose logs -f frontend

# Kiểm tra trạng thái
docker-compose ps
```

### Database operations

```bash
# Seed flower shop data
docker-compose exec backend npm run seed:flower

# Seed customers
docker-compose exec backend npm run seed:customers

# Access PostgreSQL shell
docker-compose exec postgres psql -U medusa -d medusa-db

# Backup database
docker-compose exec postgres pg_dump -U medusa medusa-db > backup.sql

# Restore database
docker-compose exec -T postgres psql -U medusa medusa-db < backup.sql
```

### Development

```bash
# Rebuild một service
docker-compose build backend
docker-compose build frontend

# Rebuild toàn bộ (không cache)
docker-compose build --no-cache

# Xem resource usage
docker stats
```

### Cleanup

```bash
# Stop và xóa containers
docker-compose down

# Xóa cả volumes (⚠️ MẤT DATA)
docker-compose down -v

# Xóa images
docker-compose down --rmi all
```

## 🌐 Production Deployment

### Option 1: Docker Compose trên VPS

```bash
# 1. Copy files lên server
scp -r . user@your-server:/opt/ying-floral

# 2. SSH vào server
ssh user@your-server

# 3. Navigate và setup
cd /opt/ying-floral
cp .env.example .env
nano .env  # Cập nhật với production values

# 4. Start services
docker-compose up -d

# 5. Setup nginx reverse proxy (recommended)
# See nginx configuration below
```

### Option 2: Docker Registry

```bash
# 1. Tag images
docker tag ying-floral-backend your-registry/ying-floral-backend:latest
docker tag ying-floral-frontend your-registry/ying-floral-frontend:latest

# 2. Push to registry
docker push your-registry/ying-floral-backend:latest
docker push your-registry/ying-floral-frontend:latest

# 3. Pull on production server
docker pull your-registry/ying-floral-backend:latest
docker pull your-registry/ying-floral-frontend:latest
```

## 🔒 Production Environment Variables

Cập nhật `.env` cho production:

```bash
# Strong secrets (use openssl rand -hex 32)
JWT_SECRET=your-strong-jwt-secret-min-64-chars
COOKIE_SECRET=your-strong-cookie-secret-min-64-chars

# Production URLs
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.yingfloral.com
NEXT_PUBLIC_BASE_URL=https://yingfloral.com

# CORS (add your domain)
STORE_CORS=https://yingfloral.com
ADMIN_CORS=https://admin.yingfloral.com
AUTH_CORS=https://admin.yingfloral.com

# Database (use strong password)
POSTGRES_PASSWORD=your-very-strong-database-password
```

## 🔧 Nginx Reverse Proxy (Recommended)

Tạo file `/etc/nginx/sites-available/yingfloral`:

```nginx
# Frontend
server {
    listen 80;
    server_name yingfloral.com www.yingfloral.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Backend API
server {
    listen 80;
    server_name api.yingfloral.com;

    location / {
        proxy_pass http://localhost:9000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable và restart nginx:

```bash
sudo ln -s /etc/nginx/sites-available/yingfloral /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 🔐 SSL with Let's Encrypt

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificates
sudo certbot --nginx -d yingfloral.com -d www.yingfloral.com -d api.yingfloral.com
```

## 📊 Monitoring

### Health checks

```bash
# Check frontend
curl http://localhost:8000

# Check backend
curl http://localhost:9000/health

# Check database
docker-compose exec postgres pg_isready -U medusa
```

### Logs location

```bash
# Container logs
docker-compose logs -f --tail=100 backend
docker-compose logs -f --tail=100 frontend

# Export logs
docker-compose logs > logs.txt
```

## 🐛 Troubleshooting

### Backend không start

```bash
# Check logs
docker-compose logs backend

# Kiểm tra database connection
docker-compose exec backend npm run db:check

# Rebuild
docker-compose build --no-cache backend
docker-compose up -d backend
```

### Frontend build fails

```bash
# Check if backend is running
docker-compose ps

# Check environment variables
docker-compose exec frontend env | grep NEXT_PUBLIC

# Rebuild
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

### Database connection issues

```bash
# Check if PostgreSQL is running
docker-compose ps postgres

# Check database logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

### Port conflicts

```bash
# Check what's using the port
sudo lsof -i :8000
sudo lsof -i :9000
sudo lsof -i :5432

# Change ports in docker-compose.yml if needed
```

## 📈 Performance Tips

1. **Resource limits**: Thêm vào docker-compose.yml:

```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
```

2. **Enable caching**: Uncomment build cache trong Dockerfile

3. **Use Docker volumes** cho database thay vì bind mounts

4. **Enable log rotation**:

```yaml
services:
  backend:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 🔄 Updates

```bash
# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose build
docker-compose up -d

# Run migrations if needed
docker-compose exec backend npm run build
```

## 📝 Notes

- Volumes `postgres_data` và `backend_uploads` được persist giữa các container restarts
- Health checks đảm bảo services start theo đúng thứ tự
- Frontend chỉ start sau khi backend đã healthy
- Database được health check trước khi backend start

## 🆘 Support

Nếu gặp vấn đề:
1. Check logs: `docker-compose logs -f`
2. Check health: `docker-compose ps`
3. Restart services: `docker-compose restart`
4. Rebuild: `docker-compose build --no-cache`

---

Made with 🌸 by Hiểu Anh | Ying Floral 