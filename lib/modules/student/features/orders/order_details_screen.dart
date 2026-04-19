import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/laundry/laundry_utils.dart';
import 'package:hsh_app/modules/student/features/laundry/widgets/laundry_status_chip.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;

class OrderDetailsScreen extends StatelessWidget {
  final LaundryOrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ui.ModernScaffold(
      backgroundColor: AppColors.mainBackground,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Date & Status chip row ────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ui.ModernText(
                        DateFormat('MMM dd, yyyy • hh:mm a').format(order.date),
                        fontSize: 14,
                        color: Colors.grey[600]!,
                      ),
                      LaundryStatusChip(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Status progress stepper ───────────────────────────
                  _StatusStepper(currentStatus: order.status),
                  const SizedBox(height: 28),

                  // ── Items heading ─────────────────────────────────────
                  ui.ModernText(
                    'Items (${order.totalItems})',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headerBlue,
                  ),
                  const SizedBox(height: 16),
                  if (order.items.isEmpty)
                    _buildEmptyState(context)
                  else
                    ...order.items.map((item) => _buildItemCard(context, item)),
                  const SizedBox(height: 24),

                  // ── Note ─────────────────────────────────────────────
                  if (order.note != null && order.note!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.reviewOrange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color:
                                AppColors.reviewOrange.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.note_rounded,
                              color: AppColors.reviewOrange, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ui.ModernText(
                              order.note!,
                              fontSize: 14,
                              color:
                                  AppColors.headerBlue.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Order Summary card ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Service Type', order.serviceType),
                        const Divider(height: 24, color: Color(0xFFEBF3F5)),
                        _buildSummaryRow('Order ID', order.orderId),
                        const Divider(height: 24, color: Color(0xFFEBF3F5)),
                        _buildSummaryRow('Estimated Cost',
                            '₹${(order.totalItems * 15).toStringAsFixed(0)}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 14,
        left: 16,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.headerBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          const ui.ModernText(
            "Order Details",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, LaundryItemEntity item) {
    final color = LaundryUtils.getServiceIcon(item.selectedService.label) ==
            Icons.iron_outlined
        ? AppColors.reviewOrange
        : AppColors.pendingBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBF3F5), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFEBF3F5),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: AppColors.headerBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ui.ModernText(
                  item.name,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headerBlue,
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ui.ModernText(
                    item.selectedService.label,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF3F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ui.ModernText(
              'x${item.quantity}',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.headerBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ui.ModernText(label, fontSize: 14, color: Colors.grey[600]!),
        ui.ModernText(
          value,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.headerBlue,
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBF3F5), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          ui.ModernText(
            'No specific items listed.',
            fontSize: 14,
            color: Colors.grey[500]!,
          ),
        ],
      ),
    );
  }
}

// ── Status Stepper ─────────────────────────────────────────────────────────────

class _StatusStepper extends StatelessWidget {
  final OrderStatus currentStatus;

  const _StatusStepper({required this.currentStatus});

  /// Ordered steps (cancelled is handled separately as a dead-end state)
  static const _steps = [
    OrderStatus.requested,
    OrderStatus.inProgress,
    OrderStatus.readyForPickup,
    OrderStatus.completed,
  ];

  static const _stepLabels = [
    'Requested',
    'Picked Up',
    'Processing',
    'Ready',
  ];

  static const _stepIcons = [
    Icons.send_rounded,
    Icons.directions_bike_outlined,
    Icons.autorenew_rounded,
    Icons.check_circle_outline,
  ];

  @override
  Widget build(BuildContext context) {
    // If cancelled, show a simple banner instead of the stepper
    if (currentStatus == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.cancelledRed.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.cancelledRed.withValues(alpha: 0.25), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_outlined,
                color: AppColors.cancelledRed, size: 20),
            const SizedBox(width: 10),
            const ui.ModernText(
              'This order has been cancelled',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.cancelledRed,
            ),
          ],
        ),
      );
    }

    final currentIdx = _steps.indexOf(currentStatus);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Node row ──────────────────────────────────────────────
          Row(
            children: List.generate(_steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                // Connector line between steps
                final leftIdx = i ~/ 2;
                final isDone = leftIdx < currentIdx;
                return Expanded(
                  child: Container(
                    height: 2.5,
                    decoration: BoxDecoration(
                      gradient: isDone
                          ? LinearGradient(colors: [
                              AppColors.headerBlue,
                              AppColors.headerBlue.withValues(alpha: 0.7),
                            ])
                          : null,
                      color: isDone ? null : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }

              final stepIdx = i ~/ 2;
              final isDone = stepIdx < currentIdx;
              final isCurrent = stepIdx == currentIdx;

              Color nodeColor;
              Color iconColor;
              if (isDone) {
                nodeColor = AppColors.headerBlue;
                iconColor = Colors.white;
              } else if (isCurrent) {
                nodeColor = Colors.white;
                iconColor = AppColors.headerBlue;
              } else {
                nodeColor = const Color(0xFFF1F5F9);
                iconColor = Colors.grey.shade400;
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: nodeColor,
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(color: AppColors.headerBlue, width: 2.5)
                      : isDone
                          ? null
                          : Border.all(
                              color: const Color(0xFFCBD5E1), width: 1.5),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppColors.headerBlue.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                child: Icon(
                  isDone ? Icons.check_rounded : _stepIcons[stepIdx],
                  size: isDone ? 16 : 14,
                  color: iconColor,
                ),
              );
            }),
          ),

          const SizedBox(height: 10),

          // ── Labels row ────────────────────────────────────────────
          Row(
            children: List.generate(_steps.length * 2 - 1, (i) {
              if (i.isOdd) return const Expanded(child: SizedBox());

              final stepIdx = i ~/ 2;
              final isDone = stepIdx < currentIdx;
              final isCurrent = stepIdx == currentIdx;

              return SizedBox(
                width: 36,
                child: Text(
                  _stepLabels[stepIdx],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight:
                        isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent
                        ? AppColors.headerBlue
                        : isDone
                            ? AppColors.headerBlue.withValues(alpha: 0.6)
                            : Colors.grey.shade400,
                    height: 1.2,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
