import 'package:flutter/material.dart';

class ComplainCard extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onTap;

  const ComplainCard({
    super.key,
    required this.title,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text("Status: $status"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
