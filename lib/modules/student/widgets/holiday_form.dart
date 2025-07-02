import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/responsive_util.dart';
import '../../../models/holiday_model.dart';
import '../../../providers/holiday_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class HolidayForm extends ConsumerStatefulWidget {
  const HolidayForm({super.key});

  @override
  ConsumerState<HolidayForm> createState() => _HolidayFormState();
}

class _HolidayFormState extends ConsumerState<HolidayForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_selectedStartDate ?? DateTime.now())
          : (_selectedEndDate ?? _selectedStartDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
          if (_selectedEndDate != null && _selectedEndDate!.isBefore(picked)) {
            _selectedEndDate = picked;
            _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
          }
        } else {
          if (_selectedStartDate != null && picked.isBefore(_selectedStartDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('End date cannot be before start date')),
            );
            return;
          }
          _selectedEndDate = picked;
          _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedStartDate == null || _selectedEndDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both start and end dates')),
        );
        return;
      }

      final newHoliday = Holiday(
        id: DateTime.now().toIso8601String(),
        name: _nameController.text,
        startDate: _selectedStartDate!,
        endDate: _selectedEndDate!,
        status: HolidayStatus.pending,
      );

      ref.read(holidayListProvider.notifier).addHoliday(newHoliday);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Holiday added successfully!')),
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
          'Request Holiday',
          style: TextStyle(fontSize: titleFont),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(padding, vertical, padding, vertical + 8),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        labelText: 'Holiday Name',
                        hintText: 'e.g., Diwali Break',
                        controller: _nameController,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter a holiday name' : null,
                      ),
                      SizedBox(height: vertical),
                      CustomTextField(
                        labelText: 'Start Date',
                        hintText: 'Select start date',
                        controller: _startDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _startDateController, true),
                        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please select a start date' : null,
                      ),
                      SizedBox(height: vertical),
                      CustomTextField(
                        labelText: 'End Date',
                        hintText: 'Select end date',
                        controller: _endDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _endDateController, false),
                        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please select an end date' : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(
              text: 'Submit Request',
              onPressed: _submitForm,
              backgroundColor: theme.colorScheme.primary,
              borderRadius: 12,
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtil.verticalSpacing(context),
                horizontal: ResponsiveUtil.horizontalSpacing(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
