import 'package:flutter/material.dart';
import 'package:hsh_app/models/chat_group_model.dart';

class GroupCard extends StatelessWidget {
  final ChatGroup group;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD6ECF7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.group, color: Color(0xFF2D507B)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${group.memberCount} students',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5D90B3),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF5D90B3)),
          ],
        ),
      ),
    );
  }
}
