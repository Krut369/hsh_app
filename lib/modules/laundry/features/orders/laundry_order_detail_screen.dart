import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/font.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/laundry_order_model.dart';
import '../../../../providers/laundry_order_provider.dart';
import '../../../student/features/chat/chat_provider.dart';
import '../../../../widgets/custom_app_bar.dart';

import '../home/widgets/laundry_order_info_card.dart';
import '../home/widgets/laundry_request_item_row.dart';
import '../home/widgets/status_update_sheet.dart';

class LaundryOrderDetailScreen extends ConsumerStatefulWidget {
  final LaundryOrder order;

  const LaundryOrderDetailScreen({super.key, required this.order});

  @override
  ConsumerState<LaundryOrderDetailScreen> createState() =>
      _LaundryOrderDetailScreenState();
}

class _LaundryOrderDetailScreenState extends ConsumerState<LaundryOrderDetailScreen> {
  // Local state to show immediate updates before provider sync if needed,
  // but better to rely on provider stream/state.
  // Using simple local update for immediate UI feedback.
  
  void _showUpdateStatusSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatusUpdateSheet(
            currentStatus: widget.order.status,
            onStatusSelected: (newStatus) {
                 final updatedOrder = widget.order.copyWith(status: newStatus);
                 ref.read(laundryOrderListProvider.notifier).updateOrder(updatedOrder);
                 // In a real app, you might waiting for API response.
                 // Here, because we are passing the object from the list, 
                 // and the list is in the provider, we should rely on the provider.
                 // However, since this screen takes 'order' as a parameter which is NOT a stream,
                 // we won't see the update unless we wrap the body in a Consumer looking at the provider for *this* specific ID,
                 // or if we rely on the parent list to rebuild. 
                 // For simpler refactor, we just rely on the fact that when we go back, the list is updated.
                 // To show update HERE, we really should watch the specific item.
                 
                 // Since we don't have a 'singleItemProvider', we will force a rebuild or just show feedback.
                 setState(() {}); 
            },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // To ensure we show the LATEST data, we should find this order in the provider list
    // Fallback to widget.order if not found (e.g. error case)
    final allOrders = ref.watch(laundryOrderListProvider);
    final currentOrder = allOrders.firstWhere(
        (o) => o.id == widget.order.id, 
        orElse: () => widget.order
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Order Details',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Card
            LaundryOrderInfoCard(order: currentOrder),
            const SizedBox(height: 24),
            
            // Status Section
            Text(
              'Order Status',
              style: AppFonts.heading3(context).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showUpdateStatusSheet,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentOrder.status.label,
                      style: AppFonts.heading3(context).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textPrimary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Laundry Items Section
            Text(
              'Laundry Items',
              style: AppFonts.heading3(context).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ...currentOrder.items.map((item) => LaundryRequestItemRow(item: item)),
           
            const SizedBox(height: 40),

             SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order status updated successfully'),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Save Changes',
                      style: AppFonts.buttonText(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                   // Placeholder Name since we don't have User model linked yet
                   final studentName = 'John Doe'; 
                   final chatId = ref.read(chatProvider.notifier).getConversationIdByName(studentName);
                   context.push('/laundry/chat/details', extra: chatId);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_bubble_rounded,
                        size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Message Student',
                      style: AppFonts.buttonText(context).copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

