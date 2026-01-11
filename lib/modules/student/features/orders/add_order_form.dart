// lib/widgets/add_order_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/modules/student/features/orders/select_items_screen.dart';

class AddOrderForm extends ConsumerStatefulWidget {
  const AddOrderForm({super.key});

  @override
  ConsumerState<AddOrderForm> createState() => _AddOrderFormState();
}

class _AddOrderFormState extends ConsumerState<AddOrderForm> {
  final _formKey = GlobalKey<FormState>();
  late final String _orderId;
  late final DateTime _orderDate;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();

    _orderDate = DateTime.now();
    _orderId =
    '#ORD${DateFormat('yyyyMMdd').format(_orderDate)}${(_uuid.v4().hashCode % 10000).abs()}';
  }

  void _proceedToItemSelection() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SelectItemsScreen(
          orderId: _orderId,
          orderDate: _orderDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'New Laundry Order',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Only show the action button
              CustomButton(
                text: 'Select Items',
                onPressed: _proceedToItemSelection,
                backgroundColor: const Color(0xFFC7B1E3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
