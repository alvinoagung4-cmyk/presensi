# ⚡ Quick Start - Backend Presensi

## 📌 Situasi Saat Ini

✅ Backend sudah **fully configured** dan siap deploy ke Railway  
✅ Semua file setup, dokumentasi, dan konfigurasi sudah lengkap  
✅ CORS sudah dikonfigurasi untuk connect dengan ProjectOne  

---

## 🚀 Deploy ke Railway (5 menit)

### Step 1: Setup PostgreSQL Database di Railway
```bash
1. Buka https://railway.app
2. Create New Project → Database → PostgreSQL
3. Copy DATABASE_URL dari PostgreSQL settings
4. Simpan URL ini
```

### Step 2: Set Environment Variables
1. Di Railway, buka Backend (Node App) service
2. Tab "Variables", tambahkan:
   - `DATABASE_URL` = paste dari step 1
   - `PORT` = 3000
   - `NODE_ENV` = production
   - `JWT_SECRET` = (generate: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`)
   - `EMAIL_SERVICE` = gmail
   - `EMAIL_USER` = your-email@gmail.com
   - `EMAIL_PASS` = your-app-password (bukan Gmail password)
   - `CORS_ORIGIN` = https://your-frontend-url.com

### Step 3: Create Database Tables
1. Railway → PostgreSQL → Connect
2. Copy-paste seluruh isi `database.sql`
3. Run/Execute

### Step 4: Deploy
Railway akan auto-deploy saat push code. Done! 🎉

---

## 🔗 Connect dengan ProjectOne (Frontend)

### Di Frontend (ProjectOne):
```javascript
// .env.local (development)
REACT_APP_API_URL=http://localhost:3000

// .env.production
REACT_APP_API_URL=https://your-railway-url.up.railway.app
```

### API Usage:
```javascript
const API_URL = process.env.REACT_APP_API_URL;

// Login
const res = await fetch(`${API_URL}/api/login`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, password })
});

// Check In (with token)
const res = await fetch(`${API_URL}/api/check-in`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({ location })
});
```

---

## 📂 Files Created/Updated

| File | Purpose |
|------|---------|
| `.env` | Environment variables (edit with your credentials) |
| `.env.example` | Template untuk reference |
| `server.js` | Updated dengan production-ready code |
| `database.sql` | SQL untuk create tables di PostgreSQL |
| `Procfile` | Railway deployment config |
| `DEPLOYMENT_GUIDE.md` | **Detailed deployment guide** |
| `FRONTEND_INTEGRATION.md` | **How to connect ProjectOne** |
| `README.md` | Project overview dan quick start |
| `setup.sh` | Setup automation script |

---

## 🔑 Environment Variables Needed

### Database
- `DATABASE_URL` - PostgreSQL connection string dari Railway

### Server
- `PORT` - Default: 3000
- `NODE_ENV` - production atau development

### Authentication
- `JWT_SECRET` - Random 32+ characters

### Email
- `EMAIL_SERVICE` - gmail
- `EMAIL_USER` - your-email@gmail.com
- `EMAIL_PASS` - App password dari Gmail (bukan password biasa)

### URLs
- `CORS_ORIGIN` - Frontend URL untuk CORS
- `BASE_URL` - Backend URL untuk email links

---

## 🧪 Test API (di local)

### Setup Local Database
```bash
# Create database
createdb presensi

# Create tables
psql presensi < database.sql

# Run server
npm run dev
```

### Test Endpoints
```bash
# Health check
curl http://localhost:3000/api/health

# Register
curl -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"nama_lengkap":"Test","email":"test@example.com","password":"test123","konfirmasi_password":"test123","no_hp":"08123456789"}'

# Login
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

---

## 🐛 Troubleshooting

### Database connection error?
- Pastikan `DATABASE_URL` set di .env
- Untuk local, setup PostgreSQL dulu
- Run `psql presensi < database.sql`

### CORS error dari frontend?
- Add frontend URL ke `allowedOrigins` di server.js
- Set `CORS_ORIGIN` environment variable

### Email not sending?
- Use Gmail App Password (bukan regular password)
- Enable 2FA di Gmail dulu
- Check `EMAIL_USER` dan `EMAIL_PASS` di .env

### Port already in use?
```bash
# Find and kill process
lsof -i :3000 | grep LISTEN | awk '{print $2}' | xargs kill -9
```

---

## 📚 Read These for Details

1. **DEPLOYMENT_GUIDE.md** - Complete Railway setup
2. **FRONTEND_INTEGRATION.md** - ProjectOne integration examples
3. **README.md** - API endpoints & tech stack

---

## ✅ Pre-Deployment Checklist

Before pushing to Railway:

- [ ] `.env` file dengan DATABASE_URL temporary
- [ ] `npm install` success, semua dependencies ada
- [ ] `npm run dev` bisa start (database error OK)
- [ ] `database.sql` ready untuk run di Railway
- [ ] CORS origins sudah dikonfigurasi
- [ ] JWT_SECRET sudah di-generate
- [ ] Email setup (if using)
- [ ] Procfile ada

---

## 🚢 Final Deployment Steps

```bash
# 1. Commit semua changes
git add .
git commit -m "Production setup: Railway configuration"

# 2. Push ke repository
git push origin main

# 3. Deployment otomatis di Railway
# Railway akan auto-deploy saat code pushed

# 4. Set environment variables di Railway
# (sudah dijelaskan di atas)

# 5. Run database.sql di Railway PostgreSQL
# (sudah dijelaskan di atas)

# 6. Get Railway URL
# Format: https://projectname-prod.up.railway.app

# 7. Update ProjectOne .env.production
# Set REACT_APP_API_URL ke Railway URL
```

---

## 🎯 Next Steps

1. **Setup Railway PostgreSQL** (5 min)
2. **Deploy code** (1 min)
3. **Configure env variables** (5 min)
4. **Run database.sql** (2 min)
5. **Test API** (5 min)
6. **Connect ProjectOne** (10 min)

**Total time: ~30 minutes** ⏱️

---

## 💬 Need Help?

- See `DEPLOYMENT_GUIDE.md` for detailed instructions
- See `FRONTEND_INTEGRATION.md` for code examples
- Check error messages in Railway logs: `railway logs`

---

**Status: ✅ Ready to Deploy**  
Last Updated: January 30, 2026
