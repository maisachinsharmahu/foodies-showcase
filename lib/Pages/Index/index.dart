import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/CategoryWise/catwise.dart';
import 'package:foodie/Pages/Index/index_ke_baar.dart';
import 'package:foodie/Pages/SideBarPages/Favourites.dart';
import 'package:foodie/Pages/search/search.dart';
import 'package:foodie/Source/helper.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/drawer.dart';
import 'package:gif_view/gif_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PapaHuPapa extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  const PapaHuPapa({super.key, this.arguments});

  @override
  _PapaHuPapaState createState() => _PapaHuPapaState();
}

class _PapaHuPapaState extends State<PapaHuPapa> {
  List<dynamic> recipes = [];
  List<dynamic> recommendedRecipes = [];
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  bool gifFinished = false;
  final int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loadUserData();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        loadRecipes();
      }
    });
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');
    print("`1`");
    Map<String, dynamic> mergedUserData = {};
    // setState(() {

    // });
    if (userDataJson != null) {
      mergedUserData = json.decode(userDataJson);
    }
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    print(connectivityResult.contains(ConnectivityResult.none));
    print("`2`");
    // print(mergedUserData);

    if (connectivityResult.contains(ConnectivityResult.none)) {
        // Handle offline here
    }
  }

  Future<void> loadRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('recipes');
    if (savedData != null) {
      loadUserData().then((_) {
        setState(() {
          recipes = json.decode(savedData);
          print("from asset");
          Provider.of<RecommendedRecipesProvider>(context, listen: false)
              .setRecommendedRecipes(shuffleRecipes(recipes), userData);
          print(isLoading);
          isLoading = false;
          Navigator.pushReplacement(
              context,
              PageTransition(
                duration: const Duration(milliseconds: 1500),
                type: PageTransitionType.rightToLeftWithFade,
                child: RecipieIndex(recipes: recipes),
              ));
          print(isLoading);
        });
      });
    } else {
      print("from asset");
      print("from1asset");
      print("from 2asset");
      print("from 3asset");
      print("from a4sset");
      print("from asset");
      print("from as5set");
      print("from ass6et");
      try {
        String data = await DefaultAssetBundle.of(context)
            .loadString('assets/finally.json');
        final decodedRecipes = json.decode(data);
        setState(() {
          recipes = decodedRecipes;
          isLoading = false;
          Navigator.pushReplacement(
              context,
              PageTransition(
                duration: const Duration(milliseconds: 1500),
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: RecipieIndex(recipes: recipes),
              ));
          Provider.of<RecommendedRecipesProvider>(context, listen: false)
              .setRecommendedRecipes(shuffleRecipes(recipes), userData);
        });
        prefs.setString('recipes', data);
      } catch (e) {
        print("Error loading recipes: $e");
      }
    }
  }

  void navigateToRecipeIndexPage() {
    setState(() {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 1000),
          type: PageTransitionType.scale,
          alignment: Alignment.bottomCenter,
          child: RecipieIndex(recipes: recipes),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = GifController();
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 300), // Adjust duration as needed
        child:
            // !isLoading
            //     ?
            Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: GifView.asset(
                  'assets/images/bg.png',
                  controller: controller,
                  loop: false,
                  onFinish: () {},
                  fit: BoxFit.fitHeight,
                ),
              ),
              Entry.all(
                visible: true,
                duration: const Duration(seconds: 1),
                child: Center(
                  child: Image.asset(
                    'assets/images/foo2 copy.gif',
                  ),
                ),
              ),
              Entry.offset(
                visible: true,
                duration: const Duration(seconds: 2),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                        left: 0.w,
                        right: 0.w,
                        bottom: 20.h,
                        child: Column(
                          children: [
                            Text(
                              "By",
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 18.sp),
                            ),
                            Text(
                              "Sachin Sharma",
                              style: TextStyle(
                                  fontFamily: 'Kalam',
                                  fontSize: 28.sp,
                                  color: FoodieColors.darkSecondary),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        )
        );
  }
}

class RecommendedRecipesProvider extends ChangeNotifier {
  List<dynamic> _recommendedRecipes = [];

  List<dynamic> get recommendedRecipes => _recommendedRecipes;

  void setRecommendedRecipes(
      List<dynamic> recipes, Map<String, dynamic> userData) {

    if (userData != null && userData['preference'] != null) {
      List<String> preferences = List<String>.from(userData['preference']);

      bool hasIndianPreference = preferences.contains('Indian');

      if (!hasIndianPreference) {
        preferences.add('Indian');
        preferences.add('brunch');
        preferences.add('snacks');
        preferences.add('tea-time');
        userData['preference'] = preferences;
      }

      _recommendedRecipes = recipes;

    } else {
      _recommendedRecipes = recipes;
    }
    notifyListeners();
  }
}

class RecipieIndex extends StatefulWidget {
  final List<dynamic> recipes;
  final int? selected;
  const RecipieIndex({super.key, this.selected, required this.recipes});

  @override
  State<RecipieIndex> createState() => _RecipieIndexState();
}

class _RecipieIndexState extends State<RecipieIndex> {
  List<dynamic> recipes = [];
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (widget.selected != null) {
      _selectedIndex = widget.selected ?? 0;
    }
    recipes = widget.recipes;
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');
    Map<String, dynamic> mergedUserData = {};

    if (userDataJson != null) {
      mergedUserData = json.decode(userDataJson);
    }
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

  }

  void _openDrawer() async {
    loadUserData();
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      indexKeBaad(
        openDrawerCallback: _openDrawer,
        userData: userData,
        recipes: recipes,
      ),
      broadCat(
        openDrawerCallback: _openDrawer,
        recipes: recipes,
        userData: userData,
      ),
      favouritesPage(
        openDrawerCallback: _openDrawer,
        recipes: recipes,
        userData: userData,
      ),
      searchPage(
        recipes: recipes,
        userData: userData,
      ),
    ];

    return recipes.isEmpty
        ? Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(30.0.w),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 0.7.sw,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Image.asset(
                          'assets/images/somthingwentwrong.png',
                          width: 0.8.sw,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Restart.restartApp();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(20.r)),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Text(
                              "Restart App",
                              style: TextStyle(
                                  fontSize: 26.sp,
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: drawerFoodie(
              openDrawerCallback: _openDrawer,
              recipes: recipes,
              userData: userData,
              closeDrawer: _closeDrawer,
            ),
            body: pages.elementAt(_selectedIndex),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: Colors.grey.shade100,
              buttonBackgroundColor: const Color.fromRGBO(208, 225, 215, 1),
              height: 60.h,
              items: [
                Icon(
                  Iconsax.home,
                  size: 30.sp,
                ),
                Icon(Iconsax.category, size: 30.sp),
                Icon(Iconsax.heart, size: 30.sp),
                Icon(Iconsax.search_favorite_1, size: 30.sp),
              ],
              onTap: _onItemTapped,
              index: _selectedIndex,
            ),
          );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

// class RecipieIndex extends StatefulWidget {
//   const RecipieIndex({Key? key}) : super(key: key);

//   @override
//   State<RecipieIndex> createState() => _RecipieIndexState();
// }

// class _RecipieIndexState extends State<RecipieIndex> {
//   List<dynamic> recipes = [];
//   Map<String, dynamic> userData = {};
//   bool isLoading = true;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     loadRecipes();
//     loadUserData();
//   }

//   Future<void> loadDataFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userDataJson = prefs.getString('userData');

//     if (userDataJson != null) {
//       setState(() {
//         userData = json.decode(userDataJson);
//       });
//     }
//   }

//   Future<void> loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userDataJson = prefs.getString('userData');

//     Map<String, dynamic> mergedUserData = {};

//     if (userDataJson != null) {
//       mergedUserData = json.decode(userDataJson);
//     }
//     print(mergedUserData);

//     User? user = FirebaseServices.authInstance.currentUser;
//     if (user != null) {
//       DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
//           await FirebaseServices.getUserData(user.uid);

//       if (userDataSnapshot.exists) {
//         Map<String, dynamic> userDataMap = userDataSnapshot.data() ?? {};

//         // Convert Timestamp objects to formatted string
//         userDataMap.forEach((key, value) {
//           if (value is Timestamp) {
//             DateTime dateTime = value.toDate();
//             // Format the DateTime object into a string in a standard format
//             userDataMap[key] = dateTime.toIso8601String();
//           }
//         });

//         mergedUserData.addAll(userDataMap);
//         print(userData);
//         setState(() {
//           userData = mergedUserData;
//           prefs.setString(
//               'userData', json.encode(userData)); // Save updated data
//         });
//       }
//     }
//   }

//   Future<void> loadRecipes() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedData = prefs.getString('recipes');
//     if (savedData != null) {
//       setState(() {
//         recipes = json.decode(savedData);
//         isLoading = false;
//       });
//     } else {
//       try {
//         String data = await DefaultAssetBundle.of(context)
//             .loadString('assets/finally.json');
//         setState(() {
//           recipes = json.decode(data);
//           isLoading = false;
//         });
//         prefs.setString('recipes', data);
//       } catch (e) {
//         print("Error loading recipes: $e");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       // Show loading indicator while recipes are loading
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else {
//       List<Widget> _pages = <Widget>[
//         indexKeBaad(
//           recipes: recipes,
//         ),
//         broadCat(recipes: recipes),
//         favouritesPage(
//           recipes: recipes,
//           userData: userData,
//         ),
//         searchPage(recipes: recipes),
//       ];

//       return Scaffold(
//         body: _pages.elementAt(_selectedIndex),
//         bottomNavigationBar: NavigationBar(
//           backgroundColor: Colors.white,
//           indicatorColor: Color.fromRGBO(208, 225, 215, 1),
//           // height: 70.h,
//           destinations: [
//             NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
//             NavigationDestination(
//                 icon: Icon(Iconsax.category), label: 'Categories'),
//             NavigationDestination(
//                 icon: Icon(Iconsax.heart), label: 'Favourite'),
//             NavigationDestination(
//                 icon: Icon(Iconsax.search_favorite_1), label: 'Search'),
//           ],
//           onDestinationSelected: _onItemTapped,
//           selectedIndex: _selectedIndex,
//         ),
//       );
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
// }
