import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/models/holiday_model.dart';
import 'package:hsh_app/providers/holiday_provider.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/widgets/custom_text_field.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';

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
  late TextEditingController _reasonController;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
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
        reason: _reasonController.text.isNotEmpty ? _reasonController.text : null,
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
    final vertical = ResponsiveUtil.verticalSpacing(context);
    final padding = ResponsiveUtil.responsivePadding(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Request Leave',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(padding, vertical, padding, vertical + 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                 'New Holiday Request',
                 style: AppFonts.heading2(context),
               ),
               const SizedBox(height: 8),
               Text(
                 'Fill in the details below to submit your holiday request for hostel leave.',
                 style: AppFonts.bodyRegular(context).copyWith(
                   color: AppColors.textSecondary,
                 ),
               ),
               SizedBox(height: vertical * 1.5),

               CustomTextField(
                 labelText: AppText.holidayName,
                 hintText: 'e.g., Diwali Break',
                 controller: _nameController,
                 validator: (value) =>
                 value == null || value.isEmpty ? AppText.errorHolidayName : null,
               ),
               SizedBox(height: vertical),
               CustomTextField(
                 labelText: AppText.startDate,
                 hintText: 'mm/dd/yyyy',
                 controller: _startDateController,
                 readOnly: true,
                 onTap: () => _selectDate(context, _startDateController, true),
                 suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                 validator: (value) =>
                 value == null || value.isEmpty ? AppText.errorStartDate : null,
               ),
               SizedBox(height: vertical),
               CustomTextField(
                 labelText: AppText.endDate,
                 hintText: 'mm/dd/yyyy',
                 controller: _endDateController,
                 readOnly: true,
                 onTap: () => _selectDate(context, _endDateController, false),
                 suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                 validator: (value) =>
                 value == null || value.isEmpty ? AppText.errorEndDate : null,
               ),
               SizedBox(height: vertical),
               CustomTextField(
                 labelText: 'Reason (Optional)',
                 hintText: 'Briefly describe your reason for leave',
                 controller: _reasonController,
                 maxLines: 4,
                 minLines: 3,
               ),
              
              SizedBox(height: vertical * 2),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: CustomButton(
                  text: 'Submit Request',
                  onPressed: _submitForm,
                  backgroundColor: const Color(0xFF2C5282),
                  borderRadius: 12,
                  icon: const Icon(Icons.send, size: 18, color: Colors.white),
                  iconSpacing: 8,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "Your request will be sent to the hostel warden for\napproval. You'll be notified once reviewed.",
                  textAlign: TextAlign.center,
                  style: AppFonts.smallText(context).copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
