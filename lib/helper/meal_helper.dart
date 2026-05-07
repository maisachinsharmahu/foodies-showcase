import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MealHelper {
  static const String _mealPlanKey = 'mealPlan';

  // Structure: { 'Monday': { 'Breakfast': recipeId, 'Lunch': recipeId, 'Dinner': recipeId }, ... }
  static Future<Map<String, dynamic>> getMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    String? planJson = prefs.getString(_mealPlanKey);
    if (planJson == null) {
      return {
        'Monday': {},
        'Tuesday': {},
        'Wednesday': {},
        'Thursday': {},
        'Friday': {},
        'Saturday': {},
        'Sunday': {},
      };
    }
    return json.decode(planJson);
  }

  static Future<void> saveMeal(String day, String mealType, String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> plan = await getMealPlan();
    if (!plan.containsKey(day)) plan[day] = {};
    plan[day][mealType] = recipeId;
    await prefs.setString(_mealPlanKey, json.encode(plan));
  }

  static Future<void> removeMeal(String day, String mealType) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> plan = await getMealPlan();
    if (plan.containsKey(day) && plan[day].containsKey(mealType)) {
      plan[day].remove(mealType);
      await prefs.setString(_mealPlanKey, json.encode(plan));
    }
  }

  static Future<void> clearPlan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mealPlanKey);
  }
}
