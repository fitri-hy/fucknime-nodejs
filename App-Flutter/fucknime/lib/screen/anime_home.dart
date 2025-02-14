import 'package:flutter/material.dart';

class AnimeHomeScreen extends StatelessWidget {
  const AnimeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Text('🏠 Home Anime', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
