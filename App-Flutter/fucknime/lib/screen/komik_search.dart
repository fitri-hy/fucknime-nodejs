import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../config.dart';
import 'komik_detail.dart';

class KomikSearchScreen extends StatefulWidget {
  const KomikSearchScreen({super.key});

  @override
  _KomikSearchScreenState createState() => _KomikSearchScreenState();
}

class _KomikSearchScreenState extends State<KomikSearchScreen> {
  int currentPage = 1;
  String currentQuery = "";
  late Future<List<dynamic>> komikList;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    komikList = fetchKomikList();
  }

  Future<List<dynamic>> fetchKomikList() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/komik/search?q=$currentQuery&page=$currentPage'),
      headers: {
        'x-api-key': ApiConfig.apiKey,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load komik list');
    }
  }

  void searchKomik() {
    setState(() {
      currentQuery = searchController.text;
      currentPage = 1;
      komikList = fetchKomikList();
    });
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
      komikList = fetchKomikList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
        foregroundColor: Colors.white,
        title: const Text("Pencarian"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
				Expanded(
				  child: TextField(
					controller: searchController,
					decoration: InputDecoration(
					  hintText: "Cari komik...",
					  filled: true,
					  fillColor: isDarkMode ? Colors.white10 : Colors.white,
					  border: OutlineInputBorder(
						borderRadius: BorderRadius.circular(3),
						borderSide: BorderSide(
						  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
						),
					  ),
					  enabledBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(3),
						borderSide: BorderSide(
						  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
						),
					  ),
					  focusedBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(3),
						borderSide: BorderSide(
						  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
						  width: 2,
						),
					  ),
					  prefixIcon: const Icon(Icons.search),
					),
					onSubmitted: (_) => searchKomik(),
				  ),
				),
				const SizedBox(width: 10),
				ElevatedButton(
				  onPressed: searchKomik,
				  style: ElevatedButton.styleFrom(
					backgroundColor: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
					shape: RoundedRectangleBorder(
					  borderRadius: BorderRadius.circular(3),
					),
					minimumSize: const Size(50, 56),
					padding: const EdgeInsets.symmetric(horizontal: 16),
				  ),
				  child: const Icon(Icons.search, color: Colors.white, size: 25),
				),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: komikList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada komik ditemukan'));
                }

                final komikList = snapshot.data!;

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final komik = komikList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KomikDetailScreen(slug: komik['slug']),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: FractionallySizedBox(
                                        heightFactor: 1.0,
                                        child: Image.network(
                                          komik['image'] ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        komik['latestChapter'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        '${komik['genre'] ?? ''} • ${komik['type'] ?? ''}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(3),
                                          bottomRight: Radius.circular(3),
                                        ),
                                      ),
                                      child: Text(
                                        komik['title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: komikList.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 4,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: currentPage > 1 ? () => changePage(currentPage - 1) : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? const Color(0xff28629c) : const Color(0xff5bacfc),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.white),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              '$currentPage',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () => changePage(currentPage + 1),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? const Color(0xff28629c) : const Color(0xff5bacfc),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              child: const Icon(Icons.arrow_forward, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
