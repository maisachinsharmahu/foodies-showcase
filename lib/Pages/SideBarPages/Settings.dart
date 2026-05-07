import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/darkmode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import 'package:iconsax/iconsax.dart';

class settingsPage extends StatefulWidget {
  final Function() openDrawerCallback;
  final Map<String, dynamic> userData;
  final List<dynamic> recipes;

  const settingsPage({
    super.key,
    required this.openDrawerCallback,
    required this.userData,
    required this.recipes,
  });

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.sp,
            fontFamily: 'metropolis',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          _buildSectionHeader("Appearance"),
          ListTile(
            leading: Icon(darkModeProvider.isDarkMode ? Iconsax.moon : Iconsax.sun, color: FoodieColors.darkSecondary),
            title: Text("Dark Mode", style: TextStyle(fontSize: 16.sp, fontFamily: 'metropolis')),
            trailing: Switch(
              value: darkModeProvider.isDarkMode,
              onChanged: (val) => darkModeProvider.toggleDarkMode(),
              activeColor: FoodieColors.darkSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          _buildSectionHeader("Account"),
          ListTile(
            leading: Icon(Iconsax.user_edit, color: FoodieColors.darkSecondary),
            title: Text("Edit Profile", style: TextStyle(fontSize: 16.sp, fontFamily: 'metropolis')),
            onTap: () {
              // Navigation to profile edit can be added here
            },
          ),
          ListTile(
            leading: Icon(Iconsax.logout, color: Colors.red),
            title: Text("Logout & Reset", style: TextStyle(fontSize: 16.sp, fontFamily: 'metropolis', color: Colors.red)),
            onTap: () => _showLogoutDialog(context),
          ),
          SizedBox(height: 30.h),
          _buildSectionHeader("About & Support"),
          ListTile(
            leading: Icon(Iconsax.info_circle, color: FoodieColors.darkSecondary),
            title: Text("App Version", style: TextStyle(fontSize: 16.sp, fontFamily: 'metropolis')),
            trailing: Text("2.0.0 (Beast Mode)", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h, top: 10.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout & Reset"),
        content: const Text("This will clear all your local data including favorites, meal plans, and grocery list. Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Restart.restartApp();
            },
            child: const Text("Yes, Reset Everything", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
