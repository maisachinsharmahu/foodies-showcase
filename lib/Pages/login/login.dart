import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/Pages/Index/index.dart';
import 'package:foodie/helper/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();

  void _saveLocalProfile(BuildContext context) async {
    if (_nameController.text.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', _nameController.text.trim());

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PapaHuPapa()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/login.png'),
                opacity: 0.9,
                fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 0.h,
          child: Container(
            width: 1.sw,
            height: 0.4.sh,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                  Colors.black,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.2.sh,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ready to unlock a world of deliciousness? ",
                  style: TextStyle(
                      color: Colors.white, fontSize: 16.sp, fontFamily: 'Poppins'),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Start Cooking ",
                  style: TextStyle(
                      color: Colors.white, fontSize: 30.sp, fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your chef name...',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0.1.sh,
          child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              width: 1.sw,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FoodieColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  )
                ),
                onPressed: () => _saveLocalProfile(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lets Cook",
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
        ),
        Positioned(
          top: 150.h,
          child: Image.asset(
            'assets/images/logo.png',
            color: Colors.white,
            height: 0.1.sh,
            width: 1.sw,
          ),
        ),
      ]),
    );
  }
}
