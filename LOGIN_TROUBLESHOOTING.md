# 🔧 Login Troubleshooting Guide

## ✅ Changes Made

1. **Updated Base URL** to production backend:
   - Changed from: `http://localhost:3000`
   - Changed to: `https://hsh-backend.onrender.com`

2. **Added Debug Logging** to auth provider:
   - Shows login attempts
   - Shows API responses
   - Shows error details

---

## 🔍 How to Debug Login Issue

### Step 1: Check Console Logs

When you try to login, you should see logs like this in your console:

```
🔐 Attempting login for: username@example.com
🌐 API URL: https://hsh-backend.onrender.com/api/auth/login
📡 Response received - Success: true/false
📡 Response data: {...}
📡 Response message: ...
📡 Status code: 200/400/401/500
```

### Step 2: Identify the Issue

Based on the console output:

#### ✅ If you see: `✅ Login successful!`
- Login is working!
- Check if navigation is happening
- Verify token is saved

#### ❌ If you see: `❌ Login failed: Invalid credentials`
- **Issue:** Wrong username/password
- **Solution:** Check credentials in your backend database

#### ❌ If you see: `❌ Login error: Connection refused`
- **Issue:** Cannot reach backend
- **Solution:** Verify backend is running at `https://hsh-backend.onrender.com`

#### ❌ If you see: `❌ Login error: SocketException`
- **Issue:** Network connectivity problem
- **Solution:** 
  - Check internet connection
  - Verify backend URL is correct
  - Check if backend is deployed and running

#### ❌ If you see: `Status code: 401`
- **Issue:** Unauthorized - wrong credentials
- **Solution:** Verify username and password

#### ❌ If you see: `Status code: 500`
- **Issue:** Backend server error
- **Solution:** Check backend logs for errors

---

## 🧪 Testing Steps

### 1. Verify Backend is Running

Open browser and go to:
```
https://hsh-backend.onrender.com/api/auth/login
```

You should see a response (even if it's an error about missing credentials).

### 2. Test Login with Valid Credentials

Make sure you have a user in your backend database. Try logging in with:
- Username: (your test user)
- Password: (your test password)

### 3. Check Flutter Console

Run your app with:
```bash
flutter run
```

Watch the console for the debug logs when you click login.

---

## 🔧 Common Issues & Solutions

### Issue 1: "No response from server"

**Symptoms:**
- App hangs on loading
- No console logs appear
- Timeout error

**Solutions:**
1. Check if backend is deployed and running
2. Verify URL: `https://hsh-backend.onrender.com`
3. Check internet connection
4. Try accessing backend URL in browser

### Issue 2: "Invalid credentials"

**Symptoms:**
- Login fails immediately
- Error message shows "Invalid credentials"
- Status code 401

**Solutions:**
1. Verify username and password are correct
2. Check if user exists in backend database
3. Ensure password is not hashed incorrectly

### Issue 3: "CORS Error" (Web only)

**Symptoms:**
- Error about CORS policy
- Only happens on Flutter web

**Solutions:**
1. Add CORS headers to backend
2. Allow origin: `*` or your web app URL
3. Configure backend to accept requests from Flutter web

### Issue 4: "SSL Certificate Error"

**Symptoms:**
- Certificate verification failed
- HTTPS connection error

**Solutions:**
1. Ensure backend has valid SSL certificate
2. For development, you may need to allow insecure connections (not recommended for production)

---

## 📝 What to Check

### ✅ Backend Checklist

- [ ] Backend is deployed and running
- [ ] URL `https://hsh-backend.onrender.com` is accessible
- [ ] `/api/auth/login` endpoint exists
- [ ] Test user exists in database
- [ ] CORS is configured (if using web)

### ✅ Flutter App Checklist

- [ ] Base URL updated to `https://hsh-backend.onrender.com`
- [ ] App has internet permission (Android)
- [ ] Using correct username/password
- [ ] Console shows debug logs

---

## 🚀 Quick Test

### Test Backend Directly

Use curl or Postman to test your backend:

```bash
curl -X POST https://hsh-backend.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test@example.com","password":"password123"}'
```

Expected response:
```json
{
  "success": true,
  "token": "eyJhbGc...",
  "user": {
    "id": "123",
    "username": "test@example.com",
    "name": "Test User",
    "role": "student"
  }
}
```

---

## 📱 Platform-Specific Issues

### Android

**Internet Permission:**
Make sure `android/app/src/main/AndroidManifest.xml` has:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

**Cleartext Traffic (if needed):**
If backend uses HTTP (not recommended), add to `AndroidManifest.xml`:
```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

### iOS

**App Transport Security:**
If backend uses HTTP, update `ios/Runner/Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## 🎯 Next Steps

1. **Run the app** and try to login
2. **Check console logs** for debug messages
3. **Share the console output** if you need help
4. **Verify backend** is accessible

---

## 💡 Expected Console Output (Success)

```
🔐 Attempting login for: student@example.com
🌐 API URL: https://hsh-backend.onrender.com/api/auth/login
📡 Response received - Success: true
📡 Response data: {token: eyJhbGc..., user: {id: 123, username: student@example.com, ...}}
📡 Response message: null
📡 Status code: 200
✅ Login successful! User data: {id: 123, username: student@example.com, ...}
✅ User authenticated and saved locally
```

---

## 📞 Still Having Issues?

If login still doesn't work, please share:
1. Console logs from Flutter app
2. Backend URL and status
3. Error messages you see
4. What happens when you click login

---

**Updated:** Base URL changed to `https://hsh-backend.onrender.com` ✅
**Debug Logging:** Added to auth provider ✅

**Try logging in now and check the console output!** 🚀
