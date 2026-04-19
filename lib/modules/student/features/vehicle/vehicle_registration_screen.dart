import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/vehicle/vehicle_dropdown.dart';
import 'package:hsh_app/modules/student/features/common/upload_container.dart';
import '../../../../models/vehicle_request_model.dart';
// ignore: depend_on_referenced_packages
import "package:file_picker/file_picker.dart";
import 'package:uuid/uuid.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _plateNumberController;
  late TextEditingController _modelController;
  String? _selectedVehicleType;
  String? _selectedParkingPreference;
  PlatformFile? _pickedFile;

  final List<String> _vehicleTypes = ['Car', 'Bike', 'Scooter', 'Bicycle'];
  final List<String> _parkingPreferences = [
    'Near Hostel Block A',
    'Near Canteen',
    'Main Gate Parking',
  ];

  @override
  void initState() {
    super.initState();
    _plateNumberController = TextEditingController();
    _modelController = TextEditingController();
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result != null) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  void _clearFile() => setState(() => _pickedFile = null);

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedVehicleType == null) {
        Get.snackbar('Error', 'Please select vehicle type');
        return;
      }
      if (_pickedFile == null) {
        Get.snackbar('Error', 'Please upload registration papers');
        return;
      }

      final request = VehicleRequest(
        id: const Uuid().v4(),
        studentId: 'CURRENT_USER_ID',
        vehicleType: _selectedVehicleType!,
        plateNumber: _plateNumberController.text,
        modelMake: _modelController.text,
        parkingPreference: _selectedParkingPreference ?? 'None',
        registrationPapersUrl: _pickedFile!.path,
        status: VehicleStatus.pending,
        createdAt: DateTime.now(),
      );

      debugPrint('Submitting Vehicle Request: $request');
      Get.snackbar('Success', 'Vehicle registration application submitted successfully');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 14,
                left: 16,
                right: 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.headerBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const ModernText(
                    'Vehicle Registration',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Form Card ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Card heading ───────────────────────────────
                      const ModernText(
                        'Register your vehicle',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.headerBlue,
                      ),
                      const SizedBox(height: 6),
                      ModernText(
                        'Provide your details to secure a parking permit.',
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 28),

                      // ── Vehicle Type dropdown ──────────────────────
                      _fieldLabel('Vehicle Type', Icons.directions_car_outlined),
                      const SizedBox(height: 8),
                      VehicleDropdown(
                        hint: 'Select vehicle type',
                        value: _selectedVehicleType,
                        items: _vehicleTypes,
                        onChanged: (val) =>
                            setState(() => _selectedVehicleType = val),
                      ),
                      const SizedBox(height: 20),

                      // ── Plate Number ───────────────────────────────
                      _fieldLabel('Plate Number', Icons.pin_outlined),
                      const SizedBox(height: 8),
                      _customField(
                        controller: _plateNumberController,
                        hint: 'e.g. MH-12-AB-1234',
                        icon: Icons.pin_outlined,
                        textCapitalization: TextCapitalization.characters,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Enter plate number' : null,
                      ),
                      const SizedBox(height: 20),

                      // ── Model / Make ───────────────────────────────
                      _fieldLabel('Model / Make', Icons.car_repair_outlined),
                      const SizedBox(height: 8),
                      _customField(
                        controller: _modelController,
                        hint: 'e.g. Toyota Camry',
                        icon: Icons.car_repair_outlined,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Enter model/make' : null,
                      ),
                      const SizedBox(height: 20),

                      // ── Parking Preference ─────────────────────────
                      _fieldLabel('Parking Preference', Icons.local_parking_outlined),
                      const SizedBox(height: 8),
                      VehicleDropdown(
                        hint: 'Select slot preference',
                        value: _selectedParkingPreference,
                        items: _parkingPreferences,
                        onChanged: (val) =>
                            setState(() => _selectedParkingPreference = val),
                      ),
                      const SizedBox(height: 20),

                      // ── Upload ─────────────────────────────────────
                      _fieldLabel('Registration Papers', Icons.upload_file_outlined),
                      const SizedBox(height: 8),
                      if (_pickedFile == null)
                        FileUploadCard(
                          title: 'Upload Registration Papers',
                          subtitle: 'PDF, PNG or JPG (Max 5MB)',
                          onTap: _pickFile,
                        )
                      else
                        _buildFilePreview(),
                      const SizedBox(height: 28),

                      // ── Submit ─────────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ModernButton(
                          text: 'Submit Application',
                          onPressed: _submitForm,
                          icon: Icons.near_me_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _fieldLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.headerBlue.withValues(alpha: 0.6)),
        const SizedBox(width: 6),
        ModernText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.headerBlue.withValues(alpha: 0.75),
        ),
      ],
    );
  }

  Widget _customField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textCapitalization: textCapitalization,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.headerBlue,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Icon(icon, size: 18, color: AppColors.headerBlue.withValues(alpha: 0.5)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.headerBlue.withValues(alpha: 0.15),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.pendingBlue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cancelledRed, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cancelledRed, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.headerBlue.withValues(alpha: 0.15),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.pendingBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.insert_drive_file_outlined,
                color: AppColors.pendingBlue, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernText(
                  _pickedFile!.name,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headerBlue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                ModernText(
                  '${(_pickedFile!.size / 1024).toStringAsFixed(1)} KB',
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppColors.cancelledRed, size: 20),
            onPressed: _clearFile,
          ),
        ],
      ),
    );
  }
}
