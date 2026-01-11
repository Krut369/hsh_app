import 'package:flutter/material.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/widgets/custom_card.dart';
import 'package:hsh_app/modules/student/features/scanner/mobile_scanner_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? _selectedAttendanceType;
  int _scanCount = 0;
  String? _scanStatus;

  final List<Map<String, dynamic>> _attendanceOptions = [
    {'name': 'Lunch', 'icon': Icons.fastfood},
    {'name': 'Dinner', 'icon': Icons.dinner_dining},
    {'name': 'Sabha', 'icon': Icons.group},
    {'name': 'Aarti', 'icon': Icons.yard_outlined},
    {'name': 'Night', 'icon': Icons.king_bed},
  ];

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(ResponsiveUtil.responsivePadding(context));
    final verticalSpacing = SizedBox(height: ResponsiveUtil.verticalSpacing(context));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Hari Saurabh Hostel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notification logic
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Attendance Type', style: AppFonts.bodyBold(context)),
              verticalSpacing,
              GridView.builder(
                itemCount: _attendanceOptions.length,
                shrinkWrap: true, // 👈 Important: makes GridView take only needed space
                physics: const NeverScrollableScrollPhysics(), // 👈 avoid nested scrolls
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final option = _attendanceOptions[index];
                  final isSelected = _selectedAttendanceType == option['name'];
                  return MyCard(
                    icon: option['icon'],
                    text: option['name'],
                    isSelected: isSelected,
                    onTap: () async {
                      setState(() {
                        _selectedAttendanceType = option['name'];
                      });

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MobileScannerScreen()),
                      );

                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Scanned: $result')),
                        );
                        setState(() => _scanCount += 1); // example logic
                      }
                    },

                  );
                },
              ),
              verticalSpacing,
              Card(
                elevation: 6, // Increased elevation for a more prominent shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Slightly more rounded corners
                ),
                margin: const EdgeInsets.all(16), // Added margin around the card for better spacing
                child: Padding(
                  padding: const EdgeInsets.all(20), // Increased padding inside the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Scan Progress', // More descriptive title
                            style: AppFonts.headline6(context)?.copyWith(fontWeight: FontWeight.bold), // Using a larger, bolder font
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1), // Light background for the count
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_scanCount/2 scans',
                              style: AppFonts.bodyMedium(context)?.copyWith(color: Theme.of(context).primaryColor), // Color matching theme
                            ),
                          ),
                        ],
                      ),
                       Divider(height: 24, thickness: 2,color: Theme.of(context).primaryColor ), // Added a divider for visual separation
                      RadioListTile<String>(
                        title: Text(
                          'First Scan: Pending Attendance',
                          style: AppFonts.subtitle1(context), // Slightly larger font for titles
                        ),
                        subtitle: const Text(
                            'Awaiting confirmation for the initial scan.'), // Added a helpful subtitle
                        value: 'first_scan',
                        groupValue: _scanStatus,
                        onChanged: (value) {
                          setState(() {
                            _scanStatus = value;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor, // Use theme's primary color
                        contentPadding: EdgeInsets.zero, // Remove default padding from RadioListTile
                      ),
                      RadioListTile<String>(
                        title: Text(
                          'Second Scan: Confirm Attendance',
                          style: AppFonts.subtitle1(context),
                        ),
                        subtitle: const Text('Please confirm attendance for the final scan.'),
                        value: 'second_scan',
                        groupValue: _scanStatus,
                        onChanged: (value) {
                          setState(() {
                            _scanStatus = value;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
