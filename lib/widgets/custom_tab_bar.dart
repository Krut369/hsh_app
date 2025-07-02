import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabLabels;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabLabels,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: TabBar(
          controller: controller,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: colorScheme.primary,
          ),
          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          tabs: tabLabels.map((label) => Tab(text: label)).toList(),
        ),
      ),
    );
  }
}
