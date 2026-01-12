  class AppText {
    // App Titles
    static const appTitle = 'Hostel Management App';
    static const loginTitle = 'Login to Your Account';
    static const welcomeMessage = 'Welcome to Your Hostel Dashboard';

    // Bottom Nav Labels
    static const home = 'Home';
    static const attendance = 'Attendance';
    static const leave = 'Leave';
    static const laundry = 'Laundry';
    static const profile = 'Profile';
    static const message = 'Messages';
    static const service = 'Services';

    // Button Labels
    static const login = 'Login';
    static const logout = 'Logout';
    static const submit = 'Submit';
    static const cancel = 'Cancel';
    static const apply = 'Apply Now';

    // Form Labels
    static const email = 'Email Address';
    static const password = 'Password';
    static const confirmPassword = 'Confirm Password';
    static const reason = 'Reason for Leave';

    // Leave Status
    static const approved = 'Approved';
    static const pending = 'Pending';
    static const rejected = 'Rejected';

    // Laundry Status
    static const laundryRequested = 'Laundry Requested';
    // static const laundryReady = 'Laundry Ready'; // Removed duplicate
    static const laundryDelivered = 'Laundry Delivered';

    // Errors / Warnings
    static const errorEmptyField = 'This field cannot be empty';
    static const errorInvalidEmail = 'Please enter a valid email';
    static const errorShortPassword = 'Password must be at least 6 characters';

    // Profile
    static const studentId = 'Student ID';
    static const roomNumber = 'Room Number';
    static const hostelName = 'Hostel Name';
    
    // Short labels for Profile Card
    static const college = 'College';
    static const room = 'Room';
    static const id = 'ID';
    
    // Services Labels
    static const fees = 'Fees';
    static const holiday = 'Holiday';
    static const applyLeave = 'Apply Leave';

    // ✅ Add these for your More Options
    static const vehicleRegistration = 'Vehicle Registration';
    static const temporaryLeave = 'Temporary Leave';

    static const filter = 'Filter';

    // Complaint Management
    static const complaint = 'Complaint';
    static const filterComplaints = 'Filter Complaints';
    static const all = 'All';
    static const completed = 'Completed';
    static const addComplaint = 'Add Complaint';

    // Holiday Screen
    static const noHolidaysTitle = 'No holidays requested yet!';
    static const noHolidaysSubtitle = 'Tap the button below to request a holiday.';
    static const requestHoliday = 'Request Holiday';
    static const fromDate = 'From';

    static const toDate = 'To';
    static const holidayName = 'Holiday Name';
    static const startDate = 'Start Date';
    static const endDate = 'End Date';
    static const submitRequest = 'Submit Request';
    static const holidayNameHint = 'e.g., Diwali Break';
    static const startDateHint = 'Select start date';
    static const endDateHint = 'Select end date';
    static const selectBothDatesError = 'Please select both start and end dates';
    static const holidayAddedSuccess = 'Holiday added successfully!';
    static const endDateBeforeStartError = 'End date cannot be before start date';
    static const errorHolidayName = 'Please enter a holiday name';
    static const errorStartDate = 'Please select a start date';
    static const errorEndDate = 'Please select an end date';


    // Vehicle Registration
    static const vehicleType = 'Vehicle Type';
    static const registrationNumber = 'Registration Number';
    static const vehicleModel = 'Vehicle Model';
    static const registerVehicle = 'Register Vehicle';
    static const vehicleTypeHint = 'Select vehicle type';
    static const registrationNumberHint = 'e.g., GJ-01-AB-1234';
    static const vehicleModelHint = 'e.g., Honda City, Activa';
    static const vehicleRegisteredSuccess = 'Vehicle registered successfully!';
    static const errorVehicleType = 'Please select a vehicle type';
    static const errorRegistrationNumber = 'Please enter registration number';
    static const errorVehicleModel = 'Please enter vehicle model';

    // Vehicle Registration (Detailed)
    static const registerYourVehicleTitle = 'Register your vehicle';
    static const vehicleRegistrationSubtitle = 'Please provide your vehicle details to secure a parking permit on campus.';
    static const plateNumber = 'Plate Number';
    static const plateNumberHint = 'E.G. ABC-1234';
    static const modelMake = 'Model / Make';
    static const modelMakeHint = 'e.g. Toyota Camry';
    static const parkingPreference = 'Parking Preference';
    static const parkingPreferenceHint = 'Select slot preference';
    static const uploadPapers = 'Upload Registration Papers';
    static const uploadHint = 'Click to upload or drag and drop';
    static const uploadSubHint = 'PDF, PNG or JPG (Max. 5MB)';
    static const submitApplication = 'Submit Application';


    // Fees & Payments
    static const feesAndPayments = 'Fees & Payments';
    static const totalBill = 'Total Bill';
    static const amountPaid = 'Amount Paid';
    static const balancePending = 'Balance Pending';
    static const paymentHistory = 'Payment History';
    static const payNow = 'Pay Now';
    static const viewAll = 'View All';
    static const dueBy = 'Due by';
    static const success = 'Success';
    static const failed = 'Failed';


    // Home Screen (Hostel Hub)
    static const hostelHub = 'AVD';
    static const quickActions = 'Quick Actions';
    static const recentActivity = 'Recent Activity';
    static const goodMorning = 'Good Morning';
    static const premiumResident = 'Premium Resident';
    static const viewStatus = 'View Status';
    static const payDue = 'Pay Due';
    static const raiseTicket = 'Raise Ticket';
    static const feePaidSuccess = 'Fee Paid Successfully';
    static const laundryReady = 'Laundry Ready for Pickup';
    static const feeAmount = '₹12,000';
    static const laundryLoad = 'Load #34';

    static const chat = 'Chat';
    static const checkMessages = 'Check Messages';
    static const notes = 'Notes';
    static const keepNotes = 'Keep Notes';
    static const allServices = 'All Services';

    // Chat
    static const hostelSupport = 'Hostel Support';
    static const online = 'Online';
    static const today = 'TODAY';
    static const typeMessage = 'Type a message...';
    static const read = 'Read';
    
    // Mock Messages
    static const chatMsg1 = 'Hello! How can we help you with your room or laundry request today?';
    static const chatMsg2 = 'Hi, I wanted to check if my room cleaning is scheduled for this afternoon.';
    static const chatMsg3 = 'Yes, the housekeeping staff will be at Room 402 at 2:00 PM today.';
    static const chatMsg4 = 'Great, thank you for the update!';

    // Notes
    static const addNewNote = 'Add New Note';
    static const save = 'Save';
    static const roomIssue = 'Room Issue';
    // static const laundry = 'Laundry'; // Removed duplicate
    static const mealPreference = 'Meal Preference';
    static const personal = 'Personal';
    static const noteTitleHint = 'Title';
    static const noteBodyHint = 'Start typing...';
    static const characters = 'characters';

// ... other labels

  }
