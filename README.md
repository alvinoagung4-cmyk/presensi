# Backend Presensi API

Backend API untuk aplikasi presensi berbasis Node.js + Express + PostgreSQL.

## 🚀 Quick Start (5 menit)

### 1. Install Dependencies
```bash
npm install
```

### 2. Setup Environment
```bash
cp .env.example .env
# Edit .env dengan konfigurasi lokal Anda
```

### 3. Setup Database
```bash
# Create PostgreSQL database
createdb presensi

# Run SQL setup
psql presensi < database.sql
```

### 4. Run Development Server
```bash
npm run dev
```

**Server running:** http://localhost:3000

---

## 📦 Project Structure

```
presensi/
├── server.js              # Main application file
├── package.json           # Dependencies
├── .env.example          # Environment template
├── .gitignore            # Git ignore rules
├── Procfile              # Railway deployment
├── database.sql          # Database schema
├── DEPLOYMENT_GUIDE.md   # Full deployment instructions
└── README.md             # This file
```

---

## 🔌 API Endpoints Summary

### Auth
```
POST   /api/register              Register new user
POST   /api/login                 Login user
GET    /api/verify-email?token=X  Verify email
GET    /api/me                    Get current user (auth required)
```

### Attendance
```
POST   /api/check-in              Clock in (auth required)
POST   /api/check-out             Clock out (auth required)
GET    /api/attendance/today      Today's attendance (auth required)
GET    /api/attendance/history    Attendance history (auth required)
DELETE /api/attendance/:id        Delete record (auth required)
```

### User
```
PUT    /api/profile               Update profile (auth required)
POST   /api/change-password       Change password (auth required)
```

### Health
```
GET    /api/health                API health check
```

---

## 📝 Example Requests

### Register
```bash
curl -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "nama_lengkap": "John Doe",
    "no_hp": "08123456789",
    "email": "john@example.com",
    "password": "password123",
    "konfirmasi_password": "password123"
  }'
```

### Login
```bash
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Check In (with token)
```bash
curl -X POST http://localhost:3000/api/check-in \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "location": "Office Building A"
  }'
```

---

## 🔐 Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| DATABASE_URL | Yes | PostgreSQL connection string |
| PORT | No | Server port (default: 3000) |
| NODE_ENV | No | Environment (development/production) |
| JWT_SECRET | Yes | Secret for JWT tokens |
| EMAIL_SERVICE | Yes | Email provider (gmail, etc) |
| EMAIL_USER | Yes | Email sender address |
| EMAIL_PASS | Yes | Email app password |
| CORS_ORIGIN | No | CORS allowed origin |
| BASE_URL | No | Base URL for email links |

---

## 🐘 Database Schema

### Users Table
- `id` (INT, PK)
- `nama_lengkap` (VARCHAR)
- `no_hp` (VARCHAR)
- `email` (VARCHAR, UNIQUE)
- `password` (VARCHAR)
- `verification_token` (VARCHAR)
- `email_verified` (BOOLEAN)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

### Attendance Table
- `id` (INT, PK)
- `user_id` (INT, FK → users)
- `check_in_time` (TIMESTAMP)
- `check_out_time` (TIMESTAMP)
- `location` (VARCHAR)
- `status` (VARCHAR)
- `created_at` (TIMESTAMP)

---

## 🛠 Development Commands

```bash
# Start development server (with auto-reload)
npm run dev

# Start production server
npm start

# Install new package
npm install package-name

# View logs
npm run logs
```

---

## 🌐 Deploy to Railway

See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) for complete deployment instructions.

**Quick Deploy:**
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway up
```

---

## 🔗 Frontend Integration

### Connect with ProjectOne
1. Update frontend API base URL to Railway URL
2. Add Railway domain to CORS origins
3. Include Bearer token in API requests

Example Frontend Config:
```javascript
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000';

// Request with auth
fetch(`${API_URL}/api/me`, {
  headers: { 'Authorization': `Bearer ${token}` }
})
```

---

## 📧 Email Setup

Uses Nodemailer with Gmail. To enable:

1. Enable 2-Factor Authentication on Gmail
2. Generate App Password at [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)
3. Set `EMAIL_PASS` in .env to the 16-character password

---

## 🐛 Troubleshooting

### "Database error: connect ECONNREFUSED"
- Check PostgreSQL is running: `psql --version`
- Verify DATABASE_URL in .env
- Run database.sql: `psql presensi < database.sql`

### "Port 3000 already in use"
```bash
# Kill existing process
lsof -i :3000 | grep LISTEN | awk '{print $2}' | xargs kill -9

# Or use different port
PORT=3001 npm start
```

### Email not sending
- Verify EMAIL_USER and EMAIL_PASS
- Ensure 2FA enabled on Gmail
- Use App Password, not regular password

---

## 📚 Tech Stack

- **Runtime:** Node.js
- **Framework:** Express.js 4
- **Database:** PostgreSQL
- **Authentication:** JWT
- **Hashing:** bcryptjs
- **Email:** Nodemailer
- **Deployment:** Railway

---

## 📄 License

ISC

---

## ✍️ Author

Your Name

---

**Need help?** See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) for detailed setup & troubleshooting.
