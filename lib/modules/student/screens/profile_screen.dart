import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/studentProfileProvider.dart';
import '../../../widgets/profile_info_chip.dart';
import '../../../widgets/shimmer_painter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProfileScreen> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _glowController;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _flipController.forward();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profile = ref.watch(studentProfileProvider);

    final cardWidth = math.min(400.0, size.width * 0.92);
    final profileRadius = size.width < 400 ? size.width * 0.16 : 64.0;
    final logoHeight = size.height * (size.height < 700 ? 0.22 : 0.32);
    final logoWidth = size.width;

    final nameFont = ResponsiveUtil.responsiveFontSize(context, 22);
    final infoFont = ResponsiveUtil.responsiveFontSize(context, 15);
    final chipFont = ResponsiveUtil.responsiveFontSize(context, 16);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Logo with responsive vertical spacing
            Padding(
              padding: EdgeInsets.only(
                top: ResponsiveUtil.verticalSpacing(context) * 2.2,
                bottom: ResponsiveUtil.verticalSpacing(context) * 1.2,
              ),
              child: SizedBox(
                width: logoWidth,
                height: logoHeight,
                child: Image.asset('assets/hsh1.png', fit: BoxFit.contain),
              ),
            ),
            // Card and profile image
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: profileRadius),
                    child: AnimatedBuilder(
                      animation: _flipController,
                      builder: (context, child) {
                        final angle = Tween<double>(
                          begin: math.pi / 2,
                          end: 0.0,
                        ).animate(
                          CurvedAnimation(
                            parent: _flipController,
                            curve: Curves.easeOutBack,
                          ),
                        ).value;

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
                        padding: EdgeInsets.fromLTRB(
                          18,
                          profileRadius,
                          18,
                          24,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.18),
                              blurRadius: 32,
                              offset: Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: _shimmerController,
                                builder: (context, _) {
                                  final shimmer = _shimmerController.value;
                                  return CustomPaint(
                                    painter: ShimmerPainter(shimmer),
                                  );
                                },
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
                                    shadows: [
                                      Shadow(
                                        color: AppColors.secondary.withOpacity(0.18),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ProfileInfoChip(
                                  icon: Icons.school,
                                  label: 'College',
                                  value: profile.college,
                                  color: AppColors.background,
                                  fontSize: chipFont,
                                  valueFont: infoFont,
                                ),
                                const SizedBox(height: 18),
                                ProfileInfoChip(
                                  icon: Icons.meeting_room,
                                  label: 'Room',
                                  value: profile.room,
                                  color: AppColors.background,
                                  fontSize: chipFont,
                                  valueFont: infoFont,
                                ),
                                const SizedBox(height: 18),
                                ProfileInfoChip(
                                  icon: Icons.badge,
                                  label: 'ID',
                                  value: profile.id,
                                  color: AppColors.background,
                                  fontSize: chipFont,
                                  valueFont: infoFont,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _glowController,
                        builder: (context, child) {
                          final glow = Tween<double>(
                            begin: 0.5,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: _glowController,
                              curve: Curves.easeInOut,
                            ),
                          ).value;
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.32 * glow),
                                  blurRadius: 44 + 16 * glow,
                                  spreadRadius: 4 + 6 * glow,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: profileRadius,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(profile.imagePath),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
