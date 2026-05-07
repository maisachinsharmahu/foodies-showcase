import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/SideBarPages/About.dart';
import 'package:foodie/Pages/SideBarPages/Feedback.dart';
import 'package:foodie/Pages/SideBarPages/Settings.dart';
import 'package:foodie/Pages/SideBarPages/faq.dart';
import 'package:foodie/Pages/MealPlanner/meal_planner.dart';
import 'package:foodie/Pages/Grocery/grocery_list.dart';
// import 'package:foodie/Pages/SideBarPages/preference/preference.dart';
import 'package:foodie/helper/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wiredash/wiredash.dart';

class drawerFoodie extends StatefulWidget {
  final Function() openDrawerCallback;
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  final Function closeDrawer;
  const drawerFoodie(
      {super.key,
      required this.userData,
      required this.closeDrawer,
      required this.recipes,
      required this.openDrawerCallback});

  @override
  State<drawerFoodie> createState() => _drawerFoodieState();
}

class _drawerFoodieState extends State<drawerFoodie> {
  @override
  void initState() {
    super.initState();
    print(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/bg.png',
              ), // Replace 'assets/background_image.jpg' with your image path
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 7,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 7,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 7,
                      ),
                      // Spacer(),
                      // CircleAvatar(
                      //   backgroundColor: Colors.grey[300],
                      //   radius: 12,
                      //   child: Icon(Iconsax.arrow_left_1),
                      // ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/logo4.png',
                  width: 200.w,
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('About'),
                      leading: Icon(Iconsax.user),
                      onTap: () {
                        widget.closeDrawer();
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 300),
                            child: about(
                              recipes: widget.recipes,
                              userData: widget.userData,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );

                        // Update UI based on drawer item click
                      },
                    ),
                    ListTile(
                      title: Text('Feedback'),
                      leading: Icon(Iconsax.star),
                      onTap: () {
                        widget.closeDrawer();
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 300),
                            child: feedbackForm(
                              recipes: widget.recipes,
                              userData: widget.userData,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );

                        // Update UI based on drawer item click
                      },
                    ),
                    ListTile(
                      title: Text('Meal Planner'),
                      leading: Icon(Iconsax.calendar_1),
                      onTap: () {
                        widget.closeDrawer();
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 300),
                            child: MealPlannerPage(
                              recipes: widget.recipes,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Grocery Cart'),
                      leading: Icon(Iconsax.shopping_cart),
                      onTap: () {
                        widget.closeDrawer();
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 300),
                            child: const SmartGroceryList(),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                    ),
                    // ListTile(
                    //   leading: Icon(Iconsax.heart),
                    //   title: Text('Favorites'),
                    //   onTap: () {
                    //     _closeDrawer();
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => favouritesPage()));
                    //     // Update UI based on drawer item click
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Iconsax.setting),
                      title: Text('Settings'),
                      onTap: () {
                        widget.closeDrawer();
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 300),
                            child: settingsPage(
                              openDrawerCallback: widget.openDrawerCallback,
                              userData: widget.userData,
                              recipes: widget.recipes,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );

                        // Update UI based on drawer item click
                      },
                    ),
                    // ListTile(
                    //   leading: Icon(Iconsax.setting),
                    //   title: Text('Prefernce'),
                    //   onTap: () {
                    //     widget.closeDrawer();
                    //     Navigator.push(
                    //       context,
                    //       PageTransition(
                    //         duration: Duration(milliseconds: 300),
                    //         child: PreferencePage(
                    //           userData: widget.userData,
                    //           recipes: widget.recipes,
                    //         ),
                    //         type: PageTransitionType.fade,
                    //       ),
                    //     );

                    //     // Update UI based on drawer item click
                    //   },
                    // ),
                    // ListTile(
                    //   leading: Icon(Iconsax.message_programming),
                    //   title: Text('Contact Us'),
                    //   onTap: () {
                    //     _closeDrawer();
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => settingsPage()));
                    //     // Update UI based on drawer item click
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Iconsax.support),
                      title: Text('Help & FAQs'),
                      onTap: () {
                        widget.closeDrawer();
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 300),
                            child: FAQ(
                              userData: widget.userData,
                              recipes: widget.recipes,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );

                        // Update UI based on drawer item click
                      },
                    ),
                    ListTile(
                      leading: Icon(Iconsax.warning_2),
                      title: Text('Report Bug'),
                      onTap: () {
                        // _closeDrawer();

                        widget.closeDrawer();
                        Wiredash.of(context).show(inheritMaterialTheme: true);
                        // Wiredash.of(context).(
                        //   force: true,
                        //   options: PsOptions(),
                        // );
                        // Update UI based on drawer item click
                      },
                    ),
                    // ListTile(
                    //   title: Icon(Iconsax.warning_2),
                    // onTap: () {
                    //   _closeDrawer();
                    //   // Wiredash.of(context).show(inheritMaterialTheme: true);
                    //   Wiredash.of(context).showPromoterSurvey(
                    //     force: true,
                    //     options: PsOptions(),
                    //   );
                    //   },
                    // ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Row(
                        children: [
                          ClipOval(
                            child: CircleAvatar(
                              radius: 0.03.sh,
                              backgroundImage: AssetImage(
                                'assets/images/avatars2/${widget.userData['avatar'] ?? 1}.png',
                              ),
                              // Set fit property inside AssetImage
                              backgroundColor: FoodieColors.darkSecondary,
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.userData['firstName']} ${widget.userData['lastName']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp),
                                ),
                                Text(
                                  "Member",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ),
                          // Spacer(),
                          Image.asset(
                            "assets/images/home/veri.png",
                            height: 35.h,
                            width: 35.w,
                          )
                          // Icon(Icons.logout)
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Text(
                  "Developed By Sachin Sharma",
                  style: TextStyle(color: Colors.grey[600]),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
