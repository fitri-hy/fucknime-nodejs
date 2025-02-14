import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../config.dart';

class AnimeEpisodeScreen extends StatefulWidget {
  final String episodeSlug;

  const AnimeEpisodeScreen({super.key, required this.episodeSlug});

  @override
  _AnimeEpisodeScreenState createState() => _AnimeEpisodeScreenState();
}

class _AnimeEpisodeScreenState extends State<AnimeEpisodeScreen> {
  Map<String, dynamic>? animeEpisode;
  bool isLoading = true;
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    fetchEpisode();
  }

  Future<void> fetchEpisode() async {
    final String apiUrl = '${ApiConfig.baseUrl}/episode/${widget.episodeSlug}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'x-api-key': ApiConfig.apiKey,
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception("Request timeout");
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            animeEpisode = data['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            animeEpisode = null;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          animeEpisode = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching episode: $e");
      setState(() {
        animeEpisode = null;
        isLoading = false;
      });
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
        title: Text(animeEpisode?['title'] ?? 'Memuat...'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : animeEpisode == null
              ? const Center(child: Text('Gagal memuat episode, video mungkin rusak.'))
              : Column(
                  children: [
                    if (animeEpisode!['videoEmbedUrl'] != null)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.black,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: WebUri(animeEpisode!['videoEmbedUrl']),
                          ),
                          onWebViewCreated: (controller) {
                            _webViewController = controller;
                          },
                          onLoadStop: (controller, url) {
                            controller.evaluateJavascript(source: """
                              var style = document.createElement('style');
                              style.innerHTML = `
                                video::-webkit-media-controls {
                                  display: flex;
                                  flex-wrap: wrap !important;
                                }
                                video::-webkit-media-controls-panel {
                                  display: flex;
                                  flex-wrap: wrap !important;
                                }
                              `;
                              document.head.appendChild(style);
                            """);
                          },
                        ),
                      ),
                    ),
					Expanded(
					  child: ListView(
						padding: const EdgeInsets.all(10),
						children: [
						  if (animeEpisode!['prevEpisode'] != null || animeEpisode!['nextEpisode'] != null)
							Column(
							  mainAxisAlignment: MainAxisAlignment.center,
							  crossAxisAlignment: CrossAxisAlignment.center,
							  children: [
								Row(
								  mainAxisSize: MainAxisSize.min,
								  mainAxisAlignment: MainAxisAlignment.center,
								  children: [
									if (animeEpisode!['prevEpisode'] != null)
									  Padding(
										padding: const EdgeInsets.symmetric(horizontal: 5),
										child: Container(
										  decoration: BoxDecoration(
											color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
											borderRadius: BorderRadius.circular(3),
										  ),
										  child: ElevatedButton(
											style: ElevatedButton.styleFrom(
											  backgroundColor: Colors.transparent,
											  shadowColor: Colors.transparent,
											  shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(3),
											  ),
											  foregroundColor: Colors.white,
											),
											onPressed: () {
											  Navigator.pushReplacement(
												context,
												MaterialPageRoute(
												  builder: (context) => AnimeEpisodeScreen(
													episodeSlug: animeEpisode!['prevEpisode'],
												  ),
												),
											  );
											},
											child: Row(
											  mainAxisSize: MainAxisSize.min,
											  children: const [
												Icon(Icons.arrow_back, color: Colors.white),
												SizedBox(width: 5),
												Text(
												  'Sebelumnya',
												  style: TextStyle(fontSize: 14, color: Colors.white),
												),
											  ],
											),
										  ),
										),
									  ),

									if (animeEpisode!['nextEpisode'] != null)
									  Padding(
										padding: const EdgeInsets.symmetric(horizontal: 5),
										child: Container(
										  decoration: BoxDecoration(
											color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
											borderRadius: BorderRadius.circular(3),
										  ),
										  child: ElevatedButton(
											style: ElevatedButton.styleFrom(
											  backgroundColor: Colors.transparent,
											  shadowColor: Colors.transparent,
											  shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(3),
											  ),
											  foregroundColor: Colors.white,
											),
											onPressed: () {
											  Navigator.pushReplacement(
												context,
												MaterialPageRoute(
												  builder: (context) => AnimeEpisodeScreen(
													episodeSlug: animeEpisode!['nextEpisode'],
												  ),
												),
											  );
											},
											child: Row(
											  mainAxisSize: MainAxisSize.min,
											  children: const [
												Text(
												  'Selanjutnya',
												  style: TextStyle(fontSize: 14, color: Colors.white),
												),
												SizedBox(width: 5),
												Icon(Icons.arrow_forward, color: Colors.white),
											  ],
											),
										  ),
										),
									  ),

								  ],
								),
							  ],
							),

						  const Divider(),
                          const SizedBox(height: 25),
						  
						  Text(
                            'Daftar Episode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
						if (animeEpisode!['episodesList'] != null)
						  Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: animeEpisode!['episodesList']
							  .map<Widget>(
								(ep) => Container(
								  margin: const EdgeInsets.symmetric(vertical: 4),
								  decoration: BoxDecoration(
									color: isDarkMode ? const Color(0xff183a5c) : const Color(0xff7dbcfa),
									borderRadius: BorderRadius.circular(3),
								  ),
								  child: ListTile(
									title: Text(
									  ep['title'],
									  style: const TextStyle(
										color: Colors.white,
										fontWeight: FontWeight.bold,
									  ),
									),
									leading: const Icon(Icons.play_circle_outline, color: Colors.white),
									trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
									onTap: () {
									  Navigator.push(
										context,
										MaterialPageRoute(
										  builder: (context) => AnimeEpisodeScreen(
											episodeSlug: ep['slug'],
										  ),
										),
									  );
									},
								  ),
								),
							  )
							  .toList(),
						  ),
						],
					  ),
					),


                  ],
                ),
    );
  }

  Widget episodeButton(String title, String slug, BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      leading: const Icon(Icons.play_circle_outline, color: Colors.blue),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeEpisodeScreen(episodeSlug: slug),
          ),
        );
      },
    );
  }
}
