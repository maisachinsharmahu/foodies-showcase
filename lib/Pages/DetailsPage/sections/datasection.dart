import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/DetailsPage/helpers/cap.dart';
import 'package:foodie/Pages/DetailsPage/sections/belowdesc.dart';
import 'package:foodie/Pages/DetailsPage/sections/ingridents.dart';
import 'package:foodie/Pages/DetailsPage/sections/steps.dart';
import 'package:foodie/helper/colors.dart';

class recidata extends StatefulWidget {
  final ScrollController controller;
  final Map<String, dynamic> userData;
  final dynamic recipe;

  const recidata(
      {super.key,
      this.recipe,
      required this.userData,
      required this.controller});

  @override
  State<recidata> createState() => _recidataState();
}

class _recidataState extends State<recidata> {
  bool showItems = false;
  @override
  void initState() {
    super.initState();
    // Wait for 2 seconds before showing the items
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        showItems = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(
                width: 1.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 8.0.h, left: 16.w, right: 16.w),
                      child: Center(
                        child: SizedBox(
                          width: 56.w,
                          height: 5.h,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3.r),
                              ),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                child: Center(
                  child: Text(
                    widget.recipe['Name'],
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'metropolis',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 8.h,
                  spacing: 8.w,
                  children: widget.recipe['type'].map<Widget>((type) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/dish.png',
                            color: FoodieColors.darkPrimary,
                            height: 18.h,
                            width: 18.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            capitalizeFirstLetter(type),
                            style: TextStyle(
                                color: Colors.black, 
                                fontSize: 12.sp,
                                fontFamily: 'metropolis'),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Divider(
                color: Colors.grey[200],
                thickness: 1.h,
              ),
              DefaultTabController(
                length: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: FoodieColors.extra,
                          borderRadius: BorderRadius.circular(25.0.r),
                        ),
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.green,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: FoodieColors.darkSecondary,
                          ),
                          tabs: [
                            const Tab(
                              text: 'Overview',
                            ),
                            const Tab(text: 'Ingredients'),
                          ],
                          labelStyle: TextStyle(
                              fontFamily: 'metropolis',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      ContentSizeTabBarView(
                        children: [
                          belowDisc(
                            recipe: widget.recipe,
                          ),
                          Ingredients(
                            recipe: widget.recipe,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80.h), // Space for bottom button
            ],
          ),
        ),
      ],
    );
  }
}
