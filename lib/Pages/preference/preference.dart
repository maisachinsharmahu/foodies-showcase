import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/CategoryWise/herlper/helper.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/local_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class PreferencePage extends StatefulWidget {
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;

  const PreferencePage({
    super.key,
    required this.recipes,
    required this.userData,
  });

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  // List of questions
  List<String> questions = [
    "Select your favorite cuisines",
    "What is your skill level in the kitchen",
    "Do you follow any specific diet?",
    "What do you typically prefer?",

    // "Thank you for telling us about yourself"
  ];

  // Index of the current question
  int currentQuestionIndex = 0;
  bool isFinished = false;
  double progressValue = 0.0;

  void updateProgressValue() {
    setState(() {
      // Update progress value based on the current question index
      progressValue = (currentQuestionIndex + 1) * 25.0;
    });
  }

  List<dynamic> FavCuisines = [];
  Set<dynamic> nayawala = {};

  void updateFavoriteCuisines(List<dynamic> cuisines) async {
    setState(() {
      FavCuisines = cuisines;
    });

    nayawala = cuisines.toSet();
    cuisines = nayawala.toList();
    FavCuisines = cuisines;
    
    // Update local SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');
    if (userDataJson != null) {
      Map<String, dynamic> userData = json.decode(userDataJson);
      userData['preference'] = cuisines;
      await prefs.setString('userData', json.encode(userData));
    }
  }

  @override
  void initState() {
    super.initState();
    widget.userData['preference'] != null
        ? FavCuisines = widget.userData['preference']
        : [];
    print(FavCuisines);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        // Show an AwesomeDialog when the user presses the back button
        AwesomeDialog dialog = AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: 'Confirmation',
          desc: 'Are you sure you want to go back?',
          btnCancelOnPress: () {},
          btnOkOnPress: () {
            Navigator.of(context).pop(); // Dismiss the dialog
            Navigator.of(context).pop(); // Actually pop the page
          },
        );

        dialog.show();
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            // Positioned(
            //   top: -100,
            //   right: -100,
            //   child: Image.asset(
            //     'assets/images/home/fruit.png',
            //     height: 200.h,
            //   ),
            // ),
            Positioned(
              top: -50,
              left: -250,
              child: Image.asset(
                'assets/images/home/pref2.png',
                height: 200.h,
              ),
            ),
            Positioned(
              top: -50,
              right: -250,
              child: Image.asset(
                'assets/images/home/pref2.png',
                height: 200.h,
              ),
            ),

            // Positioned(
            //   top: 80.h,
            //   right: 0.w,
            //   left: 0.w,
            //   child: Image.asset(
            //     'assets/images/logo.png',
            //     height: 50.h,
            //   ),
            // ),
            // Your background images or widgets
            // ...
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Expanded(
                    child: PageView.builder(
                      itemCount: questions.length,
                      physics: NeverScrollableScrollPhysics(),
                      controller: PageController(
                        initialPage: currentQuestionIndex,
                        keepPage: true,
                      ),
                      onPageChanged: (index) {
                        setState(() {
                          currentQuestionIndex = index;
                          updateProgressValue(); // Update progress value on page change
                        });
                      },
                      itemBuilder: (context, index) {
                        return currentQuestionIndex == 0
                            ? _pref1()
                            : currentQuestionIndex == 1
                                ? _pref2()
                                : currentQuestionIndex == 2
                                    ? _pref3()
                                    : currentQuestionIndex == 3
                                        ? _pref4()
                                        // : currentQuestionIndex == 3
                                        //     ? _pref4()
                                        : Center(
                                            child: Text(
                                              questions[index],
                                              style: TextStyle(
                                                fontSize: 24.0.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                      },
                    ),
                  ),

                  SizedBox(height: 20.0.h),

                  // Add the Radial Gauge here
                ],
              ),
            ),
            currentQuestionIndex == 0
                ? Positioned(
                    bottom: 120.h,
                    left: 0.w,
                    right: 0.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentQuestionIndex += 1;
                        });
                      },
                      child: SizedBox(
                        child: CircleAvatar(
                          backgroundColor: Colors.cyan.shade800,
                          radius: 40,
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            currentQuestionIndex == 1 || currentQuestionIndex == 2
                ? Positioned(
                    bottom: 120.h,
                    right: 20.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentQuestionIndex += 1;
                        });
                      },
                      child: SizedBox(
                        child: CircleAvatar(
                          backgroundColor: Colors.cyan.shade800,
                          radius: 40,
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            currentQuestionIndex == 1 || currentQuestionIndex == 2
                ? Positioned(
                    bottom: 120.h,
                    left: 20.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          print("object");
                          currentQuestionIndex -= 1;
                        });
                      },
                      child: SizedBox(
                        child: CircleAvatar(
                          backgroundColor: Colors.cyan.shade800,
                          radius: 40,
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),

            currentQuestionIndex == 3
                ? Positioned(
                    bottom: 220.h,
                    left: 0.w,
                    right: 0.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          print("object");
                          currentQuestionIndex -= 1;
                        });
                      },
                      child: SizedBox(
                        child: CircleAvatar(
                          backgroundColor: Colors.cyan.shade800,
                          radius: 40,
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            currentQuestionIndex == 3
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0.8.sh,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Center(
                          child: SwipeableButtonView(
                            buttonText: 'Slide to Submit',
                            buttontextstyle: TextStyle(
                                fontSize: 25.sp, color: Colors.white),
                            buttonWidget: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.grey),
                            activeColor: const Color(0xFF009C41),
                            onWaitingProcess: () {
                              // - - -
                              // Amount of time the circular progress
                              // indicator spins before navigating to next page
                              //- - -
                              updateFavoriteCuisines(FavCuisines);
                              Future.delayed(
                                  const Duration(seconds: 2),
                                  () => setState(() {
                                        isFinished = true;
                                      }));
                            },
                            isFinished: isFinished,
                            onFinish: () async {
                              // - - - Navigate to confirmation page - - -
                              await Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child:  DashboardScreen(recipes: widget.recipes,)));
                              // - - - Reset isFinished variable  - - -
                              setState(() => isFinished = false);
                            },
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            // currentQuestionIndex == 3
            //     ? Positioned(
            //         bottom: 20.h,
            //         left: 0.w,
            //         right: 0.w,
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 30.w),
            //           child: SwipeableButtonView(
            //             buttonText: 'Slide to Pay',
            //             buttontextstyle:
            //                 TextStyle(fontSize: 25.sp, color: Colors.white),
            //             buttonWidget: const Icon(
            //                 Icons.arrow_forward_ios_rounded,
            //                 color: Colors.grey),
            //             activeColor: const Color(0xFF009C41),
            //             onWaitingProcess: () {
            //               // - - -
            //               // Amount of time the circular progress
            //               // indicator spins before navigating to next page
            //               //- - -
            //               Future.delayed(const Duration(seconds: 2),
            //                   () => setState(() => isFinished = true));
            //             },
            //             isFinished: isFinished,
            //             onFinish: () async {
            //               // - - - Navigate to confirmation page - - -
            //               await Navigator.push(
            //                   context,
            //                   PageTransition(
            //                       type: PageTransitionType.fade,
            //                       child: const DashboardScreen()));
            //               // - - - Reset isFinished variable  - - -
            //               setState(() => isFinished = false);
            //             },
            //           ),
            //         ))
            //     // child: SwipeableButtonView(
            //     //   buttonText: 'SLIDE TO PAYMENT',
            //     //   buttonWidget: Container(
            //     //     child: Icon(
            //     //       Icons.arrow_forward_ios_rounded,
            //     //       color: Colors.grey,
            //     //     ),
            //     //   ),
            //     //   activeColor: Color(0xFF009C41),
            //     //   isFinished: isFinished,
            //     //   onWaitingProcess: () {
            //     //     Future.delayed(Duration(seconds: 2), () {
            //     //       setState(() {
            //     //         isFinished = true;
            //     //       });
            //     //     });
            //     //   },
            //     //   onFinish: () async {
            //     //     await Navigator.push(
            //     //         context,
            //     //         PageTransition(
            //     //             type: PageTransitionType.fade,
            //     //             child: DashboardScreen()));

            //     //     //TODO: For reverse ripple effect animation
            //     //     setState(() {
            //     //       isFinished = false;
            //     //     });
            //     //   },
            //     // ))
            //     : Container(),
          ],
        ),
      ),
    );
  }

  // Update progress value based on current question index

  Widget _pref1() {
    Map<String, Map<String, String>> categorizedData = Country;
    return Stack(
      children: [
        Positioned(
          top: 0.15.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0.0,
                    end: currentQuestionIndex == 1
                        ? 0.33
                        : currentQuestionIndex == 2
                            ? 0.66
                            : currentQuestionIndex == 3
                                ? 1
                                : 0),
                duration: const Duration(milliseconds: 350),
                builder: (context, value, _) => CircularStepProgressIndicator(
                  totalSteps: 100,
                  currentStep: (value * 100).toInt(),
                  stepSize: 4,
                  selectedColor: FoodieColors.darkSecondary,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 100.w,
                  height: 100.h,
                  selectedStepSize: 6,
                  roundedCap: (_, __) => true,
                  child: Center(
                    child: Image.asset(
                      'assets/images/home/items/log.png',
                      height: 100.h,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                questions[0],
                style: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 26.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0.w, top: 10.h, bottom: 30.h),
                child: SizedBox(
                  height: 220.h,
                  width: 1.sw, // Set a finite width here
                  child: SizedBox(
                    height: 200.h,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              // Generate your widgets dynamically here based on the index
                              String cuisineName =
                                  categorizedData.keys.elementAt(index);
                              Map<String, String> cuisineInfo =
                                  categorizedData[cuisineName]!;
                              return GestureDetector(
                                onTap: () {
                                  if (FavCuisines.contains(cuisineName)) {
                                    FavCuisines.remove(cuisineName);
                                  } else {
                                    FavCuisines.add(cuisineName);
                                  }
                                  setState(() {});
                                  print(FavCuisines.toList());
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0.w),
                                  child: Stack(
                                    children: [
                                      ClipOval(
                                        child: CircleAvatar(
                                          radius: 100,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: AssetImage(
                                            "${cuisineInfo['image']}",
                                          ),
                                        ),
                                      ),
                                      ClipOval(
                                        child: CircleAvatar(
                                          radius: 100,
                                          // Placeholder for the second widget with gradient color
                                          // Replace the placeholder with your desired gradient
                                          backgroundColor: Colors
                                              .transparent, // Ensure transparent background
                                          backgroundImage: AssetImage(
                                            "${cuisineInfo['image']}", // Or provide a different image
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black.withOpacity(0.3),
                                                  Colors.black.withOpacity(0.1),
                                                  Colors.black.withOpacity(0.3),
                                                ], // Example gradient colors
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipOval(
                                        child: CircleAvatar(
                                          radius: 100,
                                          // Placeholder for the second widget with gradient color
                                          // Replace the placeholder with your desired gradient
                                          backgroundColor: Colors
                                              .transparent, // Ensure transparent background
                                          backgroundImage: AssetImage(
                                            "${cuisineInfo['image']}", // Or provide a different image
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black.withOpacity(0.3),
                                                  Colors.black.withOpacity(0.1),
                                                  Colors.black.withOpacity(0.3),
                                                ], // Example gradient colors
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      FavCuisines.contains(cuisineName)
                                          ? ClipOval(
                                              child: CircleAvatar(
                                                radius: 100,
                                                backgroundColor:
                                                    FoodieColors.darkSecondary,
                                              ),
                                            )
                                          : Container(),
                                      ClipOval(
                                        child: CircleAvatar(
                                          radius: 100,
                                          backgroundColor: Colors.transparent,
                                          child: Text(
                                            cuisineName.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: categorizedData.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pref2() {
    Map<String, Map<String, String>> categorizedData = Country;
    return Stack(
      children: [
        Positioned(
          top: 0.15.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0.0,
                    end: currentQuestionIndex == 1
                        ? 0.33
                        : currentQuestionIndex == 2
                            ? 0.66
                            : currentQuestionIndex == 3
                                ? 1
                                : 0),
                duration: const Duration(milliseconds: 350),
                builder: (context, value, _) => CircularStepProgressIndicator(
                  totalSteps: 100,
                  currentStep: (value * 100).toInt(),
                  stepSize: 4,
                  selectedColor: FoodieColors.darkSecondary,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 100.w,
                  height: 100.h,
                  selectedStepSize: 6,
                  roundedCap: (_, __) => true,
                  child: Center(
                    child: Image.asset(
                      'assets/images/home/items/log.png',
                      height: 100.h,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                questions[3],
                style: TextStyle(
                  color: Colors.blueGrey.shade700, // color: Colors.red,
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0.w, top: 10.h, bottom: 30.h),
                child: SizedBox(
                  height: 220.h,
                  width: MediaQuery.of(context)
                      .size
                      .width, // Set a finite width here
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 150.h,
                          width: 150.w,
                          child: GestureDetector(
                            onTap: () {
                              if (FavCuisines.contains("Vegetarian")) {
                                FavCuisines.remove("Vegetarian");
                              } else {
                                FavCuisines.add("Vegetarian");
                              }
                              setState(() {});
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 150.h,
                                  width: 150.w,
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Colors.green,
                                      ),
                                      Positioned(
                                        left: 10.w,
                                        top: 10.h,
                                        child: Container(
                                          height: 130.h,
                                          width: 130.w,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0.w,
                                        right: 0.w,
                                        top: 30.h,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0.w,
                                        right: 0.w,
                                        top: 100.h,
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "VEG",
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FavCuisines.contains("Vegetarian")
                                    ? Stack(
                                        children: [
                                          SizedBox(
                                            height: 150.h,
                                            width: 150.w,
                                            child: Container(
                                              color: Colors.green,
                                            ),
                                          ),
                                          Positioned(
                                              left: 0.w,
                                              right: 0.w,
                                              top: 30.h,
                                              child: Image.asset(
                                                "assets/images/veg.png",
                                                height: 60.h,
                                              )),
                                          Positioned(
                                            left: 0.w,
                                            right: 0.w,
                                            top: 100.h,
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  "VEG",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150.h,
                          width: 150.w,
                          child: GestureDetector(
                            onTap: () {
                              if (FavCuisines.contains("Non-Vegetarian")) {
                                FavCuisines.remove("Non-Vegetarian");
                              } else {
                                FavCuisines.add("Non-Vegetarian");
                              }
                              setState(() {});
                              print(FavCuisines.toList());
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 150.h,
                                  width: 150.w,
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Colors.red,
                                      ),
                                      Positioned(
                                        left: 10.w,
                                        top: 10.h,
                                        child: Container(
                                          height: 130.h,
                                          width: 130.w,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0.w,
                                        right: 0.w,
                                        top: 30.h,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0.w,
                                        right: 0.w,
                                        top: 100.h,
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "NON VEG",
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FavCuisines.contains("Non-Vegetarian")
                                    ? Stack(
                                        children: [
                                          SizedBox(
                                            height: 150.h,
                                            width: 150.w,
                                            child: Container(
                                              color: Colors.red,
                                            ),
                                          ),
                                          Positioned(
                                              left: 0.w,
                                              right: 0.w,
                                              top: 30.h,
                                              child: Image.asset(
                                                "assets/images/nonveg.webp",
                                                height: 60.h,
                                              )),
                                          Positioned(
                                            left: 0.w,
                                            right: 0.w,
                                            top: 100.h,
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  "NON VEG",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pref3() {
    Map<String, Map<String, String>> categorizedData = Country;
    return Stack(
      children: [
        Positioned(
          top: 0.15.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0.0,
                    end: currentQuestionIndex == 1
                        ? 0.33
                        : currentQuestionIndex == 2
                            ? 0.66
                            : currentQuestionIndex == 3
                                ? 1
                                : 0),
                duration: const Duration(milliseconds: 350),
                builder: (context, value, _) => CircularStepProgressIndicator(
                  totalSteps: 100,
                  currentStep: (value * 100).toInt(),
                  stepSize: 4,
                  selectedColor: FoodieColors.darkSecondary,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 100.w,
                  height: 100.h,
                  selectedStepSize: 6,
                  roundedCap: (_, __) => true,
                  child: Center(
                    child: Image.asset(
                      'assets/images/home/items/log.png',
                      height: 100.h,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                questions[2],
                style: TextStyle(
                  color: Colors.blueGrey.shade700, // color: Colors.red,
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0.w, top: 10.h, bottom: 30.h),
                child: SizedBox(
                  height: 220.h,
                  width: MediaQuery.of(context)
                      .size
                      .width, // Set a finite width here
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 150.h,
                          width: 150.w,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (FavCuisines.contains("Healthy")) {
                                  FavCuisines.remove("Healthy");
                                  // FavCuisines.add("Healthy");
                                } else {
                                  FavCuisines.add("Healthy");
                                }
                                print(FavCuisines);
                              });
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 150.h,
                                  width: 150.w,
                                  child: Stack(
                                    children: [
                                      ClipOval(
                                        child: CircleAvatar(
                                          radius: 80,
                                          // Placeholder for the second widget with gradient color
                                          // Replace the placeholder with your desired gradient
                                          backgroundColor: Colors
                                              .transparent, // Ensure transparent background
                                          backgroundImage: AssetImage(
                                            'assets/images/home/heal.jpeg',
                                            // Or provide a different image
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black.withOpacity(0.3),
                                                  Colors.black.withOpacity(0.1),
                                                  Colors.black.withOpacity(0.3),
                                                ], // Example gradient colors
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      FavCuisines.contains('Healthy')
                                          ? ClipOval(
                                              child: CircleAvatar(
                                                radius: 100,
                                                backgroundColor:
                                                    FoodieColors.darkSecondary,
                                              ),
                                            )
                                          : Container(),
                                      ClipOval(
                                        child: CircleAvatar(
                                          radius: 100,
                                          backgroundColor: Colors.transparent,
                                          child: Text(
                                            "HEALTHY",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150.h,
                          width: 150.w,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (FavCuisines.contains("UnHealthy")) {
                                  FavCuisines.remove("UnHealthy");
                                  // FavCuisines.add("UnHealthy");
                                } else {
                                  FavCuisines.add("UnHealthy");
                                }
                              });
                              print(FavCuisines.toList());
                            },
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 80,
                                    backgroundImage: AssetImage(
                                      'assets/images/home/un.jpeg',
                                    ),
                                  ),
                                ),
                                ClipOval(
                                  child: CircleAvatar(
                                    radius: 80,
                                    // Placeholder for the second widget with gradient color
                                    // Replace the placeholder with your desired gradient
                                    backgroundColor: Colors
                                        .transparent, // Ensure transparent background
                                    backgroundImage: AssetImage(
                                      'assets/images/home/un.jpeg',
                                      // Or provide a different image
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.1),
                                            Colors.black.withOpacity(0.3),
                                          ], // Example gradient colors
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipOval(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 80,
                                    child: Text("Unhealthy"),
                                  ),
                                ),
                                FavCuisines.contains('UnHealthy')
                                    ? ClipOval(
                                        child: CircleAvatar(
                                          radius: 100,
                                          backgroundColor:
                                              FoodieColors.darkSecondary,
                                        ),
                                      )
                                    : Container(),
                                ClipOval(
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.transparent,
                                    child: Text(
                                      "UNHEALTHY",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.sp),
                                    ),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _pref4() {
    Map<String, Map<String, String>> categorizedData = Country;
    return Stack(
      children: [
        Positioned(
          top: 0.15.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0.0,
                    end: currentQuestionIndex == 1
                        ? 0.33
                        : currentQuestionIndex == 2
                            ? 0.66
                            : currentQuestionIndex == 3
                                ? 1
                                : 0),
                duration: const Duration(milliseconds: 350),
                builder: (context, value, _) => CircularStepProgressIndicator(
                  totalSteps: 100,
                  currentStep: (value * 100).toInt(),
                  stepSize: 4,
                  selectedColor: FoodieColors.darkSecondary,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 100.w,
                  height: 100.h,
                  selectedStepSize: 6,
                  roundedCap: (_, __) => true,
                  child: Center(
                    child: Image.asset(
                      'assets/images/home/items/log.png',
                      height: 100.h,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: 1.sw,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        questions[1],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey.shade700, // color: Colors.red,
                          fontSize: 24.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0.w, top: 10.h, bottom: 30.h),
                child: SizedBox(
                  height: 220.h,
                  width: MediaQuery.of(context)
                      .size
                      .width, // Set a finite width here
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (FavCuisines.contains("Beginner") ||
                                    FavCuisines.contains("Pro")) {
                                  FavCuisines.remove("Beginner");
                                  FavCuisines.remove("Pro");
                                  FavCuisines.add("Noob");
                                } else {
                                  FavCuisines.add("Noob");
                                }
                              });
                              print(FavCuisines.toList());
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          ClipOval(
                                            child: CircleAvatar(
                                              radius: 50,

                                              backgroundColor: Colors
                                                  .transparent, // Ensure transparent background
                                              child: FluentUiEmojiIcon(
                                                fl: Fluents
                                                    .flGrinningFaceWithSweat,
                                                w: FavCuisines.contains("Noob")
                                                    ? 130
                                                    : 80,
                                                h: FavCuisines.contains("Noob")
                                                    ? 130
                                                    : 80,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Noob",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (FavCuisines.contains("Noob") ||
                                    FavCuisines.contains("Pro")) {
                                  FavCuisines.remove("Noob");
                                  FavCuisines.remove("Pro");
                                  FavCuisines.add("Beginner");
                                } else {
                                  FavCuisines.add("Beginner");
                                }
                              });
                              print(FavCuisines.toList());
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          ClipOval(
                                            child: CircleAvatar(
                                              radius: 50,

                                              backgroundColor: Colors
                                                  .transparent, // Ensure transparent background
                                              child: FluentUiEmojiIcon(
                                                fl: Fluents.flWinkingFace,
                                                w: FavCuisines.contains(
                                                        "Beginner")
                                                    ? 130
                                                    : 80,
                                                h: FavCuisines.contains(
                                                        "Beginner")
                                                    ? 130
                                                    : 80,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Beginner",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (FavCuisines.contains("Noob") ||
                                    FavCuisines.contains("Beginner")) {
                                  FavCuisines.remove("Noob");
                                  FavCuisines.remove("Beginner");
                                  FavCuisines.add("Pro");
                                } else {
                                  FavCuisines.add("Pro");
                                }
                              });
                              print(FavCuisines.toList());
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          ClipOval(
                                            child: CircleAvatar(
                                              radius: 50,

                                              backgroundColor: Colors
                                                  .transparent, // Ensure transparent background
                                              child: FluentUiEmojiIcon(
                                                fl: Fluents
                                                    .flSmilingFaceWithSunglasses,
                                                w: FavCuisines.contains("Pro")
                                                    ? 130
                                                    : 80,
                                                h: FavCuisines.contains("Pro")
                                                    ? 130
                                                    : 80,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Pro",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 150.h,
                        //   width: 150.w,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       if (FavCuisines.contains("Healthy")) {
                        //         FavCuisines.remove("Healthy");
                        //         FavCuisines.add("UnHealthy");
                        //       } else {}
                        //       setState(() {});
                        //       print(FavCuisines.toList());
                        //     },
                        //     child: Stack(
                        //       children: [
                        //         ClipOval(
                        //           child: CircleAvatar(
                        //             radius: 80,

                        //             backgroundColor: Colors
                        //                 .transparent, // Ensure transparent background
                        //             child: FluentUiEmojiIcon(
                        //               fl: Fluents.fl1stPlaceMedal,
                        //               w: 40,
                        //               h: 35,
                        //             ),
                        //           ),
                        //         ),
                        //         // ClipOval(
                        //         //   child: CircleAvatar(
                        //         //     backgroundColor: Colors.transparent,
                        //         //     radius: 80,
                        //         //     child: Text("Unhealthy"),
                        //         //   ),
                        //         // ),
                        //         // FavCuisines.contains('UnHealthy')
                        //         //     ? ClipOval(
                        //         //         child: CircleAvatar(
                        //         //           radius: 100,
                        //         //           backgroundColor:
                        //         //               FoodieColors.darkSecondary,
                        //         //         ),
                        //         //       )
                        //         //     : Container(),
                        //         // ClipOval(
                        //         //   child: CircleAvatar(
                        //         //     radius: 100,
                        //         //     backgroundColor: Colors.transparent,
                        //         //     child: Text(
                        //         //       "UNHEALTHY",
                        //         //       style: TextStyle(
                        //         //           color: Colors.white, fontSize: 20.sp),
                        //         //     ),
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _pref3() {
  //   return Container(
  //     child: Text(
  //       questions[2],
  //       style: TextStyle(
  //         // color: Colors.red,
  //         fontSize: 24.0.sp,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }
}

class DashboardScreen extends StatefulWidget {
  final List<dynamic> recipes;
  const DashboardScreen({super.key, required this.recipes});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Adding a delay of 3 seconds before navigating to another screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: RecipieIndex(recipes: widget.recipes,),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable going back when the back button is pressed
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0x0000962e),
        body: Center(
          child: Lottie.asset(
            "assets/images/home/check.json",
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
        ),
      ),
    );
  }
}
