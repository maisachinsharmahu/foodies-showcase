// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:foodie/Pages/CategoryWise/category.dart';
// import 'package:foodie/Pages/CategoryWise/catwise.dart';
// import 'package:foodie/Pages/Index/helper/loadtop.dart';
// import 'package:foodie/Pages/Index/index_ke_baar.dart';
// import 'package:foodie/Pages/Index/sections/mainsection.dart';
// import 'package:foodie/Pages/Index/sections/top.dart';
// import 'package:foodie/Pages/SideBarPages/Favourites.dart';
// import 'package:foodie/Pages/login/Google_services/firebase_services.dart';
// import 'package:foodie/Pages/login/login.dart';
// import 'package:foodie/Pages/search/search.dart';
// import 'package:foodie/helper/colors.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stylish_bottom_bar/model/bar_items.dart';
// import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

// class RecipieIndex extends StatefulWidget {
//   const RecipieIndex({Key? key}) : super(key: key);

//   @override
//   State<RecipieIndex> createState() => _RecipieIndexState();
// }

// class _RecipieIndexState extends State<RecipieIndex> {
//   List<dynamic> recipes = [];
//   Map<String, dynamic> userData = {};
//   bool isLoading = false;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     loadRecipes();
//     // loadDataFromSharedPreferences();
//     print("HI");
//     // loadUserData();
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
//     print('a gya nahi h');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedData = prefs.getString('recipes');
//     if (savedData != null) {
//       setState(() {
//         print('sace nahi h');
//         recipes = json.decode(savedData);
//         isLoading = false;
//       });
//     } else {
//       try {
//         print('sace  h');
//         String data = await DefaultAssetBundle.of(context)
//             .loadString('assets/finally.json');
//         setState(() {
//           print('sace  h2');
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
//           userData: userData,
//           recipes: recipes,
//           // favlist: userData['favorite'],
//         ),
//         searchPage(recipes: recipes),
//       ];

//       return Scaffold(
//         body: _pages.elementAt(_selectedIndex),
//         bottomNavigationBar: NavigationBar(
//           animationDuration: Duration(microseconds: 100),
//           elevation: 3,
//           shadowColor: Colors.white,
//           backgroundColor: Colors.white,
//           indicatorColor: Color.fromRGBO(208, 225, 215, 1),
//           // height: 70.h,
//           destinations: [
//             NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
//             NavigationDestination(
//                 icon: Icon(Iconsax.category), label: 'Categories'),
//             NavigationDestination(
//                 icon: Icon(Iconsax.heart), label: 'Favourites'),
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

//         //     BottomNavigationBar(
//         //   items: const <BottomNavigationBarItem>[
//         //     BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
//         //     BottomNavigationBarItem(
//         //         icon: Icon(Icons.category), label: 'Categories'),
//         //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//         //   ],
//         //   currentIndex: _selectedIndex,
//         //   onTap: _onItemTapped,
//         // ),

//         // StylishBottomBar(
//             //   items: [
//             //     BottomBarItem(
//             //         selectedColor: FoodieColors.darkSecondary,
//             //         backgroundColor: FoodieColors.darkSecondary,
//             //         icon: const Icon(
//             //           Icons.house_outlined,
//             //         ),
//             //         title: Text('Home'),
//             //         selectedIcon: Lottie.asset('assets/images/home_bot.json')),
//             //     BottomBarItem(
//             //         selectedColor: FoodieColors.darkSecondary,
//             //         backgroundColor: FoodieColors.darkSecondary,
//             //         icon: Icon(
//             //           Icons.search,
//             //         ),
//             //         title: Text('Categories')),
//             //     BottomBarItem(
//             //       icon: Icon(Icons.search),
//             //       title: Text('Search'),
//             //       selectedColor: FoodieColors.darkSecondary,
//             //       backgroundColor: FoodieColors.darkSecondary,
//             //     ),
//             //   ],
//             //   option: AnimatedBarOptions(
//             //     barAnimation: BarAnimation.fade,
//             //     iconStyle:
//             //         IconStyle.animated, // Set IconStyle to IconStyle.animated
//             //     // Other options as needed
//             //   ),
//             //   currentIndex: _selectedIndex,
//             //   onTap: _onItemTapped,
//             // ),

// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:foodie/Source/helper.dart';
// // // import 'recipe_helper.dart';  // Import the helper file

// // class lkasndlsandlnsaln extends StatefulWidget {
// //   const lkasndlsandlnsaln({super.key});

// //   @override
// //   State<lkasndlsandlnsaln> createState() => _RecipeIndexState();
// // }

// // class _RecipeIndexState extends State<lkasndlsandlnsaln> {
// //   List<dynamic> recipes = []; // Store the decoded JSON data here

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadRecipes(); // Load recipes when the widget initializes
// //   }

// //   Future<void> loadRecipes() async {
// //     // Load JSON file from assets
// //     String data =
// //         await DefaultAssetBundle.of(context).loadString('assets/finally.json');
// //     setState(() {
// //       // Decode the JSON data and update the state
// //       recipes = json.decode(data);
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Recipes'),
// //       ),
// //       body: Column(
// //         children: [
// //           ElevatedButton(
// //             onPressed: () {
// //               // Example of using filterRecipesByType function
// //               List<dynamic> breakfastRecipes =
// //                   filterRecipesByType(recipes, 'diwali');
// //               // Do something with filtered recipes...
// //               print(breakfastRecipes.length);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //               print(breakfastRecipes);
// //             },
// //             child: Text('Filter Breakfast Recipes'),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: recipes.length,
// //               itemBuilder: (BuildContext context, int index) {
// //                 final recipe = recipes[index];
// //                 return ListTile(
// //                   title: Text(recipe['Name']),
// //                   onTap: () {
// //                     // Navigate to recipe details page passing the recipe data
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => RecipeDetails(recipe: recipe),
// //                       ),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // RecipeDetails class...

// // class RecipeDetails extends StatelessWidget {
// //   final dynamic recipe;

// //   const RecipeDetails({super.key, this.recipe});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(recipe['Name']),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(16.0.w),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Image.network(recipe['Image']),
// //             SizedBox(height: 16.0.h),
// //             Text('Total Time: ${recipe['Total Time']}'),
// //             Text('Prep Time: ${recipe['Prep Time']}'),
// //             Text('Cook Time: ${recipe['Cook Time']}'),
// //             Text('Recipe Servings: ${recipe['Recipe Servings']}'),
// //             Text('Difficulty: ${recipe['Difficulty']}'),
// //             SizedBox(height: 16.0.h),
// //             Text('Ingredients:',
// //                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: (recipe['Ingredients']['Ingredients'] as List<dynamic>)
// //                   .map((ingredient) {
// //                 return Text('- $ingredient');
// //               }).toList(),
// //             ),
// //             SizedBox(height: 16.0.h),
// //             Text('Steps:',
// //                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: (recipe['Steps'] as List<dynamic>).map((step) {
// //                 return Text('- $step');
// //               }).toList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Helper functions
// // // List<dynamic> filterssRecipesByType(List<dynamic> recipes, String type) {
// // //   return recipes.where((recipe) => recipe['type'].contains(type)).toList();
// // // }

// // Map<String, dynamic> getRecipeDetails(dynamic recipe) {
// //   return {
// //     'Name': recipe['Name'],
// //     'Total Time': recipe['Total Time'],
// //     'Prep Time': recipe['Prep Time'],
// //     'Cook Time': recipe['Cook Time'],
// //     'Recipe Servings': recipe['Recipe Servings'],
// //     'Difficulty': recipe['Difficulty'],
// //     'Ingredients': recipe['Ingredients']['Ingredients'],
// //     'Steps': recipe['Steps'],
// //   };
// // }
