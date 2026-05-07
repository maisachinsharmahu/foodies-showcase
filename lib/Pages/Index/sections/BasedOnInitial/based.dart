import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/Pages/DetailsPage/details.dart';
import 'package:foodie/Pages/DetailsPage/helpers/cap.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/Pages/Index/sections/Types/typesIndex.dart';
import 'package:foodie/Pages/ListPage/toast.dart';
import 'package:foodie/Source/helper.dart';
import 'package:foodie/helper/addtofav.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/recipe_tracking.dart';
import 'package:foodie/main.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class basedOnInitialChoice extends StatefulWidget {
  final List<dynamic> recipes;
  final Function() openDrawerCallback;
  final VoidCallback callback;
  // final List<dynamic> recipes;
  final Map<String, dynamic> userData;

  const basedOnInitialChoice(
      {super.key,
      required this.recipes,
      required this.userData,
      required this.openDrawerCallback,
      required this.callback});

  @override
  State<basedOnInitialChoice> createState() => _basedOnInitialChoiceState();
}

class _basedOnInitialChoiceState extends State<basedOnInitialChoice> {
  late List<dynamic> recommendedRecipes = [];
  int last = 30;
  bool _isfirst = true;
  final bool _isloading = false;
  // late Connectivity _connectivity;
  // late ConnectivityResult _connectivityResult;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  final GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    List<dynamic> newws =
        context.read<RecommendedRecipesProvider>().recommendedRecipes;
    recommendedRecipes = newws.sublist(10, 30).toList();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool isOffline = results.contains(ConnectivityResult.none);
      // Only rebuild if the status actually changed or it's the first time
      if (_isfirst || (isOffline != (recommendedRecipes.isEmpty))) {
        if (mounted) {
          setState(() {
            if (_isfirst) {
              recommendedRecipes = newws.sublist(10, 30).toList();
              _isfirst = false;
            } else {
              List<dynamic> fakk = context
                  .read<RecommendedRecipesProvider>()
                  .recommendedRecipes;
              recommendedRecipes = fakk.sublist(9, 32).toList();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<String?> _downloadImage(String imageUrl) async {
    try {
      // Create a temporary directory
      Directory tempDir = await Directory.systemTemp.createTemp();
      String imagePath = "${tempDir.path}/recipe_image.jpg";

      // Download the image file
      await Dio().download(imageUrl, imagePath);

      // Return the local path of the downloaded image file
      return imagePath;
    } catch (e) {
      print("Error downloading image: $e");
      return null;
    }
  }

  String _formatIngredients(Map<String, dynamic> ingredients) {
    return ingredients.entries.map((entry) {
      return "${entry.key}:\n${entry.value.map((ingredient) => "- $ingredient").join('\n')}";
    }).join('\n');
  }

  String _formatInstructions(List<dynamic> steps) {
    return steps.map((step) => "- $step").join('\n');
  }

  List<String> _splitTextContent(Map<String, dynamic> recipe) {
    // Create a list to store text chunks
    List<String> chunks = [];

    // String nessss = pw.Text('Hello World', style: pw.TextStyle( fontSize: 40.sp)),

    // Add recipe details to text chunks
    String text = '${recipe['Name']}\n\n'
        'Prep Time: ${recipe['Prep Time']}\n'
        'Cook Time: ${recipe['Cook Time']}\n'
        'Servings: ${recipe['Recipe Servings']}\n\n'
        'Ingredients:\n${_formatIngredients(recipe['Ingredients'])}\n\n'
        'Instructions:\n${_formatInstructions(recipe['Steps'])}';

    // Split text into chunks based on available space on a page
    final int maxLinesPerPage = 40; // Maximum lines per page
    final int maxLinesPerFirstPage = 20; // Adjusted for image
    List<String> lines = text.split('\n');
    String currentChunk = lines[0];

    // Use different maximum lines per page for the first page
    int linesPerPage = maxLinesPerFirstPage;

    for (int i = 1; i < lines.length; i++) {
      if (currentChunk.split('\n').length >= linesPerPage) {
        chunks.add(currentChunk);
        currentChunk = '';
        // Use the standard maximum lines per page for subsequent pages
        linesPerPage = maxLinesPerPage;
      }
      currentChunk += '\n${lines[i]}';
    }

    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk);
    }

    return chunks;
  }

  Future<Uint8List> _loadImageFromAssets(String assetName) async {
    final ByteData data = await rootBundle.load(assetName);
    return data.buffer.asUint8List();
  }

  void sharePage(dynamic recipe) async {
    // Download the image file
    String? imagePath = await _downloadImage("${recipe['Image']}");

    if (imagePath != null) {
      // Create PDF document
      final pdf = pw.Document();

      // Split text content into chunks to fit on pages
      List<String> textChunks = _splitTextContent(recipe);
      Uint8List imageBytes =
          await _loadImageFromAssets('assets/images/logo2.png');

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pw.MemoryImage(imageBytes)),
            );
          },
        ),
      );
      final font = await rootBundle.load('assets/Poppin/Poppins-Regular.ttf');
      final ttfFont = pw.Font.ttf(font);

      // Add the image to the first page
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(
                  pw.MemoryImage(File(imagePath).readAsBytesSync()),
                ),
                pw.SizedBox(
                    height: 20.h), // Add some space between image and text
                // pw.Font notoSansHindi = pw.Font.ttf(await rootBundle.load("path_to_noto_sans_hindi.ttf"));

                pw.Text(
                  textChunks.isNotEmpty ? textChunks[0] : 'No text available',
                  style: pw.TextStyle(
                    font: ttfFont, // Provide instances of pw.Font
                  ),
                ) // Add the first text chunk or display a message if empty
              ],
            );
          },
        ),
      );

      // Add the remaining text chunks to subsequent pages
      for (int i = 1; i < textChunks.length; i++) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    textChunks[i],
                    style: pw.TextStyle(
                      font: ttfFont, // Provide instances of pw.Font
                    ),
                  ), // Add the text chunk
                ],
              );
            },
          ),
        );
      }

      // Save the PDF to a temporary file
      final pdfFile =
          File("${Directory.systemTemp.path}/Foodies_${recipe['Name']}.pdf");
      await pdfFile.writeAsBytes(await pdf.save());

      // Share the PDF file
      try {
        String message = 'Check out this recipe!';
        print(message);
        await Share.shareXFiles(
          [XFile(pdfFile.path)],
          text: 'Check out this recipe!',
          subject: message,
        );
      } catch (e) {
        print("Error sharing: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("${(Screen.screenWidth(context) - 4) * 0.86}");
    // print({Screen.screenWidth(context) - 4});
    return IgnorePointer(
      ignoring: _isloading ? true : false,
      child: Opacity(
        opacity: _isloading ? 0.5 : 1,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0.w),
                        child: Text(
                          "Based on Your Interst",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            last = 30;
                            Provider.of<RecommendedRecipesProvider>(context,
                                    listen: false)
                                .setRecommendedRecipes(
                                    shuffleRecipes(widget.recipes),
                                    widget.userData);
                            List<dynamic> newws = context
                                .read<RecommendedRecipesProvider>()
                                .recommendedRecipes;
                            recommendedRecipes = newws.sublist(10, 30).toList();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 1.sw,
                    child: Column(
                      key: _key,
                      children: [
                        for (var index = 0;
                            index < recommendedRecipes.length;
                            index++)
                          boxer(context, index),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GFButton(
                        size: GFSize.LARGE,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.callback();
                          });

                          Future.delayed(const Duration(seconds: 4), () {
                            if (mounted) {
                              setState(() {
                                widget.callback();
                                List<dynamic> newws = context
                                    .read<RecommendedRecipesProvider>()
                                    .recommendedRecipes;
                                last += 20;
                                recommendedRecipes = newws
                                    .sublist(10, last)
                                    .toList();
                              });
                            }
                          });
                        },
                        text: "Load More",
                        textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins"),
                        color: FoodieColors.darkSecondary,
                        shape: GFButtonShape.pills,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget boxer(BuildContext context, int index) {
    if (index == 2) {
      return typesIndex(
        recipes: widget.recipes,
        userData: widget.userData,
        openDrawerCallback: widget.openDrawerCallback,
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0.h),
      child: Bounceable(
        onTap: () async {
          await RecipeTracking.addToRecipeVisit(
              '${recommendedRecipes[index]['id']}');
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: RecipeDetails(
                  userData: widget.userData,
                  recipe: recommendedRecipes[index],
                ),
              )).then((value) => setState(() {
                FavoriteFunctions.fetchFavoriteRecipes();
              }));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0.w),
          height: 330.h,
          child: Material(
            borderRadius: BorderRadius.circular(20.r),
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 185.h,
                      child: Stack(
                        children: [
                          Hero(
                            tag: recommendedRecipes[index]['id'],
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${recommendedRecipes[index]['Image']}',
                              height: 185.h,
                              width: 1.sw,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                'assets/images/home/notavailable1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: 185.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.2),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 3.h,
                            right: 3.w,
                            child: Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: PopupMenuButton<String>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                elevation: 8,
                                offset: const Offset(0, 40),
                                color: Colors.white,
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 26.sp,
                                  color: Colors.white,
                                ),
                                onSelected: (String choice) {
                                  if (choice == 'hide') {
                                    setState(() {
                                      recommendedRecipes.removeAt(index);
                                    });
                                  } else if (choice == 'share') {
                                    sharePage(recommendedRecipes[index]);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    height: 40.h,
                                    value: 'hide',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Iconsax.eye_slash,
                                          size: 22.sp,
                                          color: FoodieColors.darkSecondary,
                                        ),
                                        SizedBox(width: 8.w),
                                        const Text(
                                          'Hide this recipe',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    height: 40.h,
                                    value: 'share',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.share_outlined,
                                          size: 22.sp,
                                          color: FoodieColors.darkSecondary,
                                        ),
                                        SizedBox(width: 8.w),
                                        const Text(
                                          'Share',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 3.h,
                            right: 3.w,
                            child: Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${recommendedRecipes[index]['Image']}',
                                            errorWidget: (context,
                                                    url, error) =>
                                                Image.asset(
                                              'assets/images/home/notavailable1.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: CircleAvatar(
                                  radius: 15.r,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.fullscreen,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    recipekebaareme(
                      recipe: recommendedRecipes[index],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class recipekebaareme extends StatefulWidget {
  final dynamic recipe;
  const recipekebaareme({super.key, this.recipe});

  @override
  State<recipekebaareme> createState() => _recipekebaaremeState();
}

class _recipekebaaremeState extends State<recipekebaareme> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.recipe['Name'],
            maxLines: 1,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              fontFamily: 'metropolis',
            ),
          ),
          Row(
            children: [
              Text(
                widget.recipe['type'] is List && widget.recipe['type'].isNotEmpty
                    ? capitalizeFirstLetter(widget.recipe['type'][0])
                    : '',
                maxLines: 1,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  fontFamily: 'metropolis',
                  color: Colors.grey.shade500,
                ),
              ),
              if (widget.recipe['type'] is List &&
                  widget.recipe['type'].length >= 2)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Icon(
                    Icons.circle,
                    size: 4.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              Text(
                widget.recipe['type'] is List && widget.recipe['type'].length >= 2
                    ? capitalizeFirstLetter(widget.recipe['type'][1])
                    : '',
                maxLines: 1,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                  fontFamily: 'Metropolis',
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0.h),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.recipe['Total Time'] != "N/A")
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0.w),
                            child: Image.asset(
                              'assets/images/prep.png',
                              height: 22.h,
                              width: 22.w,
                            ),
                          ),
                          Text(
                            "Total Time : ",
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${widget.recipe['Total Time']}",
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    if (widget.recipe['Cook Time'] != "N/A")
                      Padding(
                        padding: EdgeInsets.only(top: 8.0.h),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0.w),
                              child: Image.asset(
                               'assets/images/Cooktime.png',
                                height: 22.h,
                                width: 22.w,
                              ),
                            ),
                            Text(
                              "Cook Time : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp),
                            ),
                            Text(
                              "${widget.recipe['Cook Time']}",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                LikeButton(
                  onTap: (isLiked) {
                    FavoriteFunctions.toggleFavorite(widget.recipe['id']);
                    if (isLiked) {
                      showRecipeRemovedToast(context);
                    } else {
                      showRecipeSavedToast(context);
                    }
                    return Future.value(!isLiked);
                  },
                  isLiked: FavoriteFunctions.favoriteRecipes
                      .contains(widget.recipe['id']),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked
                          ? Icons.bookmark
                          : Icons.bookmark_add_outlined,
                      color: isLiked ? Colors.orange : Colors.grey,
                      size: 30.sp,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = FoodieColors.darkSecondary
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 5;
    double dashSpace = 5;
    double startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
