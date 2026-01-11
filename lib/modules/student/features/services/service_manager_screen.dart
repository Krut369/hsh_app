import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/providers/tab_controller_provider.dart.dart';
import 'package:hsh_app/widgets/custom_tab_bar.dart';
import 'package:hsh_app/modules/student/features/complaint/complain_tab.dart';
import 'package:hsh_app/modules/student/features/laundry/laundry_tab.dart';

class ServiceManagerScreen extends ConsumerStatefulWidget {
  const ServiceManagerScreen({super.key});

  @override
  ConsumerState<ServiceManagerScreen> createState() =>
      _ServiceManagerScreenState();
}

class _ServiceManagerScreenState extends ConsumerState<ServiceManagerScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final StateController<TabController?> tabControllerState;
  final List<String> _tabLabels = ['Complain', 'Laundry'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);

    // Store the StateController reference
    tabControllerState = ref.read(tabControllerProvider.notifier);

    // Provide controller after build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabControllerState.state = _tabController;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabControllerState.state = null;
    });
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTabController = ref.watch(tabControllerProvider);

    // ✅ Don't build anything until the controller is available
    if (currentTabController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Manager'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomTabBar(controller: currentTabController, tabLabels: _tabLabels),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: currentTabController,
              children: const [
                ComplainTab(),
                LaundryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
