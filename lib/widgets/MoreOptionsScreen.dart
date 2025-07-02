import 'package:flutter/material.dart';
import '../core/constants/app_text.dart';
import '../core/theme/app_colors.dart';
import '../modules/auth/screens/login_screen.dart'; // Ensure this path is correct

class MoreOptionsBottomSheet extends StatelessWidget {
  const MoreOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Navigate to Vehicle Registration")),
              );
            },
          ),
          const SizedBox(height: 16),
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
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              Navigator.pop(context); // close the bottom sheet

              // Safely navigate after the current frame is rendered
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
