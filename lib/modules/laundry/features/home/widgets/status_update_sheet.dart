import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/font.dart';
import '../../../../../../models/laundry_order_model.dart'; // Ensure OrderStatus is imported

class StatusUpdateSheet extends StatelessWidget {
  final OrderStatus currentStatus;
  final Function(OrderStatus) onStatusSelected;

  const StatusUpdateSheet({
    super.key,
    required this.currentStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Update Status',
            style: AppFonts.heading3(context).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStatusTile(
            context,
            OrderStatus.requested,
            Colors.grey,
          ),
          _buildStatusTile(
            context,
            OrderStatus.inProgress,
            AppColors.primary,
          ),
          _buildStatusTile(
            context,
             OrderStatus.readyForPickup, 
             AppColors.warningOrange,
          ),
          _buildStatusTile(
            context,
            OrderStatus.completed,
            AppColors.successGreen,
            label: 'Delivered'
          ),
          _buildStatusTile(
            context,
            OrderStatus.cancelled,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTile(BuildContext context, OrderStatus status, Color color, {String? label}) {
    final displayLabel = label ?? status.label;
    final isSelected = currentStatus == status && (label == null || label == status.label); // simplified chck

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ),
      title: Text(
        displayLabel,
        style: AppFonts.bodyMedium(context).copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: () {
        onStatusSelected(status);
        Navigator.pop(context);
      },
    );
  }
}
