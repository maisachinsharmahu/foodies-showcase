import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:convert';
// import 'dart:html';
// import 'dart:html';
import 'dart:math';

import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/Index/helper/mater/dia.dart';
import 'package:foodie/Pages/Index/helper/mater/wid.dart';
import 'package:foodie/Pages/Index/sections/BasedOnInitial/based.dart';
import 'package:foodie/Pages/Index/sections/Recommended/recommend.dart';
import 'package:foodie/Pages/Index/sections/Types/festival.dart';
import 'package:foodie/Pages/Index/sections/top.dart';
import 'package:foodie/Pages/Index/sections/top.dart';
import 'package:foodie/Pages/preference/preference.dart';
import 'package:foodie/helper/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Step 1: Create a Provider class
class ActionStatusProvider with ChangeNotifier {
  bool actionPerformed = false;

  void setActionPerformed(bool value) {
    actionPerformed = value;
    notifyListeners(); // Notify listeners of state change
  }
}

class homePageMain extends StatefulWidget {
  final List<dynamic> recipes;
  final Function() openDrawerCallback;
  // final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  const homePageMain({
    super.key,
    required this.recipes,
    required this.userData,
    required this.openDrawerCallback,
  });

  @override
  State<homePageMain> createState() => _homePageMainState();
}

class _homePageMainState extends State<homePageMain> {
  List<dynamic> recipes = [];
  Map<String, dynamic> userData = {};

  // Inside _homePageMainState class
  late Timer _popupTimer;
  bool isWidgetBuilt = false;
  late final Future<void> _delayedFuture;
  @override
  void initState() {
    _delayedFuture = Future.delayed(const Duration(milliseconds: 700));
    loadDataFromSharedPreferences();
    super.initState();
    final actionStatusProvider = Provider.of<ActionStatusProvider>(
      context,
      listen: false,
    );
    // Removed loadUserData() call.
    // Generate a random delay between 7 and 20 seconds
    int randomDelaySeconds = (Random().nextInt(14) + 7);
    print(randomDelaySeconds);
    // Assign the Timer to the variable
    _popupTimer = Timer(Duration(seconds: randomDelaySeconds), () {
      // Check if the widget is still mounted before calling setState

      if (mounted) {
        setState(() {
          // Check if 'preference' is null or not present in userData
          if (!actionStatusProvider.actionPerformed) {
            if (userData['preference'] == null ||
                !userData.containsKey('preference')) {
              Dialogs.materialDialog(
                color: Colors.white,
                msg:
                    'Choose your dietary restrictions and cuisine preferences to personalize your recipe feed.',
                title: 'Set Your Food Preferences',
                lottieBuilder: Lottie.asset(
                  'assets/images/home/lot1.json',
                  fit: BoxFit.contain,
                ),
                context: context,
                actions: [
                  IconsOutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'Not Now',
                    iconData: Icons.close,
                    textStyle: TextStyle(color: Colors.grey),
                    iconColor: Colors.grey,
                  ),
                  IconsButton(
                    shape: btnShape,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 300),
                          child: PreferencePage(
                            // userData
                            userData: widget.userData,
                            recipes: widget.recipes,
                          ),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                    text: 'Let\'s Go',
                    iconData: Icons.done,
                    color: FoodieColors.darkSecondary,
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                ],
              );
            }
          }
          actionStatusProvider.setActionPerformed(true);
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isWidgetBuilt = true;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer in dispose
    _popupTimer.cancel();
    super.dispose();
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      setState(() {
        userData = json.decode(userDataJson);
      });
    }
  }

  Future<void> loadUserData() async {
    await loadDataFromSharedPreferences();
  }

  bool _isBoolFalse = false;
  void setBoolToFalse() {
    setState(() {
      _isBoolFalse = !_isBoolFalse;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget basedOnInitialChoiceWidget = Entry.offset(
      xOffset: 1000,
      yOffset: 0,
      visible: isWidgetBuilt, // Show only when widget is fully built
      duration: const Duration(milliseconds: 1000),
      child: basedOnInitialChoice(
        callback: setBoolToFalse,
        recipes: widget.recipes,
        userData: widget.userData,
        openDrawerCallback: widget.openDrawerCallback,
      ),
    );
    //  final message = ModelRoute.of(context)!.settings;
    return IgnorePointer(
      ignoring: _isBoolFalse,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Opacity(
              opacity: _isBoolFalse ? 0.6 : 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topSection(
                    name: userData['firstName'],
                    openDrawerCallback: widget.openDrawerCallback,
                    recipes: widget.recipes,
                    userData: userData,
                  ),

                  SizedBox(height: 10.h),
                  Entry.offset(
                    visible: true,
                    xOffset: 1000,
                    yOffset: 0,
                    duration: const Duration(milliseconds: 700),
                    child: Festival(
                      recipes: widget.recipes,
                      userData: widget.userData,
                    ),
                  ),

                  Entry.offset(
                    visible: true,
                    duration: const Duration(milliseconds: 700),
                    xOffset: 1000,
                    yOffset: 0,
                    child: RecommendedSection(
                      userData: widget.userData,
                      recipes: widget.recipes,
                    ),
                  ),
                  FutureBuilder(
                    future: _delayedFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Entry.offset(
                          xOffset: 1000,
                          yOffset: 0,
                          visible: true,
                          duration: const Duration(milliseconds: 1000),
                          child: basedOnInitialChoiceWidget,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
            if (_isBoolFalse)
              Positioned(
                left: 0.w,
                right: 0.w,
                bottom: 0.3.sh,
                child: Center(
                  child: Lottie.asset(
                    'assets/images/home/loadmore.json',
                    width: 300.w,
                    height: 300.h,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
