import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/modules/student/widgets/complain_tab.dart';
import '../../../providers/tab_controller_provider.dart.dart';
import '../../../widgets/custom_tab_bar.dart';
import '../widgets/laundry_tab.dart';
import '../widgets/payment_tab.dart';

class ServiceManagerScreen extends ConsumerStatefulWidget {
  const ServiceManagerScreen({super.key});

  @override
  ConsumerState<ServiceManagerScreen> createState() => _ServiceManagerScreenState();
}

class _ServiceManagerScreenState extends ConsumerState<ServiceManagerScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> _tabLabels = ['Complain','Laundry'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);

    // Delay setting the provider until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tabControllerProvider.notifier).state = _tabController;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTabController = ref.watch(tabControllerProvider);

    if (currentTabController == null) return const SizedBox.shrink();

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
