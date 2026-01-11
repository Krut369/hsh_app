import 'package:flutter/material.dart';

class VehicleLabel extends StatelessWidget {
  final String text;

  const VehicleLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}
