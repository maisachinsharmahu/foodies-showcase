import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';
import 'package:toastification/toastification.dart'; // Import the toastification package

void showRecipeSavedToast(BuildContext context) {
  toastification.show(
    // icon: const Icon(Icons.check),

    // style: ToastificationStyle.flatColored,

    backgroundColor: Colors.white,

    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    borderRadius: BorderRadius.circular(12.r),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],

    // applyBlurEffect: true,
    alignment: Alignment.topCenter,
    context: context,
    title: Text('Recipie has been added to your favorites'),
    type: ToastificationType.success,
    progressBarTheme:
        ProgressIndicatorThemeData(color: FoodieColors.darkSecondary),
    autoCloseDuration: const Duration(seconds: 3),
  );
}

void showRecipeRemovedToast(BuildContext context) {
  toastification.show(
    backgroundColor: Colors.white,

    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    borderRadius: BorderRadius.circular(12.r),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],

    // applyBlurEffect: true,
    alignment: Alignment.topCenter,
    context: context,
    title: Text(
      'Recipe removed from  favorites',
      style: TextStyle(color: Colors.red),
    ),
    type: ToastificationType.error,
    progressBarTheme: ProgressIndicatorThemeData(color: Colors.red),
    autoCloseDuration: const Duration(seconds: 3),
  );
}

void showFeedbackSavedToast(BuildContext context) {
  toastification.show(
    icon: const Icon(Icons.check),
    primaryColor: FoodieColors.darkSecondary,
    style: ToastificationStyle.flatColored,

    backgroundColor: Colors.white,

    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    borderRadius: BorderRadius.circular(12.r),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],

    // applyBlurEffect: true,
    alignment: Alignment.bottomCenter,
    context: context,
    title: Text('Thank You For Your Time'),
    type: ToastificationType.success,
    progressBarTheme:
        ProgressIndicatorThemeData(color: FoodieColors.darkSecondary),
    autoCloseDuration: const Duration(seconds: 3),
  );
}
