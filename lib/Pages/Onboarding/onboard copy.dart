// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
// // import 'package:foodie/Pages/HomePage/index.dart';
// import 'package:foodie/Pages/Onboarding/helper/onbard_items.dart';
// import 'package:foodie/Pages/Index/index.dart';

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
//       body: Container(
//         margin: EdgeInsets.symmetric(horizontal: 15.w),
//         child: PageView.builder(
//             onPageChanged: (index) => setState(
//                 () => isLastPage = controller.items.length - 1 == index),
//             itemCount: controller.items.length,
//             controller: pageController,
//             itemBuilder: (context, index) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(controller.items[index].image),
//                   const SizedBox(height: 15.h),
//                   Text(
//                     controller.items[index].title,
//                     style: TextStyle(
//                         fontSize: 30.sp, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15.h),
//                   Text(controller.items[index].title,
//                       style: TextStyle(color: Colors.grey, fontSize: 17.sp),
//                       textAlign: TextAlign.center),
//                 ],
//               );
//             }),
//       ),
//     );
//   }

//   //Now the problem is when press get started button
//   // after re run the app we see again the onboarding screen
//   // so lets do one time onboarding

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
