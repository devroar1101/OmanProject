import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tenderboard/common/themes/app_theme.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              // Carousel Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.6,
                  ),
                  items: [
                    'assets/image1.jpg',
                    'assets/image2.jpg',
                    'assets/image3.jpg',
                  ].map((imagePath) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
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
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Text(
                                  'التنقل بين الصفحات تسجيل الدخول إلى حسابك',
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
                  }).toList(),
                ),
              ),
              // Colorful Cards Section
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildColorfulCard('Inbox', '5'),
                      _buildColorfulCard('Outbox', '3'),
                      _buildColorfulCard('CC', '10'),
                      _buildColorfulCard('Circular', '2'),
                      _buildColorfulCard('Decision', '8'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        // Sidebar Notifications Section
        SizedBox(
          width: 250,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 226, 226),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'Notifications',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStyledListTile(
                  title: "Tb-20241101121 received",
                  icon: Icons.notifications_active,
                ),
                _buildStyledListTile(
                  title: "Tb-20241101122 received",
                  icon: Icons.notifications,
                ),
                _buildStyledListTile(
                  title: "Circular - 202",
                  icon: Icons.article_outlined,
                ),
                _buildStyledListTile(
                  title: "Tb-20241101122 closed",
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorfulCard(String title, String value) {
    return GestureDetector(
      onTap: () {
        // Handle card tap
      },
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.only(top: 10, left: 15),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 10, 31, 61),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0),
            bottomRight: Radius.circular(32.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              bottomRight: Radius.circular(32.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              // Value
              Text(
                value,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledListTile({required String title, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blueAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.remove_red_eye,
          color: Colors.grey[700],
        ),
        onTap: () {
          // Handle tap action
        },
      ),
    );
  }
}
