import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/Pages/Grocery/grocery_list.dart'; // For GroceryHelper
import 'package:foodie/Pages/ListPage/toast.dart';

class Ingredients extends StatefulWidget {
  final dynamic recipe;

  const Ingredients({super.key, required this.recipe});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients>
    with AutomaticKeepAliveClientMixin {
  late Map<String, bool> checkboxValues;
  bool allChecked = false;
  bool anyChecked = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Initialize the checkboxValues map with the default values
    checkboxValues = Map<String, bool>.fromEntries(
      (widget.recipe['Ingredients'] as Map<String, dynamic>).entries.expand(
            (entry) => (entry.value as List<dynamic>).map(
              (ingredient) =>
                  MapEntry<String, bool>('${entry.key}_$ingredient', false),
            ),
          ),
    );
  }

  // Function to toggle all checkboxes
  void toggleAllCheckboxes() {
    setState(() {
      allChecked = !allChecked;
      checkboxValues.updateAll((key, value) => allChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: !anyChecked,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final bool? shouldPop = await AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: 'Warning!',
          desc: 'You have checked ingredients. Leaving now will remove these items from your list. Are you sure you want to leave?',
          btnOkText: "Ok",
          btnCancelOnPress: () {},
          btnOkOnPress: () {
            Navigator.of(context).pop(true);
          },
        ).show() as bool?;

        if (shouldPop ?? false) {
           // This logic is handled by AwesomeDialog callbacks
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontFamily: 'metropolis',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: toggleAllCheckboxes,
                    icon: Icon(allChecked ? Icons.check_box : Icons.check_box_outline_blank, 
                      size: 18.sp, color: FoodieColors.darkSecondary),
                    label: Text(allChecked ? "Unselect All" : "Select All", 
                      style: TextStyle(color: FoodieColors.darkSecondary, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -20.h,
                    right: -40.w,
                    child: SizedBox(
                      child: Image.asset(
                        'assets/images/in.png',
                        fit: BoxFit.fitHeight,
                        height: 200.h,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -10.h,
                    left: 0.w,
                    child: SizedBox(
                      height: 100.h,
                      child: Image.asset(
                        'assets/images/s.png',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.h,
                    left: -5.w,
                    child: SizedBox(
                      height: 50.h,
                      child: Image.asset(
                        'assets/images/start4.png',
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 0.85.sw,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: FoodieColors.darkSecondary,
                          width: 2.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10.r,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (widget.recipe['Ingredients']
                                  as Map<String, dynamic>)
                              .entries
                              .map((entry) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (entry.key != 'Ingredients')
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
                                    child: Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: FoodieColors.darkSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: (entry.value as List<dynamic>)
                                      .map((ingredient) {
                                    String key = '${entry.key}_$ingredient';
                                    bool isChecked = checkboxValues[key]!;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.h),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 24.w,
                                            height: 24.h,
                                            child: Checkbox(
                                              activeColor:
                                                  FoodieColors.darkSecondary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                              ),
                                              value: isChecked,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  checkboxValues[key] =
                                                      newValue!;
                                                  anyChecked = checkboxValues
                                                      .containsValue(true);
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Text(
                                              ingredient.toString(),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: isChecked
                                                    ? Colors.grey[600]
                                                    : Colors.black87,
                                                decoration: isChecked
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                decorationColor: isChecked
                                                    ? Colors.grey[600]
                                                    : null,
                                              ),
                                              maxLines: null,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      List<String> allItems = [];
                      checkboxValues.forEach((key, _) {
                        String ingredient = key.substring(key.indexOf('_') + 1);
                        allItems.add(ingredient);
                      });
                      
                      await GroceryHelper.addAllToCart(allItems);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("All ${allItems.length} ingredients added to Grocery Cart!"),
                            backgroundColor: FoodieColors.darkSecondary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.add_shopping_cart, color: Colors.white, size: 20.sp),
                    label: Text("Add ALL", style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FoodieColors.darkSecondary,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  OutlinedButton.icon(
                    onPressed: () async {
                      List<String> itemsToAdd = [];
                      checkboxValues.forEach((key, value) {
                        if (value) {
                          String ingredient = key.substring(key.indexOf('_') + 1);
                          itemsToAdd.add(ingredient);
                        }
                      });
                      
                      if (itemsToAdd.isNotEmpty) {
                        await GroceryHelper.addAllToCart(itemsToAdd);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${itemsToAdd.length} checked items added to Cart!"),
                              backgroundColor: FoodieColors.darkSecondary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select items to add.")),
                        );
                      }
                    },
                    icon: Icon(Icons.playlist_add_check, color: FoodieColors.darkSecondary, size: 20.sp),
                    label: Text("Add Checked", style: TextStyle(color: FoodieColors.darkSecondary, fontSize: 14.sp)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: FoodieColors.darkSecondary),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
