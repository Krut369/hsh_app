import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/models/holiday_model.dart';
import 'package:hsh_app/providers/holiday_provider.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/widgets/custom_text_field.dart';

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
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
          if (_selectedEndDate != null && _selectedEndDate!.isBefore(picked)) {
            _selectedEndDate = null;
            _endDateController.clear();
          }
        } else {
          if (_selectedStartDate != null && picked.isBefore(_selectedStartDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppText.endDateBeforeStartError)),
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
          const SnackBar(content: Text(AppText.selectBothDatesError)),
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
        SnackBar(
          content: const Row(
            children: [
               Icon(Icons.check_circle, color: Colors.white),
               SizedBox(width: 12),
               Text(AppText.holidayAddedSuccess),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vertical = ResponsiveUtil.verticalSpacing(context);
    final padding = ResponsiveUtil.responsivePadding(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          AppText.requestHoliday,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(padding, vertical, padding, vertical + 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: const Color(0xFFF9FAFB),
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: const Color(0xFFEEEEEE)),
                 ),
                 child: Column(
                   children: [
                      CustomTextField(
                        labelText: AppText.holidayName,
                        hintText: AppText.holidayNameHint,
                        controller: _nameController,
                        validator: (value) =>
                        value == null || value.isEmpty ? AppText.errorHolidayName : null,
                      ),
                      SizedBox(height: vertical),
                      CustomTextField(
                        labelText: AppText.startDate,
                        hintText: AppText.startDateHint,
                        controller: _startDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _startDateController, true),
                        suffixIcon: const Icon(Icons.calendar_month_outlined, color: Colors.grey),
                        validator: (value) =>
                        value == null || value.isEmpty ? AppText.errorStartDate : null,
                      ),
                      SizedBox(height: vertical),
                      CustomTextField(
                        labelText: AppText.endDate,
                        hintText: AppText.endDateHint,
                        controller: _endDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _endDateController, false),
                        suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                        validator: (value) =>
                        value == null || value.isEmpty ? AppText.errorEndDate : null,
                      ),
                   ],
                 ),
              ),
              
              SizedBox(height: vertical * 2),
              SizedBox(
                height: 56,
                child: CustomButton(
                  text: AppText.submitRequest,
                  onPressed: _submitForm,
                  backgroundColor: theme.colorScheme.primary,
                  borderRadius: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
