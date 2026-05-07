import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class listPage extends StatefulWidget {
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  final String name;
  const listPage(
      {super.key,
      required this.recipes,
      required this.name,
      required this.userData});

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
  List<dynamic> _currentRecipes = [];

  //
  final bool _isfullmode = false;
  final bool _isLoading = false;
  List<dynamic> suggestions = [];
  final TextEditingController _textEditingController = TextEditingController();
  final stt.SpeechToText _speech =
      stt.SpeechToText(); // Initialize SpeechToText instance
  bool _isListening = false;
  @override
  void initState() {
    FavoriteFunctions.fetchFavoriteRecipes();
    super.initState();
    suggestions = widget.recipes;
    _currentRecipes = widget.recipes;
  }

  void updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        // _currentRecipes = [];
      });
    } else {
      List<dynamic> nameFilteredRecipes =
          filterRecipesByName(suggestions, query);
      List<dynamic> typeFilteredRecipes = filterRecipesBymanyTypes3(
          suggestions, [query]); // Assuming query as type here

      // Merge the results
      Set<dynamic> mergedResults = {};
      mergedResults.addAll(nameFilteredRecipes);
      mergedResults.addAll(typeFilteredRecipes);
      // Convert set to list
      List<dynamic> mergedList = mergedResults.toList();

      // Shuffle the list

      // mergedList.shuffle(Random());
      setState(() {
        _currentRecipes = mergedList;
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Speech recognition error'),
          duration: Duration(seconds: 2),
        ));
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
            // updateSuggestions(result.recognizedWords);
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.name),
      // ),
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
          Opacity(
            opacity: _isLoading || _isListening ? 0.4 : 1.0,
            child: SafeArea(
              child: Stack(children: [
                Column(children: [
                  Padding(
                    padding: EdgeInsets.all(26.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              size: 16.sp,
                            ),
                          ),
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                        Bounceable(
                            onTap: () {
                              setState(() {
                                _currentRecipes =
                                    shuffleRecipes(widget.recipes);
                              });
                            },
                            child: const Icon(Icons.refresh)),
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
                              if (query.trim() == '') {
                                updateSuggestions('');
                              } else {
                                updateSuggestions(query.trim());
                              }
                            },
                            decoration: InputDecoration(
                              focusColor: FoodieColors.darkSecondary,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _textEditingController.clear();
                                    updateSuggestions("");
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                  )),
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: "Search from ${widget.name} Recipes",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontFamily: 'Poppins',
                                fontSize: 14.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.h),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: Container(
                            height: 50.h,
                            width: 0.15.sw,
                            decoration: BoxDecoration(
                                color: FoodieColors.darkSecondary,
                                borderRadius: BorderRadius.circular(20.r)),
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
                        )
                      ],
                    ),
                  ),
                  suggestions.isEmpty
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0.w, top: 10.h, bottom: 10.h),
                              child: Text(
                                "${_currentRecipes.length} results",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: SizedBox(
                        width: 1.sw,
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisCount: 2,
                              crossAxisSpacing: 6.0.w,
                              mainAxisSpacing: 6.0.h,
                            ),
                            itemCount: _currentRecipes.length,
                            itemBuilder: (context, index) {
                              return Bounceable(
                                onTap: () async {
                                  await RecipeTracking.addToRecipeVisit(
                                      '${_currentRecipes[index]['id']}');
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      duration: const Duration(milliseconds: 300),
                                      child: RecipeDetails(
                                        userData: widget.userData,
                                        recipe: _currentRecipes[index],
                                      ),
                                      type: PageTransitionType.fade,
                                    ),
                                  ).then((value) => setState(() {
                                        FavoriteFunctions
                                            .fetchFavoriteRecipes();
                                      }));
                                },
                                child: Container(
                                  height: 0.4.sh,
                                  width: 0.6.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30.r),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${_currentRecipes[index]['Image']}',
                                          height: 0.4.sh,
                                          width: 0.6.sw,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/images/home/notavailable1.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 0.4.sh,
                                        width: 0.6.sw,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(
                                                  0.7),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10.h,
                                        left: 20.w,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 0.4.sw,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${_currentRecipes[index]['Name']}',
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'Poppins'
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          top: 10.h,
                                          left: 12.w,
                                          child: LimitedBox(
                                            maxWidth: 70.w,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                color:
                                                    FoodieColors.darkSecondary,
                                              ),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 8.0.w,
                                                        vertical: 3.h),
                                                child: Text(
                                                  _currentRecipes[index]
                                                      ['Total Time'],
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Positioned(
                                          top: 10.h,
                                          right: 12.w,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 18.r,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 3.0.w),
                                              child: LikeButton(
                                                onTap: (isLiked) {
                                                  FavoriteFunctions
                                                      .toggleFavorite(
                                                          _currentRecipes[index]
                                                              ['id']);

                                                  if (isLiked) {
                                                    FavoriteFunctions
                                                        .toggleFavorite(
                                                            _currentRecipes[
                                                                index]['id']);
                                                    showRecipeRemovedToast(
                                                        context);
                                                  } else {
                                                    FavoriteFunctions
                                                        .toggleFavorite(
                                                            _currentRecipes[
                                                                index]['id']);
                                                    showRecipeSavedToast(
                                                        context);
                                                  }

                                                  return Future.value(
                                                      !isLiked);
                                                },
                                                isLiked: FavoriteFunctions
                                                    .favoriteRecipes
                                                    .contains(
                                                        _currentRecipes[index]
                                                            ['id']),
                                                likeBuilder: (bool isLiked) {
                                                  return Icon(
                                                    isLiked
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border_outlined,
                                                    color: isLiked
                                                        ? Colors.red
                                                        : Colors.black,
                                                  );
                                                },
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ]),
              ]),
            ),
          ),
          Positioned(
              top: 0.25.sh,
              left: 0.w,
              right: 0.w,
              child: _currentRecipes.isEmpty &&
                      _textEditingController.text.isNotEmpty
                  ? Column(
                      children: [
                        Center(
                          child: Image.asset("assets/images/home/nofav.png"),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: Text(
                                "No Recipes Found!",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 50.0.w),
                              child: Text(
                                "Try refining your search or browse by category.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade600),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Bounceable(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    duration: const Duration(milliseconds: 300),
                                    child: RecipieIndex(
                                      recipes: widget.recipes,
                                      selected: 1,
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                              child: Container(
                                width: 220.w,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30.r)),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0.w),
                                  child: Center(
                                    child: Text(
                                      "Browse by Category",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container()),
        ],
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
              child: Stack(children: [
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      )),
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
                            glowColor: const Color.fromRGBO(0, 74, 124, 1),
                            duration: const Duration(milliseconds: 2000),
                            glowRadiusFactor: 0.5,
                            repeat: true,
                            child: CircleAvatar(
                              radius: 27.r,
                              backgroundColor: const Color.fromRGBO(0, 74, 124, 1),
                              child: const Icon(
                                Icons.mic,
                                color: Colors.white,
                              ),
                            ),
                          )
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
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _startListening();
                        },
                      )),
                )
              ]),
            )
          : null,
    );
  }
}
