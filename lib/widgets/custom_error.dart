import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  final String errorMsg;
  final IconData icon;
  final Color color;
  const CustomError(
      {super.key,
      required this.errorMsg,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Icon(icon, color: color, size: 200)),
          Text(errorMsg, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
