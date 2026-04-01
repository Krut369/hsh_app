import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart' hide AppColors;
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
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
    'Main Gate Parking'
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
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  void _clearFile() {
    setState(() {
      _pickedFile = null;
    });
  }

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

      // Create the model object
      final request = VehicleRequest(
        id: const Uuid().v4(),
        studentId: 'CURRENT_USER_ID', // Replace with actual user ID provider
        vehicleType: _selectedVehicleType!,
        plateNumber: _plateNumberController.text,
        modelMake: _modelController.text,
        parkingPreference: _selectedParkingPreference ?? 'None',
        registrationPapersUrl: _pickedFile!.path, // Or upload URL
        status: VehicleStatus.pending,
        createdAt: DateTime.now(),
      );

      // TODO: Call your provider/repo here to save 'request'
      debugPrint('Submitting Vehicle Request: $request');

      Get.snackbar('Success', 'Vehicle registration application submitted successfully');

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModernScaffold(
      backgroundColor: AppColors.mainBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Rounded Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              decoration: const BoxDecoration(
                color: AppColors.headerBlue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
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
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Form Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ModernText(
                      'Register your vehicle',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    const ModernText(
                      'Please provide your vehicle details to secure a parking permit on campus.',
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 32),

                    // Vehicle Type
                    const ModernText('Vehicle Type', fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                    const SizedBox(height: 8),
                    VehicleDropdown(
                      hint: 'Select vehicle type',
                      value: _selectedVehicleType,
                      items: _vehicleTypes,
                      onChanged: (val) => setState(() => _selectedVehicleType = val),
                    ),
                    const SizedBox(height: 24),

                    // Plate Number
                    const ModernText('Plate Number', fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernTextField(
                      controller: _plateNumberController,
                      hint: 'E.G. ABC-1234',
                      label: '',
                    ),
                    const SizedBox(height: 24),

                    // Model / Make
                    const ModernText('Model / Make', fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernTextField(
                      controller: _modelController,
                      hint: 'e.g. Toyota Camry',
                      label: '',
                    ),
                    const SizedBox(height: 24),

                    // Parking Preference
                    const ModernText('Parking Preference', fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                    const SizedBox(height: 8),
                    VehicleDropdown(
                      hint: 'Select slot preference',
                      value: _selectedParkingPreference,
                      items: _parkingPreferences,
                      onChanged: (val) => setState(() => _selectedParkingPreference = val),
                    ),
                    const SizedBox(height: 24),

                    // Upload Registration Papers
                    const ModernText('Upload Registration Papers', fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                    const SizedBox(height: 8),
                    if (_pickedFile == null)
                      FileUploadCard(
                        title: 'Upload Registration Papers',
                        subtitle: 'PDF, PNG or JPG (Max 5MB)',
                        onTap: _pickFile,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file, color: AppColors.primary, size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ModernText(
                                    _pickedFile!.name,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Text(
                                    '${(_pickedFile!.size / 1024).toStringAsFixed(1)} KB',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: _clearFile,
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 48),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ModernButton(
                        text: 'Submit Application',
                        onPressed: _submitForm,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
