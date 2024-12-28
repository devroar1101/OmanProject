import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add the styled image carousel at the top
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 250, // Height of the carousel
              autoPlay: true, // Enable auto-scrolling
              enlargeCenterPage: true, // Highlight the center image
              aspectRatio: 16 / 9, // Aspect ratio of the carousel
              viewportFraction: 0.6, // Show part of the adjacent images
            ),
            items: [
              'assets/image1.jpg',
              'assets/image2.jpg',
              'assets/image3.jpg',
            ].map((imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors
                                    .black54, // Semi-transparent background
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Text(
                                'التنقل بين الصفحاتتسجيل الدخول إلى حسابك',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter, // Position cards to top-center
                child: Container(
                  margin: const EdgeInsets.all(
                      16.0), // Margin to give space around the cards
                  child: Wrap(
                    spacing: 10, // Horizontal space between cards
                    runSpacing: 10, // Vertical space between cards
                    children: [
                      _buildColorfulCard(getTranslation('Inbox'), '5'),
                      _buildColorfulCard(getTranslation('Outbox'), '3'),
                      _buildColorfulCard(getTranslation('CC'), '10'),
                      _buildColorfulCard(getTranslation('Circular'), '2'),
                      _buildColorfulCard(getTranslation('Decision'), '8'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorfulCard(String title, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: 150, // Smaller width for compact cards
        height: 150, // Smaller height
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 197, 199, 197), // Pastel green background for all cards
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87, // Dark text for contrast
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.blueAccent, // Pastel blue for the value
                  fontSize: 24, // Increased number font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
