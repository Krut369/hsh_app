import 'package:flutter/material.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';

class LaundryOrderDetailScreen extends StatefulWidget {
  final LaundryOrderEntity order;

  const LaundryOrderDetailScreen({super.key, required this.order});

  @override
  State<LaundryOrderDetailScreen> createState() =>
      _LaundryOrderDetailScreenState();
}

class _LaundryOrderDetailScreenState extends State<LaundryOrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ModernScaffold(
      backgroundColor: const Color(0xFFF1F7F9),
      appBar: ModernAppBar(
        title: 'Order #${widget.order.id}',
        onSearchPressed: () {},
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              _buildStatusStepperCard(),
              const SizedBox(height: 20),
              _buildImageCard(),
              const SizedBox(height: 20),
              _buildOrderItemsSection(),
              const SizedBox(height: 20),
              _buildEstimatedDeliverySection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusStepperCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StepIndicator(
              label: "REQUESTED", isCompleted: true, isActive: false),
          _StepLine(isCompleted: true),
          _StepIndicator(
              label: "PICKED UP", isCompleted: true, isActive: false),
          _StepLine(isCompleted: true),
          _StepIndicator(
              label: "PROCESSING", isCompleted: false, isActive: true),
          _StepLine(isCompleted: false),
          _StepIndicator(label: "READY", isCompleted: false, isActive: false),
        ],
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/laundry_machine.png',
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 200,
            color: Colors.grey.shade200,
            child: const Icon(Icons.dry_cleaning, size: 40, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Items',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'IN PROGRESS',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F46E5)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildItemRow("2 Shirts", "Wash & Fold", "\$12.00"),
          const SizedBox(height: 16),
          _buildItemRow("1 Pant", "Press Only", "\$8.00"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Amount',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('\$24.50',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  SizedBox(height: 4),
                  Text('Includes \$4.50 Service Fee',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Help?'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String type, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(type,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        Text(price,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildEstimatedDeliverySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text('Estimated Delivery',
                  style: TextStyle(
                      fontSize: 14, color: Colors.white.withOpacity(0.8))),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Oct 24, 2023',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text('By 10:00 AM',
              style: TextStyle(
                  fontSize: 14, color: Colors.white.withOpacity(0.8))),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isActive;
  const _StepIndicator(
      {required this.label, required this.isCompleted, required this.isActive});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isCompleted
              ? Icons.check_circle
              : (isActive
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off),
          color: (isCompleted || isActive)
              ? AppColors.primary
              : Colors.grey.shade300,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isCompleted;
  const _StepLine({required this.isCompleted});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 25,
        height: 2,
        color: isCompleted ? AppColors.primary : Colors.grey.shade200);
  }
}
