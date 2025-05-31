import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/images.dart';

class PlaceSelectionScreen extends StatelessWidget {
  const PlaceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Craving Something? Select Your Place',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              SizedBox(height: 20),
              RestaurantCard(
                gradientColors: [Color(0xFFB62424), Color(0xFFDD5E5E)],
                logoPath: Images.shanghaiLogo,
                title:
                    'Discover Pan-Asian cuisine with authentic taste and flavours',
                restaurantTagline: 'FLAVORS OF CHINA',
                foodImagePath: Images.shanghaiBanner,
                onTap: () {
                  Get.toNamed(
                      RouteHelper.getInitialRoute(restaurant: 'shanghai'));
                },
              ),
              SizedBox(height: 16),
              RestaurantCard(
                gradientColors: [Color(0xFF0F4613), Color(0xFF1F6A29)],
                logoPath: Images.saltanatLogo,
                title:
                    'Get immersed in the aroma of Biryani and North Indian delicacies',
                restaurantTagline: '',
                foodImagePath: Images.saltanatBanner,
                onTap: () {
                  Get.toNamed(
                      RouteHelper.getInitialRoute(restaurant: 'saltanat'));
                },
              ),
              SizedBox(height: 16),
              RestaurantCard(
                gradientColors: [Color(0xFF5C3A1D), Color(0xFF8B5E3C)],
                logoPath: Images.palatePleasersLogo,
                title:
                    'Finest catering service to make your special day more memorable',
                restaurantTagline: '',
                foodImagePath: Images.palatePleasersBanner,
                onTap: () {
                  Get.toNamed(RouteHelper.getPlaceServiceRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final List<Color> gradientColors;
  final String logoPath;
  final String title;
  final String restaurantTagline;
  final String foodImagePath;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.gradientColors,
    required this.logoPath,
    required this.title,
    required this.restaurantTagline,
    required this.foodImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Full cover image (positioned at the bottom of the stack)
            Positioned.fill(
              child: Image.asset(
                foodImagePath,
                fit: BoxFit.cover,
              ),
            ),

            // Gradient overlay
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: MediaQuery.of(context).size.width *
                  0.7, // Half of the card width
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradientColors[0].withOpacity(0.85),
                      gradientColors[1].withOpacity(0.1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment
                        .centerRight, // Gradient flows from left to right
                  ),
                ),
              ),
            ),

            // Content layout with proper spacing
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section with logo
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      logoPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bottom section with title and call to action
                  SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title text
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Color.fromARGB(120, 0, 0, 0),
                              ),
                            ],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 50),

                        // Call to action row
                        const Row(
                          children: [
                            Text(
                              'Explore Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Color.fromARGB(120, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
