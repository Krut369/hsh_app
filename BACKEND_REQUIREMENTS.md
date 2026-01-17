# Backend Generation Requirements for Hostel Management System (HSH App)

This document outlines the backend requirements for the Hostel Management App, derived from the existing Flutter frontend codebase. The backend should support four primary user roles: **Student, Laundry, Complain (Maintenance), and Leader**.

## 1. Tech Stack Recommendations
*   **Language/Framework**: Node.js (Express/NestJS) OR Python (FastAPI/Django) OR Go.
*   **Database**: PostgreSQL (Relational) or MongoDB (NoSQL).
    *   *Note: Relational is recommended due to structured data (Orders, Complaints, Users).*
*   **Authentication**: JWT (JSON Web Tokens).
*   **Real-time Communication**: WebSocket / Socket.io (For Chat features).
*   **File Storage**: Local file system or S3-compatible storage (for Complaint images).

---

## 2. Database Schema & Models

### 2.1 Users & Authentication
*   **Table/Collection**: `users`
*   **Fields**:
    *   `id`: String/UUID (Primary Key)
    *   `username`: String (Unique, for login)
    *   `password`: String (Hashed)
    *   `name`: String
    *   `role`: Enum (`student`, `laundry`, `complain`, `leader`)
    *   `profile_image`: String (URL, optional)
    *   `room_number`: String (Optional, for students)
    *   `hostel_block`: String (Optional)
    *   `phone`: String (Optional)
    *   `created_at`: Timestamp

### 2.2 Laundry Module
*   **Table**: `laundry_orders`
    *   `id`: String/UUID
    *   `user_id`: String (Foreign Key -> users.id)
    *   `order_id`: String (e.g., "#ORD2025...")
    *   `date`: DateTime
    *   `total_items`: Integer
    *   `service_type`: String (e.g., "Wash & Press")
    *   `status`: Enum (`requested`, `inProgress`, `readyForPickup`, `completed`, `cancelled`)
    *   `note`: String (Optional)
    *   `completed_at`: Timestamp (Optional)
*   **Table**: `laundry_order_items`
    *   `id`: String/UUID
    *   `order_id`: String (Foreign Key)
    *   `name`: String (Item name, e.g., "Shirt")
    *   `quantity`: Integer
    *   `service_type`: Enum (`wash`, `press`, `both`)
    *   `icon_code`: String/Int (To map to Flutter icons)

### 2.3 Complaint Module
*   **Table**: `complaints`
    *   `id`: String/UUID
    *   `user_id`: String (Foreign Key)
    *   `date_time`: DateTime
    *   `complaint_type`: String (Category, e.g., "Electrical", "Plumbing")
    *   `status`: Enum (`underReview`, `pending`, `awaitingFeedback`, `resolved`)
*   **Table**: `complaint_issues`
    *   `id`: String/UUID
    *   `complaint_id`: String (Foreign Key)
    *   `sub_category`: String (e.g., "Fan", "Light")
    *   `description`: String
    *   `image_url`: String (Optional)

### 2.4 Holiday/Leave Module
*   **Table**: `holiday_requests`
    *   `id`: String/UUID
    *   `user_id`: String (Foreign Key)
    *   `name`: String (Name of holiday/reason)
    *   `start_date`: DateTime
    *   `end_date`: DateTime
    *   `status`: Enum (`pending`, `confirmed`, `rejected`)
    *   `reason`: String (Detailed reason)

### 2.5 Chat & Community (Leader Module)
*   **Table**: `chat_groups`
    *   `id`: String/UUID
    *   `name`: String
    *   `icon_url`: String (Optional)
    *   `created_by`: String (Leader ID)
    *   `created_at`: DateTime
*   **Table**: `chat_group_members`
    *   `group_id`: String
    *   `user_id`: String
*   **Table**: `chat_messages`
    *   `id`: String/UUID
    *   `group_id`: String
    *   `sender_id`: String
    *   `content`: Text
    *   `type`: Enum (`text`, `image`, `file`)
    *   `timestamp`: DateTime
    *   `is_read`: Boolean

### 2.6 Attendance Module
*   **Table**: `attendance_records`
    *   `id`: String/UUID
    *   `user_id`: String (Foreign Key)
    *   `date`: Date (YYYY-MM-DD)
    *   `event_type`: Enum (`Lunch`, `Dinner`, `Sabha`, `Aarti`, `Night`)
    *   `timestamp`: Timestamp
    *   `status`: Enum (`present`, `absent`, `late`)
    *   `method`: Enum (`qr_scan`, `manual`)
    *   `verified_by`: String (Leader ID, optional for manual entry)

### 2.7 Vehicle Registration
*   **Table**: `vehicle_registrations`
    *   `id`: String/UUID
    *   `user_id`: String (Foreign Key)
    *   `vehicle_type`: Enum (`Car`, `Bike`, `Scooter`, `Bicycle`)
    *   `plate_number`: String
    *   `model_make`: String
    *   `parking_preference`: String
    *   `document_url`: String (Registration Papers)
    *   `status`: Enum (`pending`, `approved`, `rejected`)

### 2.8 Student Notes
*   **Table**: `notes`
    *   `id`: String/UUID
    *   `user_id`: String (Foreign Key)
    *   `title`: String
    *   `body`: Text
    *   `category`: String
    *   `created_at`: Timestamp
    *   `updated_at`: Timestamp

### 2.9 Payments
*   **Table**: `payments`
    *   `id`: String/UUID
    *   `user_id`: String (Foreign Key)
    *   `title`: String (e.g., "Monthly Rent")
    *   `amount`: Decimal
    *   `date`: Timestamp
    *   `status`: Enum (`success`, `failed`, `pending`)
    *   `method`: String (e.g., "Visa", "UPI")
    *   `transaction_id`: String (External ID)

### 2.10 System Configuration
*   **Table**: `system_config`
    *   `key`: String (Primary Key, e.g., "laundry_prices")
    *   `value`: JSON (e.g., `{"wash": 10.0, "press": 5.0, "both": 12.0}`)

---

## 3. API Endpoints Specification

### 3.1 Authentication
*   `POST /api/auth/login`: Accepts `username`, `password`. Returns `token`, `user_details`.
*   `POST /api/auth/register`: (Admin only or Public?) Registers new user.

### 3.2 Student Features
*   **Profile**:
    *   `GET /api/student/profile`: Get current user profile.
    *   `PUT /api/student/profile`: Update details.
*   **Attendance**:
    *   `POST /api/attendance/mark`: Scan QR code (Student) or Manual Entry (Leader).
    *   `GET /api/attendance/history`: List user's attendance.
*   **Vehicle**:
    *   `POST /api/vehicle/register`: Submit registration.
    *   `GET /api/vehicle/status`: Check application status.
*   **Notes**:
    *   `GET /api/notes`: List notes.
    *   `POST /api/notes`: Create note.
    *   `PUT /api/notes/:id`: Update note.
    *   `DELETE /api/notes/:id`: Delete note.
*   **Payments**:
    *   `GET /api/payments/history`: Get transaction history.
    *   `GET /api/payments/summary`: Get totals (Pending, Paid).

### 3.3 Laundry Features
*   `POST /api/laundry/orders`: Create a new order. Payload: Items, Service Type.
*   `GET /api/laundry/orders`:
    *   **Role Student**: Returns own orders.
    *   **Role Laundry**: Returns ALL orders. Supports filtering by status/date.
*   `PUT /api/laundry/orders/:id/status`:
    *   **Role Laundry**: Update status (e.g., `inProgress` -> `readyForPickup`).
*   `GET /api/laundry/items`: List available laundry items (configuration).
*   `GET /api/laundry/config`: Get prices (wash, press, both).
*   `PUT /api/laundry/config`: Update prices (Admin/Laundry only).

### 3.4 Complaint Features
*   `POST /api/complaints`: Create a complaint. Support multipart/form-data for images.
*   `GET /api/complaints`:
    *   **Role Student**: Own complaints.
    *   **Role Complain**: All complaints.
*   `PUT /api/complaints/:id/status`: Update status (e.g., `pending` -> `resolved`).
*   `POST /api/upload`: Generic file upload, returns URL.

### 3.5 Holiday Features
*   `POST /api/holidays`: Request leave.
*   `GET /api/holidays`:
    *   **Role Student**: Own requests.
    *   **Role Leader/Admin**: All pending requests.
*   `PUT /api/holidays/:id/status`: Approve/Reject request.

### 3.6 Chat (Real-time)
*   `GET /api/chat/groups`: List user's groups.
*   `POST /api/chat/groups`: Create group (Leader only).
*   `GET /api/chat/groups/:id/messages`: Get history.
*   **WebSocket Events**:
    *   `connect`: Auth via token.
    *   `join_group`: Listen to specific group ID.
    *   `send_message`: Client sends message.
    *   `new_message`: Server broadcasts message to group members.

---

## 4. Specific Logic Requirements
1.  **Laundry Status Flow**: `requested` -> `inProgress` -> `readyForPickup` -> `completed` (or `cancelled` at any stage).
2.  **Notification System**:
    *   When Laundry Order status changes -> Notify Student.
    *   When Complaint status changes -> Notify Student.
    *   When Holiday/Leave approved -> Notify Student.
    *   When new Message in Group -> Notify Members.
3.  **Search/Filtering**:
    *   Laundry: Filter by Status, Date. Search by Order ID or Room Number.
    *   Complaints: Filter by Type, Status.
3.  **Complaint Logic**:
    *   Status flow: `pending` -> `underReview` -> `awaitingFeedback` -> `resolved`.
    *   Admin Update: When Admin updates status, they can optionally add a "Note".
    *   Feedback: `awaitingFeedback` should allow Student to Confirm Resolution or Reopen.

4.  **Attendance Rules**:
    *   Prevent double marking for same event/date.
    *   Allow Leaders to override/verify.
    *   Support valid windows for events (e.g., Lunch 12pm-2pm).

5.  **Cost Management**:
    *   `laundry_costs` key in `system_config` must be updated via `PUT /api/laundry/config`.
    *   Costs should be fetched before Order creation to calculate totals (if required in future).

## 5. Security & Validation
*   All endpoints protecting personal data must require a valid JWT.
*   **Role-based Access Control (RBAC)** is critical. A User with role `student` must NOT be able to update Laundry Order status or view other students' private data.
