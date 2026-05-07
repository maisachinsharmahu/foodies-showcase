import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/Pages/Index/sections/Types/healthy.dart';
import 'package:foodie/Pages/ListPage/listpage.dart';
import 'package:foodie/Source/helper.dart';
import 'package:page_transition/page_transition.dart';

class typesIndex extends StatefulWidget {
  final List<dynamic> recipes;
  final Function() openDrawerCallback;
  final Map<String, dynamic> userData;
  const typesIndex(
      {super.key,
      required this.recipes,
      required this.userData,
      required this.openDrawerCallback});

  @override
  State<typesIndex> createState() => _typesIndexState();
}

class _typesIndexState extends State<typesIndex> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        healthy(
          recipes: widget.recipes,
          userData: widget.userData,
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0.w),
              child: Text(
                "From Variety of Choices",
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Bounceable(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  duration: Duration(milliseconds: 300),
                  child: listPage(
                    userData: widget.userData,
                    recipes: shuffleRecipes(
                        filterRecipesByType(widget.recipes, 'Vegetarian')),
                    name: 'Vegetarian',
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: itsItems(
                photo: 'assets/images/types/veg.jpeg', name: 'Vegetarian')),
        SizedBox(
          height: 20.h,
        ),
        Bounceable(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  duration: Duration(milliseconds: 300),
                  child: listPage(
                    userData: widget.userData,
                    recipes: shuffleRecipes(filterRecipesBymanyTypes(
                        widget.recipes, ['chicken', 'meat'])),
                    name: 'Non-Vegetarian',
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: itsItems(
                photo: 'assets/images/types/non.jpeg', name: 'Non-Vegetarian')),
        SizedBox(
          height: 20.h,
        ),
        Bounceable(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  duration: Duration(milliseconds: 300),
                  child: listPage(
                    userData: widget.userData,
                    recipes: shuffleRecipes(
                        filterRecipesByType(widget.recipes, 'chinease')),
                    name: 'Chinease',
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: itsItems(
                photo: 'assets/images/types/chinease.jpeg', name: 'Chinease')),
        SizedBox(
          height: 20.h,
        ),
        Bounceable(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  duration: Duration(milliseconds: 300),
                  child: RecipieIndex(
                    recipes: widget.recipes,
                    selected: 1,
                    // openDrawerCallback: widget.openDrawerCallback,
                    // // favlist: userData['favorite'],
                    // userData: userData,
                    // recipes: widget.recipes,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: itsItems(
                photo: 'assets/images/types/worl.jpeg', name: 'Explore More')),
        SizedBox(
          height: 20.h,
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20.r),
        //   ),
        //   height: 140.h,
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.all(10.0.w),
        //         child: Image.asset(
        //           'assets/images/types/4.png',
        //           height: 120.h,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: 20.h,
        // ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0.w),
              child: Text(
                "Recipes You'll Love 💖✨",
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}

class itsItems extends StatelessWidget {
  final String photo;
  final String name;
  const itsItems({super.key, required this.photo, required this.name});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          borderRadius: BorderRadius.circular(20.r),
          elevation: 7,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            height: 180.h,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                photo,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                // Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
          height: 180.h,
          width: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          height: 180.h,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white, // Set text color as per your design
                      fontSize: 28.sp,
                      letterSpacing: 2
                      // fontWeight: FontWeight.w600,
                      // fontFamily:
                      //     'metropolis' // Set font size as per your design
                      ),
                ),
                name == 'Explore More'
                    ? Column(
                        children: [
                          // Icon(
                          //   Icons.arrow_downward,
                          //   color: Colors.white,
                          // ),
                          Image.asset(
                            'assets/images/types/down.png',
                            height: 80.h,
                            color: Colors.white,
                          )
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
