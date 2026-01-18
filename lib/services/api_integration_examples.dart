import 'package:flutter/material.dart';
import '../services/service_provider.dart';

/// Example usage of API services
/// 
/// This file demonstrates how to integrate the backend API services
/// into your Flutter application.

class ApiIntegrationExamples {
  
  // ==================== AUTHENTICATION ====================
  
  /// Example: Login
  static Future<void> loginExample() async {
    try {
      final response = await serviceProvider.auth.login(
        username: 'student123',
        password: 'password123',
      );

      if (response.success) {
        print('Login successful!');
        print('Token: ${serviceProvider.auth.getToken()}');
        print('User data: ${response.data}');
        
        // Navigate to home screen
        // Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('Login failed: ${response.message}');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  /// Example: Register
  static Future<void> registerExample() async {
    try {
      final response = await serviceProvider.auth.register(
        username: 'newstudent',
        password: 'password123',
        name: 'John Doe',
        role: 'student',
        roomNumber: '101',
        hostelBlock: 'A',
        phone: '+1234567890',
      );

      if (response.success) {
        print('Registration successful!');
      } else {
        print('Registration failed: ${response.message}');
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  /// Example: Logout
  static Future<void> logoutExample() async {
    await serviceProvider.auth.logout();
    print('Logged out successfully');
    // Navigate to login screen
    // Navigator.pushReplacementNamed(context, '/login');
  }

  // ==================== STUDENT PROFILE ====================
  
  /// Example: Get Profile
  static Future<void> getProfileExample() async {
    try {
      final response = await serviceProvider.student.getProfile();

      if (response.success) {
        print('Profile data: ${response.data}');
        // Update UI with profile data
      } else {
        print('Failed to get profile: ${response.message}');
      }
    } catch (e) {
      print('Error getting profile: $e');
    }
  }

  /// Example: Update Profile
  static Future<void> updateProfileExample() async {
    try {
      final response = await serviceProvider.student.updateProfile(
        name: 'John Doe Updated',
        phone: '+9876543210',
      );

      if (response.success) {
        print('Profile updated successfully!');
      } else {
        print('Failed to update profile: ${response.message}');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  // ==================== LAUNDRY ====================
  
  /// Example: Create Laundry Order
  static Future<void> createLaundryOrderExample() async {
    try {
      final response = await serviceProvider.laundry.createOrder(
        items: [
          {
            'name': 'Shirt',
            'quantity': 3,
            'service_type': 'both',
            'icon_code': 0xe3f4,
          },
          {
            'name': 'Pants',
            'quantity': 2,
            'service_type': 'wash',
            'icon_code': 0xe3f5,
          },
        ],
        serviceType: 'Wash & Press',
        note: 'Please handle with care',
      );

      if (response.success) {
        print('Order created successfully!');
        print('Order ID: ${response.data['order_id']}');
      } else {
        print('Failed to create order: ${response.message}');
      }
    } catch (e) {
      print('Error creating order: $e');
    }
  }

  /// Example: Get Laundry Orders
  static Future<void> getLaundryOrdersExample() async {
    try {
      final response = await serviceProvider.laundry.getOrders(
        status: 'inProgress',
      );

      if (response.success) {
        print('Orders: ${response.data}');
        // Display orders in UI
      } else {
        print('Failed to get orders: ${response.message}');
      }
    } catch (e) {
      print('Error getting orders: $e');
    }
  }

  /// Example: Update Order Status (Laundry Staff)
  static Future<void> updateOrderStatusExample() async {
    try {
      final response = await serviceProvider.laundry.updateOrderStatus(
        orderId: 'order_123',
        status: 'readyForPickup',
      );

      if (response.success) {
        print('Order status updated!');
      } else {
        print('Failed to update status: ${response.message}');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  // ==================== COMPLAINTS ====================
  
  /// Example: Create Complaint with Image
  static Future<void> createComplaintExample() async {
    try {
      // First, upload images if any
      // final imageFile = File('/path/to/image.jpg');
      // final uploadResponse = await serviceProvider.complaint.uploadImage(imageFile);
      // final imageUrl = uploadResponse.data['url'];

      final response = await serviceProvider.complaint.createComplaint(
        complaintType: 'Electrical',
        issues: [
          {
            'sub_category': 'Fan',
            'description': 'Fan not working in room 101',
            // 'image_url': imageUrl,
          },
        ],
      );

      if (response.success) {
        print('Complaint created successfully!');
      } else {
        print('Failed to create complaint: ${response.message}');
      }
    } catch (e) {
      print('Error creating complaint: $e');
    }
  }

  /// Example: Get Complaints
  static Future<void> getComplaintsExample() async {
    try {
      final response = await serviceProvider.complaint.getComplaints(
        status: 'pending',
      );

      if (response.success) {
        print('Complaints: ${response.data}');
      } else {
        print('Failed to get complaints: ${response.message}');
      }
    } catch (e) {
      print('Error getting complaints: $e');
    }
  }

  // ==================== ATTENDANCE ====================
  
  /// Example: Mark Attendance via QR
  static Future<void> markAttendanceExample() async {
    try {
      final response = await serviceProvider.attendance.markAttendance(
        eventType: 'Lunch',
        qrData: 'QR_CODE_DATA_HERE',
      );

      if (response.success) {
        print('Attendance marked successfully!');
      } else {
        print('Failed to mark attendance: ${response.message}');
      }
    } catch (e) {
      print('Error marking attendance: $e');
    }
  }

  /// Example: Get Attendance History
  static Future<void> getAttendanceHistoryExample() async {
    try {
      final response = await serviceProvider.attendance.getAttendanceHistory(
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now(),
      );

      if (response.success) {
        print('Attendance history: ${response.data}');
      } else {
        print('Failed to get history: ${response.message}');
      }
    } catch (e) {
      print('Error getting history: $e');
    }
  }

  // ==================== VEHICLE ====================
  
  /// Example: Register Vehicle
  static Future<void> registerVehicleExample() async {
    try {
      // final documentFile = File('/path/to/document.pdf');
      
      final response = await serviceProvider.vehicle.registerVehicle(
        vehicleType: 'Bike',
        plateNumber: 'ABC-1234',
        modelMake: 'Honda CBR',
        parkingPreference: 'Covered parking',
        // documentFile: documentFile,
      );

      if (response.success) {
        print('Vehicle registered successfully!');
      } else {
        print('Failed to register vehicle: ${response.message}');
      }
    } catch (e) {
      print('Error registering vehicle: $e');
    }
  }

  // ==================== HOLIDAY ====================
  
  /// Example: Request Holiday
  static Future<void> requestHolidayExample() async {
    try {
      final response = await serviceProvider.holiday.requestHoliday(
        name: 'Winter Break',
        startDate: DateTime(2026, 12, 20),
        endDate: DateTime(2026, 12, 30),
        reason: 'Going home for holidays',
      );

      if (response.success) {
        print('Holiday request submitted!');
      } else {
        print('Failed to request holiday: ${response.message}');
      }
    } catch (e) {
      print('Error requesting holiday: $e');
    }
  }

  // ==================== NOTES ====================
  
  /// Example: Create Note
  static Future<void> createNoteExample() async {
    try {
      final response = await serviceProvider.notes.createNote(
        title: 'Important Reminder',
        body: 'Don\'t forget to submit assignment',
        category: 'Academic',
      );

      if (response.success) {
        print('Note created successfully!');
      } else {
        print('Failed to create note: ${response.message}');
      }
    } catch (e) {
      print('Error creating note: $e');
    }
  }

  /// Example: Get All Notes
  static Future<void> getNotesExample() async {
    try {
      final response = await serviceProvider.notes.getNotes();

      if (response.success) {
        print('Notes: ${response.data}');
      } else {
        print('Failed to get notes: ${response.message}');
      }
    } catch (e) {
      print('Error getting notes: $e');
    }
  }

  // ==================== PAYMENTS ====================
  
  /// Example: Get Payment History
  static Future<void> getPaymentHistoryExample() async {
    try {
      final response = await serviceProvider.payment.getPaymentHistory();

      if (response.success) {
        print('Payment history: ${response.data}');
      } else {
        print('Failed to get payment history: ${response.message}');
      }
    } catch (e) {
      print('Error getting payment history: $e');
    }
  }

  /// Example: Get Payment Summary
  static Future<void> getPaymentSummaryExample() async {
    try {
      final response = await serviceProvider.payment.getPaymentSummary();

      if (response.success) {
        print('Payment summary: ${response.data}');
        print('Total pending: ${response.data['total_pending']}');
        print('Total paid: ${response.data['total_paid']}');
      } else {
        print('Failed to get summary: ${response.message}');
      }
    } catch (e) {
      print('Error getting summary: $e');
    }
  }

  // ==================== CHAT ====================
  
  /// Example: Get Chat Groups
  static Future<void> getChatGroupsExample() async {
    try {
      final response = await serviceProvider.chat.getChatGroups();

      if (response.success) {
        print('Chat groups: ${response.data}');
      } else {
        print('Failed to get groups: ${response.message}');
      }
    } catch (e) {
      print('Error getting groups: $e');
    }
  }

  /// Example: Send Message
  static Future<void> sendMessageExample() async {
    try {
      final response = await serviceProvider.chat.sendMessage(
        groupId: 'group_123',
        content: 'Hello everyone!',
        type: 'text',
      );

      if (response.success) {
        print('Message sent successfully!');
      } else {
        print('Failed to send message: ${response.message}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}

// ==================== WIDGET INTEGRATION EXAMPLE ====================

/// Example widget showing how to use services in a real Flutter widget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final response = await serviceProvider.auth.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (response.success) {
        // Login successful
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          // Navigate to home
          // Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Login failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${response.message}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
