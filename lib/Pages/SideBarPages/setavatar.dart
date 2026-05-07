import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
// User
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/local_helper.dart';

class SetAvatars extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SetAvatars({super.key, required this.userData});

  @override
  State<SetAvatars> createState() => _SetAvatarsState();
}

class _SetAvatarsState extends State<SetAvatars> {
  late int _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = int.tryParse(widget.userData['avatar']?.toString() ?? '1')! - 1;
    if (_selectedAvatar < 0) _selectedAvatar = 0;
  }

  void updateUserAvatarCuisines() async {
    // Update to local SharedPreferences index (stored as String path earlier or just 1.png)
    String newAvatar = (_selectedAvatar + 1).toString();
    await LocalHelper.setAvatar(newAvatar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 45, 45, 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          btnCancelColor: const Color(0xFF00CA71),
                          btnOkColor: Colors.red,
                          animType: AnimType.rightSlide,
                          title: 'Cancel',
                          desc:
                              'Are you sure you want to cancel without setting a new avatar?',
                          btnCancelText: "No, Go Back",
                          btnOkText: "Yes",
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            try {
                              Navigator.pop(context);
                            } catch (e) {
                              // Handle error
                            }
                          },
                        ).show();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Choose Your Avatar",
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Confirm Avatar',
                          desc: 'Would you like to change your avatar?',
                          btnCancelText: "No, Go Back",
                          btnOkText: "Yes, Update",
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            try {
                              updateUserAvatarCuisines();
                              Navigator.pop(context);
                            } catch (e) {
                              // Handle error
                            }
                          },
                        ).show();
                      },
                      child: Icon(
                        Icons.done,
                        color: Colors.greenAccent,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(top: 0.0.h),
                child: SizedBox(
                  height: 270.h,
                  width: 1.sw,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 250.h,
                        width: 1.sw,
                        child: Opacity(
                          opacity: 0.8,
                          child: Image.asset(
                            'assets/images/home/back.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 250.h,
                        width: 1.sw,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: Image.asset(
                            'assets/images/avatars2/${_selectedAvatar + 1}.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 30.w,
                      mainAxisSpacing: 30.h,
                    ),
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return Bounceable(
                        onTap: () {
                          setState(() {
                            _selectedAvatar = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: _selectedAvatar == index
                                ? Border.all(
                                    color: FoodieColors.extra,
                                    width: 3.w,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: Opacity(
                              opacity: _selectedAvatar == index ? 1.0 : 0.6,
                              child: Image.asset(
                                'assets/images/avatars2/${index + 1}.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class RotatingImageInsideOval extends StatefulWidget {
//   @override
//   _RotatingImageInsideOvalState createState() =>
//       _RotatingImageInsideOvalState();
// }

// class _RotatingImageInsideOvalState extends State<RotatingImageInsideOval>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 5),
//       // value: 0.75,
//       lowerBound: 0.25,
//       // upperBound: 0.75
//       // upperBound:
//       //     0.75, // End at 270 degrees (3/4 of a full rotation) // Increase duration for a slower rotation
//     );
//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = Screen.screenHeight(context);
//     double width = Screen.screenWidth(context);
//     return Stack(
//       children: [
//         AnimatedBuilder(
//           animation: _controller,
//           builder: (context, child) {
//             return Stack(
//               children: [
//                 Stack(
//                   children: [
//                     Positioned(
//                       left: 0.w,
//                       right: 0.w,
//                       top: Screen.screenHeight(context) / 2,
//                       // bottom: 0.h,
//                       child: Transform.translate(
//                         offset: calculateImagePosition(
//                             pi * 2 * _controller.value, Size(width, height)),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape
//                                   .circle), // Replace this with your image URL
//                           width: 100.w, // Adjust width as needed
//                           height: 100.h, // Adjust height as needed
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//         AnimatedBuilder(
//           animation: _controller,
//           builder: (context, child) {
//             return Stack(
//               children: [
//                 Stack(
//                   children: [
//                     Positioned(
//                       left: 0.w,
//                       // right: 0.w,
//                       top: Screen.screenHeight(context) / 2,
//                       // bottom: 0.h,
//                       child: Transform.translate(
//                         offset: calculateImagePosition(
//                             pi * 8 * _controller.value, Size(width, height)),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.pink,
//                               shape: BoxShape
//                                   .circle), // Replace this with your image URL
//                           width: 100.w, // Adjust width as needed
//                           height: 100.h, // Adjust height as needed
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Offset calculateImagePosition(double angle, Size size) {
//     final double radiusX = size.width / 2;
//     ; // Adjust according to your oval's radius
//     final double radiusY =
//         size.height / 2; // Adjust according to your oval's radius
//     // final double centerX = 0; // Adjust according to your oval's center
//     // final double centerY = 0; // Adjust according to your oval's center

//     // Calculate position along the oval's perimeter
//     final double x = radiusX * cos(-angle);
//     final double y = radiusY * sin(-angle);

//     return Offset(x, y);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class OvalPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.stroke;

//     final double radiusX = size.width / 2;
//     final double radiusY = size.height / 2;
//     final Offset center = Offset(size.width / 2, size.height / 2);

//     final Rect oval = Rect.fromCenter(
//       center: center,
//       width: radiusX * 2,
//       height: radiusY * 2,
//     );

//     canvas.drawOval(oval, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class SetAvatars extends StatefulWidget {
//   const SetAvatars({Key? key}) : super(key: key);

//   @override
//   State<SetAvatars> createState() => _SetAvatarsState();
// }

// class _SetAvatarsState extends State<SetAvatars> {
//   int _selectedAvatar = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: RotatingImageInsideOval(),
//       ),
//     );
//   }
// }
// class BackgroundShapes extends StatefulWidget {
//   @override
//   _BackgroundShapesState createState() => _BackgroundShapesState();
// }

// class _BackgroundShapesState extends State<BackgroundShapes>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _isAnimating = false;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleAnimation() {
//     setState(() {
//       _isAnimating = !_isAnimating;
//       if (_isAnimating) {
//         _controller.repeat(reverse: true);
//       } else {
//         _controller.stop();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return Container(
//               color: Colors.black,
//               child: CustomPaint(
//                 painter: BackgroundPainter(_animation.value),
//               ),
//             );
//           },
//         ),
//         Positioned(
//           left: MediaQuery.of(context).size.width / 2 - 100,
//           top: MediaQuery.of(context).size.height / 2 - 100,
//           child: Opacity(
//             opacity: 0.2,
//             child: Container(
//               width: 200.w,
//               height: 200.h,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 20.0.h,
//           right: 20.0.w,
//           child: ElevatedButton(
//             onPressed: _toggleAnimation,
//             child: Text(_isAnimating ? 'Stop Animation' : 'Start Animation'),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class BackgroundPainter extends CustomPainter {
//   final double rotation;

//   BackgroundPainter(this.rotation);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.white.withOpacity(0.7)
//       ..style = PaintingStyle.fill;

//     canvas.save();
//     canvas.translate(size.width / 4, size.height / 4);
//     canvas.rotate(rotation * 2 * 3.14);
//     canvas.drawCircle(Offset(0, 0), 20, paint);
//     canvas.restore();

//     Path trianglePath = Path();
//     trianglePath.moveTo(size.width * 3 / 4, size.height / 4);
//     trianglePath.lineTo(size.width * 3 / 4 + 20, size.height / 4 + 40);
//     trianglePath.lineTo(size.width * 3 / 4 - 20, size.height / 4 + 40);
//     trianglePath.close();
//     canvas.drawPath(trianglePath, paint);

//     paint.color = Colors.red;
//     canvas.drawRect(
//         Rect.fromLTWH(size.width / 4, size.height * 3 / 4, 40, 40), paint);

//     paint.color = Colors.green;
//     canvas.drawRect(
//         Rect.fromLTWH(size.width * 3 / 4, size.height * 3 / 4, 60, 40), paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class SetAvatars extends StatefulWidget {
//   const SetAvatars({Key? key}) : super(key: key);

//   @override
//   State<SetAvatars> createState() => _SetAvatarsState();
// }

// class _SetAvatarsState extends State<SetAvatars> {
//   int _selectedAvatar = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: BackgroundShapes(),
//       ),
//     );
//   }
// }

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class SetAvatars extends StatefulWidget {
//   const SetAvatars({Key? key}) : super(key: key);

//   @override
//   State<SetAvatars> createState() => _SetAvatarsState();
// }

// class _SetAvatarsState extends State<SetAvatars> {
//   int _selectedAvatar = 0; // -1 indicates no avatar selected

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(37, 37, 37, 1),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.0.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 "Choose Your Avatar",
//                 style: TextStyle(fontSize: 30.sp, color: Colors.white),
//               ),
//               SizedBox(height: 20.h),
//               CarouselSlider.builder(
//                 itemCount: 15,
//                 itemBuilder: (BuildContext context, int index, int realIndex) {
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedAvatar = index;
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: _selectedAvatar == index
//                             ? Border.all(
//                                 color: Colors.blue,
//                                 width: 3.w,
//                               )
//                             : null,
//                         borderRadius: BorderRadius.circular(50.r),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(50.r),
//                         child: Opacity(
//                           opacity: _selectedAvatar == index ? 1.0 : 0.6,
//                           child: Image.asset(
//                             'assets/images/avatars2/${index + 1}.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 options: CarouselOptions(
//                   height: 400.h,
//                   enlargeCenterPage: true,
//                   viewportFraction: 0.7,
//                   initialPage: 0,
//                   enableInfiniteScroll: false,
//                   reverse: false,
//                   autoPlay: false,
//                   autoPlayInterval: Duration(seconds: 3),
//                   autoPlayAnimationDuration: Duration(milliseconds: 800),
//                   autoPlayCurve: Curves.fastOutSlowIn,
//                   scrollDirection: Axis.horizontal,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
