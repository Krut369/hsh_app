import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/tab_controller_provider.dart.dart';
import '../../../widgets/custom_tab_bar.dart';
import '../widgets/holiday_tab.dart';
import '../widgets/payment_tab.dart';

class HolidayPaymentScreen extends ConsumerStatefulWidget {
  const HolidayPaymentScreen({super.key});

  @override
  ConsumerState<HolidayPaymentScreen> createState() => _HolidayPaymentScreenState();
}

class _HolidayPaymentScreenState extends ConsumerState<HolidayPaymentScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> _tabLabels = ['Holiday', 'Fee Payment'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);

    // Set the controller to provider so others can access it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(tabControllerProvider.notifier).state = _tabController;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Optional: just to keep provider in sync
    ref.watch(tabControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave & Payment'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomTabBar(controller: _tabController, tabLabels: _tabLabels),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                HolidayTab(),
                PaymentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
