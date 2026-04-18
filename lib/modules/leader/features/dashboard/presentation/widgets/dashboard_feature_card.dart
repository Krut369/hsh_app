import 'package:flutter/material.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart';
import 'package:hsh_app/core/theme/app_colors.dart' as hsh;

/// A dashboard feature card matching the Hostel Management Admin Portal design.
///
/// Layout:
/// ```
/// ┌───────────────────────────────────┐
/// │  [icon]                  [BADGE]  │
/// │                                   │
/// │  TITLE                            │
/// │  value  suffix  –OR–  action  →  │
/// └───────────────────────────────────┘
/// ```
class DashboardFeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;

  /// Large numeric value (e.g. "124"). When non-null, renders in big type.
  final String? value;

  /// Small suffix after value (e.g. "/ 150").
  final String? valueSuffix;

  /// Action link label (e.g. "Details", "Analytics", "Open").
  /// Rendered when [value] is null.
  final String? actionLabel;

  /// Badge text (e.g. "LIVE", "5 PENDING", "3 NEW"). Hidden when null.
  final String? badge;

  /// Badge pill background color.
  final Color? badgeColor;

  /// Shows a small red dot on the badge (notification indicator).
  final bool hasNotificationDot;

  final VoidCallback onTap;

  const DashboardFeatureCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.value,
    this.valueSuffix,
    this.actionLabel,
    this.badge,
    this.badgeColor,
    this.hasNotificationDot = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Stack(
        children: [
          // ── Main content ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),

                const Spacer(),

                // Title label
                ModernText(
                  title,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: hsh.AppColors.textSecondary,
                  letterSpacing: 0.6,
                ),
                const SizedBox(height: 5),

                // Value row  OR  action label row
                if (value != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ModernText(
                        value!,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: hsh.AppColors.textPrimary,
                      ),
                      if (valueSuffix != null) ...[
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: ModernText(
                            valueSuffix!,
                            fontSize: 13,
                            color: hsh.AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  )
                else if (actionLabel != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ModernText(
                        actionLabel!,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: hsh.AppColors.primary,
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: hsh.AppColors.primary,
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // ── Badge pill (top-right) ──
          if (badge != null)
            Positioned(
              top: 12,
              right: 12,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor ?? hsh.AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  // Tiny red notification dot overlapping the badge
                  if (hasNotificationDot)
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
