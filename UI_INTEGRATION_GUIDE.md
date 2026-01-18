# UI Integration Guide

## ✅ Completed Integrations

### 1. Authentication Module

**File:** `lib/providers/auth_provider.dart`

**Changes:**
- ✅ Replaced dummy user validation with real API calls
- ✅ Integrated `serviceProvider.auth.login()`
- ✅ JWT token automatically saved and managed
- ✅ User data stored in SharedPreferences
- ✅ Error handling for network failures

**Usage in Login Screen:**
```dart
// Already integrated in lib/modules/auth/screens/login_screen.dart
// No changes needed - it uses authProvider which now calls the API
```

---

### 2. User Model

**File:** `lib/models/user_model.dart`

**Changes:**
- ✅ Added optional fields: `roomNumber`, `hostelBlock`, `phone`, `profileImage`
- ✅ Updated `toMap()` and `fromMap()` methods
- ✅ Added `copyWith()` method for updates

---

### 3. Profile Module

**File:** `lib/providers/profile_provider.dart`

**Changes:**
- ✅ Replaced mock data with API integration
- ✅ Auto-fetches profile on initialization
- ✅ Implements `fetchProfile()` and `updateProfile()` methods
- ✅ Loading states and error handling

**How to Use:**
```dart
// In your profile screen
final profileState = ref.watch(profileProvider);

if (profileState.isLoading) {
  return CircularProgressIndicator();
}

if (profileState.error != null) {
  return Text('Error: ${profileState.error}');
}

final profile = profileState.profileData;
// Use profile data
```

---

### 4. Laundry Module

**File:** `lib/providers/laundry_provider.dart` (NEW)

**Features:**
- ✅ Fetch laundry orders with filtering
- ✅ Create new orders
- ✅ Update order status (for staff)
- ✅ Fetch and update laundry configuration
- ✅ Pull-to-refresh support

**How to Use:**
```dart
// Fetch orders
final ordersState = ref.watch(laundryOrdersProvider);
ref.read(laundryOrdersProvider.notifier).fetchOrders();

// Create order
await ref.read(laundryOrdersProvider.notifier).createOrder(
  items: [
    {'name': 'Shirt', 'quantity': 3, 'service_type': 'both'},
  ],
  serviceType: 'Wash & Press',
);

// Update status (staff only)
await ref.read(laundryOrdersProvider.notifier).updateOrderStatus(
  orderId: 'order_123',
  status: 'readyForPickup',
);
```

---

## 🔄 Screens That Need Integration

### 1. Profile Screen

**File:** `lib/modules/student/features/profile/profile_screen.dart`

**Required Changes:**
```dart
// Change from:
final profile = ref.watch(profileProvider);

// To:
final profileState = ref.watch(profileProvider);

// Add loading state
if (profileState.isLoading) {
  return Center(child: CircularProgressIndicator());
}

// Add error handling
if (profileState.error != null) {
  return Center(child: Text('Error: ${profileState.error}'));
}

// Use profile data
final profile = profileState.profileData;
```

### 2. Laundry Home Screen

**File:** `lib/modules/laundry/features/home/laundry_home_screen.dart`

**Required Changes:**
- Import `laundry_provider.dart`
- Replace mock data with `laundryOrdersProvider`
- Add pull-to-refresh
- Add loading states

**Example:**
```dart
@override
void initState() {
  super.initState();
  // Fetch orders on screen load
  Future.microtask(() {
    ref.read(laundryOrdersProvider.notifier).fetchOrders();
  });
}

@override
Widget build(BuildContext context) {
  final ordersState = ref.watch(laundryOrdersProvider);
  
  if (ordersState.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  
  return RefreshIndicator(
    onRefresh: () => ref.read(laundryOrdersProvider.notifier).refresh(),
    child: ListView.builder(
      itemCount: ordersState.orders.length,
      itemBuilder: (context, index) {
        final order = ordersState.orders[index];
        // Build order card
      },
    ),
  );
}
```

---

## 📋 Next Steps - Additional Providers Needed

### 1. Complaint Provider

Create `lib/providers/complaint_provider.dart`:
```dart
- fetchComplaints()
- createComplaint()
- uploadImage()
- updateComplaintStatus()
```

### 2. Attendance Provider

Create `lib/providers/attendance_provider.dart`:
```dart
- markAttendance()
- fetchAttendanceHistory()
- getAttendanceStats()
```

### 3. Notes Provider

Create `lib/providers/notes_provider.dart`:
```dart
- fetchNotes()
- createNote()
- updateNote()
- deleteNote()
```

### 4. Payment Provider

Create `lib/providers/payment_provider.dart`:
```dart
- fetchPaymentHistory()
- getPaymentSummary()
```

### 5. Holiday Provider

Create `lib/providers/holiday_provider.dart`:
```dart
- requestHoliday()
- fetchHolidays()
- updateHolidayStatus()
```

### 6. Vehicle Provider

Create `lib/providers/vehicle_provider.dart`:
```dart
- registerVehicle()
- getVehicleStatus()
```

### 7. Chat Provider

Create `lib/providers/chat_provider.dart`:
```dart
- fetchChatGroups()
- getMessages()
- sendMessage()
```

---

## 🧪 Testing the Integration

### 1. Start Your Backend

```bash
# Make sure your backend is running at http://localhost:3000
```

### 2. Test Authentication

1. Open the app
2. Try logging in with valid credentials
3. Check if JWT token is saved
4. Verify navigation to home screen

### 3. Test Profile

1. Navigate to profile screen
2. Verify data loads from API
3. Try updating profile
4. Check if changes are reflected

### 4. Test Laundry Orders

1. Navigate to laundry screen
2. Verify orders load from API
3. Try creating a new order
4. Check if it appears in the list

---

## 🔧 Configuration

### Update Base URL

Before testing, update the base URL in `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://localhost:3000';  // Development
// static const String baseUrl = 'https://api.yourdomain.com';  // Production
```

### For Android Emulator

If using Android emulator, use:
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

### For iOS Simulator

If using iOS simulator, use:
```dart
static const String baseUrl = 'http://localhost:3000';
```

### For Physical Device

If testing on physical device, use your computer's IP:
```dart
static const String baseUrl = 'http://192.168.x.x:3000';
```

---

## ⚠️ Common Issues & Solutions

### Issue 1: "Connection Refused"
**Solution:** Make sure backend is running and accessible from your device/emulator

### Issue 2: "Invalid credentials"
**Solution:** Verify username/password match backend database

### Issue 3: "Token not found"
**Solution:** Login again to get a fresh token

### Issue 4: "CORS Error" (Web only)
**Solution:** Configure CORS in your backend to allow requests from Flutter web

---

## 📝 Code Patterns

### Pattern 1: Fetch Data on Screen Load

```dart
@override
void initState() {
  super.initState();
  Future.microtask(() {
    ref.read(yourProvider.notifier).fetchData();
  });
}
```

### Pattern 2: Handle Loading States

```dart
final state = ref.watch(yourProvider);

if (state.isLoading) {
  return Center(child: CircularProgressIndicator());
}

if (state.error != null) {
  return Center(child: Text('Error: ${state.error}'));
}

// Use state.data
```

### Pattern 3: Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () => ref.read(yourProvider.notifier).refresh(),
  child: ListView(...),
)
```

### Pattern 4: Show Success/Error Messages

```dart
final success = await ref.read(yourProvider.notifier).performAction();

if (success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Success!')),
  );
} else {
  final error = ref.read(yourProvider).error;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $error')),
  );
}
```

---

## 🎯 Summary

**Completed:**
- ✅ Authentication integration
- ✅ User model updates
- ✅ Profile provider with API
- ✅ Laundry provider with API

**Next Steps:**
1. Update profile screen to use new provider structure
2. Update laundry screens to use new provider
3. Create providers for other modules (complaints, attendance, etc.)
4. Test all integrations with backend
5. Add error handling and loading states to all screens

**Files Modified:**
- `lib/providers/auth_provider.dart`
- `lib/models/user_model.dart`
- `lib/providers/profile_provider.dart`

**Files Created:**
- `lib/providers/laundry_provider.dart`

---

**Ready to integrate! 🚀** Start by testing the authentication flow, then gradually integrate other modules.
