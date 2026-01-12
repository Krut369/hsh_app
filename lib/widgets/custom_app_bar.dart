import 'package:flutter/material.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onNotificationTap;
  final bool showNotificationIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.onNotificationTap,
    this.showNotificationIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      centerTitle: false,
      leading: leading,
      title: titleWidget ?? Text(
        title,
        style: AppFonts.heading2(context).copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (showNotificationIcon)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CustomAppBarAction(
              icon: Icons.notifications_none,
              onTap: onNotificationTap,
              showBadge: true,
            ),
          ),
        if (actions != null) ...actions!,
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool showBadge;

  const CustomAppBarAction({
    super.key,
    required this.icon,
    this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white12,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: showBadge
            ? Badge(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              )
            : Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
      ),
    );
  }
}
