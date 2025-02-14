import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class KomikBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isDarkMode;

  const KomikBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.isDarkMode,
  });

  final List<Map<String, dynamic>> _items = const [
    {'icon': Icons.home, 'label': 'Beranda'},
    {'icon': Icons.fiber_new, 'label': 'Terbaru'},
    {'icon': Icons.av_timer, 'label': 'Populer'},
    {'icon': Icons.format_list_numbered, 'label': 'Peringkat'},
    {'icon': Icons.filter_alt, 'label': 'Filter'},
  ];

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
      buttonBackgroundColor: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
      height: 50,
      animationDuration: const Duration(milliseconds: 300),
      index: selectedIndex,
      items: List.generate(_items.length, (index) {
        final isSelected = selectedIndex == index;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _items[index]['icon'],
              size: 25,
              color: isSelected
                  ? (isDarkMode ? Colors.grey.shade100 : Colors.white)
                  : (isDarkMode ? Colors.grey.shade300 : Colors.white),
            ),
            if (!isSelected)
              Text(
                _items[index]['label'],
                style: TextStyle(
                  fontSize: 9,
                  color: isDarkMode ? Colors.grey.shade100 : Colors.grey.shade100,
                ),
              ),
          ],
        );
      }),
      onTap: onTap,
    );
  }
}
