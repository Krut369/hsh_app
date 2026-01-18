# API Integration Documentation

This document explains the API integration structure for the HSH (Hostel Management) App.

## 📁 Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart          # API endpoints and configuration
│   └── network/
│       └── api_client.dart              # HTTP client with auth support
└── services/
    ├── service_provider.dart            # Centralized service access
    ├── auth_service.dart                # Authentication
    ├── student_service.dart             # Student profile
    ├── laundry_service.dart             # Laundry orders
    ├── complaint_service.dart           # Complaints & maintenance
    ├── attendance_service.dart          # Attendance tracking
    ├── vehicle_service.dart             # Vehicle registration
    ├── holiday_service.dart             # Leave requests
    ├── notes_service.dart               # Student notes
    ├── payment_service.dart             # Payment history
    ├── chat_service.dart                # Group chat
    └── api_integration_examples.dart    # Usage examples
```

## 🚀 Quick Start

### 1. Configuration

The base URL is configured in `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://localhost:3000';
```

**Important:** Change this to your production URL before deployment!

### 2. Basic Usage

#### Login Example

```dart
import 'package:hsh_app/services/service_provider.dart';

// Login
final response = await serviceProvider.auth.login(
  username: 'student123',
  password: 'password123',
);

if (response.success) {
  print('Login successful!');
  // Token is automatically saved
} else {
  print('Error: ${response.message}');
}
```

#### Get Student Profile

```dart
final response = await serviceProvider.student.getProfile();

if (response.success) {
  final profileData = response.data;
  print('Name: ${profileData['name']}');
  print('Room: ${profileData['room_number']}');
}
```

#### Create Laundry Order

```dart
final response = await serviceProvider.laundry.createOrder(
  items: [
    {
      'name': 'Shirt',
      'quantity': 3,
      'service_type': 'both',
    },
  ],
  serviceType: 'Wash & Press',
  note: 'Handle with care',
);

if (response.success) {
  print('Order created: ${response.data['order_id']}');
}
```

## 📚 Available Services

### AuthService
- `login()` - User login
- `register()` - User registration
- `logout()` - Clear session
- `isLoggedIn()` - Check auth status
- `getToken()` - Get current token

### StudentService
- `getProfile()` - Get user profile
- `updateProfile()` - Update profile details

### LaundryService
- `createOrder()` - Create new order
- `getOrders()` - Get order list (with filters)
- `getOrderById()` - Get single order
- `updateOrderStatus()` - Update status (staff only)
- `getItems()` - Get available items
- `getConfig()` - Get pricing config
- `updateConfig()` - Update pricing (admin only)

### ComplaintService
- `createComplaint()` - Submit complaint
- `getComplaints()` - Get complaints (with filters)
- `getComplaintById()` - Get single complaint
- `updateComplaintStatus()` - Update status (staff only)
- `uploadImage()` - Upload complaint image
- `uploadImages()` - Upload multiple images

### AttendanceService
- `markAttendance()` - Mark attendance (QR or manual)
- `getAttendanceHistory()` - Get attendance records
- `getAttendanceStats()` - Get statistics

### VehicleService
- `registerVehicle()` - Register new vehicle
- `getVehicleStatus()` - Check registration status
- `getAllVehicles()` - Get all vehicles (admin)
- `updateVehicleStatus()` - Approve/reject (admin)

### HolidayService
- `requestHoliday()` - Submit leave request
- `getHolidays()` - Get leave requests
- `getHolidayById()` - Get single request
- `updateHolidayStatus()` - Approve/reject (leader)
- `cancelHoliday()` - Cancel request

### NotesService
- `getNotes()` - Get all notes
- `getNoteById()` - Get single note
- `createNote()` - Create new note
- `updateNote()` - Update note
- `deleteNote()` - Delete note

### PaymentService
- `getPaymentHistory()` - Get transaction history
- `getPaymentSummary()` - Get totals (pending/paid)
- `getPaymentById()` - Get single payment
- `createPayment()` - Initiate payment
- `updatePaymentStatus()` - Update status (admin)

### ChatService
- `getChatGroups()` - Get user's groups
- `getChatGroupById()` - Get single group
- `createChatGroup()` - Create group (leader)
- `getMessages()` - Get message history
- `sendMessage()` - Send message
- `addMembers()` - Add members (leader)
- `removeMember()` - Remove member (leader)
- `markAsRead()` - Mark messages as read

## 🔐 Authentication

The API client automatically handles authentication:

1. **Login:** Token is saved automatically after successful login
2. **Requests:** Token is included in all authenticated requests
3. **Logout:** Token is cleared from storage

```dart
// Check if user is logged in
if (serviceProvider.auth.isLoggedIn()) {
  // User is authenticated
}

// Get current token
final token = serviceProvider.auth.getToken();
```

## 📤 File Upload

For services that require file uploads (complaints, vehicle registration):

```dart
import 'dart:io';

// Upload single image
final imageFile = File('/path/to/image.jpg');
final response = await serviceProvider.complaint.uploadImage(imageFile);

if (response.success) {
  final imageUrl = response.data['url'];
  // Use imageUrl in your complaint
}

// Upload multiple images
final images = [File('image1.jpg'), File('image2.jpg')];
final urls = await serviceProvider.complaint.uploadImages(images);
```

## 🎯 Error Handling

All API calls return an `ApiResponse` object:

```dart
class ApiResponse {
  final bool success;        // true if request succeeded
  final dynamic data;        // response data
  final String? message;     // error message if failed
  final int? statusCode;     // HTTP status code
}
```

**Example:**

```dart
final response = await serviceProvider.laundry.getOrders();

if (response.success) {
  // Handle success
  final orders = response.data;
} else {
  // Handle error
  print('Error: ${response.message}');
  print('Status code: ${response.statusCode}');
}
```

## 🔄 Using in Widgets

### Example: Login Screen

```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final response = await serviceProvider.auth.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (response.success) {
        // Navigate to home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Login failed')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build your UI
  }
}
```

### Example: Fetching Data

```dart
class LaundryOrdersScreen extends StatefulWidget {
  @override
  State<LaundryOrdersScreen> createState() => _LaundryOrdersScreenState();
}

class _LaundryOrdersScreenState extends State<LaundryOrdersScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    final response = await serviceProvider.laundry.getOrders();

    if (response.success) {
      setState(() {
        _orders = response.data;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      // Show error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return ListTile(
          title: Text(order['order_id']),
          subtitle: Text(order['status']),
        );
      },
    );
  }
}
```

## 🔧 Advanced Configuration

### Custom Timeout

Edit `lib/core/constants/api_constants.dart`:

```dart
static const Duration connectionTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);
```

### Custom Headers

The API client automatically adds:
- `Content-Type: application/json`
- `Accept: application/json`
- `Authorization: Bearer <token>` (when authenticated)

## 📝 Notes

1. **Base URL:** Remember to change `baseUrl` in `api_constants.dart` for production
2. **Token Storage:** Tokens are stored using `shared_preferences`
3. **Error Handling:** Always check `response.success` before using `response.data`
4. **File Uploads:** Use multipart/form-data for file uploads
5. **WebSocket:** For real-time chat, you'll need to implement WebSocket separately

## 🎨 Integration with Riverpod

If you want to use Riverpod for state management:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for laundry orders
final laundryOrdersProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await serviceProvider.laundry.getOrders();
  if (response.success) {
    return response.data;
  }
  throw Exception(response.message);
});

// Use in widget
class LaundryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(laundryOrdersProvider);

    return ordersAsync.when(
      data: (orders) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

## 🚀 Next Steps

1. Update the base URL in `api_constants.dart`
2. Test authentication flow
3. Integrate services into your existing screens
4. Add error handling and loading states
5. Implement WebSocket for real-time chat (if needed)

## 📞 Support

For more examples, see `lib/services/api_integration_examples.dart`
