import 'package:flutter/material.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

class StudentHeaderCard extends StatelessWidget {
  final String userName;
  final String roomNumber;
  final String imagePath;
  final VoidCallback? onNotificationTap;

  const StudentHeaderCard({
    super.key,
    required this.userName,
    required this.roomNumber,
    required this.imagePath,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.2), width: 2),
            ),
            padding: const EdgeInsets.all(2), // Space for border
            child: CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xFFFFF3E0),
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppText.goodMorning}, $userName',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.meeting_room_outlined,
                              size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Room $roomNumber',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      AppText.premiumResident,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
