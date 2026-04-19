// lib/widgets/add_order_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;

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
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ui.ModernCard(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ui.ModernText(
                    'New Laundry Order',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Using ModernButton from the toolkit
                  ui.ModernButton(
                    text: 'Select Items',
                    onPressed: _proceedToItemSelection,
                    icon: Icons.shopping_basket_outlined,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
