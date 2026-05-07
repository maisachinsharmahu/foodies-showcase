import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/Pages/DetailsPage/details.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/Pages/ListPage/toast.dart';
import 'package:foodie/Source/helper.dart';
import 'package:foodie/helper/addtofav.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/recipe_tracking.dart';
import 'package:foodie/main.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RecommendedSection extends StatefulWidget {
  final Map<String, dynamic> userData;
  final List<dynamic> recipes;
  const RecommendedSection({
    super.key,
    required this.recipes,
    required this.userData,
  });

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  late List<dynamic> recommendedRecipes = [];

  @override
  void initState() {
    super.initState();
    List<dynamic> newws = context
        .read<RecommendedRecipesProvider>()
        .recommendedRecipes;
    recommendedRecipes = newws.take(5).toList();
    // _getRecommendedRecipes();
    // print(widget.recipes);
  }

  void _getRecommendedRecipes() {
    List<dynamic> tempRecipes = List.from(widget.recipes);

    tempRecipes.shuffle();

    setState(() {
      recommendedRecipes = tempRecipes.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0.w),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0.w),
                child: Text(
                  "Recommended For You",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    Provider.of<RecommendedRecipesProvider>(
                      context,
                      listen: false,
                    ).setRecommendedRecipes(
                      shuffleRecipes(widget.recipes),
                      widget.userData,
                    );

                    List<dynamic> newws = context
                        .read<RecommendedRecipesProvider>()
                        .recommendedRecipes;
                    recommendedRecipes = newws.take(5).toList();
                  });
                },
                icon: Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.only(left: 10.0.w),
          child: SizedBox(
            height: 0.4.sh,
            width: 1.sw,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedRecipes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                  height: 0.4.sh,
                  width: 0.6.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Bounceable(
                    onTap: () async {
                      await RecipeTracking.addToRecipeVisit(
                        '${recommendedRecipes[index]['id']}',
                      );
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: const Duration(milliseconds: 300),
                          child: RecipeDetails(
                            userData: widget.userData,
                            recipe: recommendedRecipes[index],
                          ),
                          type: PageTransitionType.fade,
                        ),
                      ).then(
                        (value) => setState(() {
                          FavoriteFunctions.fetchFavoriteRecipes();
                        }),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: CachedNetworkImage(
                            imageUrl: '${recommendedRecipes[index]['Image']}',
                            height: 0.4.sh,
                            width: 0.6.sw,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/home/notavailable1.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Container(
                          height: 0.4.sh,
                          width: 0.6.sw,
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
                          bottom: 0.02.sh,
                          left: 20.w,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 0.4.sw,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Foodies by Sachin Sharma",
                                      style: TextStyle(
                                        color: Colors.grey.shade100,
                                        fontSize: 10.sp,
                                        fontFamily: 'metropolis',
                                      ),
                                    ),
                                    Text(
                                      '${recommendedRecipes[index]['Name']}',
                                      maxLines: 2,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'metropolis',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0.w),
                                child: SizedBox(
                                  width: 0.2.sw,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 18.r,
                                        backgroundColor: Colors.white,
                                        child: Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 3.0.w,
                                              ),
                                              child: LikeButton(
                                                onTap: (isLiked) {
                                                  FavoriteFunctions.toggleFavorite(
                                                    recommendedRecipes[index]['id'],
                                                  );
                                                  if (isLiked) {
                                                    showRecipeRemovedToast(
                                                      context,
                                                    );
                                                  } else {
                                                    showRecipeSavedToast(
                                                      context,
                                                    );
                                                  }

                                                  return Future.value(!isLiked);
                                                },
                                                isLiked: FavoriteFunctions
                                                    .favoriteRecipes
                                                    .contains(
                                                      recommendedRecipes[index]['id'],
                                                    ),
                                                likeBuilder: (bool isLiked) {
                                                  return Icon(
                                                    isLiked
                                                        ? Icons.favorite
                                                        : Icons
                                                              .favorite_border_outlined,
                                                    color: isLiked
                                                        ? Colors.red
                                                        : Colors.black,
                                                    size: 28.sp,
                                                  );
                                                },
                                                size: 28.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
