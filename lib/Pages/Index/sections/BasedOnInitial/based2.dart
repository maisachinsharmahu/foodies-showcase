import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';

class basedOnInitialChoice2 extends StatefulWidget {
  final List<dynamic> recipes;
  const basedOnInitialChoice2({super.key, required this.recipes});

  @override
  State<basedOnInitialChoice2> createState() => _basedOnInitialChoice2State();
}

class _basedOnInitialChoice2State extends State<basedOnInitialChoice2> {
  late List<dynamic> recommendedRecipes = [];

  @override
  void initState() {
    super.initState();
    _getRecommendedRecipes();
    // print(widget.recipes);
  }

  void _getRecommendedRecipes() {
    // Create a copy of the original recipes list
    List<dynamic> tempRecipes = List.from(widget.recipes);
    // Shuffle the list
    tempRecipes.shuffle();
    // Select the first three items
    setState(() {
      recommendedRecipes = tempRecipes.take(20).toList();
    });
    // Now you can print recommendedRecipes
    // print(recommendedRecipes.length);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0.w),
                child: Text(
                  "Based",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _getRecommendedRecipes();
                  });
                },
                icon: Icon(Icons.refresh),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: ((1.sw + 54) * 5.2),
            // height: 1000.h,
            width: 1.sw,
            child: Column(
              children: List.generate((recommendedRecipes.length / 2).ceil(),
                  (rowIndex) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 0.0.h),
                  child: Row(
                    children: List.generate(2, (columnIndex) {
                      final index = rowIndex * 2 + columnIndex;
                      if (index >= recommendedRecipes.length) {
                        return SizedBox
                            .shrink(); // Empty SizedBox if there are no more items
                      }
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.0.w),
                              height: (1.sw - 14) / 2,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.r),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${recommendedRecipes[index]['Image']}',
                                      height:
                                          (1.sw - 14) /
                                              2,
                                      width:
                                          (1.sw - 14) /
                                              2,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  Container(
                                    height: 0.4.sh,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5.h,
                                    left: 5.w,
                                    child: Container(
                                      width:
                                          ((1.sw - 14) /
                                              2),
                                      padding: EdgeInsets.all(8.w),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:
                                                ((1.sw -
                                                            14) /
                                                        2) -
                                                    20,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Text(
                                                //   "Foodies by Sachin Sharma",
                                                //   style: TextStyle(
                                                //     color: Colors.grey.shade100,
                                                //     fontSize: 10.sp,
                                                //     fontFamily: 'Poppins',
                                                //   ),
                                                // ),
                                                Text(
                                                  '${recommendedRecipes[index]['Name']}',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Spacer(),
                                          // Padding(
                                          //   padding: EdgeInsets.all(8.0.w),
                                          //   child: Container(
                                          //     width: ((Screen.screenWidth(
                                          //                     context) -
                                          //                 14) /
                                          //             2) *
                                          //         0.2,
                                          //     child: Column(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment.start,
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.start,
                                          //       children: [
                                          //         CircleAvatar(
                                          //           radius: 17,
                                          //           backgroundColor:
                                          //               Colors.white,
                                          //           child: Icon(
                                          //             Icons
                                          //                 .favorite_border_outlined,
                                          //             size: 28.sp,
                                          //           ),
                                          //         )
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 3.h,
                                    right: 3.w,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0.w),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.favorite_border_outlined,
                                                size: 24.sp,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0.w, top: 5.h, bottom: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   '${recommendedRecipes[index]['Name']}',
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.w600,
                                  //       fontSize: 14.sp,
                                  //       fontFamily: 'Poppins',
                                  //       overflow: TextOverflow.ellipsis),
                                  //   maxLines: 1,
                                  // ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 16.sp,
                                        color: FoodieColors.darkSecondary,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '${recommendedRecipes[index]['Total Time']}',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontFamily: 'Poppins',
                                            color: FoodieColors.grey3),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}



//  SizedBox(
//             height: ((Screen.screenWidth(context) - 20)) * 5.075,
//             width: Screen.screenWidth(context),
//             child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   childAspectRatio: 1,
//                   crossAxisCount: 2, // number of columns
//                   crossAxisSpacing: 6.0, // spacing between columns
//                   mainAxisSpacing: 6.0, // spacing between rows
//                 ),

//                 // scrollDirection: Axis.horizontal,
//                 itemCount: recommendedRecipes.length,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return Container(
//                     // margin: EdgeInsets.symmetric(horizontal: 1.0.w),
//                     height: Screen.screenHeight(context) * 0.4,
//                     width: Screen.screenWidth(context) * 0.6,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                     child: Stack(
//                       children: [
//                         // CachedNetworkImage for the image
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(30.r),
//                           child: CachedNetworkImage(
//                             imageUrl: '${recommendedRecipes[index]['Image']}',
//                             height: Screen.screenHeight(context) * 0.4,
//                             width: Screen.screenWidth(context) * 0.6,
//                             fit: BoxFit.cover,
//                             // placeholder: (context, url) => CircularProgressIndicator(),
//                             errorWidget: (context, url, error) =>
//                                 Icon(Icons.error),
//                           ),
//                         ),
//                         // Container for the gradient overlay
//                         Container(
//                           height: Screen.screenHeight(context) * 0.4,
//                           width: Screen.screenWidth(context) * 0.6,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30.r),
//                             gradient: LinearGradient(
//                               begin: Alignment.topRight,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Colors.transparent,
//                                 Colors.black.withOpacity(
//                                     0.7), // Adjust opacity as needed
//                               ],
//                             ),
//                           ),
//                         ),

//                         // Positioned widget for the text "data"
//                         Positioned(
//                           bottom: -10,
//                           left: 20.w, // Adjust left position as needed
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: Screen.screenWidth(context) * 0.4,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Foodies by Sachin Sharma",
//                                       // maxLines: 1,
//                                       style: TextStyle(
//                                           // overflow: TextOverflow.ellipsis,
//                                           color: Colors.grey
//                                               .shade100, // Set text color as per your design
//                                           fontSize: 10.sp,
//                                           fontFamily:
//                                               'Poppins' // Set font size as per your design
//                                           ),
//                                     ),
//                                     Text(
//                                       '${recommendedRecipes[index]['Name']}',
//                                       maxLines: 2,
//                                       style: TextStyle(
//                                           overflow: TextOverflow.ellipsis,
//                                           color: Colors
//                                               .white, // Set text color as per your design
//                                           fontSize: 22.sp,
//                                           fontWeight: FontWeight.w500,
//                                           fontFamily:
//                                               'Poppins' // Set font size as per your design
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0.w),
//                                 child: Container(
//                                   width: Screen.screenWidth(context) * 0.2,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 17,
//                                         backgroundColor: Colors.white,
//                                         child: Icon(
//                                           Icons.favorite_border_outlined,
//                                           size: 28.sp,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//           )














// 2nd
// SizedBox(
//             height: ((Screen.screenWidth(context) + 54) * 5.2),
//             // height: 1000.h,
//             width: Screen.screenWidth(context),
//             child: Column(
//               children: List.generate((recommendedRecipes.length / 2).ceil(),
//                   (rowIndex) {
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: 0.0.h),
//                   child: Row(
//                     children: List.generate(2, (columnIndex) {
//                       final index = rowIndex * 2 + columnIndex;
//                       if (index >= recommendedRecipes.length) {
//                         return SizedBox
//                             .shrink(); // Empty SizedBox if there are no more items
//                       }
//                       return Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.symmetric(horizontal: 3.0.w),
//                               height: (Screen.screenWidth(context) - 14) / 2,
//                               child: Stack(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(30.r),
//                                     child: CachedNetworkImage(
//                                       imageUrl:
//                                           '${recommendedRecipes[index]['Image']}',
//                                       height:
//                                           (Screen.screenWidth(context) - 14) /
//                                               2,
//                                       width:
//                                           (Screen.screenWidth(context) - 14) /
//                                               2,
//                                       fit: BoxFit.cover,
//                                       errorWidget: (context, url, error) =>
//                                           Icon(Icons.error),
//                                     ),
//                                   ),
//                                   Container(
//                                     height: Screen.screenHeight(context) * 0.4,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30.r),
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topRight,
//                                         end: Alignment.bottomCenter,
//                                         colors: [
//                                           Colors.transparent,
//                                           Colors.black.withOpacity(0.7),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     bottom: 5.h,
//                                     left: 5.w,
//                                     child: Container(
//                                       width:
//                                           ((Screen.screenWidth(context) - 14) /
//                                               2),
//                                       padding: EdgeInsets.all(8.w),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width:
//                                                 ((Screen.screenWidth(context) -
//                                                             14) /
//                                                         2) -
//                                                     20,
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 // Text(
//                                                 //   "Foodies by Sachin Sharma",
//                                                 //   style: TextStyle(
//                                                 //     color: Colors.grey.shade100,
//                                                 //     fontSize: 10.sp,
//                                                 //     fontFamily: 'Poppins',
//                                                 //   ),
//                                                 // ),
//                                                 Text(
//                                                   '${recommendedRecipes[index]['Name']}',
//                                                   maxLines: 2,
//                                                   style: TextStyle(
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     color: Colors.white,
//                                                     fontSize: 14.sp,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontFamily: 'Poppins',
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           // Spacer(),
//                                           // Padding(
//                                           //   padding: EdgeInsets.all(8.0.w),
//                                           //   child: Container(
//                                           //     width: ((Screen.screenWidth(
//                                           //                     context) -
//                                           //                 14) /
//                                           //             2) *
//                                           //         0.2,
//                                           //     child: Column(
//                                           //       mainAxisAlignment:
//                                           //           MainAxisAlignment.start,
//                                           //       crossAxisAlignment:
//                                           //           CrossAxisAlignment.start,
//                                           //       children: [
//                                           //         CircleAvatar(
//                                           //           radius: 17,
//                                           //           backgroundColor:
//                                           //               Colors.white,
//                                           //           child: Icon(
//                                           //             Icons
//                                           //                 .favorite_border_outlined,
//                                           //             size: 28.sp,
//                                           //           ),
//                                           //         )
//                                           //       ],
//                                           //     ),
//                                           //   ),
//                                           // ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 3.h,
//                                     right: 3.w,
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0.w),
//                                       child: Container(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             CircleAvatar(
//                                               radius: 15,
//                                               backgroundColor: Colors.white,
//                                               child: Icon(
//                                                 Icons.favorite_border_outlined,
//                                                 size: 24.sp,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   left: 10.0.w, top: 5.h, bottom: 10.h),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Text(
//                                   //   '${recommendedRecipes[index]['Name']}',
//                                   //   style: TextStyle(
//                                   //       fontWeight: FontWeight.w600,
//                                   //       fontSize: 14.sp,
//                                   //       fontFamily: 'Poppins',
//                                   //       overflow: TextOverflow.ellipsis),
//                                   //   maxLines: 1,
//                                   // ),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.schedule,
//                                         size: 16.sp,
//                                         color: FoodieColors.darkSecondary,
//                                       ),
//                                       SizedBox(
//                                         width: 5.w,
//                                       ),
//                                       Text(
//                                         '${recommendedRecipes[index]['Total Time']}',
//                                         style: TextStyle(
//                                             fontSize: 13.sp,
//                                             fontFamily: 'Poppins',
//                                             color: FoodieColors.grey3),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                 );
//               }),
//             ),
//           )






//  SizedBox(
//             height: ((Screen.screenWidth(context) - 20)) * 5.075,
//             width: Screen.screenWidth(context),
//             child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   childAspectRatio: 1,
//                   crossAxisCount: 2, // number of columns
//                   crossAxisSpacing: 6.0, // spacing between columns
//                   mainAxisSpacing: 6.0, // spacing between rows
//                 ),

//                 // scrollDirection: Axis.horizontal,
//                 itemCount: recommendedRecipes.length,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return Container(
//                     // margin: EdgeInsets.symmetric(horizontal: 1.0.w),
//                     height: Screen.screenHeight(context) * 0.4,
//                     width: Screen.screenWidth(context) * 0.6,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                     child: Stack(
//                       children: [
//                         // CachedNetworkImage for the image
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(30.r),
//                           child: CachedNetworkImage(
//                             imageUrl: '${recommendedRecipes[index]['Image']}',
//                             height: Screen.screenHeight(context) * 0.4,
//                             width: Screen.screenWidth(context) * 0.6,
//                             fit: BoxFit.cover,
//                             // placeholder: (context, url) => CircularProgressIndicator(),
//                             errorWidget: (context, url, error) =>
//                                 Icon(Icons.error),
//                           ),
//                         ),
//                         // Container for the gradient overlay
//                         Container(
//                           height: Screen.screenHeight(context) * 0.4,
//                           width: Screen.screenWidth(context) * 0.6,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30.r),
//                             gradient: LinearGradient(
//                               begin: Alignment.topRight,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Colors.transparent,
//                                 Colors.black.withOpacity(
//                                     0.7), // Adjust opacity as needed
//                               ],
//                             ),
//                           ),
//                         ),

//                         // Positioned widget for the text "data"
//                         Positioned(
//                           bottom: -10,
//                           left: 20.w, // Adjust left position as needed
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: Screen.screenWidth(context) * 0.4,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Foodies by Sachin Sharma",
//                                       // maxLines: 1,
//                                       style: TextStyle(
//                                           // overflow: TextOverflow.ellipsis,
//                                           color: Colors.grey
//                                               .shade100, // Set text color as per your design
//                                           fontSize: 10.sp,
//                                           fontFamily:
//                                               'Poppins' // Set font size as per your design
//                                           ),
//                                     ),
//                                     Text(
//                                       '${recommendedRecipes[index]['Name']}',
//                                       maxLines: 2,
//                                       style: TextStyle(
//                                           overflow: TextOverflow.ellipsis,
//                                           color: Colors
//                                               .white, // Set text color as per your design
//                                           fontSize: 22.sp,
//                                           fontWeight: FontWeight.w500,
//                                           fontFamily:
//                                               'Poppins' // Set font size as per your design
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0.w),
//                                 child: Container(
//                                   width: Screen.screenWidth(context) * 0.2,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 17,
//                                         backgroundColor: Colors.white,
//                                         child: Icon(
//                                           Icons.favorite_border_outlined,
//                                           size: 28.sp,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//           )














// 2nd
// SizedBox(
//             height: ((Screen.screenWidth(context) + 54) * 5.2),
//             // height: 1000.h,
//             width: Screen.screenWidth(context),
//             child: Column(
//               children: List.generate((recommendedRecipes.length / 2).ceil(),
//                   (rowIndex) {
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: 0.0.h),
//                   child: Row(
//                     children: List.generate(2, (columnIndex) {
//                       final index = rowIndex * 2 + columnIndex;
//                       if (index >= recommendedRecipes.length) {
//                         return SizedBox
//                             .shrink(); // Empty SizedBox if there are no more items
//                       }
//                       return Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.symmetric(horizontal: 3.0.w),
//                               height: (Screen.screenWidth(context) - 14) / 2,
//                               child: Stack(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(30.r),
//                                     child: CachedNetworkImage(
//                                       imageUrl:
//                                           '${recommendedRecipes[index]['Image']}',
//                                       height:
//                                           (Screen.screenWidth(context) - 14) /
//                                               2,
//                                       width:
//                                           (Screen.screenWidth(context) - 14) /
//                                               2,
//                                       fit: BoxFit.cover,
//                                       errorWidget: (context, url, error) =>
//                                           Icon(Icons.error),
//                                     ),
//                                   ),
//                                   Container(
//                                     height: Screen.screenHeight(context) * 0.4,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30.r),
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topRight,
//                                         end: Alignment.bottomCenter,
//                                         colors: [
//                                           Colors.transparent,
//                                           Colors.black.withOpacity(0.7),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     bottom: 5.h,
//                                     left: 5.w,
//                                     child: Container(
//                                       width:
//                                           ((Screen.screenWidth(context) - 14) /
//                                               2),
//                                       padding: EdgeInsets.all(8.w),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width:
//                                                 ((Screen.screenWidth(context) -
//                                                             14) /
//                                                         2) -
//                                                     20,
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 // Text(
//                                                 //   "Foodies by Sachin Sharma",
//                                                 //   style: TextStyle(
//                                                 //     color: Colors.grey.shade100,
//                                                 //     fontSize: 10.sp,
//                                                 //     fontFamily: 'Poppins',
//                                                 //   ),
//                                                 // ),
//                                                 Text(
//                                                   '${recommendedRecipes[index]['Name']}',
//                                                   maxLines: 2,
//                                                   style: TextStyle(
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     color: Colors.white,
//                                                     fontSize: 14.sp,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontFamily: 'Poppins',
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           // Spacer(),
//                                           // Padding(
//                                           //   padding: EdgeInsets.all(8.0.w),
//                                           //   child: Container(
//                                           //     width: ((Screen.screenWidth(
//                                           //                     context) -
//                                           //                 14) /
//                                           //             2) *
//                                           //         0.2,
//                                           //     child: Column(
//                                           //       mainAxisAlignment:
//                                           //           MainAxisAlignment.start,
//                                           //       crossAxisAlignment:
//                                           //           CrossAxisAlignment.start,
//                                           //       children: [
//                                           //         CircleAvatar(
//                                           //           radius: 17,
//                                           //           backgroundColor:
//                                           //               Colors.white,
//                                           //           child: Icon(
//                                           //             Icons
//                                           //                 .favorite_border_outlined,
//                                           //             size: 28.sp,
//                                           //           ),
//                                           //         )
//                                           //       ],
//                                           //     ),
//                                           //   ),
//                                           // ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 3.h,
//                                     right: 3.w,
//                                     child: Padding(
//                                       padding: EdgeInsets.all(8.0.w),
//                                       child: Container(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             CircleAvatar(
//                                               radius: 15,
//                                               backgroundColor: Colors.white,
//                                               child: Icon(
//                                                 Icons.favorite_border_outlined,
//                                                 size: 24.sp,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   left: 10.0.w, top: 5.h, bottom: 10.h),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Text(
//                                   //   '${recommendedRecipes[index]['Name']}',
//                                   //   style: TextStyle(
//                                   //       fontWeight: FontWeight.w600,
//                                   //       fontSize: 14.sp,
//                                   //       fontFamily: 'Poppins',
//                                   //       overflow: TextOverflow.ellipsis),
//                                   //   maxLines: 1,
//                                   // ),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.schedule,
//                                         size: 16.sp,
//                                         color: FoodieColors.darkSecondary,
//                                       ),
//                                       SizedBox(
//                                         width: 5.w,
//                                       ),
//                                       Text(
//                                         '${recommendedRecipes[index]['Total Time']}',
//                                         style: TextStyle(
//                                             fontSize: 13.sp,
//                                             fontFamily: 'Poppins',
//                                             color: FoodieColors.grey3),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                 );
//               }),
//             ),
//           )