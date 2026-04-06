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
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
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
      backgroundColor: const Color(0xFFEBF3F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Rounded Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 40, 24, 10),
              decoration: const BoxDecoration(
                color: AppColors.headerBlue,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 4),
                  const ModernText(
                    'Request leave',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ModernText('Holiday Name',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernTextField(
                      controller: _holidayNameController,
                      hint: 'e.g. Summer Break',
                      label: '',
                    ),
                    const SizedBox(height: 24),
                    const ModernText('Start Date',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernDateField(
                      onDateSelected: (date) =>
                          setState(() => _startDate = date),
                      initialDate: _startDate,
                    ),
                    const SizedBox(height: 24),
                    const ModernText('End Date',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                    const SizedBox(height: 8),
                    ModernDateField(
                      onDateSelected: (date) => setState(() => _endDate = date),
                      initialDate: _endDate,
                    ),
                    const SizedBox(height: 24),
                    const ModernText('Reason',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reasonController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            'Please provide details for your leave request...',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.headerBlue, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ModernButton(
                        text: 'Submit Request',
                        onPressed: _submitForm,
                        icon: Icons.near_me_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Footer text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
                  children: [
                    TextSpan(
                        text:
                            'All leave requests are subject to review and final approval by the '),
                    TextSpan(
                        text: 'Warden',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.headerBlue)),
                    TextSpan(
                        text:
                            '. You will receive a notification once a decision is made.'),
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
