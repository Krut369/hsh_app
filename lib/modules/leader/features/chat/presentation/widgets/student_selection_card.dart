import 'package:flutter/material.dart';

class StudentSelectionCard extends StatelessWidget {
  final String name;
  final String room;
  final bool isSelected;
  final VoidCallback onTap;

  const StudentSelectionCard({
    super.key,
    required this.name,
    required this.room,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a consistent pseudo-avatar based on name length for demo purposes
    final avatarId = name.length * 3;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // Ultra-subtle or no drop shadow per aesthetic mock
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?img=$avatarId'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name, 
                      style: const TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 16,
                        color: Color(0xFF1D3557)
                      )
                    ),
                    const SizedBox(height: 2),
                    Text(
                      room.contains('Room') ? room : 'Room $room', 
                      style: const TextStyle(
                        color: Color(0xFF6B7A8A), 
                        fontSize: 13
                      )
                    ),
                  ],
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF0D253F) : const Color(0xFFE8F1F8),
                ),
                alignment: Alignment.center,
                child: isSelected 
                    ? const Icon(Icons.check, size: 16, color: Colors.white) 
                    : const Icon(Icons.add, size: 16, color: Color(0xFF6B7A8A)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
