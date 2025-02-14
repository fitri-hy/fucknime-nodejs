import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../config.dart';
import 'anime_detail.dart';

class AnimeFilterScreen extends StatefulWidget {
  const AnimeFilterScreen({super.key});

  @override
  _AnimeFilterScreenState createState() => _AnimeFilterScreenState();
}

class _AnimeFilterScreenState extends State<AnimeFilterScreen> {
  int currentPage = 1;
  String? selectedOrder;
  String? selectedType;
  String? selectedStatus;
  String? selectedGenre;

  List<dynamic> orders = [];
  List<dynamic> types = [];
  List<dynamic> statuses = [];
  List<dynamic> genres = [];

  @override
  void initState() {
    super.initState();
    fetchFilters();
  }

  Future<void> fetchFilters() async {
    orders = await fetchFilterData('${ApiConfig.baseUrl}/filter/order');
    types = await fetchFilterData('${ApiConfig.baseUrl}/filter/type');
    statuses = await fetchFilterData('${ApiConfig.baseUrl}/filter/status');
    genres = await fetchFilterData('${ApiConfig.baseUrl}/filter/genre');
    setState(() {});
  }

  Future<List<dynamic>> fetchFilterData(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-api-key': ApiConfig.apiKey,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }
    return [];
  }

  Future<List<dynamic>> fetchAnimeList() async {
    final url =
        '${ApiConfig.baseUrl}/filter/advance?order=${selectedOrder ?? 'default'}&genre=${selectedGenre ?? 'aksi'}&status=${selectedStatus ?? ''}&type=${selectedType ?? ''}&page=$currentPage';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-api-key': ApiConfig.apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load anime list');
    }
  }

  void applyFilter() {
    setState(() {
      currentPage = 1;
    });
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
				  children: [
					Expanded(
					  child: DropdownButtonFormField<String>(
						value: selectedOrder,
						hint: const Text('Urutkan'),
						decoration: InputDecoration(
						  filled: true,
						  fillColor: isDarkMode ? Colors.white10 : Colors.white,
						  border: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							),
						  ),
						  enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							),
						  ),
						  focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							  width: 2,
							),
						  ),
						),
						items: orders.map((item) {
						  return DropdownMenuItem<String>(
							value: item['slug'],
							child: Text(item['title']),
						  );
						}).toList(),
						onChanged: (value) => setState(() => selectedOrder = value),
					  ),
					),
					const SizedBox(width: 10),
					Expanded(
					  child: DropdownButtonFormField<String>(
						value: selectedType,
						hint: const Text('Tipe'),
						decoration: InputDecoration(
						  filled: true,
						  fillColor: isDarkMode ? Colors.white10 : Colors.white,
						  border: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							),
						  ),
						  enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							),
						  ),
						  focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							  width: 2,
							),
						  ),
						),
						items: types.map((item) {
						  return DropdownMenuItem<String>(
							value: item['slug'],
							child: Text(item['title']),
						  );
						}).toList(),
						onChanged: (value) => setState(() => selectedType = value),
					  ),
					),
				  ],
				),
				const SizedBox(height: 10),
				Row(
				  children: [
					Expanded(
					  child: DropdownButtonFormField<String>(
						value: selectedStatus,
						hint: const Text('Status'),
						decoration: InputDecoration(
						  filled: true,
						  fillColor: isDarkMode ? Colors.white10 : Colors.white,
						  border: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							),
						  ),
						  enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							),
						  ),
						  focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							  width: 2,
							),
						  ),
						),
						items: statuses.map((item) {
						  return DropdownMenuItem<String>(
							value: item['slug'],
							child: Text(item['title']),
						  );
						}).toList(),
						onChanged: (value) => setState(() => selectedStatus = value),
					  ),
					),
					const SizedBox(width: 10),
					Expanded(
					  child: DropdownButtonFormField<String>(
						value: selectedGenre,
						hint: const Text('Genre'),
						decoration: InputDecoration(
						  filled: true,
						  fillColor: isDarkMode ? Colors.white10 : Colors.white,
						  border: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							),
						  ),
						  enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							),
						  ),
						  focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(10),
							borderSide: BorderSide(
							  color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
							  width: 2,
							),
						  ),
						),
						items: genres.map((item) {
						  return DropdownMenuItem<String>(
							value: item['slug'],
							child: Text(item['title']),
						  );
						}).toList(),
						onChanged: (value) => setState(() => selectedGenre = value),
					  ),
					),
				  ],
				),
				  /*
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: applyFilter,
                    child: const Text('Apply Filter'),
                  ),
				  */
                ],
              ),
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: fetchAnimeList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
			    return SliverToBoxAdapter(
				  child: Padding(
				    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.4),
				    child: Center(
					  child: Text('Anime tidak ditemukan'),
				    ),
				  ),
			    );
			  }

              final animeList = snapshot.data!;

              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final anime = animeList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimeDetailScreen(slug: anime['slug']),
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
									anime['image'] ?? '',
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
                                  anime['episodes'],
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
                                  anime['status'],
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
                                  anime['title'],
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
                    childCount: animeList.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
		    child: Padding(
			  padding: const EdgeInsets.only(top: 5, bottom: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 1 ? () => changePage(currentPage - 1) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? const Color(0xff28629c) : const Color(0xff5bacfc),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
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
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
