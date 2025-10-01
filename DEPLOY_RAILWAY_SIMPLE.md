# 🚀 Deploy Railway - Siêu Đơn Giản (Web UI)

## ✅ ĐÃ CÓ SẴN:
- Railway Project: https://railway.com/project/59694fd7-b116-4382-be24-1ecfbbe7bc98
- PostgreSQL database: ✅ 
- JWT_SECRET: `3f9412d4d24d8ef2d1fd5de31d754f1c7c81307c9fedeebc98ef845374ebb825`
- COOKIE_SECRET: `0de30bb0c239b1cbaebf53b1653fb7de331b6cee9d71420d592bde9356b16f87`

---

## 📦 BƯỚC 1: Deploy Backend (5 phút)

### 1.1 Tạo Service
1. Mở: https://railway.com/project/59694fd7-b116-4382-be24-1ecfbbe7bc98
2. Click **"+ New"**
3. Chọn **"GitHub Repo"**
4. Connect GitHub nếu chưa có
5. Chọn repo **"pathtechdev/YingFloral"**
6. Railway sẽ hỏi: **"Configure Service"**

### 1.2 Config Backend Service
Click vào service vừa tạo → **"Settings"**:

**Source:**
- Root Directory: `my-medusa-store`
- (Leave branch as main)

**Build:**
- Builder: Dockerfile
- Dockerfile Path: `Dockerfile`

**Deploy:**
- Start Command: `npm run start`
- Health Check Path: `/health`

### 1.3 Environment Variables
Click tab **"Variables"** → Add these:

```bash
# Database (click "New Variable" → "Add Reference")
DATABASE_URL → Reference: PostgreSQL → DATABASE_URL

# Add these manually:
NODE_ENV=production
JWT_SECRET=3f9412d4d24d8ef2d1fd5de31d754f1c7c81307c9fedeebc98ef845374ebb825
COOKIE_SECRET=0de30bb0c239b1cbaebf53b1653fb7de331b6cee9d71420d592bde9356b16f87
STORE_CORS=*
ADMIN_CORS=*
AUTH_CORS=*
PORT=9000
```

### 1.4 Generate Domain
1. Trong Settings, scroll to **"Networking"**
2. Click **"Generate Domain"**
3. Copy domain (e.g., `backend-production-abc.up.railway.app`)
4. **SAVE THIS URL!**

### 1.5 Deploy!
- Click **"Deploy"** button (top right)
- Đợi ~3-5 phút
- Check logs: tab "Deployments" → click latest → "View Logs"
- Test: `curl https://your-backend-url.railway.app/health`

---

## 🎨 BƯỚC 2: Deploy Frontend (5 phút)

### 2.1 Tạo Service
1. Quay lại project: https://railway.com/project/59694fd7-b116-4382-be24-1ecfbbe7bc98
2. Click **"+ New"** again
3. Chọn **"GitHub Repo"**
4. Chọn repo **"pathtechdev/YingFloral"** (same repo, different folder)

### 2.2 Config Frontend Service
Click service → **"Settings"**:

**Source:**
- Root Directory: `medusa-storefront`

**Build:**
- Builder: Dockerfile
- Dockerfile Path: `Dockerfile`

**Deploy:**
- Start Command: `node server.js`

### 2.3 Environment Variables  
Click tab **"Variables"**:

```bash
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://your-backend-url-from-step-1.railway.app
NEXT_PUBLIC_DEFAULT_REGION=vn
NEXT_PUBLIC_USE_MOCK_DATA=false
NODE_ENV=production
PORT=8000
```

**⚠️ QUAN TRỌNG:** Thay `your-backend-url-from-step-1` bằng URL backend ở bước 1.4!

### 2.4 Generate Domain
1. Settings → "Networking"
2. **"Generate Domain"**
3. Copy frontend URL
4. **Quay lại Variables**, update:
   ```
   NEXT_PUBLIC_BASE_URL=https://your-frontend-url.railway.app
   ```

### 2.5 Deploy!
- Click **"Deploy"**
- Đợi ~3-5 phút
- Check logs nếu cần

---

## 🌱 BƯỚC 3: Seed Data (2 phút)

### Option A: Qua Web UI
1. Click vào **Backend service**
2. Tab **"Deployments"** → Latest deployment
3. Click **"..."** menu → **"Restart"**
4. Sau khi restart, vào database và check

### Option B: Qua Railway CLI (Easy!)
```bash
cd /home/pathtech/Downloads/dena/YingFloral/my-medusa-store
railway link
# Chọn project: ying-floral
# Chọn service: backend

railway run npm run seed:flower
```

---

## ✅ HOÀN THÀNH!

### 🎉 URLs của bạn:
- **Frontend**: https://your-frontend.up.railway.app
- **Backend**: https://your-backend.up.railway.app  
- **Admin**: https://your-backend.up.railway.app/app

### 🧪 Test ngay:
```bash
# Test backend health
curl https://your-backend.railway.app/health

# Test frontend
curl https://your-frontend.railway.app

# Mở browser
https://your-frontend.railway.app
```

---

## 🌐 BƯỚC 4: Custom Domain (Optional)

### Nếu có domain riêng (e.g., yingfloral.com):

#### 4.1 Setup Frontend Domain
1. Click vào **Frontend service**
2. Settings → **"Networking"**
3. Scroll to **"Custom Domains"**
4. Click **"Add Custom Domain"**
5. Enter: `yingfloral.com` và `www.yingfloral.com`
6. Railway sẽ cho bạn CNAME records

#### 4.2 Update DNS
Vào domain provider (Cloudflare, Namecheap, etc):
```
Type: CNAME
Name: @
Value: <railway-provided-value>

Type: CNAME  
Name: www
Value: <railway-provided-value>
```

#### 4.3 Setup Backend Domain (API subdomain)
1. Click vào **Backend service**
2. Settings → "Networking" → "Add Custom Domain"
3. Enter: `api.yingfloral.com`
4. Add CNAME record tương tự

#### 4.4 Update Environment Variables
Sau khi custom domain active:

**Backend Variables:**
```bash
STORE_CORS=https://yingfloral.com,https://www.yingfloral.com
ADMIN_CORS=https://admin.yingfloral.com
```

**Frontend Variables:**
```bash
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.yingfloral.com
NEXT_PUBLIC_BASE_URL=https://yingfloral.com
```

#### 4.5 Redeploy
- Click "Deploy" trên cả 2 services
- Đợi deploy xong
- Test: https://yingfloral.com

---

## 🐛 Troubleshooting

### Backend không start
```bash
# Check logs trong Railway
# Common issues:
1. DATABASE_URL không đúng
2. Missing JWT_SECRET hoặc COOKIE_SECRET
3. Port conflict (đảm bảo PORT=9000)
```

### Frontend không connect backend
```bash
# Check:
1. NEXT_PUBLIC_MEDUSA_BACKEND_URL có đúng không?
2. Có https:// ở đầu không?
3. Không có / ở cuối
4. Backend đã deploy xong chưa?
```

### Database issues
```bash
# Reset database:
1. Click PostgreSQL service
2. Tab "Data"
3. Click "Reset" (⚠️ mất hết data)
4. Redeploy backend
5. Seed lại: railway run npm run seed:flower
```

---

## 💰 Chi phí Railway

**Free Tier ($5 credit/month):**
- ~500 execution hours/month
- 1GB RAM per service
- 1GB disk per service
- Shared CPU

**Đủ cho:**
- Small shop: 100-500 visitors/day
- Test/staging environment
- Personal projects

**Scale up khi cần:**
- Hobby: $5/month (more resources)
- Pro: $20/month (priority support)

---

Made with 🌸 by Hiểu Anh | Ying Floral
