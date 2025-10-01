# 🐳 Docker Quick Start - Ying Floral

Hướng dẫn nhanh để chạy Ying Floral với Docker trong 5 phút.

## 🚀 Cách 1: Sử dụng Script Tự Động (Khuyến nghị)

```bash
cd /home/pathtech/Downloads/dena/YingFloral
./docker-start.sh
```

Script sẽ tự động:
- Kiểm tra Docker đã cài chưa
- Tạo file `.env` nếu chưa có
- Build và start tất cả services
- Chờ backend khởi động
- Hỏi bạn có muốn seed data không

## 🔧 Cách 2: Manual (Step by Step)

### Bước 1: Setup Environment

```bash
cd /home/pathtech/Downloads/dena/YingFloral

# Copy và chỉnh sửa .env
cp .env.example .env
nano .env
```

**Thay đổi quan trọng trong `.env`:**
```bash
# Đổi password mạnh
POSTGRES_PASSWORD=your-strong-password-here

# Generate secrets (chạy 2 lần để có 2 secrets khác nhau)
openssl rand -hex 32
# Dán kết quả vào JWT_SECRET và COOKIE_SECRET
```

### Bước 2: Build và Start

```bash
# Build và start tất cả services
docker-compose up -d

# Xem logs
docker-compose logs -f
```

### Bước 3: Seed Data (Lần đầu chạy)

```bash
# Chờ backend khởi động (30-60 giây)
# Kiểm tra health
curl http://localhost:9000/health

# Seed flower shop data
docker-compose exec backend npm run seed:flower
```

## 🌐 Truy cập ứng dụng

- **Frontend (Storefront)**: http://localhost:8000
- **Backend API**: http://localhost:9000
- **Admin Dashboard**: http://localhost:9000/app
- **Database**: localhost:5432

## 📝 Commands Thông Dụng

```bash
# Xem logs tất cả services
docker-compose logs -f

# Xem logs backend
docker-compose logs -f backend

# Xem logs frontend
docker-compose logs -f frontend

# Restart một service
docker-compose restart backend
docker-compose restart frontend

# Stop tất cả
docker-compose down

# Stop và xóa volumes (⚠️ MẤT DATA)
docker-compose down -v

# Rebuild
docker-compose build --no-cache
docker-compose up -d
```

## 🐛 Troubleshooting

### Backend không start

```bash
# Xem logs
docker-compose logs backend

# Kiểm tra database
docker-compose logs postgres

# Restart
docker-compose restart backend
```

### Frontend build fails

```bash
# Xem logs
docker-compose logs frontend

# Check environment variables
docker-compose exec frontend env | grep NEXT_PUBLIC

# Rebuild
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

### Port đã được sử dụng

```bash
# Kiểm tra port nào đang dùng
sudo lsof -i :8000
sudo lsof -i :9000
sudo lsof -i :5432

# Hoặc đổi port trong docker-compose.yml
```

### Reset toàn bộ

```bash
# Dừng và xóa tất cả
docker-compose down -v

# Xóa images (optional)
docker-compose down --rmi all

# Start lại từ đầu
docker-compose up -d --build
docker-compose exec backend npm run seed:flower
```

## 🌟 Production Deployment

Để deploy lên server production:

```bash
# 1. Copy files lên server
scp -r . user@your-server:/opt/ying-floral

# 2. SSH vào server
ssh user@your-server
cd /opt/ying-floral

# 3. Chỉnh sửa .env cho production
nano .env
# Đổi URLs, passwords, secrets

# 4. Start services
docker-compose up -d

# 5. Setup nginx reverse proxy
# Xem DOCKER_DEPLOYMENT.md cho chi tiết
```

## 📊 Kiểm tra hệ thống

```bash
# Kiểm tra trạng thái services
docker-compose ps

# Kiểm tra resource usage
docker stats

# Health checks
curl http://localhost:8000        # Frontend
curl http://localhost:9000/health # Backend
docker-compose exec postgres pg_isready -U medusa
```

## 🔄 Update Code

```bash
# Pull code mới
git pull origin main

# Rebuild và restart
docker-compose down
docker-compose build
docker-compose up -d
```

## ⚡ Quick Reference

| Action | Command |
|--------|---------|
| Start all | `docker-compose up -d` |
| Stop all | `docker-compose down` |
| View logs | `docker-compose logs -f` |
| Restart service | `docker-compose restart [service]` |
| Rebuild | `docker-compose build --no-cache` |
| Seed data | `docker-compose exec backend npm run seed:flower` |
| Check status | `docker-compose ps` |
| Enter container | `docker-compose exec [service] sh` |

## 📚 Tài liệu chi tiết

Xem `DOCKER_DEPLOYMENT.md` cho:
- Production deployment guide
- Nginx configuration
- SSL setup
- Advanced troubleshooting
- Performance optimization

---

Made with 🌸 by Hiểu Anh | Ying Floral 