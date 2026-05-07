// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// // import 'package:foodie/Pages/HomePage/index.dart';
// import 'package:foodie/Pages/Index/index.dart';
// import 'package:foodie/Pages/login/Google_services/firebase_services.dart';
// import 'package:foodie/helper/colors.dart';

// class Start extends StatefulWidget {
//   const Start({super.key});

//   @override
//   State<Start> createState() => _StartState();
// }

// class _StartState extends State<Start> {
//   Map<String, dynamic> userData = {};

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//     print(userData);
//   }

//   Future<void> loadUserData() async {
//     // Get the current user
//     User? user = FirebaseServices.authInstance.currentUser;
//     if (user != null) {
//       // Fetch user data from Firestore
//       DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
//           await FirebaseServices.getUserData(user.uid);
//       setState(() {
//         userData = userDataSnapshot.data() ?? {}; // Extract user data
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(children: [
//           Positioned(
//             top: 0.h,
//             left: 0.w,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Image.asset(
//                   'assets/images/Blob/3.png',
//                   // height: Screen.screenHeight(context),
//                   width: Screen.screenWidth(context) -
//                       (Screen.screenWidth(context) * 0.2),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//                   child: Container(
//                     width: Screen.screenWidth(context) / 2,
//                     child: RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         children: [
//                           WidgetSpan(
//                               child: SizedBox(
//                             height: 40.h,
//                             child: Text(
//                               'Do You know ',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 32.sp,

//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           )),
//                           WidgetSpan(
//                             child: SizedBox(
//                               height: 40.h,
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                       bottom: 4.h,
//                                       left: -3,
//                                       child: Container(
//                                         height: 10.h,
//                                         // width: 10.w,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                           color: const Color.fromARGB(
//                                               255, 188, 233, 199),
//                                         ),
//                                         child: Text(
//                                           'You ',
//                                           style: TextStyle(
//                                             color: Colors.transparent,
//                                             fontSize: 32.sp,
//                                           ),
//                                         ),
//                                       )),
//                                   Positioned(
//                                     child: Text(
//                                       'You ',
//                                       textAlign: TextAlign.start,
//                                       softWrap: true,
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 32.sp,

//                                         // fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   )
//                                 ], // Adjust the width as needed
//                               ),
//                             ),
//                           ),
//                           WidgetSpan(
//                               child: SizedBox(
//                             height: 40.h,
//                             child: Text(
//                               " Can ",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 32.sp,

//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           )),
//                           WidgetSpan(
//                               child: SizedBox(
//                             height: 40.h,
//                             child: Text(
//                               "Cook too?",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 32.sp,

//                                 // fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           )),
//                         ],
//                       ),
//                     ),

//                     // Text(
//                     //   "You know you can Cook too?",
//                     //   style: TextStyle(
//                     //     fontSize: 28.sp,
//                     //     fontFamily: 'Poppins',
//                     //   ),
//                     // ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 30.h,
//             left: 15.w,
//             child: Column(
//               children: [
//                 Text(
//                   "Let's Cook",
//                   style: TextStyle(
//                     fontSize: 35.sp,
//                     fontFamily: 'Bree',
//                   ),
//                 ),
//                 Text(
//                   "Now",
//                   style: TextStyle(
//                     fontSize: 35.sp,
//                     fontFamily: 'Bree',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 60.h,
//             right: 0.w,
//             child: Image.asset(
//               'assets/images/start1.png',
//               height: 410.h,
//               width: 180.w,
//             ),
//           ),
//           Positioned(
//             bottom: -20,
//             left: -50,
//             child: Image.asset(
//               'assets/images/start2.png',
//               height: 300.h,
//               width: 300.w,
//             ),
//           ),
//           Positioned(
//             bottom: 50.h,
//             right: 0.w,
//             child: GestureDetector(
//               // onTap: () => FirebaseServices.signOut(),
//               onTap: () => Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => RecipieIndex())),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(50.r),
//                     bottomLeft: Radius.circular(50.r),
//                   ),
//                   color: FoodieColors.darkSecondary,
//                 ),
//                 height: 100.h,
//                 width: Screen.screenWidth(context) * 0.4,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Start ",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Poppins',
//                         fontSize: 30.sp,
//                       ),
//                     ),
//                     Icon(
//                       Icons.east,
//                       color: Colors.white,
//                       size: 28.sp,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
