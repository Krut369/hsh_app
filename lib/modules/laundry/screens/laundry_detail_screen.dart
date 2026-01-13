import 'package:flutter/material.dart';
import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'laundry_order_detail_screen.dart';

class LaundryDetailScreen extends StatefulWidget {
  const LaundryDetailScreen({super.key});

  @override
  State<LaundryDetailScreen> createState() => _LaundryDetailScreenState();
}

class _LaundryDetailScreenState extends State<LaundryDetailScreen> {
  String selectedFilter = 'All';
  DateTime selectedDate = DateTime.now();

  // Mock Data mimicking the image content
  final List<Map<String, dynamic>> laundryRequests = [
    {
      'status': 'In Progress',
      'time': '10 mins ago',
      'name': 'John Doe',
      'room': 'Room 204 • #ORD-9921',
      'action': 'Update Status',
      'actionColor': AppColors.primary,
      'actionTextColor': Colors.white,
      'statusColor': const Color(0xFFE3F2FD), // Light Blue
      'statusTextColor': AppColors.primary,
    },
    {
      'status': 'Ready for Pickup',
      'time': '1 hour ago',
      'name': 'Jane Smith',
      'room': 'Room 102 • #ORD-9918',
      'action': 'Update Status',
      'actionColor': const Color(0xFFF5F5F5), // Light Grey
      'actionTextColor': Colors.black,
      'statusColor': const Color(0xFFFFF3E0), // Light Orange
      'statusTextColor': AppColors.warningOrange,
    },
    {
      'status': 'Requested',
      'time': '2 hours ago',
      'name': 'Mike Ross',
      'room': 'Room 305 • #ORD-9925',
      'action': 'Start Washing',
      'actionColor': const Color(0xFFF5F5F5),
      'actionTextColor': Colors.black,
      'statusColor': const Color(0xFFEEEEEE), // Light Grey
      'statusTextColor': Colors.grey[700],
    },
    {
      'status': 'Delivered',
      'time': 'Completed',
      'name': 'Harvey Specter',
      'room': 'Room 501 • #ORD-9910',
      'action': 'Finished',
      'actionColor': const Color(0xFFE8F5E9), // Light Green
      'actionTextColor': AppColors.successGreen,
      'statusColor': const Color(0xFFE8F5E9),
      'statusTextColor': AppColors.successGreen,
      'isFinished': true,
    },
  ];

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Filters",
                            style: AppFonts.heading3(context)
                                .copyWith(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedFilter = 'All';
                              selectedDate = DateTime.now();
                            });
                            setModalState(() {});
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Clear all",
                            style: AppFonts.bodyMedium(context).copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close))
                      ]),
                  const SizedBox(height: 20),

                  // Date Filter
                  Text("Date",
                      style: AppFonts.bodyMedium(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.textPrimary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                          setModalState(() {});
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.surface,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDate(selectedDate),
                                    style: AppFonts.bodyRegular(context)),
                                const Icon(Icons.calendar_today_rounded,
                                    size: 20, color: AppColors.textSecondary)
                              ]))),
                  const SizedBox(height: 20),

                  // Status Filter
                  Text("Status",
                      style: AppFonts.bodyMedium(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'All',
                      'Requested',
                      'In Progress',
                      'Ready for Pickup',
                      'Delivered'
                    ].map((status) {
                      return ChoiceChip(
                        label: Text(status),
                        selected: selectedFilter == status,
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              selectedFilter = status;
                            });
                            setModalState(() {});
                            Navigator.pop(context);
                          }
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: selectedFilter == status
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: selectedFilter == status
                                    ? Colors.transparent
                                    : AppColors.border)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showUpdateStatusSheet(Map<String, dynamic> item) {
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
              _buildStatusTile(
                  item, 'In Progress', 'In Progress', AppColors.primary),
              _buildStatusTile(item, 'Ready for Pickup', 'Ready for Pickup',
                  AppColors.warningOrange),
              _buildStatusTile(
                  item, 'Delivered', 'Delivered', AppColors.successGreen),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusTile(
      Map<String, dynamic> item, String label, String statusKey, Color color) {
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
            color: item['status'] == statusKey ? color : Colors.transparent,
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
        _updateStatus(item, statusKey);
        Navigator.pop(context);
      },
    );
  }

  void _updateStatus(Map<String, dynamic> item, String newStatus) {
    setState(() {
      int index = laundryRequests.indexOf(item);
      if (index != -1) {
        laundryRequests[index]['status'] = newStatus;
        if (newStatus == 'In Progress') {
          laundryRequests[index]['statusColor'] = const Color(0xFFE3F2FD);
          laundryRequests[index]['statusTextColor'] = AppColors.primary;
          laundryRequests[index]['action'] = 'Update Status';
          laundryRequests[index]['actionColor'] = const Color(0xFFF5F5F5);
          laundryRequests[index]['actionTextColor'] = Colors.black;
          laundryRequests[index]['isFinished'] = false;
        } else if (newStatus == 'Ready for Pickup') {
          laundryRequests[index]['statusColor'] = const Color(0xFFFFF3E0);
          laundryRequests[index]['statusTextColor'] = AppColors.warningOrange;
          laundryRequests[index]['action'] = 'Update Status';
          laundryRequests[index]['actionColor'] = const Color(0xFFF5F5F5);
          laundryRequests[index]['actionTextColor'] = Colors.black;
          laundryRequests[index]['isFinished'] = false;
        } else if (newStatus == 'Delivered') {
          laundryRequests[index]['statusColor'] = const Color(0xFFE8F5E9);
          laundryRequests[index]['statusTextColor'] = AppColors.successGreen;
          laundryRequests[index]['action'] = 'Finished';
          laundryRequests[index]['actionColor'] = const Color(0xFFE8F5E9);
          laundryRequests[index]['actionTextColor'] = AppColors.successGreen;
          laundryRequests[index]['isFinished'] = true;
        }
      }
    });
  }

  String _formatDate(DateTime date) {
    if (DateUtils.isSameDay(date, DateTime.now())) {
      return "Today, ${DateFormat('MMM d').format(date)}";
    }
    return DateFormat('EEE, MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    // Filter list logic
    final filteredRequests = selectedFilter == 'All'
        ? laundryRequests
        : laundryRequests
            .where((item) =>
                item['status'].toString().toUpperCase() ==
                selectedFilter.toUpperCase())
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Laundry',
          style: AppFonts.heading2(context).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 8),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white12, shape: BoxShape.circle),
                padding: const EdgeInsets.all(8),
                child: const Badge(
                    child: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 24,
                ))),
          ),
          GestureDetector(
            onTap: () => _showFilterDialog(),
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white12, shape: BoxShape.circle),
                padding: const EdgeInsets.all(8),
                child: selectedFilter != 'All'
                    ? const Badge(
                        child: Icon(
                        Icons.filter_list_rounded,
                        color: Colors.white,
                        size: 24,
                      ))
                    : const Icon(
                        Icons.filter_list_rounded,
                        color: Colors.white,
                        size: 24,
                      )),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          ResponsiveUtil.responsivePadding(context),
          16,
          ResponsiveUtil.responsivePadding(context),
          80, // Bottom padding for FAB
        ),
        itemCount: filteredRequests.length,
        itemBuilder: (context, index) {
          final item = filteredRequests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildLaundryCard(context, item),
          );
        },
      ),
    );
  }

  Widget _buildLaundryCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaundryOrderDetailScreen(requestData: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header: Name and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: AppFonts.heading3(context).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['room'],
                        style: AppFonts.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: item['statusColor'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['status'],
                    style: AppFonts.smallText(context).copyWith(
                      color: item['statusTextColor'],
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),

            // Footer: Time and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      item['time'],
                      style: AppFonts.smallText(context).copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Action Button Logic
                if (item['isFinished'] == true)
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: item['actionColor'],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.check_circle,
                            size: 16, color: item['actionTextColor']),
                        const SizedBox(width: 6),
                        Text(
                          item['action'],
                          style: AppFonts.buttonText(context).copyWith(
                            color: item['actionTextColor'],
                            fontSize: 13,
                          ),
                        )
                      ]))
                else
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showUpdateStatusSheet(item),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item['action'],
                                style: AppFonts.buttonText(context).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                )),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded,
                                size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
