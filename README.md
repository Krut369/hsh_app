# 🏨 Hari Saurabh Hostel (HSH) App

![HSH App](flutter_01.png)

A modern, high-performance hostel management system built with Flutter. HSH App streamlines daily operations for students and administrators with a focus on ease of use and real-time tracking.

---

## 🚀 Features

### For Students
- **👤 Profile Management**: View and update student information and room details.
- **📅 Attendance Tracking**: Mark attendance easily via QR code scanning.
- **💰 Fees & Payments**: Track fee summaries and view detailed payment history.
- **🛠️ Complaint Desk**: Register complaints with image uploads and track resolution status.
- **🏝️ Leave Requests**: Submit temporary leave or holiday requests directly from the app.
- **🧺 Laundry Service**: Manage laundry orders, track status, and view service configurations.
- **📝 Student Notes**: Personal note-taking system within the app.
- **💬 Community Chat**: Engage with fellow residents in group messages.

### For Administrators
- **📊 Operational Oversight**: Manage attendance, complaints, and laundry services efficiently.
- **📈 Real-time Updates**: Instant visibility into hostel activities and student requests.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (3.5.4+)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Local Storage**: `shared_preferences`
- **Scanning**: `mobile_scanner`
- **Networking**: Custom `ApiClient` (built on `dart:io` HttpClient)

---

## 🏗️ Architecture

The project follows a modular and service-oriented architecture:

- **`lib/core/`**: Centralized constants (`api_constants.dart`) and networking logic (`api_client.dart`).
- **`lib/services/`**: Feature-specific logic encapsulated in services (e.g., `auth_service.dart`, `laundry_service.dart`).
- **`lib/modules/`**: UI screens and components organized by feature.
- **`lib/models/`**: Data structures and serialization logic.
- **`lib/providers/`**: Global state providers using Riverpod.

---

## 🚦 Getting Started

### Prerequisites
- Flutter SDK installed.
- Access to the HSH Backend API.

### Installation
1.  **Clone the repository**:
    ```bash
    git clone [repository-url]
    cd hsh_app
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Configure API**:
    Open `lib/core/constants/api_constants.dart` and set your backend URL:
    ```dart
    static const String baseUrl = 'YOUR_API_BASE_URL';
    ```
4.  **Run the app**:
    ```bash
    flutter run
    ```

---

## 📖 Documentation

For more detailed information, check out:
- [📁 Folder Structure](FOLDER_STRUCTURE.md)
- [🔌 API Integration Guide](API_INTEGRATION.md)
- [🛠️ Integration Summary](INTEGRATION_SUMMARY.md)
- [🚀 Quick Search/Start](GET_STARTED.md)

---

## 🤝 Contributing

Contributions are welcome! Please ensure you follow the existing code style and naming conventions.

---

*Built with ❤️ for Hari Saurabh Hostel.*
