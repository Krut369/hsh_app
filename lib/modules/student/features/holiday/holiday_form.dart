import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart' hide AppColors;
import 'package:hsh_app/core/theme/app_colors.dart';

class HolidayForm extends StatefulWidget {
  const HolidayForm({super.key});

  @override
  State<HolidayForm> createState() => _HolidayFormState();
}

class _HolidayFormState extends State<HolidayForm> {
  final _formKey = GlobalKey<FormState>();
  final _holidayNameController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _holidayNameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
      Get.back();
      Get.snackbar(
        'Success',
        'Holiday request submitted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else if (_startDate == null || _endDate == null) {
      Get.snackbar('Error', 'Please select both start and end dates');
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
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  const ModernText(
                    'Request leave',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Form Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3B82F6), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ModernText('Holiday Name', fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernTextField(
                      controller: _holidayNameController,
                      hint: 'e.g. Summer Break',
                      label: '',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const ModernText('Start Date', fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernDateField(
                      onDateSelected: (date) => setState(() => _startDate = date),
                      initialDate: _startDate,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const ModernText('End Date', fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernDateField(
                      onDateSelected: (date) => setState(() => _endDate = date),
                      initialDate: _endDate,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const ModernText('Reason', fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernTextField(
                      controller: _reasonController,
                      hint: 'Please provide details for your leave request...',
                      label: '',
                    ),
                    
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ModernButton(
                        text: 'Submit Request',
                        onPressed: _submitForm,
                        icon: Icons.change_history_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Footer text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
                  children: [
                    TextSpan(text: 'All leave requests are subject to review and final approval by the '),
                    TextSpan(text: 'Warden', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.headerBlue)),
                    TextSpan(text: '. You will receive a notification once a decision is made.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
