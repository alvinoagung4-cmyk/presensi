#!/bin/bash

# ============ BACKEND PRESENSI - SETUP SCRIPT ============

echo "╔════════════════════════════════════════════════════════╗"
echo "║   Backend Presensi - Setup Script                      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if .env exists
if [ -f .env ]; then
    echo "✅ .env file already exists"
else
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env created"
    echo "⚠️  Please edit .env with your database and email credentials"
fi

echo ""
echo "📦 Installing dependencies..."
npm install

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit .env with your database and email credentials"
echo "  2. Create PostgreSQL database: createdb presensi"
echo "  3. Run database setup: psql presensi < database.sql"
echo "  4. Start server: npm start (production) or npm run dev (development)"
echo ""
echo "🚀 Ready to go!"
