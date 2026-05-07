import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/Onboarding/helper/onbard_items.dart';
// import 'package:foodie/Pages/home/temp.dart';
import 'package:foodie/Pages/login/login.dart';
import 'package:foodie/helper/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  final controller = OnboardItem();
  final pageController = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet: Container(
      //   color: Colors.white,
      //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      //   child: isLastPage
      //       ? getStarted()
      //       : Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             //Skip Button
      //             TextButton(
      //                 onPressed: () => pageController
      //                     .jumpToPage(controller.items.length - 1),
      //                 child: const Text("Skip")),

      //             //Indicator

      //             //Next Button
      //             TextButton(
      //                 onPressed: () => pageController.nextPage(
      //                     duration: const Duration(milliseconds: 600),
      //                     curve: Curves.easeIn),
      //                 child: const Text("Next")),
      //           ],
      //         ),
      // ),
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.all(16.w),
          child: PageView.builder(
              onPageChanged: (index) => setState(
                  () => isLastPage = controller.items.length - 1 == index),
              itemCount: controller.items.length,
              controller: pageController,
              itemBuilder: (context, index) {
                print('${Image.asset(controller.items[index].image)}');
                return Stack(
                  // blurRadius: 20,
                  //         offset: Offset(5, 15),
                  children: [
                    SizedBox(
                      height: 1.sh,
                      width: 1.sw,
                      child: Image.asset(
                        'assets/images/bg.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Positioned(
                      left: 0.w,
                      top: -10.h,
                      child: Image.asset(
                        'assets/images/left.png',
                        height: 100.h,
                        color: const Color.fromRGBO(116, 213, 141, 1),
                      ),
                    ),
                    Positioned(
                      right: 0.w,
                      top: -10.h,
                      child: Image.asset(
                        'assets/images/left2.png',
                        height: 100.h,
                        color: const Color.fromRGBO(116, 213, 141, 1),
                      ),
                    ),
                    Positioned(
                      top: 0.03.sh,
                      width: 1.sw,
                      child: Image.asset(
                        'assets/images/logo.png',
                        color: FoodieColors.darkPrimary,
                        height: 0.08.sh,
                        width: 1.sw,
                      ),
                    ),
                    Positioned(
                      top: 0.1.sh,
                      width: 1.sw,
                      child: Column(
                        children: [
                          Image.asset(
                            controller.items[index].image,
                            height: 0.4.sh,
                            width: 1.sw,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0.53.sh,
                      width: 1.sw,
                      child: Column(
                        children: [
                          SmoothPageIndicator(
                            controller: pageController,
                            count: controller.items.length,
                            onDotClicked: (index) =>
                                pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.bounceIn),
                            effect: ExpandingDotsEffect(
                              activeDotColor: FoodieColors.darkSecondary,
                              dotColor: const Color.fromARGB(255, 95, 200, 134),
                              dotHeight: 12.h,
                              dotWidth: 12.w,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            width: 1.sw,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                      child: SizedBox(
                                    height: 40.h,
                                    child: Text(
                                      controller.items[index].name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 35.sp,
                                        fontFamily: 'Bree',
                                      ),
                                    ),
                                  )),
                                  WidgetSpan(
                                    child: SizedBox(
                                      height: 40.h,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                              bottom: 1.h,
                                              left: -3.w,
                                              child: Container(
                                                height: 10.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10.r,
                                                  ),
                                                  color: const Color.fromARGB(
                                                      255, 188, 233, 199),
                                                ),
                                                child: Text(
                                                  '${controller.items[index].under} ',
                                                  style: TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 35.sp,
                                                  ),
                                                ),
                                              )),
                                          Positioned(
                                            child: Text(
                                              controller.items[index].under,
                                              textAlign: TextAlign.start,
                                              softWrap: true,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 35.sp,
                                                fontFamily: 'Bree',
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  WidgetSpan(
                                      child: SizedBox(
                                    height: 40.h,
                                    child: Text(
                                      controller.items[index].after,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 35.sp,
                                        fontFamily: 'Bree',
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              controller.items[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.grey.shade500),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    ),
                    isLastPage
                        ? getStarted()
                        : Positioned(
                            bottom: 30.h,
                            left: 0.w,
                            right: 0.w,
                            child: GestureDetector(
                              onTap: () => pageController.nextPage(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeIn),
                              child: Center(
                                child: Container(
                                    width: 0.075.sh,
                                    height: 0.075.sh,
                                    decoration: BoxDecoration(
                                        color: FoodieColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: Icon(
                                      Icons.east,
                                      color: Colors.white,
                                      size: 0.04.sh,
                                    )),
                              ),
                            ))
                  ],
                );
              }),
        ),
      ),
    );
  }

  //Get started button
  Widget getStarted() {
    return Positioned(
      bottom: 30.h,
      left: 0.w,
      right: 0.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // Add a SizedBox to provide constraints
            // width: MediaQuery.of(context).size.width *
            //     0.5, // Set the width to half of the screen width
            child: GestureDetector(
              onTap: () async {
                final pres = await SharedPreferences.getInstance();
                pres.setBool("onboarding", true);

                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: FoodieColors.primaryColor,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
                  child: Center(
                    child: Text(
                      "Let's Go Cooking",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontFamily: 'Bree',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
