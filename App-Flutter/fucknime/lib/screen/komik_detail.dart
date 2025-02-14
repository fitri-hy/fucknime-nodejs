import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../config.dart';
import 'komik_chapter.dart';

class KomikDetailScreen extends StatefulWidget {
  final String slug;

  const KomikDetailScreen({super.key, required this.slug});

  @override
  _KomikDetailScreenState createState() => _KomikDetailScreenState();
}

class _KomikDetailScreenState extends State<KomikDetailScreen> {
  Map<String, dynamic>? komikDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKomikDetail();
  }

  Future<void> fetchKomikDetail() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/komik/detail/${widget.slug}'),
        headers: {
          'x-api-key': ApiConfig.apiKey,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          komikDetail = jsonResponse['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
        foregroundColor: Colors.white,
        title: Text(komikDetail?['title'] ?? 'Detail Komik'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : komikDetail != null
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Image.network(
                              komikDetail!['image'] ?? '',
                              width: 200,
                              height: 300,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/placeholder.png',
                                  width: 200,
                                  height: 300,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        Text(
                          komikDetail!['title'] ?? 'Tidak ada judul',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          komikDetail!['description'] ?? 'Deskripsi tidak tersedia',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Table(
                          border: TableBorder.all(color: Colors.grey, width: 0.5),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            _buildTableRow('Status', komikDetail!['status']),
                            _buildTableRow('Tanggal Rilis', komikDetail!['releaseDate']),
                            _buildTableRow('Jenis', komikDetail!['type']),
                            _buildTableRow('Author', komikDetail!['author']),
                            _buildTableRow('Genre', komikDetail!['genres']?.join(', ')),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Text(
                          'Daftar Chapter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        komikDetail!['chapters'] != null
                            ? Column(
                                children: (komikDetail!['chapters'] as List).map((chapter) => 
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        chapter['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      leading: const Icon(Icons.menu_book, color: Colors.white),
                                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => KomikChapterScreen(
                                              chapterSlug: chapter['slug'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ).toList(),
                              )
                            : const Text('Tidak ada chapter tersedia'),
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                      'Gagal memuat data',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value ?? '-'),
        ),
      ],
    );
  }
}