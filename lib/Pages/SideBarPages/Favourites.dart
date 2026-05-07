import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/Pages/DetailsPage/details.dart';
import 'package:foodie/Pages/DetailsPage/helpers/cap.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/Pages/ListPage/toast.dart';
import 'package:foodie/Pages/ListPage/toast.dart';
import 'package:foodie/Source/helper.dart';
import 'package:foodie/helper/addtofav.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/drawer.dart';
import 'package:foodie/helper/recipe_tracking.dart';
import 'package:foodie/main.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class favouritesPage extends StatefulWidget {
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  final Function() openDrawerCallback;
  const favouritesPage({
    super.key,
    required this.userData,
    required this.recipes,
    required this.openDrawerCallback,
  });

  @override
  State<favouritesPage> createState() => _favouritesPageState();
}

class _favouritesPageState extends State<favouritesPage> {
  List userfav = [];
  List<dynamic> favs = [];
  Map<String, dynamic> userData = {};
  bool isready = false;
  @override
  void initState() {
    super.initState();
    FavoriteFunctions.fetchFavoriteRecipes();
    print("HI");
    loadDataFromSharedPreferences();
    // loadUserData();
    // userData = widget.userData;
    loadUserData();
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');
    print("`0`");
    if (userDataJson != null) {
      setState(() {
        print(userfav); // Assign userfav here
      });
    }
  }

  void refreshFavoriteRecipes() {
    setState(() {
      // Fetch favorite recipes again to update the list
      FavoriteFunctions.fetchFavoriteRecipes();
    });
  }

  Future<void> loadUserData() async {
    // Merging local data only
    userfav = await FavoriteFunctions.fetchFavoriteRecipes().then((_) => FavoriteFunctions.favoriteRecipes);
    favs = filterRecipesByMultipleIds(widget.recipes, userfav);
    
    if (mounted) {
      setState(() {
        isready = true;
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    // Add this function
    _scaffoldKey.currentState!.openEndDrawer();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        // Disable going back when the back button is pressed
        // Perform the navigation here
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 300),
            type: PageTransitionType.fade,
            child: RecipieIndex(
              recipes: widget.recipes,
            ),
          ),
          (route) => false,
        );
      },
      child: Opacity(
        opacity: _isLoading ? 0.4 : 1.0,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          drawer: drawerFoodie(
            openDrawerCallback: widget.openDrawerCallback,
            recipes: widget.recipes,
            userData: userData,
            closeDrawer: _closeDrawer,
          ),
          // backgroundColor: FoodieColors.darkSecondary,
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoading = true;
                loadUserData(); // Show the loading GIF
              });

              // Simulate a 2-second delay
              await Future.delayed(Duration(seconds: 2));

              // Update suggestions

              setState(() {
                _isLoading = false; // Hide the loading GIF
              });
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(26.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Center the Row content
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                    duration: Duration(milliseconds: 300),
                                    type: PageTransitionType.fade,
                                    child:
                                        RecipieIndex(recipes: widget.recipes),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                size: 16.sp,
                              ),
                            ),
                          ),
                          Text(
                            "My Favourites",
                            style: TextStyle(
                              fontSize: 22.sp,
                              // fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              // fontFamily: 'Poppins',
                            ),
                          ),
                          Bounceable(
                            onTap: widget.openDrawerCallback,
                            child: Icon(
                              Icons.segment,
                              size: 30.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: 1.sw,
                          child: Image.asset(
                            'assets/images/bg.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Positioned(
                            top: 0.1.sh,
                            left: 0.w,
                            right: 0.w,
                            child: !isready
                                ? Container()
                                : favs.isEmpty
                                    ? Column(
                                        children: [
                                          Center(
                                            child: Image.asset(
                                                "assets/images/home/nofav.png"),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.all(8.0.w),
                                                child: Text(
                                                  "No Favourites Yet!",
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 22.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 50.0.w),
                                                child: Text(
                                                  "This is where your favorite recipes will be saved.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14.sp,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              Bounceable(
                                                onTap: () {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    PageTransition(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      type: PageTransitionType
                                                          .fade,
                                                      child: RecipieIndex(
                                                          recipes:
                                                              widget.recipes),
                                                    ),
                                                    (route) => false,
                                                  );
                                                },
                                                child: Container(
                                                  width: 160.w,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(30.r)),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(16.0.w),
                                                    child: Center(
                                                      child: Text(
                                                            "Go Back",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16.sp,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container()),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.r),
                              topRight: Radius.circular(40.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0.h),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: favs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _buildtile(index, favs[index]);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildtile(int index, dynamic suggestions) {
    bool isLikedme = userfav.contains(suggestions['id']);
    return Container(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15.0.h),
            child: Bounceable(
              onTap: () async {
                await RecipeTracking.addToRecipeVisit('${suggestions['id']}');
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: RecipeDetails(
                      userData: widget.userData,
                      recipe: suggestions,
                    ),
                  ),
                ).then((value) => setState(() {
                      loadUserData();
                      FavoriteFunctions.fetchFavoriteRecipes();
                    }));
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0.w,
                  right: 16.w,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.0.w),
                  height: (1.sw - 4.w) * 0.86,
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
                              height: (1.sw - 14.w) * 0.5,
                              child: Stack(
                                children: [
                                  Hero(
                                    tag: suggestions['id'],
                                    child: CachedNetworkImage(
                                      imageUrl: '${suggestions['Image']}',
                                      height: (1.sw - 14.w),
                                      width: (1.sw - 14.w),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/home/notavailable1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 0.4.sh,
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
                                            Bounceable(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Center(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              '${suggestions['Image']}',
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            'assets/images/home/notavailable1.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: CircleAvatar(
                                                radius: 15.r,
                                                backgroundColor: Colors.white,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        suggestions['Name'],
                                        maxLines: 1,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        fontFamily: 'metropolis',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          suggestions['type'] is List &&
                                                  suggestions['type'].length >=
                                                      1
                                              ? capitalizeFirstLetter(
                                                  suggestions['type'][0])
                                              : '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.sp,
                                            fontFamily: 'metropolis',
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        suggestions['type'] is List &&
                                                suggestions['type'].length >= 2
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 8.0.w),
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 4.sp,
                                                  color: Colors.grey.shade500,
                                                ),
                                              )
                                            : Container(),
                                        Text(
                                          suggestions['type'] is List &&
                                                  suggestions['type'].length >=
                                                      2
                                              ? capitalizeFirstLetter(
                                                  suggestions['type'][1])
                                              : '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade500,
                                            fontFamily: 'Metropolis',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0.h),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              suggestions['Total Time'] != "N/A"
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
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            "${suggestions['Total Time']}",
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8.0.h),
                                                child: suggestions[
                                                            'Cook Time'] !=
                                                        "N/A"
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.w),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                      right: 8.0.w),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/Cooktime.png',
                                                                height: 22.h,
                                                                width: 22.w,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Cook Time : ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12.sp),
                                                            ),
                                                            Text(
                                                              "${suggestions['Cook Time']}",
                                                              style: TextStyle(
                                                                  fontSize: 12.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                              ),
                                            ],
                                          ),
                                          const VerticalDivider(
                                            thickness: 5,
                                            color: Colors.amber,
                                          ),
                                          const Spacer(),
                                          Container(
                                            child: Column(
                                              children: [
                                                LikeButton(
                                                  onTap: (isLiked) {
                                                    FavoriteFunctions
                                                        .toggleFavorite(
                                                            suggestions['id']);
                                                    if (isLiked) {
                                                      FavoriteFunctions
                                                          .toggleFavorite(
                                                              suggestions[
                                                                  'id']);
                                                      showRecipeRemovedToast(
                                                          context);
                                                      setState(() {
                                                        favs.remove(
                                                            suggestions);
                                                      });
                                                    } else {
                                                      FavoriteFunctions
                                                          .toggleFavorite(
                                                              suggestions[
                                                                  'id']);
                                                      showRecipeSavedToast(
                                                          context);
                                                    }

                                                    return Future.value(
                                                        !isLiked);
                                                  },
                                                  isLiked: isLikedme,
                                                  likeBuilder: (bool isLiked) {
                                                    return Icon(
                                                      isLiked
                                                          ? Icons.bookmark
                                                          : Icons
                                                              .bookmark_add_outlined,
                                                      size: 40.sp,
                                                      color: Colors.red,
                                                    );
                                                  },
                                                  size: 40.r,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
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
              ),
            ),
          ),
        ],
      ),
    );
    // Widget _buildtile(int index, dynamic suggestions) {
    //   return Padding(
    //     padding: index == 0
    //         ? EdgeInsets.only(top: 20.0.h)
    //         : EdgeInsets.symmetric(vertical: 0.0.h),
    //     child: Column(
    //       children: [
    //         ListTile(
    //           selectedColor: FoodieColors.darkSecondary,
    //           title: Container(
    //             child: Row(
    //               children: [
    //                 Stack(children: [
    //                   Container(
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(30.r)),
    //                     height: 150.h,
    //                     width: Screen.screenWidth(context) * 0.43,
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(30.r),
    //                       child: CachedNetworkImage(
    //                         imageUrl: "${suggestions['Image']}",
    //                         fit: BoxFit.cover,
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     height: 150.h,
    //                     width: Screen.screenWidth(context) * 0.43,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(30.r),
    //                       gradient: LinearGradient(
    //                         begin: Alignment.topRight,
    //                         end: Alignment.bottomCenter,
    //                         colors: [
    //                           Colors.transparent,
    //                           Colors.black
    //                               .withOpacity(0.4), // Adjust opacity as needed
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   Positioned(
    //                     bottom: 10.h,
    //                     right: 10.w,
    //                     child: CircleAvatar(
    //                       radius: 18,
    //                       backgroundColor: Colors.white,
    //                       child: Padding(
    //                         padding: EdgeInsets.only(left: 3.0.w, top: 2.h),
    //                         child: LikeButton(
    //                           onTap: (isLiked) {
    //                             FavoriteFunctions.toggleFavorite(
    //                                 suggestions['id']);

    //                             if (isLiked) {
    //                               // Recipe is being removed from favorites
    //                               FavoriteFunctions.toggleFavorite(
    //                                   suggestions['id']);
    //                               showRecipeRemovedToast(context);
    //                             } else {
    //                               // Recipe is being added to favorites
    //                               FavoriteFunctions.toggleFavorite(
    //                                   suggestions['id']);
    //                               showRecipeSavedToast(context);
    //                             }

    //                             return Future.value(
    //                                 !isLiked); // Reverse the liked status // Reverse the liked status
    //                           },
    //                           isLiked: FavoriteFunctions.favoriteRecipes
    //                               .contains(suggestions['id']),
    //                           likeBuilder: (bool isLiked) {
    //                             return Icon(
    //                               isLiked
    //                                   ? Icons.favorite
    //                                   : Icons.favorite_border_outlined,
    //                               color: isLiked ? Colors.red : Colors.black,
    //                             );
    //                           },
    //                           // size: 2,
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 ]),
    //                 SizedBox(
    //                   width: 15.w,
    //                 ),
    //                 Expanded(
    //                   child: Container(
    //                     height: 150.h,
    //                     child: Padding(
    //                       padding: EdgeInsets.symmetric(vertical: 8.0.h),
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             "${suggestions['Name']}",
    //                             maxLines: 2,
    //                             style: TextStyle(
    //                                 overflow: TextOverflow.ellipsis,
    //                                 fontWeight: FontWeight.w500),
    //                           ),
    //                           SizedBox(
    //                             height: 5.h,
    //                           ),
    //                           Text(
    //                             "${suggestions['Dish Overview'][0]}",
    //                             maxLines: 3,
    //                             style: TextStyle(
    //                               fontSize: 13.sp,
    //                               overflow: TextOverflow.ellipsis,
    //                             ),
    //                           ),
    //                           Spacer(),
    //                           Divider(
    //                             color: Colors.grey[300],
    //                           ),
    //                           Row(
    //                             children: [
    //                               Icon(
    //                                 Iconsax.clock,
    //                                 color: FoodieColors.darkSecondary,
    //                                 size: 20.sp,
    //                               ),
    //                               SizedBox(
    //                                 width: 5.w,
    //                               ),
    //                               Text(
    //                                 suggestions['Total Time'].length < 20
    //                                     ? "${suggestions['Total Time']}"
    //                                     : "${suggestions['Total Time']}"
    //                                         .substring(0, 20),
    //                                 style: TextStyle(fontSize: 13.sp),
    //                               )
    //                             ],
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //           onTap: () {
    //             Navigator.push(
    //               context,
    //               PageTransition(
    //                 duration: Duration(milliseconds: 300),
    //                 child: RecipeDetails(
    //                   recipe: suggestions,
    //                 ),
    //                 type: PageTransitionType.fade,
    //               ),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   );
  }
}
