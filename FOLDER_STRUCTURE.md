# API Integration Folder Structure

```
hsh_app/
│
├── lib/
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart          # Base URL, endpoints, configuration
│   │   │
│   │   └── network/
│   │       └── api_client.dart              # HTTP client (GET, POST, PUT, DELETE, Upload)
│   │
│   └── services/
│       │
│       ├── service_provider.dart            # Singleton - centralized access to all services
│       │
│       ├── auth_service.dart                # Login, Register, Logout
│       ├── student_service.dart             # Profile management
│       ├── laundry_service.dart             # Laundry orders & config
│       ├── complaint_service.dart           # Complaints & image upload
│       ├── attendance_service.dart          # Attendance marking & history
│       ├── vehicle_service.dart             # Vehicle registration
│       ├── holiday_service.dart             # Leave requests
│       ├── notes_service.dart               # Student notes CRUD
│       ├── payment_service.dart             # Payment history & summary
│       ├── chat_service.dart                # Group chat & messaging
│       │
│       └── api_integration_examples.dart    # Complete usage examples
│
└── API_INTEGRATION.md                       # Documentation (this file)
```

## 🎯 Quick Reference

### Core Files

| File | Purpose |
|------|---------|
| `api_constants.dart` | Stores base URL, all API endpoints, timeout settings |
| `api_client.dart` | HTTP client with authentication, handles all requests |
| `service_provider.dart` | Singleton pattern for easy access to all services |

### Service Files

| Service | Endpoints Covered |
|---------|-------------------|
| `auth_service.dart` | `/api/auth/login`, `/api/auth/register` |
| `student_service.dart` | `/api/student/profile` |
| `laundry_service.dart` | `/api/laundry/orders`, `/api/laundry/items`, `/api/laundry/config` |
| `complaint_service.dart` | `/api/complaints`, `/api/upload` |
| `attendance_service.dart` | `/api/attendance/mark`, `/api/attendance/history` |
| `vehicle_service.dart` | `/api/vehicle/register`, `/api/vehicle/status` |
| `holiday_service.dart` | `/api/holidays` |
| `notes_service.dart` | `/api/notes` |
| `payment_service.dart` | `/api/payments/history`, `/api/payments/summary` |
| `chat_service.dart` | `/api/chat/groups`, `/api/chat/groups/:id/messages` |

## 🔄 Data Flow

```
User Action (UI)
    ↓
Service Call (e.g., serviceProvider.laundry.getOrders())
    ↓
API Client (Adds auth token, makes HTTP request)
    ↓
Backend API (http://localhost:3000/api/...)
    ↓
API Response (JSON)
    ↓
API Client (Parses response)
    ↓
Service Returns ApiResponse
    ↓
UI Updates (Display data or error)
```

## 📦 Dependencies

The API integration uses only standard Flutter packages:

```yaml
dependencies:
  shared_preferences: ^2.2.2  # For token storage
```

No additional HTTP packages required - uses Dart's built-in `dart:io` HttpClient.

## 🎨 Usage Pattern

### 1. Import Service Provider
```dart
import 'package:hsh_app/services/service_provider.dart';
```

### 2. Make API Call
```dart
final response = await serviceProvider.laundry.getOrders();
```

### 3. Handle Response
```dart
if (response.success) {
  // Use response.data
} else {
  // Show response.message
}
```

## 🔐 Authentication Flow

```
1. User logs in
   ↓
2. auth_service.login() called
   ↓
3. API returns token
   ↓
4. Token saved to SharedPreferences
   ↓
5. All subsequent requests include token
   ↓
6. User logs out → token cleared
```

## 📱 Integration Steps

1. **Update Base URL** in `api_constants.dart`
2. **Import Service Provider** in your screens
3. **Call Services** as needed
4. **Handle Responses** with success/error states
5. **Update UI** based on response data

## 🎯 Best Practices

✅ Always check `response.success` before using data
✅ Show loading indicators during API calls
✅ Handle errors gracefully with user-friendly messages
✅ Use try-catch blocks for network errors
✅ Store sensitive data securely
✅ Clear tokens on logout

❌ Don't hardcode API URLs in multiple places
❌ Don't ignore error responses
❌ Don't make API calls in build() methods
❌ Don't forget to handle loading states
