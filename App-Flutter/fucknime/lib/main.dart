import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'widgets/anime_bottom_navbar.dart';
import 'widgets/anime_floating_button.dart';
import 'screen/anime_home.dart';
import 'screen/anime_news.dart';
import 'screen/anime_popular.dart';
import 'screen/anime_ranking.dart';
import 'screen/anime_filter.dart';
import 'screen/anime_search.dart';
import 'main_komik.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AnimeHomeScreen(),
    const AnimeNewsScreen(),
    const AnimePopularScreen(),
    const AnimeRankingScreen(),
    const AnimeFilterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
        foregroundColor: Colors.white,
        title: const Text("FuckNime"),
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
				MaterialPageRoute(builder: (context) => AnimeSearchScreen()),
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
              child: AnimeBottomNavbar(
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
      floatingActionButton: AnimeFloatingButton(
        isDarkMode: themeProvider.isDarkMode,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainKomik()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
