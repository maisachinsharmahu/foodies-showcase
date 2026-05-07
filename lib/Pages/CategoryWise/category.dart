// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:foodie/Pages/DetailsPage/sections/MainDetails.dart';
// import 'package:foodie/Source/helper.dart';
// import 'package:foodie/helper/colors.dart';

// class categorywise extends StatefulWidget {
  
//   final List<dynamic> recipes;
//   const categorywise({super.key, required this.recipes});

//   @override
//   State<categorywise> createState() => _categorywiseState();
// }

// class _categorywiseState extends State<categorywise> {
//   List<Widget> shuffleItems(List<Widget> items) {
//     List<Widget> shuffledList = List.from(items);
//     shuffledList.shuffle();
//     return shuffledList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Categories"),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//               children: shuffleItems([
//             items(
//               recipes: filterRecipesByType(widget.recipes, 'Vegetarian'),
//               name: 'Vegetarian',
//             ),
//             items(
//               recipes: filterRecipesBymanyTypes(widget.recipes, [
//                 'chicken',
//                 'meat',
//               ]),
//               name: 'Non-Vegetarian',
//             ),
//             items(
//               recipes: filterRecipesByType(widget.recipes, 'Sea'),
//               name: 'Sea',
//             ),
//             items(
//               recipes: filterRecipesByType(widget.recipes, 'singapore'),
//               name: 'Singapore',
//             ),
//             items(
//               recipes: filterRecipesByType(widget.recipes, 'american'),
//               name: 'American',
//             ),
//           ])

//               // items(),

//               ),
//         ),
//       ),
//     );
//   }
// }

// class items extends StatefulWidget {
//   final List<dynamic> recipes;
//   final String name;
//   const items({super.key, required this.recipes, required this.name});

//   @override
//   State<items> createState() => _itemsState();
// }

// class _itemsState extends State<items> {
//   late List<dynamic> recommendedRecipes = [];

//   @override
//   void initState() {
//     super.initState();
//     _getRecommendedRecipes();
//     // print(widget.recipes);
//   }

//   void _getRecommendedRecipes() {
//     // Create a copy of the original recipes list
//     List<dynamic> tempRecipes = List.from(widget.recipes);
//     // Shuffle the list
//     tempRecipes.shuffle();
//     // Select the first three items
//     setState(() {
//       recommendedRecipes = tempRecipes
//           .take((widget.recipes.length < 20 ? widget.recipes.length : 20))
//           .toList();
//     });
//     // Now you can print recommendedRecipes
//     // print(recommendedRecipes.length);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16.0.w),
//           child: Row(
//             children: [
//               Text(
//                 widget.name,
//                 style: TextStyle(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'Poppins'),
//               ),
//               Spacer(),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 10.h,
//         ),
//         // Text("${recipes}"),
//         SizedBox(
//           height: 150.h,
//           width: Screen.screenWidth(context),
//           child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               // scrollDirection: Axis.horizontal,
//               itemCount: recommendedRecipes.length,
//               // physics: NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: index == 0
//                       ? EdgeInsets.only(right: 8.0.w, left: 10.w)
//                       : EdgeInsets.only(right: 8.0.w),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => mainDetails(
//                                 userData: widget.userData,
//                                     recipe: recommendedRecipes[index],
//                                   )));
//                     },
//                     child: Container(
//                       // margin: EdgeInsets.symmetric(horizontal: 1.0.w),
//                       height: 150.h,
//                       width: Screen.screenWidth(context) * 0.42,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30.r),
//                       ),
//                       child: Stack(
//                         children: [
//                           // CachedNetworkImage for the image
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(30.r),
//                             child: CachedNetworkImage(
//                               imageUrl: '${recommendedRecipes[index]['Image']}',
//                               height: 150.h,
//                               width: Screen.screenWidth(context) * 0.42,
//                               fit: BoxFit.cover,
//                               // placeholder: (context, url) => CircularProgressIndicator(),
//                               errorWidget: (context, url, error) =>
//                                   Icon(Icons.error),
//                             ),
//                           ),
//                           // Container for the gradient overlay
//                           Container(
//                             height: 150.h,
//                             width: Screen.screenWidth(context) * 0.42,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30.r),
//                               gradient: LinearGradient(
//                                 begin: Alignment.topRight,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Colors.transparent,
//                                   Colors.black.withOpacity(
//                                       0.7), // Adjust opacity as needed
//                                 ],
//                               ),
//                             ),
//                           ),

//                           Positioned(
//                             top: 85.h,
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0.w),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: Screen.screenWidth(context) * 0.3,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '${recommendedRecipes[index]['Name']}',
//                                           maxLines: 2,
//                                           style: TextStyle(
//                                               overflow: TextOverflow.ellipsis,
//                                               color: Colors
//                                                   .white, // Set text color as per your design
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.w500,
//                                               fontFamily:
//                                                   'Poppins' // Set font size as per your design
//                                               ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                               top: 10.h,
//                               left: 12.w,
//                               child: LimitedBox(
//                                 maxWidth: 70,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10.r),
//                                     color: FoodieColors.darkSecondary,
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 8.0.w, vertical: 3.h),
//                                     child: Text(
//                                       recommendedRecipes[index]['Total Time'],
//                                       maxLines: 1,
//                                       style: TextStyle(
//                                         overflow: TextOverflow.ellipsis,
//                                         fontSize: 12.sp,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                           Positioned(
//                               top: 10.h,
//                               right: 12.w,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50.r),
//                                   color: Colors.white,
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 2.0.w, vertical: 2.h),
//                                   child: Icon(
//                                     Icons.favorite_border_outlined,
//                                     size: 20.sp,
//                                   ),
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//         )
//       ],
//     );
//   }
// }
