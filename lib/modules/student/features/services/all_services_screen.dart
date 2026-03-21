import 'package:flutter/material.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/modules/student/features/common/quick_action_card.dart';
import 'package:hsh_app/modules/student/features/attendance/attendance_screen.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_screen.dart';
import 'package:hsh_app/modules/student/features/payment/payment_screen.dart';
import 'package:hsh_app/modules/student/features/chat/chat_screen.dart';
import 'package:hsh_app/modules/student/features/notes/notes_screen.dart';

class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.allServices),
        elevation: 0,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          QuickActionCard(
            icon: Icons.person_outline,
            title: AppText.attendance,
            subtitle: AppText.viewStatus,
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.withValues(alpha: 0.1),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
          ),
          QuickActionCard(
            icon: Icons.payments_outlined,
            title: 'Fees',
            subtitle: AppText.payDue,
            iconColor: Colors.green,
            iconBgColor: Colors.green.withValues(alpha: 0.1),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen())),
          ),
          QuickActionCard(
            icon: Icons.warning_amber_rounded,
            title: AppText.complaint,
            subtitle: AppText.raiseTicket,
            iconColor: Colors.orange,
            iconBgColor: Colors.orange.withValues(alpha: 0.1),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComplaintScreen())),
          ),
          QuickActionCard(
            icon: Icons.chat_bubble_outline,
            title: AppText.chat,
            subtitle: AppText.checkMessages,
            iconColor: Colors.purple,
            iconBgColor: Colors.purple.withValues(alpha: 0.1),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
          ),
          QuickActionCard(
            icon: Icons.note_alt_outlined,
            title: AppText.notes,
            subtitle: AppText.keepNotes,
            iconColor: Colors.teal,
            iconBgColor: Colors.teal.withValues(alpha: 0.1),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen())),
          ),
        ],
      ),
    );
  }
}
