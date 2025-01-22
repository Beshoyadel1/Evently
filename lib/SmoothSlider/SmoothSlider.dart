import 'package:evently/SmoothSlider/thiredPageSlider.dart';
import 'package:evently/SmoothSlider/firstPageSlider.dart';
import 'package:evently/SmoothSlider/secondPageSlider.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Main Slider Class
class SmoothSlider extends StatefulWidget {
  static const String RouteName = 'SmoothSlider';

  @override
  State<SmoothSlider> createState() => _SmoothSliderState();
}

class _SmoothSliderState extends State<SmoothSlider> {
  final PageController _pageController = PageController();
  double _buttonPosition = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _buttonPosition = _pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of page widgets
    final List<Widget> pages = [
      firstPageSlider(),
      secondPageSlider(),
      thiredPageSlider(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // PageView to display images
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return pages[index];
            },
          ),

          // SmoothPageIndicator at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    border: Border.all(
                      color: AppColors.primarycolor, // Border color
                      width: 2, // Border width
                    ),
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_pageController.page! > 0) {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: Icon(Icons.arrow_back, color: AppColors.primarycolor),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: pages.length,
                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    spacing: 16,
                    dotColor: AppColors.blackcolor,
                    activeDotColor: AppColors.primarycolor,
                  ),
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    border: Border.all(
                      color: AppColors.primarycolor, // Border color
                      width: 2, // Border width
                    ),
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_pageController.page! < pages.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: Icon(Icons.arrow_forward, color: AppColors.primarycolor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}