import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart';

import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:hsh_app/modules/laundry/presentation/widgets/home/laundry_order_info_card.dart';
import 'package:hsh_app/modules/laundry/presentation/widgets/home/laundry_request_item_row.dart';
import 'package:hsh_app/modules/laundry/presentation/widgets/home/status_update_sheet.dart';

class LaundryOrderDetailScreen extends StatefulWidget {
  final LaundryOrderEntity order;

  const LaundryOrderDetailScreen({super.key, required this.order});

  @override
  State<LaundryOrderDetailScreen> createState() =>
      _LaundryOrderDetailScreenState();
}

class _LaundryOrderDetailScreenState extends State<LaundryOrderDetailScreen> {
  final LaundryController controller = Get.find<LaundryController>();

  void _showUpdateStatusSheet() {
    showModernSheet(
      // actionText: context,
      title: 'Update Status',
      child: StatusUpdateSheet(
        currentStatus: widget.order.status,
        onStatusSelected: (newStatus) {
          controller.updateOrderStatus(widget.order.id, newStatus);
          setState(() {});
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentOrder = controller.orders.firstWhere(
          (o) => o.id == widget.order.id,
          orElse: () => widget.order);

      return ModernScaffold(
        appBar: ModernAppBar(
          title: 'Order Summary',
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LaundryOrderInfoCard(order: currentOrder),
              const SizedBox(height: 24),
              const Text(
                'Order Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ModernListTile(
                title: currentOrder.status.label,
                subtitle: 'Tap to change status',
                leading: const Icon(Icons.info_outline),
                onTap: _showUpdateStatusSheet,
              ),
              const SizedBox(height: 24),
              const Text(
                'Laundry Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...currentOrder.items
                  .map((item) => LaundryRequestItemRow(item: item)),
              const SizedBox(height: 40),
              ModernButton(
                text: 'Save Changes',
                onPressed: () {
                  ModernToast.show(
                    message: 'Order status updated successfully',
                    type: ToastType.success,
                  );
                  context.pop();
                },
              ),
              const SizedBox(height: 16),
              ModernButton(
                text: 'Message Student',
                isSecondary: true,
                onPressed: () {
                  context.push('/laundry/chat/details', extra: 'some_id');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
