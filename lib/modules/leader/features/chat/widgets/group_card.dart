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
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // Extremely subtle or no shadow per mock
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with optional online dot
            Stack(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1F8), // light blue fallback
                    shape: BoxShape.circle,
                    image: group.iconUrl != null
                        ? DecorationImage(
                            image: NetworkImage(group.iconUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: group.iconUrl == null
                      ? Icon(
                          group.name.contains('Group') ? Icons.groups : Icons.person,
                          color: const Color(0xFF1D3557),
                          size: 28,
                        )
                      : null,
                ),
                if (group.unreadCount > 0) // Mocking online status using unreadCount for demo
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC3545), // Red dot
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Middle section: Name and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D3557), // Dark navy
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (group.lastMessage != null)
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          children: [
                            if (group.name.contains('Group')) 
                              TextSpan(
                                text: '${group.lastMessage!.senderName}: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7A8A),
                                ),
                              ),
                            TextSpan(
                              text: group.lastMessage!.content,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7A8A), // Subtitle grey
                              ),
                            ),
                          ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right section: Timestamp and Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (group.lastMessage != null)
                  Text(
                    _formatTimestamp(group.lastMessage!.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: group.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                      color: group.unreadCount > 0 ? const Color(0xFF1D3557) : const Color(0xFF9BABBB),
                    ),
                  ),
                const SizedBox(height: 8),
                if (group.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D3557),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                    alignment: Alignment.center,
                    child: Text(
                      '${group.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20), // Placeholder to maintain height
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0 && now.day == time.day) {
      // Today: '2:44 AM'
      int hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
      String amPm = time.hour >= 12 ? 'PM' : 'AM';
      String minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute $amPm';
    } else if (difference.inDays == 1 || (difference.inDays == 0 && now.day != time.day)) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // Day of week e.g. 'Tue'
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[time.weekday - 1];
    } else {
      // Date e.g. 'Oct 12'
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[time.month - 1]} ${time.day}';
    }
  }
}
