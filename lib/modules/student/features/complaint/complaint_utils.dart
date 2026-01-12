import 'package:flutter/material.dart';
import 'package:hsh_app/models/complaint_model.dart';

class ComplaintUtils {
  static IconData getComplaintTypeIcon(String typeName) {
    switch (typeName) {
      case 'Carpentry':
        return Icons.handyman_outlined;
      case 'Electrical':
        return Icons.electrical_services_outlined;
      case 'Plumbing':
        return Icons.water_damage_outlined; // Or water_drop_outlined if preferred
      case 'Housekeeping':
        return Icons.cleaning_services_outlined;
      case 'Internet':
        return Icons.wifi;
      case 'Others':
        return Icons.miscellaneous_services_outlined;
      default:
        return Icons.build_circle_outlined;
    }
  }

  static IconData getSubComplaintIcon(String typeName, String subName) {
    if (typeName == 'Electrical') {
      switch (subName) {
        case 'Fan':
          return Icons.wind_power;
        case 'Light':
          return Icons.lightbulb_outline;
        case 'Geyser':
          return Icons.hot_tub_outlined;
        case 'Switch Board':
          return Icons.power_outlined;
        default:
          return Icons.electrical_services_outlined;
      }
    } else if (typeName == 'Plumbing') {
      switch (subName) {
        case 'Tap':
          return Icons.water_drop_outlined;
        case 'Flush':
          return Icons.waves; // Approximation
        case 'Jet Spray':
          return Icons.shower_outlined;
        default:
          return Icons.plumbing_outlined;
      }
    } else if (typeName == 'Carpentry') {
      switch (subName) {
        case 'Bed':
          return Icons.bed_outlined;
        case 'Door':
          return Icons.door_front_door_outlined;
        case 'Cupboard':
          return Icons.door_sliding_outlined;
        default:
          return Icons.carpenter_outlined;
      }
    }
    return Icons.build_circle_outlined;
  }

  static Color getStatusColor(BuildContext context, ComplaintStatus status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case ComplaintStatus.underReview:
        return Colors.orange;
      case ComplaintStatus.pending:
        return scheme.secondary; // Or specific color like Colors.amber
      case ComplaintStatus.awaitingFeedback:
        return Colors.blue;
      case ComplaintStatus.resolved:
        return Colors.green;
    }
  }

  static IconData getStatusIcon(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.underReview:
        return Icons.visibility_outlined;
      case ComplaintStatus.pending:
        return Icons.pending_actions_outlined;
      case ComplaintStatus.awaitingFeedback:
        return Icons.feedback_outlined;
      case ComplaintStatus.resolved:
        return Icons.check_circle_outline;
    }
  }
}
