import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/DetailsPage/helpers/cap.dart';
import 'package:foodie/Pages/DetailsPage/sections/belowdesc.dart';
import 'package:foodie/Pages/DetailsPage/sections/ingridents.dart';
import 'package:foodie/helper/colors.dart';

class fullpagedetails extends StatefulWidget {
  final Map<String, dynamic> userData;
  final dynamic recipe;
  const fullpagedetails({super.key, this.recipe, required this.userData});

  @override
  State<fullpagedetails> createState() => _fullpagedetailsState();
}

class _fullpagedetailsState extends State<fullpagedetails> {
  List<Widget> shuffleItems(List<Widget> items) {
    List<Widget> shuffledList = List.from(items);
    shuffledList.shuffle();
    return shuffledList;
  }

  // "Hindi": {"name": "Hindi", "image": "assets/images/types/cat/amer.jpeg"},
  // "Hindi": {"name": "Hindi", "image": "assets/images/types/cat/amer.jpeg"},

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(26.0.w),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Center the Row content
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500, fontFamily: 'Poppins',
                      // fontWeig/ht: FontWeight.w500,
                      color: Colors.black,
                      // fontFamily: 'Poppins',
                    ),
                  ),
                  GestureDetector(
                    // onTap: widget.openDrawerCallback,
                    child: Icon(
                      Icons.segment,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 16.0.h, left: 16.w, right: 16.w),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                                    color: Colors.black,
                                    fontFamily: 'metropolis'),
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
                  Column(
                    children: [
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: FoodieColors.extra,
                                borderRadius: BorderRadius.circular(
                                  25.0,
                                ),
                              ),
                              child: TabBar(
                                dividerColor: Colors.transparent,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.green,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  color: FoodieColors.darkSecondary,
                                ),
                                tabs: [
                                  Tab(
                                    text: 'Overview',
                                  ),
                                  Tab(text: 'Ingredients'),
                                ],
                                labelStyle: TextStyle(
                                    fontFamily: 'metropolis',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              // Adjust the height as per your requirement
                              child: ContentSizeTabBarView(
                                children: [
                                  // Add your content for Tab 1 here
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.w, right: 16.w),
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
                    ],
                  ),

                  // Divider(
                  //   color: Colors.grey[200],
                  // ),

                  // SizedBox(
                  //   height: 5.h,
                  // ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
