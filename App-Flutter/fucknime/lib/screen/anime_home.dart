import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../theme_provider.dart';
import '../config.dart';
import 'anime_detail.dart';

class AnimeHomeScreen extends StatefulWidget {
  const AnimeHomeScreen({super.key});

  @override
  _AnimeHomeScreenState createState() => _AnimeHomeScreenState();
}

class _AnimeHomeScreenState extends State<AnimeHomeScreen> {
  List<dynamic> animeList = [];
  List<dynamic> terbaruList = [];
  List<dynamic> populerList = [];
  List<dynamic> ratingList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnimeList();
  }

  Future<void> fetchAnimeList() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/list?order=default'),
        headers: {'x-api-key': ApiConfig.apiKey},
      );
      final terbaruResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/list?order=update'),
        headers: {'x-api-key': ApiConfig.apiKey},
      );
      final populerResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/list?order=populer'),
        headers: {'x-api-key': ApiConfig.apiKey},
      );
      final ratingResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/list?order=rating'),
        headers: {'x-api-key': ApiConfig.apiKey},
      );

      if (response.statusCode == 200 &&
          terbaruResponse.statusCode == 200 &&
          populerResponse.statusCode == 200 &&
          ratingResponse.statusCode == 200) {
        setState(() {
          animeList = json.decode(response.body)['data'];
          terbaruList = (json.decode(terbaruResponse.body)['data'] as List).take(4).toList();
          populerList = (json.decode(populerResponse.body)['data'] as List).take(4).toList();
          ratingList = (json.decode(ratingResponse.body)['data'] as List).take(4).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 70),
                child: Column(
                  children: [
                    SizedBox(
					  child: CarouselSlider.builder(
						options: CarouselOptions(
						  viewportFraction: 0.3,
						  autoPlay: true,
						  enlargeCenterPage: true,
						),
						itemCount: animeList.length,
						itemBuilder: (context, index, realIndex) {
						  return AspectRatio(
							aspectRatio: 9 / 16,
							child: _buildAnimeImage(animeList[index]),
						  );
						},
					  ),
					),
                    const SizedBox(height: 25),
                    _buildGridSection('Terbaru', terbaruList, isDarkMode),
                    const SizedBox(height: 25),
                    _buildGridSection('Populer', populerList, isDarkMode),
                    const SizedBox(height: 25),
                    _buildGridSection('Peringkat', ratingList, isDarkMode),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGridSection(String title, List<dynamic> list, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
		  width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 120 / 180,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _buildAnimeImage(list[index]);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAnimeImage(dynamic anime) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeDetailScreen(slug: anime['slug']),
          ),
        );
      },
      child: SizedBox(
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
            if (anime['episodes'] != null)
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
                    '${anime['episodes']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (anime['type'] != null)
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
                    anime['type'],
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
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
                child: Text(
                  anime['title'] ?? '',
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
      ),
    );
  }
}
