import 'package:flutter/material.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

class LaundryUtils {
  static Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.requested:
        return AppColors.requestedGrey;
      case OrderStatus.inProgress:
        return AppColors.reviewOrange;
      case OrderStatus.readyForPickup:
        return AppColors.pendingBlue;
      case OrderStatus.completed:
        return AppColors.resolvedGreen;
      case OrderStatus.cancelled:
        return AppColors.cancelledRed;
    }
  }

  static IconData getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.requested:
        return Icons.send_rounded;
      case OrderStatus.inProgress:
        return Icons.autorenew_rounded;
      case OrderStatus.readyForPickup:
        return Icons.notifications_active_outlined;
      case OrderStatus.completed:
        return Icons.check_circle_outline;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  static IconData getServiceIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'wash':
        return Icons.local_laundry_service_outlined;
      case 'press':
        return Icons.iron_outlined;
      case 'both':
        return Icons.dry_cleaning_outlined;
      default:
        return Icons.local_laundry_service_outlined;
    }
  }
}
