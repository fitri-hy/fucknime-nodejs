import 'package:flutter/material.dart';

class KomikFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDarkMode;

  const KomikFloatingButton({
    super.key,
    required this.onPressed,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: FloatingActionButton(
        onPressed: onPressed,
        mini: true,
        backgroundColor: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
        child: const Icon(Icons.videocam, color: Colors.white),
      ),
    );
  }
}
