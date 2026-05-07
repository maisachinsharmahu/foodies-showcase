import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';

class basedOnInitialChoice3 extends StatefulWidget {
  final List<dynamic> recipes;
  const basedOnInitialChoice3({super.key, required this.recipes});

  @override
  State<basedOnInitialChoice3> createState() => _basedOnInitialChoice3State();
}

class _basedOnInitialChoice3State extends State<basedOnInitialChoice3> {
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

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
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
                  "Based on Your Interst",
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
            height: ((1.sw + 54) * 5.2) * 100,
            width: 1.sw,
            child: Column(
              children: List.generate(
                recommendedRecipes.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.0.h),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.0.w),
                      height: (1.sw - 4) * 0.9,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.r),
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      (1.sw - 14) * 0.5,
                                  child: Stack(
                                    children: [
                                      Hero(
                                        tag: recommendedRecipes[index]['Image'],
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${recommendedRecipes[index]['Image']}',
                                          height: (1.sw -
                                              14),
                                          width: (1.sw -
                                              14),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      Container(
                                        height:
                                            0.4.sh,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.2),
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
                                                    Icons
                                                        .favorite_border_outlined,
                                                    size: 24.sp,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 3.h,
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
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Center(
                                                            child: Hero(
                                                              tag:
                                                                  recommendedRecipes[
                                                                          index]
                                                                      ['Image'],
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    '${recommendedRecipes[index]['Image']}',
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons.fullscreen,
                                                      size: 24.sp,
                                                    ),
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
                                  padding: EdgeInsets.all(16.0.w),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recommendedRecipes[index]['Name'],
                                          maxLines: 1,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            // fontWeight: FontWeight.w800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp,
                                            fontFamily: 'metropolis',
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              recommendedRecipes[index]['type'] is List && recommendedRecipes[index]['type'].length >= 1 ? capitalizeFirstLetter(recommendedRecipes[index]['type'][0]) : '',
                                              maxLines: 1,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                fontFamily: 'metropolis',
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                            recommendedRecipes[index]['type']
                                                        is List &&
                                                    recommendedRecipes[index]
                                                                ['type']
                                                            .length >=
                                                        2
                                                ? Padding(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0.w),
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 4.sp,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  )
                                                : Container(),
                                            Text(
                                              recommendedRecipes[index]['type'] is List && recommendedRecipes[index]['type'].length >= 2 ? capitalizeFirstLetter(recommendedRecipes[index]['type'][1]) : '',
                                              maxLines: 1,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                color: Colors.grey.shade500,
                                                fontFamily: 'Metropolis',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: 8.0.h),
                                          child: Row(
                                            children: [
                                              recommendedRecipes[index]
                                                          ['Total Time'] !=
                                                      "N/A"
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 0.w),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets
                                                                    .only(
                                                                    right: 8.0.w),
                                                            child: Image.asset(
                                                              'assets/images/prep.png',
                                                              height: 22.h,
                                                              width: 22.w,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Total Time : ",
                                                            style: TextStyle(
                                                                fontSize: 14.sp),
                                                          ),
                                                          Text(
                                                            "${recommendedRecipes[index]['Total Time']}",
                                                            style: TextStyle(
                                                                fontSize: 14.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              recommendedRecipes[index]
                                                          ['Total Time'] !=
                                                      "N/A"
                                                  ? Spacer()
                                                  : Container(),
                                              recommendedRecipes[index]
                                                          ['Cook Time'] !=
                                                      "N/A"
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.w),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets
                                                                    .only(
                                                                    right: 8.0.w),
                                                            child: Image.asset(
                                                              'assets/images/Cooktime.png',
                                                              height: 22.h,
                                                              width: 22.w,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Cook Time : ",
                                                            style: TextStyle(
                                                                fontSize: 14.sp),
                                                          ),
                                                          Text(
                                                            "${recommendedRecipes[index]['Cook Time']}",
                                                            style: TextStyle(
                                                                fontSize: 14.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          "${recommendedRecipes[index]['Dish Overview']}",
                                          maxLines: 2,
                                        ),

                                        // recommendedRecipes[index]
                                        //             ['Prep Time'] !=
                                        //         "N/A"
                                        //     ? Spacer()
                                        //     : Container(),
                                        // recommendedRecipes[index]
                                        //             ['Prep Time'] !=
                                        //         "N/A"
                                        //     ? Padding(
                                        //         padding: EdgeInsets.only(
                                        //             right: 8.w),
                                        //         child: Row(
                                        //           children: [
                                        //             Padding(
                                        //               padding:
                                        //                   EdgeInsets
                                        //                       .only(
                                        //                       right: 8.0.w),
                                        //               child: Image.asset(
                                        //                 'assets/images/prep2.png',
                                        //                 height: 20.h,
                                        //                 width: 20.w,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Prep Time :",
                                        //               style: TextStyle(
                                        //                   fontSize: 12.sp),
                                        //             ),
                                        //             Text(
                                        //               "${recommendedRecipes[index]['Prep Time']}",
                                        //               style: TextStyle(
                                        //                   fontSize: 12.sp),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       )
                                        //     : Container(),
                                        // ],
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
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