import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/DetailsPage/helpers/cap.dart';
import 'package:foodie/Pages/DetailsPage/sections/belowdesc.dart';
import 'package:foodie/Pages/DetailsPage/sections/ingridents.dart';
import 'package:foodie/helper/colors.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';

class recidata extends StatefulWidget {
  final dynamic recipe;

  const recidata({super.key, this.recipe});

  @override
  State<recidata> createState() => _recidataState();
}

class _recidataState extends State<recidata> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.0.h, left: 16.w, right: 16.w),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    widget.recipe['Name'],
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 20.sp,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'metropolis',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Wrap(
            runSpacing: 8,
            children: widget.recipe['type'].map<Widget>((type) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                margin: EdgeInsets.only(right: 8.w),
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
                      // color: Colors.grey[500],
                      height: 18.h,
                      width: 18.w,
                    ), // Add the icon here
                    SizedBox(
                        width: 4.w), // Add some spacing between the icon and text
                    Text(
                      capitalizeFirstLetter(type),
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'metropolis'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Divider(
          color: Colors.grey[200],
        ),
        DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Ingredients'),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                // Adjust the height as per your requirement
                child: AutoScaleTabBarView(
                  children: [
                    // Add your content for Tab 1 here
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: belowDisc(
                        recipe: widget.recipe,
                      ),
                    ),
                    // Add your content for Tab 2 here
                    Ingredients(
                      recipe: widget.recipe,
                    ),
                    // Add your content for Tab 3 here
                  ],
                ),
              ),
            ],
          ),
        ),

        // Divider(
        //   color: Colors.grey[200],
        // ),

        // SizedBox(
        //   height: 5.h,
        // ),

        // SizedBox(
        //   height: 5.h,
        // ),
        // // Divider(
        // //   color: Colors.grey[200],
        // // ),
        // ElevatedButton(onPressed: () {}, child: Text("15 To Cook"))
      ],
    );
  }
}
