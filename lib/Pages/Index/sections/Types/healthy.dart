import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/Pages/ListPage/listpage.dart';
import 'package:foodie/Source/helper.dart';
import 'package:page_transition/page_transition.dart';

class healthy extends StatefulWidget {
  final Map<String, dynamic> userData;
  final List<dynamic> recipes;
  const healthy({super.key, required this.recipes, required this.userData});

  @override
  State<healthy> createState() => _healthyState();
}

class _healthyState extends State<healthy> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Are You a Fitness freak",
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                  ),
                  Text(
                    "Looking for healthy Options",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
            const Spacer(),
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
                  duration: const Duration(milliseconds: 300),
                  child: listPage(
                    userData: widget.userData,
                    recipes: shuffleRecipes(
                        filterRecipesByType(widget.recipes, 'Healthy')),
                    name: 'Healthy',
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: const itsItems(
                photo: 'assets/images/types/health.jpeg', name: 'Healthy')),
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
            height: 250.h,
            width: 1.sw,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                photo,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
