import 'package:flutter/material.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/widgets/custom_text_field.dart';
import 'vehicle_label.dart';
import 'vehicle_dropdown.dart';
import 'package:hsh_app/modules/student/features/common/upload_container.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedVehicleType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppText.errorVehicleType)),
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
    final theme = Theme.of(context);
    final vertical = ResponsiveUtil.verticalSpacing(context);
    final padding = ResponsiveUtil.responsivePadding(context);
    final titleFont = ResponsiveUtil.responsiveFontSize(context, 20);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppText.vehicleRegistration,
          style: TextStyle(
              fontSize: titleFont,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppText.vehicleRegistrationSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: vertical * 1.5),

              // Vehicle Type
              VehicleLabel(AppText.vehicleType),
              const SizedBox(height: 8),
              VehicleDropdown(
                hint: AppText.vehicleTypeHint,
                value: _selectedVehicleType,
                items: _vehicleTypes,
                onChanged: (val) => setState(() => _selectedVehicleType = val),
              ),
              SizedBox(height: vertical),

              // Plate Number
              VehicleLabel(AppText.plateNumber),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: AppText.plateNumberHint,
                controller: _plateNumberController,
                validator: (value) => value == null || value.isEmpty
                    ? AppText.errorRegistrationNumber
                    : null,
                borderRadius: 12,
              ),
              SizedBox(height: vertical),

              // Model / Make
              VehicleLabel(AppText.modelMake),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: AppText.modelMakeHint,
                controller: _modelController,
                validator: (value) => value == null || value.isEmpty
                    ? AppText.errorVehicleModel
                    : null,
                borderRadius: 12,
              ),
              SizedBox(height: vertical),

              // Parking Preference
              VehicleLabel(AppText.parkingPreference),
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
              VehicleLabel(AppText.uploadPapers),
              const SizedBox(height: 8),
              const UploadContainer(),
              SizedBox(height: vertical * 2),

              // Submit Button
              SafeArea(
                child: CustomButton(
                  text: AppText.submitApplication,
                  onPressed: _submitForm,
                  backgroundColor: const Color(0xFF1976D2), // Strong blue
                  borderRadius: 25,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  fontSize: 18,
                  elevation: 5,
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
