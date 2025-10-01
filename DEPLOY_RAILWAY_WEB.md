# 🚀 Deploy lên Railway (Web UI) - 10 phút

## Bước 1: Tạo tài khoản (1 phút)
1. Vào https://railway.app
2. Click **"Login"** → **"Login with GitHub"**
3. Authorize Railway
4. ✅ Có $5 credit miễn phí/tháng!

---

## Bước 2: Tạo Project mới (1 phút)
1. Click **"New Project"**
2. Chọn **"Deploy from GitHub repo"**
3. Connect GitHub account của bạn
4. Chọn repository **YingFloral**

---

## Bước 3: Add PostgreSQL (1 phút)
1. Trong project vừa tạo
2. Click **"New"** → **"Database"** → **"Add PostgreSQL"**
3. Database tự động tạo!
4. Click vào **PostgreSQL** → tab **"Variables"** → copy **DATABASE_URL**

---

## Bước 4: Deploy Backend (3 phút)

### 4.1: Add Backend Service
1. Click **"New"** → **"GitHub Repo"** → chọn repo **YingFloral**
2. Railway sẽ hỏi: chọn **root directory**
3. Click **"Settings"**
4. **Root Directory**: đổi thành `my-medusa-store`
5. **Start Command**: `npm run start`

### 4.2: Set Environment Variables
Click **"Variables"** tab, add:
```bash
DATABASE_URL=<paste từ bước 3>
NODE_ENV=production
STORE_CORS=*
ADMIN_CORS=*
AUTH_CORS=*
```

Generate secrets (chạy lệnh này 2 lần để có 2 secrets khác nhau):
```bash
openssl rand -hex 32
```

Thêm vào Railway:
```bash
JWT_SECRET=<paste secret 1>
COOKIE_SECRET=<paste secret 2>
```

### 4.3: Deploy
1. Click **"Settings"** → **"Generate Domain"**
2. Copy domain (ví dụ: `backend-production-abc.up.railway.app`)
3. Đợi deploy xong (~3-5 phút)
4. Check: https://backend-production-abc.up.railway.app/health

---

## Bước 5: Deploy Frontend (3 phút)

### 5.1: Add Frontend Service
1. Click **"New"** → **"GitHub Repo"** → chọn repo **YingFloral**
2. Click **"Settings"**
3. **Root Directory**: đổi thành `medusa-storefront`
4. **Start Command**: `node server.js`

### 5.2: Set Environment Variables
Click **"Variables"** tab, add:
```bash
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://<backend-domain-từ-bước-4>
NEXT_PUBLIC_BASE_URL=https://<sẽ-có-ở-bước-tiếp-theo>
NEXT_PUBLIC_DEFAULT_REGION=vn
NEXT_PUBLIC_USE_MOCK_DATA=false
NODE_ENV=production
```

### 5.3: Deploy
1. Click **"Settings"** → **"Generate Domain"**
2. Copy domain frontend
3. Quay lại **Variables**, update **NEXT_PUBLIC_BASE_URL** với domain vừa tạo
4. Đợi deploy xong (~3-5 phút)

---

## Bước 6: Seed Data (2 phút)

### Option A: Dùng Railway CLI
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link to backend service
railway link

# Seed data
railway run npm run seed:flower
```

### Option B: Dùng Web UI
1. Click vào **Backend service**
2. Tab **"Deployments"** → click vào deployment mới nhất
3. Click **"View Logs"**
4. Nếu backend đã start, connect qua SSH:
   - Vào tab **"Settings"**
   - Scroll xuống **"Service"**
   - Có thể exec commands ở đây

---

## ✅ HOÀN THÀNH!

**URLs của bạn:**
- 🌐 **Frontend**: https://frontend-xxx.up.railway.app
- 🔧 **Backend API**: https://backend-xxx.up.railway.app
- 👨‍💼 **Admin**: https://backend-xxx.up.railway.app/app

**Test ngay:**
```bash
# Test backend
curl https://backend-xxx.up.railway.app/health

# Test frontend
curl https://frontend-xxx.up.railway.app
```

---

## 🐛 Troubleshooting

### Backend không start
1. Check logs: Click vào Backend service → **"Deployments"** → **"View Logs"**
2. Kiểm tra DATABASE_URL đã đúng chưa
3. Kiểm tra JWT_SECRET và COOKIE_SECRET đã set chưa

### Frontend không kết nối backend
1. Kiểm tra **NEXT_PUBLIC_MEDUSA_BACKEND_URL** có đúng không
2. Phải có `https://` ở đầu
3. Không có `/` ở cuối

### Port issues
Railway tự động detect port. Nếu không được:
- Backend: Add variable `PORT=9000`
- Frontend: Add variable `PORT=8000`

---

## 💰 Chi phí

**Railway Free Tier:**
- $5 credit/tháng
- ~500 hours runtime
- 1GB RAM per service
- 1GB Storage

**Đủ để chạy shop nhỏ!**

Khi cần scale:
- Upgrade lên Hobby Plan: $5/month
- Pro Plan: $20/month

---

Made with 🌸 by Hiểu Anh
