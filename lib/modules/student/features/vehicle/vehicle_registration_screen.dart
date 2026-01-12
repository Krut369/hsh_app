import 'package:flutter/material.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/widgets/custom_text_field.dart';
import 'package:hsh_app/modules/student/features/vehicle/vehicle_dropdown.dart';
import 'package:hsh_app/modules/student/features/common/upload_container.dart';

// ignore: depend_on_referenced_packages
import "package:file_picker/file_picker.dart";

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppText.errorVehicleType)),
        );
        return;
      }

      if (_pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload registration papers')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppText.vehicleRegisteredSuccess)),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... theme variables ...
    final vertical = ResponsiveUtil.verticalSpacing(context);
    final padding = ResponsiveUtil.responsivePadding(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        title: AppText.vehicleRegistration,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppText.registerYourVehicleTitle,
                style: AppFonts.heading2(context),
              ),
              const SizedBox(height: 8),
              Text(
                AppText.vehicleRegistrationSubtitle,
                style: AppFonts.bodyRegular(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: vertical * 1.5),

              // Vehicle Type
              Text(AppText.vehicleType, style: AppFonts.bodyBold(context)),
              const SizedBox(height: 8),
              VehicleDropdown(
                hint: AppText.vehicleTypeHint,
                value: _selectedVehicleType,
                items: _vehicleTypes,
                onChanged: (val) => setState(() => _selectedVehicleType = val),
              ),
              SizedBox(height: vertical),

              // Plate Number
              CustomTextField(
                labelText: AppText.plateNumber,
                hintText: AppText.plateNumberHint,
                controller: _plateNumberController,
                validator: (value) => value == null || value.isEmpty
                    ? AppText.errorRegistrationNumber
                    : null,
                borderRadius: 12,
              ),
              SizedBox(height: vertical),

              // Model / Make
              CustomTextField(
                labelText: AppText.modelMake,
                hintText: AppText.modelMakeHint,
                controller: _modelController,
                validator: (value) => value == null || value.isEmpty
                    ? AppText.errorVehicleModel
                    : null,
                borderRadius: 12,
              ),
              SizedBox(height: vertical),

              // Parking Preference
              Text(AppText.parkingPreference, style: AppFonts.bodyBold(context)),
              const SizedBox(height: 8),
              VehicleDropdown(
                hint: AppText.parkingPreferenceHint,
                value: _selectedParkingPreference,
                items: _parkingPreferences,
                onChanged: (val) =>
                    setState(() => _selectedParkingPreference = val),
              ),
              SizedBox(height: vertical),

              // Upload Registration Papers
              Text(AppText.uploadPapers, style: AppFonts.bodyBold(context)),
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.insert_drive_file,
                          color: AppColors.primary, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _pickedFile!.name,
                              style: AppFonts.bodyBold(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${(_pickedFile!.size / 1024).toStringAsFixed(1)} KB',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
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
              SizedBox(height: vertical * 2),

              // Submit Button
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: AppText.submitApplication,
                    onPressed: _submitForm,
                    backgroundColor: AppColors.primary,
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    fontSize: 16,
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(height: vertical),
            ],
          ),
        ),
      ),
    );
  }
}
