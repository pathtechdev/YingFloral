#!/bin/bash

echo "�� Ying Floral - Deploy 1-Click lên Railway"
echo "=========================================="
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "📥 Installing Railway CLI..."
    npm install -g @railway/cli
fi

echo "✅ Railway CLI ready"
echo ""

# Login to Railway
echo "🔐 Logging in to Railway..."
railway login

echo ""
echo "📦 Creating new Railway project..."
railway init

echo ""
echo "🗄️  Adding PostgreSQL..."
railway add --plugin postgresql

echo ""
echo "🔧 Setting up Backend..."
cd my-medusa-store

# Set backend environment variables
railway variables set NODE_ENV=production
railway variables set JWT_SECRET=$(openssl rand -hex 32)
railway variables set COOKIE_SECRET=$(openssl rand -hex 32)
railway variables set STORE_CORS="*"
railway variables set ADMIN_CORS="*"
railway variables set AUTH_CORS="*"

# Deploy backend
railway up

echo ""
BACKEND_URL=$(railway domain)
echo "✅ Backend deployed: $BACKEND_URL"

cd ..

echo ""
echo "🎨 Setting up Frontend..."
cd medusa-storefront

# Set frontend environment variables
railway variables set NEXT_PUBLIC_MEDUSA_BACKEND_URL="https://$BACKEND_URL"
railway variables set NEXT_PUBLIC_DEFAULT_REGION="vn"
railway variables set NEXT_PUBLIC_USE_MOCK_DATA="false"
railway variables set NODE_ENV=production

# Deploy frontend
railway up

FRONTEND_URL=$(railway domain)
echo "✅ Frontend deployed: $FRONTEND_URL"

cd ..

echo ""
echo "🌱 Seeding data..."
cd my-medusa-store
railway run npm run seed:flower

echo ""
echo "=========================================="
echo "🎉 DEPLOYMENT COMPLETE!"
echo "=========================================="
echo ""
echo "🌐 Frontend: https://$FRONTEND_URL"
echo "🔧 Backend:  https://$BACKEND_URL"
echo "👨‍💼 Admin:    https://$BACKEND_URL/app"
echo ""
echo "Made with 🌸 by Hiểu Anh"

