import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/DetailsPage/details.dart';
import 'package:foodie/Pages/ListPage/toast.dart';
import 'package:foodie/Source/helper.dart';
import 'package:foodie/helper/addtofav.dart';
import 'package:foodie/helper/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // Import speech_to_text package

class searchPageWorking extends StatefulWidget {
    final Map<String, dynamic> userData;
  final List<dynamic> recipes;
  final String? name;
  const searchPageWorking({super.key, this.name, required this.recipes, required this.userData});

  @override
  _searchPageWorkingState createState() => _searchPageWorkingState();
}

class _searchPageWorkingState extends State<searchPageWorking> {
  bool _isfullmode = false;

  List<dynamic> suggestions = [];
  final TextEditingController _textEditingController = TextEditingController();
  final stt.SpeechToText _speech =
      stt.SpeechToText(); // Initialize SpeechToText instance
  bool _isListening = false;

  @override
  void initState() {
    _textEditingController.text = widget.name ?? '';
    updateSuggestions(widget.name ?? '');
    super.initState();
  }

  void updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });
    } else {
      setState(() {
        suggestions = filterRecipesByName(widget.recipes, query);
      });
    }
  }

  void _startListening() async {
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
        _isListening = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Speech recognition error'),
          duration: Duration(seconds: 2),
        ));
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        onResult: (result) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Search'),
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: () {
              _startListening();
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0.w),
                child: TextField(
                  cursorColor: FoodieColors.darkSecondary,
                  controller: _textEditingController,
                  onChanged: (query) {
                    if (query == '') {
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
                      updateSuggestions(query);
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
                        icon: Icon(
                          Icons.close,
                        )),
                    filled: true,

                    fillColor: Colors.grey[200],
                    hintText: "Search Food and Recipies",

                    contentPadding: EdgeInsets.symmetric(
                        vertical: 14.h), // Adjust the vertical padding as needed

                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
              ),
              suggestions.isEmpty
                  ? Container()
                  : Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.0.w, top: 10.h, bottom: 10.h),
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
                            icon: Icon(_isfullmode
                                ? Icons.view_list
                                : Icons
                                    .view_module), // Change icon based on view mode
                            onPressed: () {
                              setState(() {
                                _isfullmode = !_isfullmode; // Toggle view mode
                              });
                            },
                          ),
                        ),
                      ],
                    ),
              Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final recipe = suggestions[index];
                    return _isfullmode
                        ? Padding(
                            padding: index == 0
                                ? EdgeInsets.only(top: 20.0.h)
                                : EdgeInsets.symmetric(vertical: 0.0.h),
                            child: Column(
                              children: [
                                ListTile(
                                  selectedColor: FoodieColors.darkSecondary,
                                  title: Container(
                                    child: Row(
                                      children: [
                                        Stack(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.r)),
                                            height: 150.h,
                                            width: 0.43.sw,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${suggestions[index]['Image']}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 150.h,
                                            width: 0.43.sw,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(
                                                      0.4), // Adjust opacity as needed
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10.h,
                                            right: 10.w,
                                            child: CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.white,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 3.0.w, top: 2.h),
                                                child: LikeButton(
                                                  onTap: (isLiked) {
                                                    FavoriteFunctions
                                                        .toggleFavorite(
                                                            suggestions[index]
                                                                ['id']);

                                                    if (isLiked) {
                                                      // Recipe is being removed from favorites
                                                      FavoriteFunctions
                                                          .toggleFavorite(
                                                              suggestions[index]
                                                                  ['id']);
                                                      showRecipeRemovedToast(
                                                          context);
                                                    } else {
                                                      // Recipe is being added to favorites
                                                      FavoriteFunctions
                                                          .toggleFavorite(
                                                              widget.recipes[
                                                                  index]['id']);
                                                      showRecipeSavedToast(
                                                          context);
                                                    }

                                                    return Future.value(
                                                        !isLiked); // Reverse the liked status // Reverse the liked status
                                                  },
                                                  isLiked: FavoriteFunctions
                                                      .favoriteRecipes
                                                      .contains(
                                                          suggestions[index]
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
                                                  // size: 2,
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 150.h,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8.0.h),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${suggestions[index]['Name']}",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    "${suggestions[index]['Dish Overview'][0]}",
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Divider(
                                                    color: Colors.grey[300],
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
                                                        suggestions[index][
                                                                        'Total Time']
                                                                    .length <
                                                                20
                                                            ? "${suggestions[index]['Total Time']}"
                                                            : "${suggestions[index]['Total Time']}"
                                                                .substring(
                                                                    0, 20),
                                                        style: TextStyle(
                                                            fontSize: 13.sp),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecipeDetails(
                                          userData: widget.userData,
                                          recipe: recipe,
                                        ),
                                      ),
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
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetails(
                                    userData: widget.userData,
                                    recipe: recipe,
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
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
              child: Container(
                height: 150.h,
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
                        Spacer(),
                        AvatarGlow(
                          glowColor: Color.fromRGBO(0, 74, 124, 1),
                          // endRadius: 90.0,
                          duration: Duration(milliseconds: 2000),
                          glowRadiusFactor: 0.5,
                          repeat: true,
                          child: CircleAvatar(
                            radius: 27,
                            backgroundColor: Color.fromRGBO(0, 74, 124, 1),
                            child: Icon(
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
            )
          : null,
    );
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