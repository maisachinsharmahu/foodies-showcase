// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
// import 'package:flutter/material.dart';
// // import 'package:foodie/Pages/HomePage/index.dart';
// import 'package:foodie/Pages/Onboarding/helper/onbard_items.dart';
// import 'package:foodie/Pages/Index/index.dart';
// // import 'package:foodie/Pages/home/temp.dart';
// import 'package:foodie/helper/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class Onboard extends StatefulWidget {
//   const Onboard({super.key});

//   @override
//   State<Onboard> createState() => _OnboardState();
// }

// class _OnboardState extends State<Onboard> {
//   final controller = OnboardItem();
//   final pageController = PageController();

//   bool isLastPage = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomSheet: Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//         child: isLastPage
//             ? getStarted()
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   //Skip Button
//                   TextButton(
//                       onPressed: () => pageController
//                           .jumpToPage(controller.items.length - 1),
//                       child: const Text("Skip")),

//                   //Indicator
//                   SmoothPageIndicator(
//                     controller: pageController,
//                     count: controller.items.length,
//                     onDotClicked: (index) => pageController.animateToPage(index,
//                         duration: const Duration(milliseconds: 600),
//                         curve: Curves.easeIn),
//                     effect: const WormEffect(
//                       dotHeight: 12,
//                       dotWidth: 12,
//                       activeDotColor: Colors.purple,
//                     ),
//                   ),

//                   //Next Button
//                   TextButton(
//                       onPressed: () => pageController.nextPage(
//                           duration: const Duration(milliseconds: 600),
//                           curve: Curves.easeIn),
//                       child: const Text("Next")),
//                 ],
//               ),
//       ),
//       body: SafeArea(
//         child: Container(
//           // padding: EdgeInsets.all(16.w),
//           child: PageView.builder(
//               onPageChanged: (index) => setState(
//                   () => isLastPage = controller.items.length - 1 == index),
//               itemCount: controller.items.length,
//               controller: pageController,
//               itemBuilder: (context, index) {
//                 print('${Image.asset(controller.items[index].image)}');
//                 return Stack(
//                   // blurRadius: 20,
//                   //         offset: Offset(5, 15),
//                   children: [
//                     Image.asset('assets/images/bg.png'),
//                     // Positioned(
//                     //   right: 0.w,
//                     //   top: Screen.screenWidth(context) * 0.1,
//                     //   child: Image.asset(
//                     //     'assets/images/bg2.png',
//                     //     height: 100.h,
//                     //     // height: Screen.screenHeight(context) * 0.5,
//                     //     // width: Screen.screenWidth(context) * 1,
//                     //   ),
//                     // ),
//                     Positioned(
//                       left: 0.w,
//                       top: -10,
//                       child: Image.asset(
//                         'assets/images/left.png',
//                         height: 100.h,
//                         color: Color.fromRGBO(116, 213, 141, 1),
//                         // height: Screen.screenHeight(context) * 0.5,
//                         // width: Screen.screenWidth(context) * 1,
//                       ),
//                     ),
//                     Positioned(
//                       right: 0.w,
//                       top: -10,
//                       child: Image.asset(
//                         'assets/images/left2.png',
//                         height: 100.h,
//                         color: Color.fromRGBO(116, 213, 141, 1),
//                         // height: Screen.screenHeight(context) * 0.5,
//                         // width: Screen.screenWidth(context) * 1,
//                       ),
//                     ),
//                     // Positioned(
//                     //   bottom: 0.h,
//                     //   right: 0.w,

//                     //   // right: -0,
//                     //   // top: Screen.screenWidth(context) * 0.1,
//                     //   child: Image.asset(
//                     //     'assets/images/right.png',
//                     //     color: Color.fromRGBO(116, 213, 141, 1),
//                     //     height: 150.h,
//                     //     // height: Screen.screenHeight(context) * 0.5,
//                     //     // width: Screen.screenWidth(context) * 1,
//                     //   ),
//                     // ),
//                     Positioned(
//                       top: Screen.screenHeight(context) * 0.1,
//                       // left: -20,
//                       width: Screen.screenWidth(context),
//                       child: Column(
//                         children: [
//                           Image.asset(
//                             '${controller.items[index].image}',
//                             height: Screen.screenHeight(context) * 0.47,
//                             width: Screen.screenWidth(context) * 1,
//                           ),
//                           // DropShadowImage(
//                           //   image: Image.asset(
//                           //     '${controller.items[index].image}',
//                           //     height: Screen.screenHeight(context) * 0.5,
//                           //     width: Screen.screenWidth(context) * 1,
//                           //   ),
//                           //   // blurRadius: 20,
//                           //   // offset: Offset(5, -2),
//                           //   // blurRadius: 10,
//                           //   borderRadius: 0,
//                           //   // scale: 0,
//                           // ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       // left: -20,
//                       top: Screen.screenHeight(context) * 0.03,
//                       width: Screen.screenWidth(context),
//                       child: Image.asset(
//                         'assets/images/logo.png',
//                         color: FoodieColors.darkPrimary,
//                         height: Screen.screenHeight(context) * 0.08,
//                         width: Screen.screenWidth(context) * 1,
//                       ),
//                     ),
//                     Positioned(
//                       top: Screen.screenHeight(context) * 0.6,
//                       width: Screen.screenWidth(context),
//                       child: Column(
//                         children: [
//                           Text(
//                             '${controller.items[index].name}',
//                             style: TextStyle(fontSize: 30.sp),
//                           ),
//                           SizedBox(
//                             height: 20.h,
//                           ),
//                           Text('${controller.items[index].title}'),
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               }),
//         ),
//       ),
//     );
//   }

//   //Get started button

//   Widget getStarted() {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8.r), color: Colors.black),
//       width: MediaQuery.of(context).size.width * .9,
//       height: 55.h,
//       child: TextButton(
//           onPressed: () async {
//             final pres = await SharedPreferences.getInstance();
//             pres.setBool("onboarding", true);

//             //After we press get started button this onboarding value become true
//             // same key
//             if (!mounted) return;
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => RecipieIndex()));
//           },
//           child: const Text(
//             "Get started",
//             style: TextStyle(color: Colors.white),
//           )),
//     );
//   }
// }
