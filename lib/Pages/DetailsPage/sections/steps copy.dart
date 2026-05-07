// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:typed_data';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
// import 'package:foodie/Pages/SideBarPages/Feedback.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:foodie/Pages/Index/index.dart';
// import 'package:foodie/helper/colors.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';

// class CookSteps extends StatefulWidget {
//   final Map<String, dynamic> userData;
//   final dynamic recipe;
//   const CookSteps({Key? key, required this.recipe, required this.userData})
//       : super(key: key);

//   @override
//   State<CookSteps> createState() => _CookStepsState();
// }

// class _CookStepsState extends State<CookSteps>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late ConfettiController _confettiController;
//   int _currentStep = -1;
//   bool _allStepsCompleted = false;
//   FlutterTts flutterTts = FlutterTts(); // Initialize FlutterTts instance
//   bool _isvoiceactive = false;
//   Future<void> speakRecipeSteps(int index, bool no) async {
//     // Sample step text to detect language, you can replace it with the actual recipe step
//     if (no) {
//       String sampleStep = widget.recipe['Steps'][index];

//       // Detect language of the sample step text
//       String detectedLanguage = await detectLanguage(sampleStep);

//       // Set language based on detected language
//       if (detectedLanguage == 'en') {
//         await flutterTts.setLanguage("en-US"); // Set language to English
//       } else if (detectedLanguage == 'hi') {
//         await flutterTts.setLanguage("hi-IN");
//         // await flutterTts
//         //     .setVoice({"name": "hi-in-x-hic-local"}); // Set language to Hindi
//       } else {
//         // Default to English if language detection fails or if it's not English or Hindi
//         await flutterTts.setLanguage("en-US");
//       }

//       await flutterTts.setPitch(1.0);

//       // Speak the step at the given index
//       await flutterTts.speak(widget.recipe['Steps'][index]);
//       await flutterTts.awaitSpeakCompletion(true).whenComplete(() {
//         setState(() {
//           _isvoiceactive = false;
//         });
//       });
//     }
//   }

//   Future<String> detectLanguage(String text) async {
//     // Check if the text contains characters from the Hindi script
//     if (RegExp(r'[अ-ह]+').hasMatch(text)) {
//       return 'hi'; // Hindi
//     }
//     // Check if the text contains characters from the English alphabet
//     else if (RegExp(r'[a-zA-Z]+').hasMatch(text)) {
//       return 'en'; // English
//     } else {
//       return ''; // Unknown language
//     }
//   }

//   List<dynamic> recipes = [];
//   @override
//   void initState() {
//     super.initState();
//     List<dynamic> newws =
//         context.read<RecommendedRecipesProvider>().recommendedRecipes;
//     recipes = newws.toList();
//     flutterTts = FlutterTts();
//     speakRecipeSteps(1, false);
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     _confettiController = ConfettiController(duration: Duration(seconds: 5));
//   }

//   AssetImage _image = AssetImage('assets/images/foo2.gif');

//   @override
//   Widget build(BuildContext context) {
//     Future<void> playAudio() async {
//       final player = AudioPlayer();
//       await player.setAsset('assets/images/home/yay.mp3');
//       await player.setVolume(0.1);
//       await player.play();
//     }

//     @override
//     void dispose() {
//       super.dispose();
//     }

//     // @override
//     // void initState() {
//     //   super.initState();
//     //   // Add your provider logic here
//     //   //  Provider.of<RecipeTrackingProvider>(context, listen: false)
//     //   //                 .addToRecipeVisit("${widget.recipe['id']}");
//     //   Set<dynamic> newws = context.read<RecipeTrackingProvider>().
//     // edCooking;
//     //   print(newws);
//     //   // Provider.of<RecipeTrackingProvider>(context)
//     //   //     .addToRecipeVisit(widget.recipe['id']);
//     //   // final integerListProvider = Provider.of<RecipeTrackingProvider>(context);
//     //   // print(integerListProvider);
//     // }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Recipe Instructions'),
//       ),
//       body: _allStepsCompleted
//           ? Stack(
//               children: [
//                 _buildMainContent(),
//                 _buildOverlay(),
//               ],
//             )
//           : Stack(
//               children: [
//                 Stack(children: [
//                   _buildMainContent(),
//                   Positioned(
//                       left: 10.w,
//                       bottom: 20.h,
//                       child: GestureDetector(
//                         onTap: () {
//                           flutterTts.stop();
//                           // speakRecipeSteps(_currentStep + 1);
//                           _animationController.forward(from: 0.0);
//                           setState(() {
//                             // _isvoiceactive =false

//                             if (_currentStep > 0) {
//                               _currentStep--;
//                               _animationController.reverse(from: 1.0);
//                               _allStepsCompleted = false;
//                             }
//                           });
//                         },
//                         child: _allStepsCompleted
//                             ? Container()
//                             : _currentStep == -1
//                                 ? Container()
//                                 : _isvoiceactive
//                                     ? Container()
//                                     : Image.asset(
//                                         'assets/images/nex2.png',
//                                         height: 56.h,
//                                       ),
//                       )),
//                   Positioned(
//                     right: 10.w,
//                     bottom: 20.h,
//                     child: GestureDetector(
//                       onTap: () {
//                         // print('here');
//                         // speakRecipeSteps(_currentStep + 1);
//                         // _animationController.forward(from: 0.0);
//                         flutterTts.stop();
//                         setState(() {
//                           // print('there');
//                           if (_currentStep <
//                               widget.recipe['Steps'].length - 1) {
//                             _currentStep++;
//                           } else {
//                             _allStepsCompleted = true;
//                             playAudio();
//                             _confettiController.play();
//                           }
//                         });
//                       },
//                       child: _allStepsCompleted
//                           ? Container()
//                           : _currentStep == -1
//                               ? Container()
//                               : _currentStep ==
//                                       widget.recipe['Steps'].length - 1
//                                   ? _isvoiceactive
//                                       ? Container()
//                                       : Image.asset(
//                                           'assets/images/serve.png',
//                                           height: 56.h,
//                                         )
//                                   : _isvoiceactive
//                                       ? Container()
//                                       : Image.asset(
//                                           'assets/images/nex.png',
//                                           height: 56.h,
//                                         ),
//                     ),
//                   ),
//                   Positioned(
//                     right: 0.w,
//                     left: 0.w,
//                     bottom: 20.h,
//                     child: GestureDetector(
//                       onTap: () {
//                         flutterTts.stop();

//                         _isvoiceactive
//                             ? null
//                             : speakRecipeSteps(_currentStep, true);
//                         _animationController.forward(from: 0.0);
//                         _currentStep == -1
//                             ? null
//                             : setState(() {
//                                 _isvoiceactive = !_isvoiceactive;
//                                 // if (_currentStep < widget.recipe['Steps'].length - 1) {
//                                 //   _currentStep++;
//                                 // } else {
//                                 //   _allStepsCompleted = true;
//                                 //   _confettiController.play();
//                                 // }
//                               });
//                       },
//                       child: _allStepsCompleted
//                           ? Container()
//                           : _currentStep == -1
//                               ? Container(
//                                   // color: Colors.amber,
//                                   child: Center(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Provider.of<RecipeTrackingProvider>(
//                                                 context,
//                                                 listen: false)
//                                             .addToStartedCooking(
//                                                 "${widget.recipe['id']}");
//                                         Set<dynamic> newws = context
//                                             .read<RecipeTrackingProvider>()
//                                             .startedCooking;
//                                         print(newws);
//                                         setState(() {
//                                           _currentStep++;
//                                         });
//                                       },
//                                       child: Container(
//                                         width:
//                                             Screen.screenWidth(context) * 0.55,
//                                         decoration: BoxDecoration(
//                                           color: FoodieColors.darkSecondary,
//                                           borderRadius:
//                                               BorderRadius.circular(30.r),
//                                         ),
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 16.w, vertical: 10.h),
//                                           child: Row(
//                                             children: [
//                                               Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 10.0.w),
//                                                 child: Text(
//                                                   "Start Cooking",
//                                                   style: TextStyle(
//                                                       fontFamily: 'metropolis',
//                                                       color: Colors.white,
//                                                       fontSize: 20.sp,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ),
//                                               Spacer(),
//                                               CircleAvatar(
//                                                   backgroundColor: Colors.white,
//                                                   radius: 16,
//                                                   child: Center(
//                                                     child: Padding(
//                                                       padding:
//                                                           EdgeInsets.only(
//                                                               left: 2.0.w),
//                                                       child: Icon(
//                                                         size: 22.sp,
//                                                         Icons.chevron_right,
//                                                         color: Colors.teal[700],
//                                                       ),
//                                                     ),
//                                                   ))
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : _isvoiceactive
//                                   ? AvatarGlow(
//                                       child: CircleAvatar(
//                                         radius: 32,
//                                         child: Icon(
//                                           Icons.mic,
//                                           color: Colors.white,
//                                         ),
//                                         backgroundColor:
//                                             Color.fromRGBO(0, 74, 124, 1),
//                                       ),
//                                       glowColor: Color.fromRGBO(0, 74, 124, 1),
//                                       // endRadius: 90.0,
//                                       duration: Duration(milliseconds: 2000),
//                                       glowRadiusFactor: 0.5,
//                                       repeat: true,
//                                     )
//                                   : CircleAvatar(
//                                       radius: 32,
//                                       child: Icon(
//                                         Icons.play_arrow,
//                                         color: Colors.white,
//                                       ),
//                                       backgroundColor:
//                                           Color.fromRGBO(0, 74, 124, 1),
//                                     ),
//                     ),
//                   ),
//                 ]),
//               ],
//             ),
//       floatingActionButtonLocation:
//           _allStepsCompleted ? FloatingActionButtonLocation.startFloat : null,
//     );
//   }

//   Widget _buildMainContent() {
//     return SafeArea(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0.w),
//             child: Text(
//               'Steps',
//               style: TextStyle(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Container(
//             height: 4.h,
//             margin: EdgeInsets.symmetric(horizontal: 16.w),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2.r),
//             ),
//             child: Column(
//               children: [
//                 LinearProgressIndicator(
//                   value: ((_currentStep + 1) / widget.recipe['Steps'].length)
//                       .toDouble(),
//                   backgroundColor: Colors.transparent,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 16.h),
//                   // Loop through the steps and create ListTile widgets
//                   for (int index = 0;
//                       index < widget.recipe['Steps'].length;
//                       index++)
//                     ListTile(
//                       leading: CircleAvatar(
//                         radius: 15,
//                         backgroundColor: index <= _currentStep
//                             ? FoodieColors.darkSecondary
//                             : Colors.grey[300],
//                         child: Text(
//                           (index + 1).toString(),
//                           style: TextStyle(
//                             color: index <= _currentStep
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         widget.recipe['Steps'][index],
//                         textAlign: TextAlign.justify,
//                         style: TextStyle(
//                           fontWeight:
//                               index == _currentStep ? FontWeight.w600 : null,
//                           color: index == _currentStep
//                               ? Color.fromARGB(255, 22, 120, 26)
//                               : index < _currentStep
//                                   ? Colors.black
//                                   : Colors.grey[400],
//                         ),
//                       ),
//                       trailing: index < _currentStep
//                           ? Icon(Icons.check, color: Colors.green)
//                           : index == _currentStep
//                               ? null
//                               : null,
//                     ),

//                   SizedBox(height: 75.h),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildOverlay() {
//     bool _isPlaying = false; // Flag to track audio playing state

//     Future<void> playAudio() async {
//       if (_isPlaying) {
//         return; // Do nothing if audio is already playing
//       }

//       _isPlaying = true; // Set flag to indicate audio is now playing

//       final player = AudioPlayer();
//       await player.setAsset('assets/images/home/yay.mp3');
//       await player.setVolume(0.1);
//       await player.play();

//       // Option 1 (if using latest just_audio):
//       // player.playerStateStream.listen((playerState) {
//       //   if (playerState == PlayerState.COMPLETED) {
//       //     _isPlaying = false;
//       //   }
//       // });

//       // Option 2 (alternative completion check):
//       player.playerStateStream.listen((playerState) {
//         if (playerState.processingState == ProcessingState.completed) {
//           _isPlaying = false;
//         }
//       });
//     }

//     return Center(
//       child: Stack(
//         children: [
//           BackdropFilter(
//             filter: ImageFilter.blur(
//                 sigmaX: 7,
//                 sigmaY: 7), // Adjust sigmaX and sigmaY for desired blur effect
//             child: Container(
//               color: Colors.transparent, // Overlay color is transparent
//               width: double.infinity,
//               height: double.infinity,
//             ),
//           ),
//           Center(
//             child: ConfettiWidget(
//               confettiController: _confettiController,
//               blastDirectionality: BlastDirectionality.explosive,
//               particleDrag: 0.05, // Change particleDrag value as needed
//               emissionFrequency:
//                   0.05, // Change emissionFrequency value as needed
//               numberOfParticles: 10, // Change numberOfParticles value as needed
//               gravity: 0.05, // Change gravity value as needed
//             ),
//           ),
//           Center(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image(image: _image),
//               SizedBox(
//                 height: 10.h,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.0.w),
//                 child: Text(
//                   "Thanks For Cooking With Foodies By",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontFamily: 'metropolis',
//                       color: Colors.black,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.0.w),
//                 child: Text(
//                   "Sachin Sharma",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontFamily: 'metropolis',
//                       color: Colors.red,
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Container(
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0.w),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             PageTransition(
//                               duration: Duration(milliseconds: 300),
//                               type: PageTransitionType.fade,
//                               child: RecipieIndex(
//                                 recipes: recipes,
//                               ),
//                             ),
//                             (route) => false,
//                           );
//                         },
//                         child: Column(
//                           children: [
//                             Image.asset(
//                               'assets/images/hpme.png',
//                               height: 70.h,
//                             ),
//                             SizedBox(
//                               height: 5.h,
//                             ),
//                             Text(
//                               "Back To Home",
//                               style: TextStyle(
//                                   fontFamily: 'metropolis',
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20.w,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             PageTransition(
//                               duration: Duration(milliseconds: 300),
//                               type: PageTransitionType.fade,
//                               child: feedbackForm(userData: widget.userData),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           children: [
//                             Image.asset(
//                               'assets/images/feed.png',
//                               height: 70.h,
//                             ),
//                             SizedBox(
//                               height: 5.h,
//                             ),
//                             Text(
//                               "Review/Feedback",
//                               style: TextStyle(
//                                   fontFamily: 'metropolis',
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           )),
//           Positioned(
//             right: 10.w,
//             bottom: 10.h,
//             child: FloatingActionButton(
//                 elevation: 0,
//                 backgroundColor: Colors.transparent,
//                 onPressed: () {
//                   playAudio();
//                   _animationController.forward(from: 0.0);
//                   setState(() {
//                     _confettiController.play();
//                   });
//                 },
//                 child: Image.asset('assets/images/con.png')),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Stop the audio and dispose of the FlutterTts instance in the dispose method
//     flutterTts.stop();

//     _animationController.dispose();
//     _confettiController.dispose();
//     super.dispose();
//     _image.evict();
//   }
// }
