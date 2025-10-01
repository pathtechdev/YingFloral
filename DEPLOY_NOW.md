# 🚀 DEPLOY NGAY - Railway.app (5 phút)

## Bước 1: Tạo tài khoản Railway
1. Vào https://railway.app
2. Click "Login" → Sign in with GitHub
3. Authorize Railway

## Bước 2: Deploy Database
1. Click "New Project"
2. Chọn "Provision PostgreSQL"
3. Database sẽ tự động tạo
4. Copy DATABASE_URL (click vào PostgreSQL → Connect → Copy)

## Bước 3: Deploy Backend
1. Click "New" → "GitHub Repo"
2. Chọn repository YingFloral
3. Click "Add Service" → chọn folder `my-medusa-store`
4. Thêm Environment Variables:
   ```
   DATABASE_URL=<paste từ bước 2>
   JWT_SECRET=<chạy: openssl rand -hex 32>
   COOKIE_SECRET=<chạy: openssl rand -hex 32>
   STORE_CORS=*
   ADMIN_CORS=*
   AUTH_CORS=*
   PORT=9000
   ```
5. Railway sẽ tự build và deploy
6. Sau khi deploy xong, copy URL (ví dụ: https://backend-production-xxx.up.railway.app)

## Bước 4: Seed Data Backend
1. Trong Railway Backend service
2. Click "Settings" → "Deploy Triggers" → có thể seed sau
3. Hoặc dùng Railway CLI:
   ```bash
   railway run npm run seed:flower
   ```

## Bước 5: Deploy Frontend
1. Click "New Service" trong cùng project
2. Chọn repository YingFloral  
3. Click folder `medusa-storefront`
4. Thêm Environment Variables:
   ```
   NEXT_PUBLIC_MEDUSA_BACKEND_URL=<URL backend từ bước 3>
   NEXT_PUBLIC_BASE_URL=https://your-frontend-url.railway.app
   NEXT_PUBLIC_DEFAULT_REGION=vn
   NEXT_PUBLIC_USE_MOCK_DATA=false
   PORT=8000
   ```
5. Deploy xong!

## ✅ XONG!

URL của bạn:
- Frontend: https://frontend-xxx.up.railway.app
- Backend: https://backend-xxx.up.railway.app

---

# 🌟 CÁCH 2: Render.com (Alternative)

## Deploy Backend + Database
1. Vào https://render.com
2. Click "New +" → "PostgreSQL"
3. Tạo database
4. Click "New +" → "Web Service"
5. Connect GitHub repo
6. Chọn folder `my-medusa-store`
7. Settings:
   - Environment: Docker
   - Dockerfile Path: `my-medusa-store/Dockerfile`
8. Add Environment Variables (tương tự Railway)
9. Deploy!

## Deploy Frontend
1. Click "New +" → "Web Service"
2. Chọn folder `medusa-storefront`
3. Settings:
   - Environment: Docker
   - Dockerfile Path: `medusa-storefront/Dockerfile`
4. Add Environment Variables
5. Deploy!

---

# 🎯 CÁCH 3: Vercel (Frontend) + Railway (Backend) - NHANH NHẤT!

## Deploy Frontend lên Vercel
```bash
cd medusa-storefront

# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Set environment variables trong Vercel Dashboard:
# NEXT_PUBLIC_MEDUSA_BACKEND_URL
# NEXT_PUBLIC_USE_MOCK_DATA=false
```

## Deploy Backend lên Railway (như bước 2-4 ở trên)

---

Made with 🌸 by Hiểu Anh
