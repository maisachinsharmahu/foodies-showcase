import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';

class about extends StatefulWidget {
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  const about({super.key, required this.recipes, required this.userData});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FoodieColors.darkSecondary,
        body: SafeArea(
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(26.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.white.withOpacity(0.6),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      Text(
                        "About",
                        style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Poppins'),
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/bg.png'),
                          fit: BoxFit.fitHeight,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.r),
                            topRight: Radius.circular(40.r))),
                    child: Padding(
                      padding: EdgeInsets.all(26.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About Foodies",
                            style: TextStyle(
                                fontFamily: 'metropolis',
                                fontSize: 30.sp,
                                fontWeight: FontWeight
                                    .w600
                                ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Foodie is more than just an app, it's a journey fueled by my passion for both food and app development. As I dive into the world of app creation, Foodie has emerged as a deliciously exciting project that I'm eager to share with fellow food enthusiasts like you.\n\nFoodie is a one-stop recipe app designed to ignite your Cooking Journey. Dive into a treasure trove of over 15,000+ recipes in both Hindi and English, catering to a wide range of cuisines and dietary preferences.",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontFamily: 'Poppins',
                              height: 1.5.h,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Sachin Sharma\nFounder & Developer, Foodies",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.sp,
                                fontWeight: FontWeight
                                    .w600
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ]),
        ));
  }
}
