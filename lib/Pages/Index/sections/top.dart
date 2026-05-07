import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/SideBarPages/Settings.dart';
import 'package:foodie/Pages/search/animation/animated_text.dart';
import 'package:foodie/Pages/search/search.dart';
import 'package:foodie/helper/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:foodie/helper/local_helper.dart';

class topSection extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String? name;
  final List<dynamic> recipes;
  final Function() openDrawerCallback;

  const topSection(
      {super.key,
      required this.name,
      required this.recipes,
      required this.openDrawerCallback,
      required this.userData});

  @override
  State<topSection> createState() => _topSectionState();
}

class _topSectionState extends State<topSection> {
  final TextEditingController _textEditingController = TextEditingController();
  String userName = "Chef";
  String avatarPath = "1";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await LocalHelper.getUserName();
    final avatar = await LocalHelper.getAvatar();
    if (mounted) {
      setState(() {
        userName = name;
        avatarPath = avatar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.r), bottomRight: Radius.circular(40.r)),
        image: const DecorationImage(
          image: AssetImage('assets/images/bg3.png'),
          fit: BoxFit.cover,
        ),
      ),
      height: 200.h,
      width: 1.sw,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to settings or avatar change
                    _loadProfileData();
                  },
                  child: ClipOval(
                    child: CircleAvatar(
                      radius: 24.r,
                      backgroundImage: AssetImage(
                        'assets/images/avatars2/$avatarPath.png',
                      ),
                      backgroundColor: FoodieColors.darkSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                        children: [
                          const TextSpan(
                            text: "Hello ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                              text: userName,
                              style: TextStyle(
                                color: FoodieColors.darkSecondary,
                              )),
                        ],
                      ),
                    ),
                    Text(
                      "What do you want to cook today?",
                      style: TextStyle(color: FoodieColors.grey3, fontSize: 12.sp),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.segment,
                    size: 30.sp,
                  ),
                  onPressed: widget.openDrawerCallback,
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: AnimatedTextField(
                      hintTexts: const [
                        'Search Food and Recipes',
                        'Search for "Breakfast"',
                        'Search for Cusines',
                        'Search for "Brunch"',
                        "Search 15000+ Recipes"
                      ],
                      animationType: Animationtype.slide,
                      animationDuration: const Duration(seconds: 3),
                      cursorColor: FoodieColors.darkSecondary,
                      controller: _textEditingController,
                      onSubmitted: (value) {
                        if (_textEditingController.text.trim().isNotEmpty) {
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: const Duration(milliseconds: 300),
                              child: searchPage(
                                userData: widget.userData,
                                name: _textEditingController.text,
                                recipes: widget.recipes,
                              ),
                              type: PageTransitionType.fade,
                            ),
                          );
                          _textEditingController.clear();
                        }
                      },
                      decoration: InputDecoration(
                        focusColor: FoodieColors.darkSecondary,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _textEditingController.clear();
                            },
                            icon: const Icon(
                              Icons.close,
                            )),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Search Food and Recipes",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.h),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () {
                    if (_textEditingController.text.trim().isNotEmpty) {
                       Navigator.push(
                          context,
                          PageTransition(
                            duration: const Duration(milliseconds: 300),
                            child: searchPage(
                              userData: widget.userData,
                              name: _textEditingController.text,
                              recipes: widget.recipes,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                    }
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: FoodieColors.darkSecondary,
                        borderRadius: BorderRadius.circular(20.r)),
                    child: Icon(
                      Icons.search,
                      size: 26.sp,
                      color: Colors.grey[50],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}