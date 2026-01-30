# 📋 Panduan Setup & Deployment Backend Presensi ke Railway

## 🚀 Quick Start - Local Development

### 1. Install Dependencies
```bash
npm install
```

### 2. Setup Environment Variables
Salin `.env.example` ke `.env` dan isi dengan data Anda:
```bash
cp .env.example .env
```

Edit `.env`:
```env
DATABASE_URL=postgresql://localhost/presensi
PORT=3000
NODE_ENV=development
JWT_SECRET=your-secret-key-min-32-chars
EMAIL_SERVICE=gmail
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
CORS_ORIGIN=http://localhost:8080
BASE_URL=http://localhost:3000
```

### 3. Setup Database Lokal
```bash
# Buat database
createdb presensi

# Jalankan SQL script
psql presensi < database.sql
```

### 4. Jalankan Server
```bash
# Development (dengan auto-reload)
npm run dev

# Production
npm start
```

Server akan berjalan di `http://localhost:3000`

---

## 🌐 Deployment ke Railway

### 1. Persiapan Project
```bash
# Initialize git (jika belum)
git init
git add .
git commit -m "Initial commit"
```

### 2. Deploy ke Railway
**Option A: Menggunakan Railway Dashboard**
1. Buka [https://railway.app](https://railway.app)
2. Login/Register
3. Klik "New Project"
4. Pilih "Deploy from GitHub"
5. Pilih repository `presensi`
6. Railway akan auto-detect Node.js

**Option B: Menggunakan Railway CLI**
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link project
railway link

# Deploy
railway up
```

### 3. Setup PostgreSQL di Railway
1. Di Railway Dashboard, klik "New"
2. Pilih "Database" → "PostgreSQL"
3. Railway akan membuat database baru
4. Salin `DATABASE_URL` dari PostgreSQL plugin settings

### 4. Setup Environment Variables
Di Railway Dashboard:
1. Klik project Anda
2. Klik service "Node App"
3. Buka tab "Variables"
4. Tambahkan:

```
DATABASE_URL=postgresql://user:pass@host:5432/database
PORT=3000
NODE_ENV=production
JWT_SECRET=[generate dari: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"]
EMAIL_SERVICE=gmail
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
CORS_ORIGIN=https://yourdomain.com
BASE_URL=https://yourdomain.com
```

### 5. Setup Database Tables
1. Di Railway Dashboard, buka PostgreSQL plugin
2. Klik "Connect"
3. Copy seluruh isi `database.sql`
4. Paste di Query Editor
5. Run/Execute

### 6. Dapatkan Railway URL
Di Railway Dashboard:
- Services → Node App
- URL akan terlihat: `https://projectname-prod.up.railway.app`
- Gunakan URL ini untuk CORS_ORIGIN dan BASE_URL

---

## 🔗 Koneksi dengan ProjectOne (Frontend)

### Setup CORS untuk Frontend ProjectOne
Edit `server.js` (sudah dikonfigurasi, tapi bisa diubah jika perlu):

```javascript
const allowedOrigins = [
  'http://localhost:3000',
  'http://localhost:8080',
  'http://192.168.1.1:8080',
  'https://projectone.vercel.app', // URL frontend Anda
  process.env.CORS_ORIGIN || '*'
];
```

### API Base URL di Frontend
Di projectone, set API base URL ke Railway URL:

```javascript
// React example
const API_URL = 'https://projectname-prod.up.railway.app';

// atau dari env
const API_URL = process.env.REACT_APP_API_URL;
```

### Contoh API Calls dari Frontend
```javascript
// Login
const response = await fetch(`${API_URL}/api/login`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, password })
});

// Get Current User
const response = await fetch(`${API_URL}/api/me`, {
  headers: { 'Authorization': `Bearer ${token}` }
});

// Check In
const response = await fetch(`${API_URL}/api/check-in`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({ location: 'Office' })
});
```

---

## 📝 API Endpoints

### Authentication
- `POST /api/register` - Daftar user baru
- `POST /api/login` - Login
- `GET /api/verify-email?token=...` - Verifikasi email
- `GET /api/me` - Get current user (require token)

### Profile
- `PUT /api/profile` - Update profile
- `POST /api/change-password` - Ubah password

### Attendance
- `POST /api/check-in` - Check in
- `POST /api/check-out` - Check out
- `GET /api/attendance/today` - Get today's attendance
- `GET /api/attendance/history` - Get attendance history
- `DELETE /api/attendance/:id` - Delete attendance record

### Health Check
- `GET /api/health` - Test API

---

## 🔒 Environment Variables Reference

| Variable | Deskripsi | Contoh |
|----------|-----------|--------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://user:pass@host:5432/db` |
| `PORT` | Port server | `3000` |
| `NODE_ENV` | Environment | `production` atau `development` |
| `JWT_SECRET` | Secret untuk JWT signing | Random 32+ chars |
| `EMAIL_SERVICE` | Email service provider | `gmail` |
| `EMAIL_USER` | Email address | `app@gmail.com` |
| `EMAIL_PASS` | Email password/app password | App password (bukan password Gmail biasa) |
| `CORS_ORIGIN` | CORS allowed origin | `https://yourdomain.com` |
| `BASE_URL` | Base URL untuk email links | `https://yourdomain.com` |

---

## 📧 Setup Email (Gmail)

### Langkah-langkah:
1. Buka [myaccount.google.com](https://myaccount.google.com)
2. Security → 2-Step Verification (aktifkan)
3. Security → App Passwords
4. Select "Mail" dan "Windows Computer"
5. Google akan generate 16-char password
6. Copy ke `EMAIL_PASS` di .env

### Troubleshooting Email:
- Pastikan 2FA aktif
- Gunakan App Password bukan regular password
- Izinkan "Less secure app access" (jika diperlukan)

---

## 🐛 Troubleshooting

### Database Connection Error
```
❌ Database error: connect ECONNREFUSED
```
**Solution:**
- Pastikan `DATABASE_URL` benar di Railway
- Pastikan database sudah di-initialize dengan SQL script
- Cek PostgreSQL service di Railway sudah running

### Email Not Sending
**Solution:**
- Pastikan EMAIL_USER dan EMAIL_PASS benar
- Gunakan App Password untuk Gmail (bukan regular password)
- Cek EMAIL_SERVICE setting

### CORS Error
**Solution:**
- Tambahkan frontend URL ke `allowedOrigins` di server.js
- Pastikan `CORS_ORIGIN` env variable sudah diset
- Test dengan `*` dulu, tapi ubah sebelum production

### Port Already in Use
```
Error: listen EADDRINUSE :::3000
```
**Solution:**
```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>

# Atau gunakan port lain
PORT=3001 npm start
```

---

## 📚 Useful Commands

```bash
# Generate JWT Secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Test API health
curl https://yourdomain.com/api/health

# View Railway logs
railway logs

# Pull env variables dari Railway
railway env pull

# Run locally with Railway env
railway run npm start
```

---

## ✅ Checklist Pre-Production

- [ ] Semua env variables sudah diset di Railway
- [ ] Database dan tables sudah dibuat
- [ ] Email configuration sudah ditest
- [ ] CORS origins sudah dikonfigurasi
- [ ] JWT_SECRET sudah di-generate secara random
- [ ] NODE_ENV set ke `production`
- [ ] Base URL/Domain sudah diupdate
- [ ] SSL/HTTPS sudah aktif (Railway default)
- [ ] Logging sudah disetup
- [ ] Backup database strategy sudah direncanakan

---

## 🆘 Support & Debug

### Check Server Status
```bash
# View logs di Railway
railway logs

# View recent logs
railway logs --tail
```

### Test Endpoints
```bash
# Health check
curl https://yourdomain.com/api/health

# Register
curl -X POST https://yourdomain.com/api/register \
  -H "Content-Type: application/json" \
  -d '{"nama_lengkap":"Test","email":"test@example.com","password":"test123"}'
```

---

**Last Updated:** January 2026
**Backend**: Node.js + Express + PostgreSQL
**Hosting**: Railway
