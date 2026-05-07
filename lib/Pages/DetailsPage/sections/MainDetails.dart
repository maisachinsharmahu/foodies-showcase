import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/DetailsPage/sections/datasection.dart';
import 'package:foodie/Pages/DetailsPage/sections/steps.dart';
import 'package:foodie/Pages/Index/helper/giffy/new.dart' as giff;
import 'package:lottie/lottie.dart';
import 'package:foodie/Pages/ListPage/toast.dart';
import 'package:foodie/helper/addtofav.dart';
import 'package:foodie/helper/colors.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class mainDetails extends StatefulWidget {
  final Map<String, dynamic> userData;
  final dynamic recipe;
  const mainDetails({super.key, this.recipe, required this.userData});

  @override
  State<mainDetails> createState() => _mainDetailsState();
}

class _mainDetailsState extends State<mainDetails> {
  bool _issharing = false;
  bool isMaximized = false; // Initialize the variable

  // @override
  // void initState() {
  //   super.initState();
  //   // Add your provider logic here
  //   //  Provider.of<RecipeTrackingProvider>(context, listen: false)
  //   //                 .addToRecipeVisit("${widget.recipe['id']}");
  //   Set<dynamic> newws = context.read<RecipeTrackingProvider>().recipeVisit;
  //   print(newws);
  //   // Provider.of<RecipeTrackingProvider>(context)
  //   //     .addToRecipeVisit(widget.recipe['id']);
  //   // final integerListProvider = Provider.of<RecipeTrackingProvider>(context);
  //   // print(integerListProvider);
  // }

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
      // final ByteData assetData =
      //     await rootBundle.load('assets/recipe_image.jpg');
      try {
        // Load the asset image
        ByteData assetData =
            await rootBundle.load('assets/images/home/detnot.png');

        // Create a temporary directory
        Directory tempDir = await Directory.systemTemp.createTemp();
        String imagePath = "${tempDir.path}/recipe_image.jpg";

        // Write the asset image data to the temporary file
        await File(imagePath).writeAsBytes(assetData.buffer.asUint8List());

        // Return the local path of the asset image file
        return imagePath;
      } catch (e) {
        print("Error loading asset image: $e");
        return null;
      }
      // return null;
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

  void sharePage() async {
    setState(() {
      _issharing = true;
    });

    // Download the image file
    String? imagePath = await _downloadImage("${widget.recipe['Image']}");

    if (imagePath != null) {
      // Create PDF document
      final pdf = pw.Document();

      // Split text content into chunks to fit on pages
      List<String> textChunks = _splitTextContent(widget.recipe);
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
      final pdfFile = File(
          "${Directory.systemTemp.path}/Foodies_${widget.recipe['Name']}.pdf");
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
        setState(() {
          _issharing = false;
        });
      } catch (e) {
        print("Error sharing: $e");
        setState(() {
          _issharing = false;
        });
      }
    }
  }

  final DraggableScrollableController _controller =
      DraggableScrollableController();
  bool _isfull = false;
  final bool _ishalf = true;
  final bool _isonetime = false;

  @override
  Widget build(BuildContext context) {
    // @override
    // void initState() {
    //   super.initState();
    //   // _controller.addListener(() {
    //   //   double maxChildSize = _controller.size;
    //   //   setState(() {
    //   //     _isfull = maxChildSize == 1;
    //   //     print(_isfull = maxChildSize == 1);
    //   //   });
    //   // });
    // }

    // @override
    // void dispose() {
    //   _controller.dispose();
    //   super.dispose();
    // }

    // void _maxChildSizeListener() {
    //   double maxChildSize = _controller.size;
    //   if (maxChildSize > 0.9) {
    //     _isfull = true;
    //     setState(() {});
    //     print(maxChildSize);
    //     print(_isfull);
    //   } else {
    //     _isfull = false;
    //     if (_isfull == false) {
    //       _isfull = false;

    //       setState(() {
    //         print(_isfull);
    //       });
    //     }
    //   }

    // }
    bool debounceActive = false;
    Timer? debounceTimer;

    bool isScrollingDown = false;
    return IgnorePointer(
      ignoring: _issharing,
      child: Scaffold(
        body: Stack(
          children: [
            Opacity(
              opacity: _issharing ? 0.7 : 1,
              child: Stack(
                children: [
                  SizedBox(
                      height: 0.4.sh,
                      width: 1.sw,
                      child: CachedNetworkImage(
                        imageUrl: '${widget.recipe['Image']}',
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/home/detnot.png',
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => Container(
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                    bottom: 0.h,
                    child: Container(
                      height: 0.65.sh,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        children: [
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(20.0.w),
                              child: SizedBox(
                                width: 0.9.sw,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 18.r,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(right: 3.0.w),
                                          child: const Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 50.h,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: LikeButton(
                                        onTap: (isLiked) {
                                          FavoriteFunctions.toggleFavorite(
                                              widget.recipe['id']);
                                          if (isLiked) {
                                            showRecipeRemovedToast(context);
                                          } else {
                                            showRecipeSavedToast(context);
                                          }
                                          return Future.value(!isLiked);
                                        },
                                        isLiked: FavoriteFunctions
                                            .favoriteRecipes
                                            .contains(widget.recipe['id']),
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            isLiked
                                                ? Icons.bookmark
                                                : Icons.bookmark_add_outlined,
                                            color: isLiked
                                                ? Colors.red
                                                : Colors.black,
                                            size: 32.sp,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: NotificationListener<
                                DraggableScrollableNotification>(
                              onNotification: (scrollNotification) {
                                bool scrollingDown =
                                    scrollNotification.maxExtent > 0.85;

                                if (isScrollingDown != scrollingDown &&
                                    !debounceActive) {
                                  debounceActive = true;
                                  debounceTimer?.cancel();

                                  debounceTimer =
                                      Timer(const Duration(milliseconds: 300), () {
                                    setState(() {
                                      _isfull = !_isfull;
                                      isScrollingDown = scrollingDown;
                                      debounceActive = false;
                                    });
                                  });
                                }
                                return false;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.r),
                                    topRight: Radius.circular(30.r),
                                  ),
                                ),
                                child: DraggableScrollableSheet(
                                  snap: true,
                                  shouldCloseOnMinExtent: false,
                                  snapAnimationDuration:
                                      const Duration(milliseconds: 200),
                                  maxChildSize: 0.93,
                                  controller: _controller,
                                  initialChildSize: 0.75,
                                  minChildSize: 0.75,
                                  builder: (BuildContext context,
                                      ScrollController scrollController) {
                                    return SizedBox(
                                      height: 0.65.sh,
                                      width: 1.sw,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: 1.sw,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.r),
                                                topRight: Radius.circular(30.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.0.h),
                                              child: recidata(
                                                controller: scrollController,
                                                recipe: widget.recipe,
                                                userData: widget.userData,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 20.w,
                                              top: -30.h,
                                              child: GestureDetector(
                                                onTap: () {
                                                  sharePage();
                                                },
                                                child: Container(
                                                    height: 50.h,
                                                    width: 50.w,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: FoodieColors
                                                          .darkSecondary,
                                                    ),
                                                    child: Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                      size: 32.sp,
                                                    )),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 0.h,
                        child: Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  duration: const Duration(milliseconds: 300),
                                  child: CookSteps(
                                    userData: widget.userData,
                                    recipe: widget.recipe,
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Container(
                              width: 0.5.sw,
                              decoration: BoxDecoration(
                                  color: FoodieColors.darkSecondary,
                                  borderRadius: BorderRadius.circular(30.r)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 10.h),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10.0.w),
                                      child: Text(
                                        "Cook Now",
                                        style: TextStyle(
                                            fontFamily: 'metropolis',
                                            color: Colors.white,
                                            fontSize: 19.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 16.r,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 2.0.w),
                                            child: Icon(
                                              size: 22.sp,
                                              Icons.chevron_right,
                                              color: Colors.teal[700],
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                _issharing
                    ? Positioned(
                        left: 0.w,
                        right: 0.w,
                        top: 0.1.sh,
                        child: Lottie.asset('assets/images/home/sending.json',
                            width: 1.sw, height: 1.sw))
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// appBar: AppBar(
//         title: Text(widget.recipe['Name']),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(widget.recipe['Image']),
//             SizedBox(height: 16.0.h),
//             Text('Total Time: ${widget.recipe['Total Time']}'),
//             Text('Prep Time: ${widget.recipe['Prep Time']}'),
//             Text('Cook Time: ${widget.recipe['Cook Time']}'),
//             Text('Recipe Servings: ${widget.recipe['Recipe Servings']}'),
//             Text('Difficulty: ${widget.recipe['Difficulty']}'),
//             SizedBox(height: 16.0.h),
//             Text('Ingredients:',
//                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: (widget.recipe['Ingredients'] as Map<String, dynamic>)
//                   .entries
//                   .map((entry) {
//                 // For each entry (section) in the Ingredients map
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Subtitle for the section
//                     Text(entry.key,
//                         style: TextStyle(
//                             fontSize: 18.sp, fontWeight: FontWeight.bold)),
//                     // List of ingredients for the section
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children:
//                           (entry.value as List<dynamic>).map((ingredient) {
//                         return Text('- $ingredient');
//                       }).toList(),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16.0.h),
//             Text('Steps:',
//                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: (widget.recipe['Steps'] as List<dynamic>).map((step) {
//                 return Text('- $step');
//               }).toList(),
//             ),
//             SizedBox(height: 16.0.h),
//           ],
//         ),
//       ),
