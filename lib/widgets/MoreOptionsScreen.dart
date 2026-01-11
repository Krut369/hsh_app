import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../modules/auth/screens/login_screen.dart';
import '../../providers/auth_provider.dart';
import 'package:hsh_app/modules/student/features/vehicle/vehicle_registration_screen.dart';

class MoreOptionsBottomSheet extends ConsumerWidget {
  const MoreOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🚗 Vehicle Registration Button
          ElevatedButton.icon(
            icon: const Icon(Icons.directions_car),
            label: const Text(AppText.vehicleRegistration),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleRegistrationScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // 🛫 Temporary Leave Button
          ElevatedButton.icon(
            icon: const Icon(Icons.airplane_ticket_outlined),
            label: const Text(AppText.temporaryLeave),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Navigate to Temporary Leave")),
              );
            },
          ),

          const SizedBox(height: 16),

          // 🔒 Logout Button
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () async {
              Navigator.pop(context); // Close the bottom sheet

              await ref.read(authProvider.notifier).logout();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
