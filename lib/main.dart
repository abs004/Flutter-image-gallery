import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  List images = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {

    final response = await http.get(
      Uri.parse('https://picsum.photos/v2/list'),
    );

    if (response.statusCode == 200) {

      setState(() {

        images = json.decode(response.body);

        isLoading = false;
      });

    } else {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Image Gallery"),
        centerTitle: true,
      ),

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : RefreshIndicator(

              onRefresh: fetchImages,

              child: Padding(

                padding: const EdgeInsets.all(10),

                child: GridView.builder(

                  itemCount: images.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,

                    crossAxisSpacing: 10,

                    mainAxisSpacing: 10,

                    childAspectRatio: 0.75,
                  ),

                  itemBuilder: (context, index) {

                    final image = images[index];

                    return GestureDetector(

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) => FullScreenImage(

                              images: images,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },

                      child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                            )
                          ],
                        ),

                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Expanded(

                              child: ClipRRect(

                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),

                                child: Image.network(

                                  image['download_url'],

                                  width: double.infinity,

                                  fit: BoxFit.cover,

                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {

                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },

                                  errorBuilder:
                                      (context, error, stackTrace) {

                                    return const Center(
                                      child: Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                            ),

                            Padding(

                              padding: const EdgeInsets.all(8.0),

                              child: Text(

                                image['author'],

                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}

class FullScreenImage extends StatefulWidget {

  final List images;
  final int initialIndex;

  const FullScreenImage({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void nextImage() {

    if (currentIndex < widget.images.length - 1) {

      setState(() {
        currentIndex++;
      });
    }
  }

  void previousImage() {

    if (currentIndex > 0) {

      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final image = widget.images[currentIndex];

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        foregroundColor: Colors.white,

        title: Text(image['author']),
      ),

      body: Stack(

        children: [

          Center(

            child: InteractiveViewer(

              child: Image.network(
                image['download_url'],
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(

            left: 10,
            top: 0,
            bottom: 0,

            child: Center(

              child: IconButton(

                onPressed: previousImage,

                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),

          Positioned(

            right: 10,
            top: 0,
            bottom: 0,

            child: Center(

              child: IconButton(

                onPressed: nextImage,

                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}