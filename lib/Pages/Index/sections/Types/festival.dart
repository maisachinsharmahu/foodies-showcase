import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/Pages/ListPage/listpage.dart';
import 'package:foodie/Source/helper.dart';
import 'package:foodie/helper/colors.dart';
import 'package:page_transition/page_transition.dart';

class Festival extends StatefulWidget {
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  const Festival({super.key, required this.recipes, required this.userData});

  @override
  State<Festival> createState() => _FestivalState();
}

class _FestivalState extends State<Festival> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Text(
                "Festive Recipies",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 190.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 10.w,
              ),
              Bounceable(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      duration: const Duration(milliseconds: 300),
                      child: listPage(
                        userData: widget.userData,
                        recipes: shuffleRecipes(
                            filterRecipesByType(widget.recipes, 'Diwali')),
                        name: 'Diwali',
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                child: const itsItems(
                    photo: 'assets/images/types/diwali.jpeg', name: 'Diwali'),
              ),
              SizedBox(
                width: 10.w,
              ),
              Bounceable(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: const Duration(milliseconds: 300),
                        child: listPage(
                          userData: widget.userData,
                          recipes: shuffleRecipes(
                              filterRecipesByType(widget.recipes, 'Holi')),
                          name: 'Holi',
                        ),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: const itsItems(
                      photo: 'assets/images/types/holi.jpeg', name: 'Holi')),
              SizedBox(
                width: 10.w,
              ),
              Bounceable(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: const Duration(milliseconds: 300),
                        child: listPage(
                          userData: widget.userData,
                          recipes: shuffleRecipes(
                              filterRecipesByType(widget.recipes, 'Eid')),
                          name: 'Eid',
                        ),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: const itsItems(
                      photo: 'assets/images/types/Eid.jpeg', name: 'Eid')),
              SizedBox(
                width: 10.w,
              ),
              Bounceable(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      duration: const Duration(milliseconds: 300),
                      child: listPage(
                        userData: widget.userData,
                        recipes: shuffleRecipes(
                            filterRecipesByType(widget.recipes, 'Christmas')),
                        name: 'Christmas',
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                child: const itsItems(
                    photo: 'assets/images/types/christ.jpeg',
                    name: 'Christmas'),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
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
    return Column(
      children: [
        Stack(
          children: [
            Material(
              borderRadius: BorderRadius.circular(20.r),
              elevation: 7,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                height: 150.h,
                width: 0.4.sw,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    photo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20.r),
            //     gradient: LinearGradient(
            //       begin: Alignment.centerLeft,
            //       end: Alignment.centerRight,
            //       colors: [
            //         // Colors.transparent,
            //         Colors.black.withOpacity(0.3),
            //         Colors.black.withOpacity(0.4),
            //         Colors.black.withOpacity(0.3),
            //       ],
            //     ),
            //   ),
            //   height: 180.h,
            //   width: double.infinity,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20.r),
            //   ),
            //   height: 180.h,
            //   width: double.infinity,
            //   child: Center(
            //     child: Text(
            //       name,
            //       style: TextStyle(
            //           overflow: TextOverflow.ellipsis,
            //           color: Colors.white, // Set text color as per your design
            //           fontSize: 28.sp,
            //           letterSpacing: 2
            //           // fontWeight: FontWeight.w600,
            //           // fontFamily:
            //           //     'metropolis' // Set font size as per your design
            //           ),
            //     ),
            //   ),
            // ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          name,
          style: TextStyle(
              fontFamily: 'metropolis',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
