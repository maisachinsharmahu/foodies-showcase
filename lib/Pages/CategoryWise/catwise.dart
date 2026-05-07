import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/Pages/CategoryWise/herlper/helper.dart';
import 'package:foodie/Pages/DetailsPage/helpers/cap.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/Pages/Index/sections/Types/healthy.dart';
import 'package:foodie/Pages/ListPage/listpage.dart';
import 'package:foodie/Source/helper.dart';
import 'package:foodie/helper/colors.dart';
import 'package:page_transition/page_transition.dart';

class broadCat extends StatefulWidget {
  final List<dynamic> recipes;
  final Function() openDrawerCallback;
  final Map<String, dynamic> userData;
  const broadCat(
      {super.key,
      required this.recipes,
      required this.userData,
      required this.openDrawerCallback});

  @override
  State<broadCat> createState() => _broadCatState();
}

class _broadCatState extends State<broadCat> {
  List<Widget> shuffleItems(List<Widget> items) {
    List<Widget> shuffledList = List.from(items);
    shuffledList.shuffle();
    return shuffledList;
  }

  // "Hindi": {"name": "Hindi", "image": "assets/images/types/cat/amer.jpeg"},
  // "Hindi": {"name": "Hindi", "image": "assets/images/types/cat/amer.jpeg"},

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    // Add this function
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable going back when the back button is pressed
        // Perform the navigation here
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.fade,
            child: RecipieIndex(
              recipes: widget.recipes,
            ),
          ),
          (route) => false,
        );
        return false; // Return false to prevent default back navigation
      },
      child: Scaffold(
        key: _scaffoldKey,
        // drawer: drawerFoodie(
        //   recipes: widget.recipes,
        //   userData: widget.userData,
        //   closeDrawer: _closeDrawer,
        // ),
        // appBar: AppBar(
        //   title: Text("Categories"),
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(26.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Center the Row content
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                  duration: Duration(milliseconds: 400),
                                  type: PageTransitionType.fade,
                                  child: RecipieIndex(
                                    recipes: widget.recipes,
                                  ),
                                ),
                                (route) => false,
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
                        Bounceable(
                          onTap: widget.openDrawerCallback,
                          child: Icon(
                            Icons.segment,
                            size: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Entry.all(
                          visible: true,
                          // xOffset: 1000,
                          // yOffset: 0,
                          duration: const Duration(milliseconds: 400),
                          child: items(
                            userData: widget.userData,
                            categorizedData: Country,
                            name: "Cuisine",
                            recipes: widget.recipes,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Don't know English?",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                "No Problem",
                                style: TextStyle(
                                    // fontSize: 24.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0.w),
                          child: Bounceable(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 300),
                                      child: listPage(
                                        userData: widget.userData,
                                        recipes: shuffleRecipes(
                                            filterRecipesByHindi(
                                                widget.recipes)),
                                        name: 'Hindi',
                                      ),
                                      type: PageTransitionType.fade));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => listPage(
                              //               recipes: shuffleRecipes(
                              //                   filterRecipesByType(
                              //                       widget.recipes, 'hindi')),
                              //               name: 'Hindi',
                              //             )));
                            },
                            child: Entry.all(
                              visible: true,
                              duration: const Duration(milliseconds: 400),
                              child: itsItems2(
                                  photo: "assets/images/types/cat/Hindi.jpeg",
                                  name: "Hindi"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0.w),
                          child: healthy(
                            recipes: widget.recipes,
                            userData: widget.userData,
                          ),
                        ),
                        Entry.all(
                          visible: true,
                          // xOffset: 1000,
                          // yOffset: 0,
                          duration: const Duration(milliseconds: 400),
                          child: items(
                            userData: widget.userData,
                            recipes: widget.recipes,
                            categorizedData: Festival,
                            name: "Festival",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cooking for Kids?",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                "Kids Special",
                                style: TextStyle(
                                    // fontSize: 24.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0.w),
                          child: Bounceable(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  duration: Duration(milliseconds: 300),
                                  child: listPage(
                                    userData: widget.userData,
                                    recipes: shuffleRecipes(filterRecipesByType(
                                        widget.recipes, 'kids')),
                                    name: 'Kids',
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Entry.all(
                              visible: true,
                              // xOffset: 1000,
                              // yOffset: 0,
                              duration: const Duration(milliseconds: 400),
                              child: itsItems2(
                                  photo: "assets/images/types/cat/kids.jpeg",
                                  name: "Kids Special"),
                            ),
                          ),
                        ),
                        Entry.all(
                          visible: true,
                          // xOffset: 1000,
                          // yOffset: 0,
                          duration: const Duration(milliseconds: 400),
                          child: items(
                            userData: widget.userData,
                            recipes: widget.recipes,
                            categorizedData: Meal_Type,
                            name: "Meal Type",
                          ),
                        ),
                        Entry.all(
                          visible: true,
                          // xOffset: 1000,
                          // yOffset: 0,
                          duration: const Duration(milliseconds: 400),
                          child: items(
                            userData: widget.userData,
                            recipes: widget.recipes,
                            categorizedData: Ingredient_Item,
                            name: "By Ingredients",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Looking For Party Recipes?",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                "We have something",
                                style: TextStyle(
                                    // fontSize: 24.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0.w),
                          child: Bounceable(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  duration: Duration(milliseconds: 300),
                                  child: listPage(
                                    userData: widget.userData,
                                    recipes: shuffleRecipes(filterRecipesByType(
                                        widget.recipes, 'party')),
                                    name: 'Party',
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: itsItems2(
                                photo: "assets/images/types/cat/party.jpeg",
                                name: "Party Special"),
                          ),
                        ),
                        Entry.all(
                          visible: true,
                          // xOffset: 1000,
                          // yOffset: 0,
                          duration: const Duration(milliseconds: 400),
                          child: items(
                            userData: widget.userData,
                            recipes: widget.recipes,
                            categorizedData: Season,
                            name: "Season",
                          ),
                        ),
                      ]

                      // items(),

                      ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class items extends StatefulWidget {
  final Map<String, dynamic> userData;
  final List<dynamic> recipes;
  final Map<String, Map<String, String>> categorizedData;
  final String name;

  const items(
      {super.key,
      required this.categorizedData,
      required this.name,
      required this.recipes,
      required this.userData});

  @override
  State<items> createState() => _itemsState();
}

class _itemsState extends State<items> {
  bool isListView = true; // Track current view mode

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          children: [
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                isListView ? Icons.more_vert : Icons.more_horiz,
                size: 32.sp,
              ), // Change icon based on view mode
              onPressed: () {
                setState(() {
                  isListView = !isListView; // Toggle view mode
                });
              },
            ),
          ],
        ),
      ),
      isListView
          ? SizedBox(
              height: 190.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categorizedData.length,
                itemBuilder: (context, index) {
                  String cuisineName =
                      widget.categorizedData.keys.elementAt(index);
                  Map<String, String> cuisineInfo =
                      widget.categorizedData[cuisineName]!;
                  return Padding(
                    padding: EdgeInsets.only(left: 10.0.w),
                    child: Bounceable(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 300),
                            child: listPage(
                              userData: widget.userData,
                              recipes: shuffleRecipes(
                                filterRecipesByType(
                                  widget.recipes,
                                  cuisineInfo['name'] == 'Tea Time'
                                      ? 'tea-time'
                                      : cuisineInfo['name'] == 'Indonesian'
                                          ? 'indonesian'
                                          : cuisineInfo['name'] == 'Vietnamese'
                                              ? 'vietnamese'
                                              : capitalizeFirstLetter(
                                                  '${cuisineInfo['name']}'),
                                ),
                              ),
                              name: '${cuisineInfo['name']}',
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      child: itsItems(
                        recipes: widget.recipes,
                        photo: cuisineInfo['image']!,
                        name: capitalizeFirstLetter(" ${cuisineInfo['name']}"),
                      ),
                    ),
                  );
                },
              ))
          : Column(
              children: widget.categorizedData.entries.map((entry) {
                String cuisineName = entry.key;
                String photo = entry.value['image']!;
                String name = entry.value['name']!;
                return Padding(
                  padding: EdgeInsets.only(left: 10.0.w),
                  child: Column(
                    children: [
                      Bounceable(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => listPage(
                                        userData: widget.userData,
                                        recipes: shuffleRecipes(
                                            filterRecipesByType(
                                                widget.recipes,
                                                name == 'Tea Time'
                                                    ? 'tea-time'
                                                    : name)),
                                        name: 'capitalizeFirstLetter($name)',
                                      )));
                        },
                        child: itsItems2(
                          photo: photo,
                          name: capitalizeFirstLetter(
                            name,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    ]);
  }
}

class itsItems extends StatelessWidget {
  final List<dynamic> recipes;
  final String photo;
  final String name;
  const itsItems(
      {super.key,
      required this.photo,
      required this.name,
      required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Material(
              borderRadius: BorderRadius.circular(20.r),
              elevation: 7,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                height: 150.h,
                width: 0.4.sw,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    photo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          name,
          style: TextStyle(
              fontFamily: 'metropolis',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class itsItems2 extends StatelessWidget {
  final String photo;
  final String name;
  const itsItems2({super.key, required this.photo, required this.name});

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
            height: 180.h,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                photo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
          height: 180.h,
          width: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          height: 180.h,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontSize: 28.sp,
                      letterSpacing: 2
                      ),
                ),
                name == 'Explore More'
                    ? Column(
                        children: [
                          Image.asset(
                            'assets/images/types/down.png',
                            height: 80.h,
                            color: Colors.white,
                          )
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
