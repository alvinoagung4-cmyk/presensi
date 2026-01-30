# 🔗 Panduan Koneksi Backend Presensi dengan Frontend ProjectOne

## 📌 Overview

Backend Presensi dan Frontend ProjectOne adalah dua aplikasi terpisah yang perlu terhubung via API.

```
┌─────────────────────┐         API Calls          ┌──────────────────────┐
│   ProjectOne        │ ◄────────────────────► │   Backend Presensi   │
│   (Frontend)        │      (JSON REST API)    │   (Node.js + PG)     │
└─────────────────────┘                         └──────────────────────┘
   React/Vue/Vanilla        Port 8080, 3000          Port 3000, Railway
   localhost:8080            http://localhost        https://xxx.railway.app
```

---

## 🔧 Setup Langkah-Langkah

### 1️⃣ Backend API URL Configuration

#### Local Development
```javascript
// projectone/.env.local atau projectone/src/config.js
REACT_APP_API_URL = "http://localhost:3000"
VUE_APP_API_URL = "http://localhost:3000"
```

#### Production (Railway)
```javascript
// projectone/.env.production
REACT_APP_API_URL = "https://projectname-prod.up.railway.app"
VUE_APP_API_URL = "https://projectname-prod.up.railway.app"
```

---

### 2️⃣ CORS Configuration (Backend Presensi)

Backend sudah dikonfigurasi untuk accept requests dari multiple origins.

Di `server.js`, CORS allowedOrigins termasuk:
```javascript
const allowedOrigins = [
  'http://localhost:3000',
  'http://localhost:3001',
  'http://localhost:8080',      // ProjectOne local
  'http://192.168.1.1:8080',     // ProjectOne on network
  'https://projectone.vercel.app', // ProjectOne production
  process.env.CORS_ORIGIN || '*'
];
```

**Jika ProjectOne di URL lain:**
Edit `server.js` dan tambahkan URL frontend ke `allowedOrigins`:
```javascript
const allowedOrigins = [
  // ... existing origins
  'https://your-projectone-url.com'
];
```

---

### 3️⃣ API Integration di ProjectOne

#### Setup API Service
```javascript
// projectone/src/services/api.js atau similar

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000';

const api = {
  // Authentication
  register: (data) => fetch(`${API_URL}/api/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  }).then(r => r.json()),

  login: (email, password) => fetch(`${API_URL}/api/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password })
  }).then(r => r.json()),

  // Attendance
  checkIn: (token, location) => fetch(`${API_URL}/api/check-in`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({ location })
  }).then(r => r.json()),

  checkOut: (token) => fetch(`${API_URL}/api/check-out`, {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${token}` }
  }).then(r => r.json()),

  getTodayAttendance: (token) => fetch(`${API_URL}/api/attendance/today`, {
    headers: { 'Authorization': `Bearer ${token}` }
  }).then(r => r.json()),

  getAttendanceHistory: (token) => fetch(`${API_URL}/api/attendance/history`, {
    headers: { 'Authorization': `Bearer ${token}` }
  }).then(r => r.json()),

  // Profile
  getCurrentUser: (token) => fetch(`${API_URL}/api/me`, {
    headers: { 'Authorization': `Bearer ${token}` }
  }).then(r => r.json()),

  updateProfile: (token, data) => fetch(`${API_URL}/api/profile`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify(data)
  }).then(r => r.json())
};

export default api;
```

#### Usage in Components

**React Example:**
```javascript
import api from './services/api';

export function LoginPage() {
  const handleLogin = async (email, password) => {
    try {
      const response = await api.login(email, password);
      if (response.success) {
        localStorage.setItem('token', response.token);
        localStorage.setItem('user', JSON.stringify(response.user));
        // Redirect to dashboard
      } else {
        console.error(response.message);
      }
    } catch (error) {
      console.error('Login failed:', error);
    }
  };

  return (
    <form onSubmit={(e) => {
      e.preventDefault();
      handleLogin(email, password);
    }}>
      {/* form fields */}
    </form>
  );
}
```

**Check In Example:**
```javascript
export function AttendancePage() {
  const handleCheckIn = async () => {
    const token = localStorage.getItem('token');
    const location = 'Office Building A'; // Get from GPS or input

    try {
      const response = await api.checkIn(token, location);
      if (response.success) {
        alert('Check in berhasil!');
      }
    } catch (error) {
      console.error('Check in failed:', error);
    }
  };

  return (
    <button onClick={handleCheckIn}>
      Check In
    </button>
  );
}
```

---

### 4️⃣ Token Management

Backend menggunakan JWT tokens untuk authentication.

#### Store Token (after login)
```javascript
const response = await api.login(email, password);
if (response.success) {
  localStorage.setItem('token', response.token);
  localStorage.setItem('user', JSON.stringify(response.user));
}
```

#### Include Token in Requests
```javascript
const token = localStorage.getItem('token');
const headers = {
  'Content-Type': 'application/json',
  'Authorization': `Bearer ${token}`
};

fetch(`${API_URL}/api/me`, { headers })
  .then(r => r.json());
```

#### Token Expiry (7 days)
- After 7 days, token expires
- User needs to login again
- Add logout/re-login on 401 response

```javascript
// Interceptor for 401 responses
async function fetchWithAuth(url, options = {}) {
  const token = localStorage.getItem('token');
  
  const headers = {
    ...options.headers,
    'Authorization': `Bearer ${token}`
  };

  const response = await fetch(url, { ...options, headers });
  
  if (response.status === 401) {
    // Token expired
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.location.href = '/login'; // Redirect to login
  }
  
  return response;
}
```

---

### 5️⃣ Error Handling

API returns consistent error format:
```json
{
  "success": false,
  "message": "Error description"
}
```

**Handle errors:**
```javascript
try {
  const response = await api.checkIn(token, location);
  
  if (!response.success) {
    console.error('API Error:', response.message);
    // Show error to user
    showErrorAlert(response.message);
  } else {
    // Success
    showSuccessAlert('Check in successful!');
  }
} catch (error) {
  console.error('Network Error:', error);
  showErrorAlert('Network error. Please try again.');
}
```

---

### 6️⃣ Environment Configuration

#### ProjectOne `.env` file
```bash
# Local development
REACT_APP_API_URL=http://localhost:3000

# Or define in .env.production
REACT_APP_API_URL=https://projectname-prod.up.railway.app
```

#### Build & Deploy
```bash
# Build with production env
npm run build

# API URL will be automatically set from .env.production
```

---

## 🔌 Complete API Endpoints Reference

### Auth Endpoints
| Method | Endpoint | Body | Auth |
|--------|----------|------|------|
| POST | `/api/register` | {nama_lengkap, email, password, konfirmasi_password, no_hp} | No |
| POST | `/api/login` | {email, password} | No |
| GET | `/api/verify-email?token=X` | - | No |
| GET | `/api/me` | - | Yes |

### Attendance Endpoints
| Method | Endpoint | Body | Auth |
|--------|----------|------|------|
| POST | `/api/check-in` | {location} | Yes |
| POST | `/api/check-out` | - | Yes |
| GET | `/api/attendance/today` | - | Yes |
| GET | `/api/attendance/history` | - | Yes |
| DELETE | `/api/attendance/:id` | - | Yes |

### Profile Endpoints
| Method | Endpoint | Body | Auth |
|--------|----------|------|------|
| PUT | `/api/profile` | {email?, no_hp?} | Yes |
| POST | `/api/change-password` | {old_password, new_password} | Yes |

---

## 🧪 Testing API Connections

### Using Postman/Thunder Client

1. **Register User**
   ```
   POST http://localhost:3000/api/register
   Content-Type: application/json

   {
     "nama_lengkap": "Test User",
     "email": "test@example.com",
     "password": "test123",
     "konfirmasi_password": "test123",
     "no_hp": "08123456789"
   }
   ```

2. **Login**
   ```
   POST http://localhost:3000/api/login
   Content-Type: application/json

   {
     "email": "test@example.com",
     "password": "test123"
   }
   ```
   Response akan contain `token` - copy untuk step berikutnya

3. **Check In (with token)**
   ```
   POST http://localhost:3000/api/check-in
   Content-Type: application/json
   Authorization: Bearer <PASTE_TOKEN_HERE>

   {
     "location": "Office"
   }
   ```

---

## 🚀 Deployment Checklist

- [ ] Backend deployed to Railway
- [ ] Railway PostgreSQL database setup
- [ ] Environment variables set in Railway
- [ ] Frontend API_URL points to Railway backend
- [ ] CORS origins updated in backend
- [ ] Email configuration working
- [ ] Test login flow works
- [ ] Test check-in/check-out works
- [ ] Token refresh/expiry handled
- [ ] Error messages show to user
- [ ] Logging configured
- [ ] Performance optimized (caching, etc)

---

## 🆘 Troubleshooting

### CORS Error: "Access-Control-Allow-Origin"
**Solution:**
1. Check frontend URL is in `allowedOrigins` in server.js
2. Add to `.env`: `CORS_ORIGIN=https://your-frontend-url.com`
3. Restart backend server

### 401 Unauthorized
**Solution:**
1. Check token is included in Authorization header
2. Format: `Authorization: Bearer <token>`
3. Check token not expired (7 days)

### API returns 404
**Solution:**
1. Check API endpoint path is correct
2. Check backend is running on correct port
3. Check API_URL in frontend is correct

### Email not sending
**Solution:**
1. Check EMAIL_USER and EMAIL_PASS in .env
2. Use Gmail App Password (not regular password)
3. Enable 2FA on Gmail account

---

## 📚 Example Project Structure

```
projectone/
├── src/
│   ├── services/
│   │   └── api.js              # API service with all endpoints
│   ├── pages/
│   │   ├── LoginPage.js
│   │   ├── RegisterPage.js
│   │   ├── DashboardPage.js
│   │   └── AttendancePage.js
│   ├── components/
│   │   ├── CheckInButton.js
│   │   ├── CheckOutButton.js
│   │   └── AttendanceHistory.js
│   ├── App.js
│   └── index.js
├── .env.local
├── .env.production
├── package.json
└── README.md
```

---

**Last Updated:** January 2026
**Backend:** Node.js + Express + PostgreSQL  
**Frontend:** React/Vue/Vanilla JS  
**Hosting:** Railway (Backend) + Vercel/Netlify (Frontend)
