import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../config.dart';

class KomikChapterScreen extends StatefulWidget {
  final String chapterSlug;

  const KomikChapterScreen({super.key, required this.chapterSlug});

  @override
  _KomikChapterScreenState createState() => _KomikChapterScreenState();
}

class _KomikChapterScreenState extends State<KomikChapterScreen> {
  late Future<Map<String, dynamic>> _chapterData;

  @override
  void initState() {
    super.initState();
    _chapterData = fetchChapterData();
  }

  Future<Map<String, dynamic>> fetchChapterData() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/komik/chapter/${widget.chapterSlug}'),
      headers: {
        'x-api-key': ApiConfig.apiKey,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chapter data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return FutureBuilder<Map<String, dynamic>>(
      future: _chapterData,
      builder: (context, snapshot) {
        String title = 'Memuat...';

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          title = snapshot.data!['title'] ?? 'Tanpa Judul';
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
            foregroundColor: Colors.white,
            title: Text(title, overflow: TextOverflow.ellipsis),
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : snapshot.hasError
                  ? Center(child: Text('Error: ${snapshot.error}'))
                  : snapshot.hasData && snapshot.data!['data'] != null
                      ? SingleChildScrollView(
                          child: Column(
                            children: (snapshot.data!['data'] as List).map((imageData) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  imageData['img'],
                                  fit: BoxFit.contain,
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : const Center(child: Text('Tidak ada gambar tersedia')),
        );
      },
    );
  }
}
