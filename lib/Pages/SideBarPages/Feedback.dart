import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/local_helper.dart';

class feedbackForm extends StatefulWidget {
  final List<dynamic>? recipes;
  final Map<String, dynamic> userData;
  const feedbackForm({super.key, required this.userData, this.recipes});

  @override
  _feedbackFormState createState() => _feedbackFormState();
}

class _feedbackFormState extends State<feedbackForm> {
  String? _selectedExperience;
  String? _recommendation;
  String? _comment;

  void _submitFeedback() async {
    if (_selectedExperience != null &&
        _recommendation != null &&
        _comment != null) {
      try {
        // Since we are offline-only, we just show a success message.
        // In a real app, this might be synced later or sent via email API.
        
        FancySnackbar.show(
            context, "Thanks For Your Time\nFeedback submitted successfully!",
            logo: const Icon(Icons.done_all, color: Colors.white), seconds: 5);

        // Show a success message or navigate to another screen
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Feedback submitted successfully!'),
        //     duration: Duration(seconds: 2),
        //   ),
        // );

        FancySnackbar.show(
            context, "Thanks For Your Time\nFeedback submitted successfully!",
            logo: const Icon(Icons.done_all, color: Colors.white), seconds: 05);
        // Clear form fields after submission
        setState(() {
          _selectedExperience = null;
          _recommendation = null;
          _comment = null;
        });
        Navigator.pop(
          context,
          (route) => false,
        );
      } catch (error) {
        // Handle errors
        print('Error submitting feedback: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill out all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Container(
              color: FoodieColors.darkSecondary,
              height: 600.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(26.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.white.withOpacity(0.6),
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
                        "Feedback",
                        style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Poppins'),
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/bg.png'),
                        fit: BoxFit.fitHeight,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r))),
                  child: Padding(
                    padding: EdgeInsets.all(26.0.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Share Your Feedback",
                          style: TextStyle(
                            fontFamily: 'metropolis',
                            fontSize: 24.sp,
                            color: const Color.fromARGB(255, 44, 93, 62),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Rate Your Experience",
                          style: TextStyle(
                            fontFamily: 'metropolis',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _emojiButton(Fluents.flAngryFaceWithHorns, "Poor"),
                            _emojiButton(
                                Fluents.flSlightlyFrowningFace, "Average"),
                            _emojiButton(Fluents.flNeutralFace, "Good"),
                            _emojiButton(
                                Fluents.flGrinningFaceWithBigEyes, "Excellent"),
                            _emojiButton(
                                Fluents.flSmilingFaceWithHeartEyes, "Awsome"),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          "Would you recommend us to your friends",
                          style: TextStyle(
                            fontFamily: 'metropolis',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _numberButton("1", "Not likely"),
                            _numberButton("2", "Unlikely"),
                            _numberButton("3", "Maybe"),
                            _numberButton("4", "Likely"),
                            _numberButton("5", "Most likely"),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        Row(
                          children: [
                            Text(
                              "Your Comment  ",
                              style: TextStyle(
                                fontFamily: 'metropolis',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "(500 words)",
                              style: TextStyle(
                                  fontFamily: 'metropolis',
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade600
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          maxLength: 500,
                          decoration: InputDecoration(
                            hintText: 'Describe Your Experience here...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                    color: FoodieColors.darkSecondary)),
                          ),
                          onChanged: (value) {
                            _comment = value;
                          },
                        ),

                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: _submitFeedback,
                          child: Container(
                            width: 1.sw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: FoodieColors.darkSecondary,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: Center(
                                child: Text(
                                  "Send Feeback",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget _emojiButton(FluentData data, String label) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedExperience = label;
          });
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: _selectedExperience == label
                  ? Colors.white
                  : Colors.grey[200],
              radius: 22.r,
              child: FluentUiEmojiIcon(
                fl: data,
                w: _selectedExperience == label ? 40.w : 35.w,
                h: _selectedExperience == label ? 40.h : 35.h,
              ),
            ),
            _selectedExperience == label
                ? Text(
                    label,
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color.fromARGB(255, 58, 102, 7),
                        fontWeight: FontWeight.w500),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _numberButton(String number, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _recommendation = number;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: _recommendation == number
                ? Colors.green.withOpacity(0.3)
                : Colors.grey[200],
            radius: 20.r,
            child: Text(
              number,
              style: TextStyle(
                  fontWeight:
                      _recommendation == number ? FontWeight.bold : null,
                  fontSize: _recommendation == number ? 20.sp : null),
            ),
          ),
          _recommendation == number
              ? Text(
                  label,
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color.fromARGB(255, 58, 102, 7),
                      fontWeight: FontWeight.w500),
                )
              : Container(),
        ],
      ),
    );
  }
}
