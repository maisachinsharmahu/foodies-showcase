import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:foodie/Pages/SideBarPages/Feedback.dart';
import 'package:foodie/helper/recipe_tracking.dart';
import 'package:foodie/main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/helper/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'dart:async';

class CookSteps extends StatefulWidget {
  final Map<String, dynamic> userData;
  final dynamic recipe;
  const CookSteps({super.key, required this.recipe, required this.userData});

  @override
  State<CookSteps> createState() => _CookStepsState();
}

class _CookStepsState extends State<CookSteps>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ConfettiController _confettiController;
  int _currentStep = -1;
  bool _allStepsCompleted = false;
  FlutterTts flutterTts = FlutterTts(); // Initialize FlutterTts instance
  bool _isvoiceactive = false;
  Future<void> speakRecipeSteps(int index, bool no) async {
    // Sample step text to detect language, you can replace it with the actual recipe step
    if (no) {
      String sampleStep = widget.recipe['Steps'][index];

      // Detect language of the sample step text
      String detectedLanguage = await detectLanguage(sampleStep);

      // Set language based on detected language
      if (detectedLanguage == 'en') {
        await flutterTts.setLanguage("en-US"); // Set language to English
      } else if (detectedLanguage == 'hi') {
        await flutterTts.setLanguage("hi-IN");
        // await flutterTts
        //     .setVoice({"name": "hi-in-x-hic-local"}); // Set language to Hindi
      } else {
        // Default to English if language detection fails or if it's not English or Hindi
        await flutterTts.setLanguage("en-US");
      }

      await flutterTts.setPitch(1.0);

      // Speak the step at the given index
      await flutterTts.speak(widget.recipe['Steps'][index]);
      await flutterTts.awaitSpeakCompletion(true).whenComplete(() {
        setState(() {
          _isvoiceactive = false;
        });
      });
    }
  }

  Future<String> detectLanguage(String text) async {
    // Check if the text contains characters from the Hindi script
    if (RegExp(r'[अ-ह]+').hasMatch(text)) {
      return 'hi'; // Hindi
    }
    // Check if the text contains characters from the English alphabet
    else if (RegExp(r'[a-zA-Z]+').hasMatch(text)) {
      return 'en'; // English
    } else {
      return ''; // Unknown language
    }
  }

  List<dynamic> recipes = [];
  @override
  void initState() {
    super.initState();
    List<dynamic> newws =
        context.read<RecommendedRecipesProvider>().recommendedRecipes;
    recipes = newws.toList();
    flutterTts = FlutterTts();
    speakRecipeSteps(1, false);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
    
    // Enable wakelock for cooking
    WakelockPlus.enable();
  }

  final AssetImage _image = AssetImage('assets/images/foo2.gif');

  Future<void> playAudio() async {
    final player = AudioPlayer();
    await player.setAsset('assets/images/home/yay.mp3');
    await player.setVolume(0.1);
    await player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          _allStepsCompleted ? FloatingActionButtonLocation.startFloat : null,
      backgroundColor: Colors.white,
      body: _allStepsCompleted
          ? Stack(
              children: [
                baseofapp(),
                _buildOverlay(),
              ],
            )
          : Stack(
              children: [
                SizedBox(
                  width: 1.sw,
                  child: Image.asset(
                    'assets/images/bg.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                baseofapp(),
                Positioned(
                    left: 10.w,
                    bottom: 20.h,
                    child: GestureDetector(
                      onTap: () {
                        flutterTts.stop();
                        _animationController.forward(from: 0.0);
                        setState(() {
                          if (_currentStep > 0) {
                            _currentStep--;
                            _animationController.reverse(from: 1.0);
                            _allStepsCompleted = false;
                          }
                        });
                      },
                      child: _allStepsCompleted
                          ? Container()
                          : _currentStep == -1
                              ? Container()
                              : _currentStep == widget.recipe['Steps'].length
                                  ? Container()
                                  : _isvoiceactive
                                      ? Container()
                                      : Image.asset(
                                          'assets/images/nex2.png',
                                          height: 56.h,
                                        ),
                    )),
                Positioned(
                  right: 10.w,
                  bottom: 20.h,
                  child: GestureDetector(
                    onTap: () {
                      flutterTts.stop();
                      setState(() {
                        if (_currentStep < widget.recipe['Steps'].length) {
                          _currentStep++;
                        } else {
                          _allStepsCompleted = true;
                          playAudio();
                          _confettiController.play();
                        }
                      });
                    },
                    child: _allStepsCompleted
                        ? Container()
                        : _currentStep == -1
                            ? Container()
                            : _currentStep == widget.recipe['Steps'].length - 1
                                ? _isvoiceactive
                                    ? Container()
                                    : Image.asset(
                                        'assets/images/serve.png',
                                        height: 56.h,
                                      )
                                : _currentStep == widget.recipe['Steps'].length
                                    ? Container()
                                    : _isvoiceactive
                                        ? Container()
                                        : Image.asset(
                                            'assets/images/nex.png',
                                            height: 56.h,
                                          ),
                  ),
                ),
                if (_isTimerRunning)
                  Positioned(
                    top: 20.h,
                    right: 20.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: Colors.white, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            "${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () => setState(() { _timer?.cancel(); _isTimerRunning = false; }),
                            child: Icon(Icons.close, color: Colors.white, size: 18.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  right: 20.w,
                  bottom: 100.h,
                  child: FloatingActionButton(
                    onPressed: _showTimerDialog,
                    backgroundColor: FoodieColors.darkSecondary,
                    child: Icon(Icons.timer_outlined, color: Colors.white),
                  ),
                ),
                Positioned(
                  right: 0.w,
                  left: 0.w,
                  bottom: 10.h,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_allStepsCompleted)
                          _buildStepControl(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStepControl() {
    if (_currentStep == -1) {
      return GestureDetector(
        onTap: () async {
          await RecipeTracking.addToStartedCooking('${widget.recipe['id']}');
          setState(() {
            _currentStep++;
          });
        },
        child: Container(
          width: 0.6.sw,
          decoration: BoxDecoration(
            color: FoodieColors.darkSecondary,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Start Cooking",
                  style: TextStyle(
                      fontFamily: 'metropolis',
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10.w),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16.r,
                  child: Icon(
                    Icons.chevron_right,
                    size: 22.sp,
                    color: FoodieColors.darkSecondary,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    if (_currentStep == widget.recipe['Steps'].length) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SwipeableButtonView(
          buttonText: 'Finish Cooking',
          buttontextstyle: TextStyle(fontSize: 22.sp, color: Colors.white),
          buttonWidget: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
            size: 20.sp,
          ),
          activeColor: FoodieColors.darkSecondary,
          onWaitingProcess: () async {
            await RecipeTracking.addToCooked('${widget.recipe['id']}');
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _allStepsCompleted = true;
                  playAudio();
                  _confettiController.play();
                });
              }
            });
          },
          isFinished: _allStepsCompleted,
          onFinish: () {},
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        flutterTts.stop();
        if (!_isvoiceactive) {
          speakRecipeSteps(_currentStep, true);
        }
        setState(() {
          _isvoiceactive = !_isvoiceactive;
        });
      },
      child: _isvoiceactive
          ? AvatarGlow(
              glowColor: const Color.fromRGBO(0, 74, 124, 1),
              duration: const Duration(milliseconds: 2000),
              glowRadiusFactor: 0.5,
              repeat: true,
              child: CircleAvatar(
                radius: 35.r,
                backgroundColor: const Color.fromRGBO(0, 74, 124, 1),
                child: Icon(
                  Icons.mic,
                  size: 28.sp,
                  color: Colors.white,
                ),
              ),
            )
          : CircleAvatar(
              radius: 35.r,
              backgroundColor: const Color.fromRGBO(0, 74, 124, 1),
              child: Icon(
                Icons.play_arrow,
                size: 38.sp,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget baseofapp() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(26.0.w),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
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
                  "Recipe Instructions",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                Container(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Row(
              children: [
                Text(
                  'Steps',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: FoodieColors.darkSecondary,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Text(
                          '${widget.recipe['Total Time']}',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 4.h,
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: ((_currentStep + 1) / widget.recipe['Steps'].length)
                      .toDouble(),
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.0.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMainContent(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              for (int index = 0;
                  index < widget.recipe['Steps'].length;
                  index++)
                Stack(
                  children: [
                    Positioned(
                      top: 0.0.h,
                      bottom: 0.0.h,
                      left: 30.0.w,
                      child: CustomPaint(
                        size: const Size(1.0, double.infinity),
                        painter: DottedLinePainter(),
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 15.r,
                        backgroundColor: index <= _currentStep
                            ? FoodieColors.darkSecondary
                            : Colors.grey[300],
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: index <= _currentStep
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      title: Text(
                        widget.recipe['Steps'][index],
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontWeight:
                              index == _currentStep ? FontWeight.w600 : null,
                          color: index == _currentStep
                              ? const Color.fromARGB(255, 22, 120, 26)
                              : index < _currentStep
                                  ? Colors.grey[800]
                                  : Colors.grey[400],
                        ),
                      ),
                      trailing: index < _currentStep
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                    ),
                  ],
                ),
              SizedBox(height: 75.h),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOverlay() {
    bool isPlaying = false;

    Future<void> playAudio() async {
      if (isPlaying) {
        return;
      }
      isPlaying = true;
      final player = AudioPlayer();
      await player.setAsset('assets/images/home/yay.mp3');
      await player.setVolume(0.1);
      await player.play();
      player.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          isPlaying = false;
        }
      });
    }

    return Center(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 7,
                sigmaY: 7),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 10,
              gravity: 0.05,
            ),
          ),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: _image),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Text(
                  "Thanks For Cooking With Foodies By",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'metropolis',
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Text(
                  "Sachin Sharma",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'metropolis',
                      color: Colors.red,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              duration: const Duration(milliseconds: 300),
                              type: PageTransitionType.fade,
                              child: RecipieIndex(
                                recipes: recipes,
                              ),
                            ),
                            (route) => false,
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/hpme.png',
                              height: 70.h,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "Back To Home",
                              style: TextStyle(
                                  fontFamily: 'metropolis',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: const Duration(milliseconds: 300),
                              type: PageTransitionType.fade,
                              child: feedbackForm(userData: widget.userData),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/feed.png',
                              height: 70.h,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "Review/Feedback",
                              style: TextStyle(
                                  fontFamily: 'metropolis',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
          Positioned(
            right: 10.w,
            bottom: 10.h,
            child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  playAudio();
                  _animationController.forward(from: 0.0);
                  setState(() {
                    _confettiController.play();
                  });
                },
                child: Image.asset('assets/images/con.png')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Stop the audio and dispose of the FlutterTts instance in the dispose method
    flutterTts.stop();

    _animationController.dispose();
    _confettiController.dispose();
    
    // Disable wakelock
    WakelockPlus.disable();
    _timer?.cancel();
    
    super.dispose();
    _image.evict();
  }

  // Timer logic
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isTimerRunning = false;

  void _startTimer(int seconds) {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = seconds;
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        setState(() => _isTimerRunning = false);
        _showTimerFinished();
      }
    });
  }

  void _showTimerFinished() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Time's up! Check your food."),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(label: "OK", textColor: Colors.white, onPressed: () {}),
      ),
    );
  }

  void _showTimerDialog() {
    int selectedMinutes = 5;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(24.w),
          height: 0.4.sh,
          child: Column(
            children: [
              Text("Set Kitchen Timer", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'metropolis')),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () => setModalState(() => selectedMinutes > 1 ? selectedMinutes-- : null), icon: Icon(Icons.remove_circle_outline, size: 30.sp)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text("$selectedMinutes min", style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(onPressed: () => setModalState(() => selectedMinutes++), icon: Icon(Icons.add_circle_outline, size: 30.sp)),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  _startTimer(selectedMinutes * 60);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FoodieColors.darkSecondary,
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Text("Start Timer", style: TextStyle(fontSize: 18.sp, color: Colors.white)),
              )
            ],
          ),
        ),
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
