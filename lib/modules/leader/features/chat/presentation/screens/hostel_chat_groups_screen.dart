import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;
import 'package:hsh_app/modules/leader/presentation/router/leader_auto_router.dart';
import '../../../../../../models/chat_group_model.dart';
import '../controllers/chat_controller.dart';
import '../widgets/group_card.dart';

@RoutePage()
class HostelChatGroupsScreen extends GetView<HostelChatGroupsController> {
  const HostelChatGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No need for Get.put anymore as it's provided via LeaderBinding

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light gray from mockup
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.chat_bubble_rounded),
        onPressed: () => context.router.push(const CreateNewGroupRoute()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom App Bar with rounded bottom corners
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 24,
                right: 24,
                bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF1D3557), // Dark navy
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                // Avatar icon box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      'https://i.pravatar.cc/150?img=68',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, color: Colors.white70);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Messages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Search button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.search, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // RECENTS header
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 12),
            child: Text(
              'RECENTS',
              style: TextStyle(
                color: Color(0xFF9BABBB),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // Chat groups list
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: controller.chatGroups.length,
                  itemBuilder: (context, index) {
                    final group = controller.chatGroups[index];
                    return GroupCard(
                      group: group,
                      onTap: () =>
                          context.router.push(GroupChatRoute(group: group)),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
