import 'package:flutter/material.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';

class LaundryRequestItemRow extends StatelessWidget {
  final LaundryItemEntity item;

  const LaundryRequestItemRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    Color typeTextColor;

    switch (item.selectedService) {
      case LaundryServiceType.wash:
        typeColor = const Color(0xFFE3F2FD);
        typeTextColor = AppColors.primary;
        break;
      case LaundryServiceType.press:
        typeColor = const Color(0xFFF3E5F5);
        typeTextColor = Colors.purple;
        break;
      case LaundryServiceType.both:
        typeColor = const Color(0xFFE0F2F1);
        typeTextColor = Colors.teal;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppFonts.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Qty: ${item.quantity}',
                    style: AppFonts.smallText(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.selectedService.label,
                style: AppFonts.smallText(context).copyWith(
                  color: typeTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.circle, color: AppColors.successGreen, size: 12),
          ],
        ),
      ),
    );
  }
}
