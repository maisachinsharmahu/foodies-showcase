// const ingredients({super.key, this.recipe});

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';

class ingredients extends StatefulWidget {
  final dynamic recipe;
  const ingredients({super.key, this.recipe});

  @override
  State<ingredients> createState() => _ingredientsState();
}

class _ingredientsState extends State<ingredients> {
  late Map<String, bool> ingredientStates;

  @override
  void initState() {
    super.initState();
    // Initialize ingredientStates map with all checkboxes set to false
    ingredientStates = Map.fromEntries(
      (widget.recipe['Ingredients'] as Map<String, dynamic>)
          .entries
          .map((entry) => MapEntry(entry.key, false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Text(
              'Ingredients',
              style: TextStyle(
                  fontFamily: 'metropolis',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            child: Stack(
              children: [
                Positioned(
                  bottom: 0.h,
                  right: -40,
                  child: Container(
                    // width: Screen.screenWidth(context) * 1,
                    // height: 400.h, // specify the desired height
                    child: Image.asset(
                      'assets/images/in.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                //           Positioned(
                //             bottom: -30,
                //             left: -40,
                //             child: Container(
                //               // width: 200.w, // Adjust the width as needed
                //               height: 170.h, // Adjust the height as needed
                //               child: SvgPicture.string(
                //                 '''
                // <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
                //   <path transform="translate(100 100)" d="M67.6,-21.8C73.4,-4.2,54,21.7,29.9,38.6C5.8,55.6,-23,63.5,-44.4,50.5C-65.8,37.4,-79.7,3.5,-71.1,-18C-62.4,-39.5,-31.2,-48.6,-0.2,-48.6C30.9,-48.5,61.8,-39.3,67.6,-21.8Z" fill="#FF0066" style="fill: #44ff0063;"></path>
                // </svg>
                // ''',
                //                 fit: BoxFit.contain, // Adjust the fit as needed
                //               ),
                //             ),
                //           ),
                Positioned(
                  top: -10,
                  left: 0.w,
                  child: SizedBox(
                    // width: Screen.screenWidth(context) * 1,
                    height: 100.h,
                    // width: 100.w, // specify the desired height
                    child: Image.asset(
                      'assets/images/s.png',
                    ),
                    // Adjust the fit as needed
                  ),
                ),
                Positioned(
                  bottom: 0.h,
                  left: -5,
                  child: SizedBox(
                    // width: Screen.screenWidth(context) * 1,
                    height: 50.h,
                    // width: 100.w, // specify the desired height
                    child: Image.asset(
                      'assets/images/start4.png',
                    ),
                    // Adjust the fit as needed
                  ),
                ),

                // Container for the ingredients
                Container(
                  child: Center(
                    child: Container(
                      width: 0.75.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: FoodieColors.darkSecondary,
                          width: 3.w,
                        ),
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
                                entry.key != 'Ingredients'
                                    ? Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Container(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: (entry.value as List<dynamic>)
                                      .map((ingredient) {
                                    final isChecked =
                                        ingredientStates[ingredient] ?? false;
                                    return Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1.1,
                                          child: Checkbox(
                                            visualDensity: VisualDensity(
                                              horizontal: 0.w, // Adjust the horizontal density
                                              vertical:
                                                  -2, // Adjust the vertical density
                                            ),
                                            activeColor:
                                                FoodieColors.darkSecondary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            value: isChecked,
                                            onChanged: (newValue) {
                                              setState(() {
                                                ingredientStates[ingredient] =
                                                    newValue!;
                                              });
                                            },
                                          ),
                                        ),

                                        // Icon(Icons.circle_outlined),
                                        // Image.asset(
                                        //   'assets/images/dot.png',
                                        //   color: FoodieColors.darkSecondary,
                                        //   height: 15.h,
                                        //   width: 15.w,
                                        // ),
                                        SizedBox(
                                            width: 5.w), // Adjust the spacing between the image and the text
                                        Expanded(
                                          // Wrap the Text widget with Expanded
                                          child: Text(
                                            '$ingredient',
                                            style: TextStyle(
                                              color: isChecked
                                                  ? Colors.grey[600]
                                                  : null,
                                              decoration: isChecked
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              decorationColor: isChecked
                                                  ? Colors.grey[600]
                                                  : null,
                                            ),
                                            // Set maxLines to allow the text to wrap if it exceeds the available width
                                            maxLines: null,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
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
                ),

                // Positioned image
              ],
            ),
          )
        ],
      ),
    );
  }
}
