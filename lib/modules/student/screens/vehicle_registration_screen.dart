import 'package:flutter/material.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _registrationNumberController;
  late TextEditingController _modelController;
  String? _selectedVehicleType;

  final List<String> _vehicleTypes = ['Car', 'Bike', 'Scooter', 'Bicycle'];

  @override
  void initState() {
    super.initState();
    _registrationNumberController = TextEditingController();
    _modelController = TextEditingController();
  }

  @override
  void dispose() {
    _registrationNumberController.dispose();
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

      // Logic to save/send data would go here
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
      appBar: AppBar(
        title: Text(
          AppText.vehicleRegistration,
          style: TextStyle(fontSize: titleFont),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(padding, vertical, padding, vertical + 20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedVehicleType,
                        decoration: InputDecoration(
                          labelText: AppText.vehicleType,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.directions_car),
                        ),
                        hint: const Text(AppText.vehicleTypeHint),
                        items: _vehicleTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicleType = value;
                          });
                        },
                        validator: (value) =>
                        value == null ? AppText.errorVehicleType : null,
                      ),
                      SizedBox(height: vertical),

                      // Registration Number
                      CustomTextField(
                        labelText: AppText.registrationNumber,
                        hintText: AppText.registrationNumberHint,
                        controller: _registrationNumberController,
                        validator: (value) => value == null || value.isEmpty
                            ? AppText.errorRegistrationNumber
                            : null,
                      ),
                      SizedBox(height: vertical),

                      // Vehicle Model
                      CustomTextField(
                        labelText: AppText.vehicleModel,
                        hintText: AppText.vehicleModelHint,
                        controller: _modelController,
                        validator: (value) => value == null || value.isEmpty
                            ? AppText.errorVehicleModel
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: vertical * 2),
            CustomButton(
              text: AppText.registerVehicle,
              onPressed: _submitForm,
              backgroundColor: theme.colorScheme.primary,
              borderRadius: 15,
              padding: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: ResponsiveUtil.horizontalSpacing(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
