import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/font.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../student/features/chat/chat_provider.dart';
import '../../../../widgets/custom_app_bar.dart';

class LaundryOrderDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> requestData;

  const LaundryOrderDetailScreen({super.key, required this.requestData});

  @override
  ConsumerState<LaundryOrderDetailScreen> createState() =>
      _LaundryOrderDetailScreenState();
}

class _LaundryOrderDetailScreenState extends ConsumerState<LaundryOrderDetailScreen> {
  late Map<String, dynamic> _currentRequestData;

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the data
    _currentRequestData = Map<String, dynamic>.from(widget.requestData);
  }





  void _showUpdateStatusSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Update Status',
                style: AppFonts.heading3(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatusTile('In Progress', 'In Progress', AppColors.primary),
              _buildStatusTile('Ready for Pickup', 'Ready for Pickup',
                  AppColors.warningOrange),
              _buildStatusTile(
                  'Delivered', 'Delivered', AppColors.successGreen),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusTile(String label, String statusKey, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentRequestData['status'] == statusKey
                ? color
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ),
      title: Text(
        label,
        style: AppFonts.bodyMedium(context).copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: () {
        _updateStatus(statusKey);
        Navigator.pop(context);
      },
    );
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _currentRequestData['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ... items list ...
    final List<Map<String, dynamic>> laundryItems = [
      {
        'name': 'T-Shirts',
        'qty': 5,
        'type': 'WASH',
        'typeColor': const Color(0xFFE3F2FD),
        'typeTextColor': AppColors.primary,
        'icon': Icons.checkroom_rounded, // Placeholder icon
      },
      {
        'name': 'Formal Shirts',
        'qty': 2,
        'type': 'PRESS',
        'typeColor': const Color(0xFFF3E5F5),
        'typeTextColor': Colors.purple,
        'icon': Icons.dry_cleaning_rounded, // Placeholder icon
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Order Details',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... Student Info Card ...
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                   // Image Placeholder
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.grey, // Placeholder color
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://placehold.co/600x400/png'), // Placeholder
                          fit: BoxFit.cover,
                        )),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.image_not_supported_outlined,
                            color: Colors.white54, size: 50)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ACTIVE ORDER',
                              style: AppFonts.smallText(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _currentRequestData['orderId'] ??
                                    '#ORD-8829', // Fallback
                                style: AppFonts.smallText(context).copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _currentRequestData['name'] ?? 'Alex Johnson',
                          style: AppFonts.heading2(context).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ... rest of student info ...
                        const SizedBox(height: 8),
                         Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              _currentRequestData['room'] ??
                                  'Room 402, North Hall',
                              style: AppFonts.bodyMedium(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              'Pickup: Oct 24, 10:00 AM',
                              style: AppFonts.bodyMedium(context).copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
             const SizedBox(height: 24),
            
            // ... Status Section ...
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
                  borderRadius: BorderRadius.circular(30), // Pill shape
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _currentRequestData['status'] ?? 'In Progress',
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

            // ... Laundry Items Section ...
            Text(
              'Laundry Items',
              style: AppFonts.heading3(context).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
             ...laundryItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item['icon'], color: AppColors.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: AppFonts.bodyMedium(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Qty: ${item['qty']}',
                                style: AppFonts.smallText(context).copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: item['typeColor'],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['type'],
                            style: AppFonts.smallText(context).copyWith(
                              color: item['typeTextColor'],
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.circle,
                            color: AppColors.successGreen, size: 12),
                      ],
                    ),
                  ),
                )),
           
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
                  Navigator.pop(context, _currentRequestData);
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
                   final studentName = _currentRequestData['name'] ?? 'John Doe';
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
