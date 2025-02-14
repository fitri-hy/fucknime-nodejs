import 'package:flutter/material.dart';

class KomikHomeScreen extends StatelessWidget {
  const KomikHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Text('🏠 Home Komik', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
