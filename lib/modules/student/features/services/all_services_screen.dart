import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: const Text(
          AppText.allServices,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          QuickActionCard(
            icon: Icons.person_outline_rounded,
            title: AppText.attendance,
            subtitle: AppText.viewStatus,
            iconColor: const Color(0xFF2563EB),
            iconBgColor: const Color(0xFF2563EB).withValues(alpha: 0.12),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
          ),
          QuickActionCard(
            icon: Icons.payments_outlined,
            title: 'Fees',
            subtitle: AppText.payDue,
            iconColor: const Color(0xFF10B981),
            iconBgColor: const Color(0xFF10B981).withValues(alpha: 0.12),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen())),
          ),
          QuickActionCard(
            icon: Icons.warning_amber_rounded,
            title: AppText.complaint,
            subtitle: AppText.raiseTicket,
            iconColor: const Color(0xFFF59E0B),
            iconBgColor: const Color(0xFFF59E0B).withValues(alpha: 0.12),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComplaintScreen())),
          ),
          QuickActionCard(
            icon: Icons.chat_bubble_outline_rounded,
            title: AppText.chat,
            subtitle: AppText.checkMessages,
            iconColor: const Color(0xFF8B5CF6),
            iconBgColor: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
          ),
          QuickActionCard(
            icon: Icons.note_alt_outlined,
            title: AppText.notes,
            subtitle: AppText.keepNotes,
            iconColor: const Color(0xFF06B6D4),
            iconBgColor: const Color(0xFF06B6D4).withValues(alpha: 0.12),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen())),
          ),
          QuickActionCard(
            icon: Icons.directions_car_outlined,
            title: 'Vehicle',
            subtitle: 'Register vehicle',
            iconColor: const Color(0xFF0D9488),
            iconBgColor: const Color(0xFF0D9488).withValues(alpha: 0.12),
            onTap: () => Get.toNamed('/student/vehicle-registration'),
          ),
        ],
      ),
    );
  }
}
