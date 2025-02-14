import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'widgets/komik_bottom_navbar.dart';
import 'widgets/komik_floating_button.dart';
import 'screen/komik_home.dart';
import 'screen/komik_news.dart';
import 'screen/komik_popular.dart';
import 'screen/komik_ranking.dart';
import 'screen/komik_filter.dart';
import 'screen/komik_search.dart';

class MainKomik extends StatefulWidget {
  const MainKomik({super.key});

  @override
  State<MainKomik> createState() => _MainKomikState();
}

class _MainKomikState extends State<MainKomik> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const KomikHomeScreen(),
    const KomikNewsScreen(),
    const KomikPopularScreen(),
    const KomikRankingScreen(),
    const KomikFilterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
		automaticallyImplyLeading: false,
        backgroundColor: themeProvider.isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
		foregroundColor: Colors.white,
        title: const Text("FuckMik"),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: themeProvider.toggleTheme,
          ),
          IconButton(
			icon: const Icon(Icons.search),
			onPressed: () {
			  Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => KomikSearchScreen()),
			  );
			},
		  ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _pages[_selectedIndex],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: themeProvider.isDarkMode ? Colors.black.withOpacity(0.0) : Colors.white.withOpacity(0.0),
              child: KomikBottomNavbar(
                selectedIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                isDarkMode: themeProvider.isDarkMode,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: KomikFloatingButton(
        isDarkMode: themeProvider.isDarkMode,
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
