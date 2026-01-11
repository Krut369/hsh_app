import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/models/student_profile.dart';
import 'package:hsh_app/widgets/profile_info_chip.dart';
import 'package:hsh_app/widgets/shimmer_painter.dart';

class ProfileCard extends StatelessWidget {
  final StudentProfile profile;
  final double profileRadius;
  final Animation<double> flipAnimation;
  final Animation<double> shimmerAnimation;

  const ProfileCard({
    required this.profile,
    required this.profileRadius,
    required this.flipAnimation,
    required this.shimmerAnimation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = math.min(400.0, MediaQuery.of(context).size.width * 0.92);
    final nameFont = ResponsiveUtil.responsiveFontSize(context, 22);
    final chipFont = ResponsiveUtil.responsiveFontSize(context, 14);
    final valueFont = ResponsiveUtil.responsiveFontSize(context, 15);

    return AnimatedBuilder(
      animation: flipAnimation,
      builder: (context, child) {
        final angle = flipAnimation.value;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: child,
        );
      },
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.fromLTRB(18, profileRadius, 18, 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.93),
              AppColors.secondary.withOpacity(0.93),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.18),
              blurRadius: 32,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: shimmerAnimation,
                builder: (_, __) => CustomPaint(
                  painter: ShimmerPainter(shimmerAnimation.value),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: nameFont,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                ProfileInfoChip(
                  icon: Icons.school,
                  label: 'College',
                  value: profile.college,
                  color: AppColors.background,
                  fontSize: chipFont,
                  valueFont: valueFont,
                ),
                const SizedBox(height: 18),
                ProfileInfoChip(
                  icon: Icons.meeting_room,
                  label: 'Room',
                  value: profile.room,
                  color: AppColors.background,
                  fontSize: chipFont,
                  valueFont: valueFont,
                ),
                const SizedBox(height: 18),
                ProfileInfoChip(
                  icon: Icons.badge,
                  label: 'ID',
                  value: profile.id,
                  color: AppColors.background,
                  fontSize: chipFont,
                  valueFont: valueFont,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
