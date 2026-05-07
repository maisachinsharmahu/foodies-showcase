import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/meal_helper.dart';
import 'package:elegant_notification/elegant_notification.dart';

class belowDisc extends StatefulWidget {
  final dynamic recipe;
  const belowDisc({super.key, this.recipe});

  @override
  State<belowDisc> createState() => _belowDiscState();
}

class _belowDiscState extends State<belowDisc> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipe Details',
            style: TextStyle(
                fontFamily: 'metropolis',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8.h,
          ),
          ExpandableText(
            text: '${widget.recipe['Dish Overview'][0]},',
          ),
          SizedBox(height: 10.h),
          Divider(
            color: Colors.grey[200],
            thickness: 1.h,
          ),
          Column(
            children: [
              _buildMetricRow(
                'assets/images/pers.png',
                'Servings',
                widget.recipe['Recipe Servings']
                        .toLowerCase()
                        .contains('servings')
                    ? widget.recipe['Recipe Servings']
                    : '${widget.recipe['Recipe Servings']} Servings',
              ),
              _buildMetricRow(
                'assets/images/prep2.png',
                'Prep Time',
                '${widget.recipe['Prep Time']}',
              ),
              _buildMetricRow(
                'assets/images/Cooktime.png',
                'Cook Time',
                '${widget.recipe['Cook Time']}',
              ),
              _buildMetricRow(
                'assets/images/prep.png',
                'Total Time',
                '${widget.recipe['Total Time']}',
              ),
              SizedBox(
                height: 20.h,
              ),
              ElevatedButton.icon(
                onPressed: () => _showMealPlanSelector(context),
                icon: Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20.sp),
                label: Text("Add to Weekly Meal Plan", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FoodieColors.darkSecondary,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMealPlanSelector(BuildContext context) {
    String selectedDay = 'Monday';
    String selectedMeal = 'Breakfast';
    final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final List<String> meals = ['Breakfast', 'Lunch', 'Dinner'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Plan this Meal", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'metropolis')),
              SizedBox(height: 20.h),
              DropdownButtonFormField<String>(
                value: selectedDay,
                decoration: InputDecoration(labelText: "Select Day", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
                items: days.map((day) => DropdownMenuItem(value: day, child: Text(day))).toList(),
                onChanged: (val) => setModalState(() => selectedDay = val!),
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                value: selectedMeal,
                decoration: InputDecoration(labelText: "Select Meal", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
                items: meals.map((meal) => DropdownMenuItem(value: meal, child: Text(meal))).toList(),
                onChanged: (val) => setModalState(() => selectedMeal = val!),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () async {
                  await MealHelper.saveMeal(selectedDay, selectedMeal, widget.recipe['id'].toString());
                  Navigator.pop(context);
                  ElegantNotification.success(
                    title: Text("Meal Planned!"),
                    description: Text("${widget.recipe['Name']} added to $selectedDay's $selectedMeal."),
                  ).show(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FoodieColors.darkSecondary,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text("Confirm Plan", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String asset, String label, String value) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Image.asset(
                asset,
                height: 30.h,
                width: 30.w,
              ),
              SizedBox(
                width: 15.w,
              ),
              Text(
                label,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                    fontSize: 14.sp),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          thickness: 1.h,
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({
    super.key,
    required this.text,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = true; // Set to true by default to show full text

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'metropolis',
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
            maxLines: isExpanded ? null : 2,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                const Spacer(),
                Text(
                  isExpanded ? 'Show less' : 'Show more',
                  style: TextStyle(
                    color: FoodieColors.darkSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
