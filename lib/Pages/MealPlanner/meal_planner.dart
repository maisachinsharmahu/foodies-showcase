import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/helper/colors.dart';
import 'package:foodie/helper/meal_helper.dart';
import 'package:foodie/Source/helper.dart'; // For filterRecipesByMultipleIds etc.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:foodie/Pages/DetailsPage/details.dart';

class MealPlannerPage extends StatefulWidget {
  final List<dynamic> recipes;
  const MealPlannerPage({super.key, required this.recipes});

  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  String selectedDay = 'Monday';
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  Map<String, dynamic> mealPlan = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    setState(() => isLoading = true);
    mealPlan = await MealHelper.getMealPlan();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
          "Weekly Meal Planner",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.sp,
            fontFamily: 'metropolis',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined, color: Colors.red, size: 24.sp),
            onPressed: () async {
              await MealHelper.clearPlan();
              _loadPlan();
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          Expanded(
            child: isLoading 
              ? Center(child: CircularProgressIndicator(color: FoodieColors.darkSecondary))
              : _buildMealList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          bool isSelected = selectedDay == days[index];
          return GestureDetector(
            onTap: () => setState(() => selectedDay = days[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: isSelected ? FoodieColors.darkSecondary : Colors.grey[100],
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: FoodieColors.darkSecondary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              alignment: Alignment.center,
              child: Text(
                days[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontSize: 15.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'metropolis',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealList() {
    Map<String, dynamic> dayMeals = mealPlan[selectedDay] ?? {};
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildMealCard('Breakfast', dayMeals['Breakfast']),
        SizedBox(height: 16.h),
        _buildMealCard('Lunch', dayMeals['Lunch']),
        SizedBox(height: 16.h),
        _buildMealCard('Dinner', dayMeals['Dinner']),
      ],
    );
  }

  Widget _buildMealCard(String type, String? recipeId) {
    dynamic recipe;
    if (recipeId != null) {
      recipe = widget.recipes.firstWhere((r) => r['id'].toString() == recipeId, orElse: () => null);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'metropolis',
                    color: FoodieColors.darkSecondary,
                  ),
                ),
                if (recipeId == null)
                  TextButton.icon(
                    onPressed: () => _showRecipeSelector(type),
                    icon: Icon(Icons.add_circle_outline, size: 20.sp, color: FoodieColors.darkSecondary),
                    label: Text("Plan Meal", style: TextStyle(color: FoodieColors.darkSecondary)),
                  )
                else
                  IconButton(
                    icon: Icon(Icons.close, size: 20.sp, color: Colors.red),
                    onPressed: () async {
                      await MealHelper.removeMeal(selectedDay, type);
                      _loadPlan();
                    },
                  ),
              ],
            ),
          ),
          if (recipe != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: RecipeDetails(recipe: recipe, userData: const {}),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: recipe['Image'],
                        height: 70.h,
                        width: 70.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['Name'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'metropolis',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${recipe['Total Time']} • ${recipe['Cuisine']}",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey[300]),
                  ],
                ),
              ),
            ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  void _showRecipeSelector(String mealType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RecipeSelector(
        recipes: widget.recipes,
        onSelected: (recipe) async {
          await MealHelper.saveMeal(selectedDay, mealType, recipe['id'].toString());
          Navigator.pop(context);
          _loadPlan();
        },
      ),
    );
  }
}

class _RecipeSelector extends StatefulWidget {
  final List<dynamic> recipes;
  final Function(dynamic) onSelected;

  const _RecipeSelector({required this.recipes, required this.onSelected});

  @override
  State<_RecipeSelector> createState() => _RecipeSelectorState();
}

class _RecipeSelectorState extends State<_RecipeSelector> {
  String search = '';
  late List<dynamic> filteredRecipes;

  @override
  void initState() {
    super.initState();
    filteredRecipes = widget.recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          Container(
            height: 5.h,
            width: 40.w,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  search = val;
                  filteredRecipes = widget.recipes
                      .where((r) => r['Name'].toString().toLowerCase().contains(val.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                hintText: "Search recipes...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              padding: EdgeInsets.all(16.w),
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedNetworkImage(
                      imageUrl: recipe['Image'],
                      height: 50.h,
                      width: 50.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    recipe['Name'],
                    style: TextStyle(
                      fontFamily: 'metropolis',
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  subtitle: Text("${recipe['Cuisine']} • ${recipe['Total Time']}"),
                  onTap: () => widget.onSelected(recipe),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
