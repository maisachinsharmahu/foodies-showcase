import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/Pages/DetailsPage/details.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/Pages/ListPage/toast.dart';
import 'package:foodie/Source/helper.dart';
import 'package:foodie/helper/addtofav.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/recipe_tracking.dart';
import 'package:foodie/main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // Import speech_to_text package

class searchPage extends StatefulWidget {
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  final String? name;
  const searchPage({
    super.key,
    this.name,
    required this.recipes,
    required this.userData,
  });

  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  List<dynamic> Myrecipes = [];
  bool _isfullmode = false;
  bool _isLoading = false;
  List<dynamic> suggestions = [];
  final TextEditingController _textEditingController = TextEditingController();
  final stt.SpeechToText _speech =
      stt.SpeechToText(); // Initialize SpeechToText instance
  bool _isListening = false;

  @override
  void initState() {
    _textEditingController.text = widget.name ?? '';
    updateSuggestions(widget.name ?? '');
    Myrecipes = widget.recipes;
    super.initState();
    FavoriteFunctions.fetchFavoriteRecipes();
  }

  // if (query.isEmpty) {
  //       setState(() {
  //         suggestions = [];
  //       });
  //     } else {
  //       setState(() {
  //         suggestions = filterRecipesByName(widget.recipes, query);
  //       });
  //     }
  void updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });
    } else {
      List<dynamic> nameFilteredRecipes = filterRecipesByName(Myrecipes, query);
      List<dynamic> typeFilteredRecipes = filterRecipesBymanyTypes3(Myrecipes, [
        query,
      ]); // Assuming query as type here

      // Merge the results
      Set<dynamic> mergedResults = {};
      mergedResults.addAll(nameFilteredRecipes);
      mergedResults.addAll(typeFilteredRecipes);
      // Convert set to list
      List<dynamic> mergedList = mergedResults.toList();

      // Shuffle the list

      // mergedList.shuffle(Random());
      setState(() {
        suggestions = mergedList;
      });
    }
  }

  void _startListening() async {
    if (!mounted) return; // Check if the widget is still mounted

    if (_isListening) {
      // Stop listening if already listening
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
      return;
    }

    // Check microphone permission
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Show a Snackbar with a button to navigate to app settings
      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.rightSlide,
        title: 'Microphone Permission Required',
        desc:
            'Please enable microphone permission in app settings to use this feature.',
        btnOkText: "Settings",
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          openAppSettings();
        },
      ).show();
      return; // Exit if permission not granted
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() {
            _isListening = false;
            print(status);
          });
        }
        print('Listening status: $status');
      },
      onError: (error) {
        if (!mounted) return; // Check if the widget is still mounted
        _isListening = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech recognition error'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );

    if (!mounted) return; // Check if the widget is still mounted

    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        onResult: (result) {
          if (!mounted) return; // Check if the widget is still mounted
          setState(() {
            _textEditingController.text = result.recognizedWords;
            updateSuggestions(result.recognizedWords);
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 300),
            type: PageTransitionType.fade,
            child: RecipieIndex(recipes: widget.recipes),
          ),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: Text('Recipe Search'),
        //   actions: [
        //     // IconButton(
        //     //   icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
        //     //   onPressed: () {
        //     //     _startListening();
        //     //   },
        //     // ),
        //     // IconButton(
        //     //   icon: Icon(Icons.filter_list),
        //     //   onPressed: () {},
        //     // ),
        //   ],
        // ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isLoading = true; // Show the loading GIF
            });

            // Simulate a 2-second delay
            await Future.delayed(Duration(seconds: 2));

            // Update suggestions
            updateSuggestions(_textEditingController.text);

            setState(() {
              _isLoading = false; // Hide the loading GIF
            });
          },
          child: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  height: 1.sh,
                  width: 1.sw,
                  child: Image.asset(
                    'assets/images/bg.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Opacity(
                  opacity: _isLoading || _isListening ? 0.4 : 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      duration: Duration(milliseconds: 300),
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
                              "Recipe Search",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                // fontWeig/ht: FontWeight.w500,
                                color: Colors.black,
                                // fontFamily: 'Poppins',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Simulate a 2-second delay

                                // Update suggestions
                                updateSuggestions(_textEditingController.text);
                              },
                              child: Icon(Icons.refresh),
                            ),
                            // CircleAvatar(
                            //   radius: 18,
                            //   backgroundColor: Colors.transparent,
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 0.78.sw,
                              height: 50.h,
                              child: TextField(
                                cursorColor: FoodieColors.darkSecondary,
                                controller: _textEditingController,
                                onChanged: (query) {
                                  if (query == '') {
                                    Myrecipes.shuffle(Random());
                                    updateSuggestions('');
                                  } else if (query == ' ') {
                                    updateSuggestions('');
                                  } else if (query == '  ') {
                                    updateSuggestions('');
                                  } else if (query == '   ') {
                                    updateSuggestions('');
                                  } else if (query == '    ') {
                                    updateSuggestions('');
                                  } else {
                                    updateSuggestions(query.trim());
                                  }
                                },
                                decoration: InputDecoration(
                                  focusColor: FoodieColors.darkSecondary,
                                  prefixIcon: Icon(Icons.search),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      updateSuggestions("");
                                      _textEditingController.clear();
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                  filled: true,

                                  fillColor: Colors.grey[200],
                                  hintText: "Search 15000+ Recipes",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Poppins',
                                    fontSize: 14.sp,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 14.h,
                                  ), // Adjust the vertical padding as needed

                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    duration: Duration(milliseconds: 300),
                                    child: searchPage(
                                      userData: widget.userData,
                                      name: _textEditingController.text,
                                      recipes: widget.recipes,
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 0.15.sw,
                                decoration: BoxDecoration(
                                  color: FoodieColors.darkSecondary,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                // color: FoodieColors.darkSecondary,
                                child: IconButton(
                                  icon: Icon(
                                    _isListening ? Icons.mic : Icons.mic_none,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _startListening();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      suggestions.isEmpty
                          ? Container()
                          : Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20.0.w,
                                    top: 10.h,
                                    bottom: 10.h,
                                  ),
                                  child: Text(
                                    "${suggestions.length} results",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20.0.w,
                                    top: 10.h,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      _isfullmode
                                          ? Icons.more_vert
                                          : Icons.more_horiz,
                                    ), // Change icon based on view mode
                                    onPressed: () {
                                      setState(() {
                                        _isfullmode =
                                            !_isfullmode; // Toggle view mode
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: _isfullmode
                                  ? Colors.transparent
                                  : Colors.grey.shade200,
                            );
                          },
                          itemCount: suggestions.length,
                          itemBuilder: (BuildContext context, int index) {
                            final recipe = suggestions[index];
                            return !_isfullmode
                                ? Padding(
                                    padding: index == 0
                                        ? EdgeInsets.only(top: 20.0.h)
                                        : EdgeInsets.symmetric(vertical: 0.0.h),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          selectedColor:
                                              FoodieColors.darkSecondary,
                                          title: Container(
                                            child: Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              30,
                                                            ),
                                                      ),
                                                      height: 150.h,
                                                      width: 0.43.sw,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              30.r,
                                                            ),
                                                        child: CachedNetworkImage(
                                                          imageUrl:
                                                              "${suggestions[index]['Image']}",
                                                          fit: BoxFit.cover,
                                                          errorWidget:
                                                              (
                                                                context,
                                                                url,
                                                                error,
                                                              ) => Image.asset(
                                                                'assets/images/home/notavailable1.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 150.h,
                                                      width: 0.43.sw,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              30.r,
                                                            ),
                                                        gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topRight,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.black
                                                                .withOpacity(
                                                                  0.4,
                                                                ), // Adjust opacity as needed
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 10.h,
                                                      right: 10.w,
                                                      child: CircleAvatar(
                                                        radius: 18,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 3.0.w,
                                                                top: 2.h,
                                                              ),
                                                          child: LikeButton(
                                                            onTap: (isLiked) {
                                                              FavoriteFunctions.toggleFavorite(
                                                                suggestions[index]['id'],
                                                              );

                                                              if (isLiked) {
                                                                // Recipe is being removed from favorites
                                                                FavoriteFunctions.toggleFavorite(
                                                                  suggestions[index]['id'],
                                                                );
                                                                showRecipeRemovedToast(
                                                                  context,
                                                                );
                                                              } else {
                                                                // Recipe is being added to favorites
                                                                FavoriteFunctions.toggleFavorite(
                                                                  suggestions[index]['id'],
                                                                );
                                                                showRecipeSavedToast(
                                                                  context,
                                                                );
                                                              }

                                                              return Future.value(
                                                                !isLiked,
                                                              ); // Reverse the liked status // Reverse the liked status
                                                            },
                                                            isLiked: FavoriteFunctions
                                                                .favoriteRecipes
                                                                .contains(
                                                                  suggestions[index]['id'],
                                                                ),
                                                            likeBuilder: (bool isLiked) {
                                                              return Icon(
                                                                isLiked
                                                                    ? Icons
                                                                          .favorite
                                                                    : Icons
                                                                          .favorite_border_outlined,
                                                                color: isLiked
                                                                    ? Colors.red
                                                                    : Colors
                                                                          .black,
                                                              );
                                                            },
                                                            // size: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 15.w),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 155.h,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 8.0.h,
                                                          ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${suggestions[index]['Name']}",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          Text(
                                                            "${suggestions[index]['Dish Overview'][0]}",
                                                            maxLines: 3,
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Divider(
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Iconsax.clock,
                                                                color: FoodieColors
                                                                    .darkSecondary,
                                                                size: 20.sp,
                                                              ),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Text(
                                                                suggestions[index]['Total Time']
                                                                            .length <
                                                                        20
                                                                    ? "${suggestions[index]['Total Time']}"
                                                                    : "${suggestions[index]['Total Time']}"
                                                                          .substring(
                                                                            0,
                                                                            20,
                                                                          ),
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          12.sp,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            await RecipeTracking.addToRecipeVisit(
                                              '${recipe['id']}',
                                            );
                                            Set<String> startedCooking =
                                                await RecipeTracking
                                                    .recipeVisit;
                                            print(startedCooking);
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                duration: Duration(
                                                  milliseconds: 300,
                                                ),
                                                child: RecipeDetails(
                                                  userData: widget.userData,
                                                  recipe: recipe,
                                                ),
                                                type: PageTransitionType.fade,
                                              ),
                                            ).then(
                                              (value) => setState(() {
                                                // print("HIsssss");
                                                // loadUserData();
                                                FavoriteFunctions.fetchFavoriteRecipes();
                                              }),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : ListTile(
                                    title: Text(recipe['Name']),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          duration: Duration(milliseconds: 300),
                                          child: RecipeDetails(
                                            userData: widget.userData,
                                            recipe: recipe,
                                          ),
                                          type: PageTransitionType.fade,
                                        ),
                                      ).then(
                                        (value) => setState(() {
                                          // print("HIsssss");
                                          // loadUserData();
                                          FavoriteFunctions.fetchFavoriteRecipes();
                                        }),
                                      );
                                    },
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.25.sh,
                  left: 0.w,
                  right: 0.w,
                  child:
                      suggestions.isEmpty &&
                          _textEditingController.text.isNotEmpty
                      ? Column(
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/images/home/nofav.png",
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0.w),
                                  child: Text(
                                    "No Recipes Found!",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 50.0.w,
                                  ),
                                  child: Text(
                                    "Try refining your search or browse by category.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Bounceable(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        duration: Duration(milliseconds: 300),
                                        child: RecipieIndex(
                                          recipes: widget.recipes,
                                          selected: 1,
                                          // openDrawerCallback: widget.openDrawerCallback,
                                          // // favlist: userData['favorite'],
                                          // userData: userData,
                                          // recipes: widget.recipes,
                                        ),
                                        type: PageTransitionType.fade,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 220.w,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0.w),
                                      child: Center(
                                        child: Text(
                                          "Browse by Category",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                ),
                Positioned(
                  top: 0.35.sh,
                  left: 0.w,
                  right: 0.w,
                  child:
                      suggestions.isEmpty && _textEditingController.text.isEmpty
                      ? Column(
                          children: [
                            Opacity(
                              opacity: 0.8,
                              child: Center(
                                child: Image.asset(
                                  "assets/images/sear.png",
                                  height: 200.h,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 20.h,
                            // ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.0.w),
                              child: Text(
                                "Search Your Favorite Recipes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: false,
        bottomSheet: _isListening
            ? Material(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                elevation: 7,
                child: Stack(
                  children: [
                    Container(
                      height: 180.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0.w),
                          child: Column(
                            children: [
                              Text(
                                'Listening...',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(height: 30.h),
                              AvatarGlow(
                                glowColor: Color.fromRGBO(0, 74, 124, 1),
                                // endRadius: 90.0,
                                duration: Duration(milliseconds: 2000),
                                glowRadiusFactor: 0.5,
                                repeat: true,
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundColor: Color.fromRGBO(
                                    0,
                                    74,
                                    124,
                                    1,
                                  ),
                                  child: Icon(Icons.mic, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20.w,
                      top: 10.h,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            _startListening();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  void _stopListening() async {
    if (_isListening) {
      // Stop listening if currently listening
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }
}





 // Positioned(
          //   bottom: 20.h, // Adjust bottom position as needed
          //   left: MediaQuery.of(context).size.width / 2 -
          //       30, // Center horizontally
          //   child: GestureDetector(
          //     onTap: _startListening,
          //     child: CircleAvatar(
          //       radius: 32,
          //       child: _isListening
          //           ? AvatarGlow(
          //               child: CircleAvatar(
          //                 radius: 400,
          //                 child: Icon(
          //                   Icons.mic,
          //                   color: Colors.white,
          //                 ),
          //                 backgroundColor: Color.fromRGBO(0, 74, 124, 1),
          //               ),
          //               glowColor: Color.fromRGBO(0, 74, 124, 1),
          //               // endRadius: 90.0,
          //               duration: Duration(milliseconds: 2000),
          //               glowRadiusFactor: 0.5,
          //               repeat: true,
          //             )
          //           : CircleAvatar(
          //               radius: 400,
          //               child: Icon(
          //                 Icons.play_arrow,
          //                 color: Colors.white,
          //               ),
          //               backgroundColor: Color.fromRGBO(0, 74, 124, 1),
          //             ),
          //     ),
          //   ),
          // ),