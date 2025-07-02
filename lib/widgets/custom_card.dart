import 'package:flutter/material.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/auth_provider.dart';

class MyCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const MyCard({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final paddingValue = ResponsiveUtil.responsivePadding(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: isSelected
              ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0)
              : BorderSide.none,
        ),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: EdgeInsets.all(paddingValue),
          child: Column(
            mainAxisSize: MainAxisSize.min, // important to avoid RenderFlex error
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ResponsiveUtil.responsiveFontSize(context, 40),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).iconTheme.color,
              ),
              const SizedBox(height: 8.0),
              FittedBox( // or Flexible/FlexWrap if needed
                child: Text(
                  text,
                  style: AppFonts.bodyMedium(context).copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
