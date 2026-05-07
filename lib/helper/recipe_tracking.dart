import 'package:shared_preferences/shared_preferences.dart';

class RecipeTracking {
  static const String _recipeVisitKey = 'recipeVisit';
  static const String _startedCookingKey = 'startedCooking';
  static const String _cookedKey = 'cooked';

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<Set<String>> get recipeVisit async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(_recipeVisitKey)?.toSet() ?? {};
  }

  static Future<void> addToRecipeVisit(String recipeId) async {
    final SharedPreferences prefs = await _prefs;
    Set<String> currentVisits = await recipeVisit;
    currentVisits.add(recipeId);
    await prefs.setStringList(_recipeVisitKey, currentVisits.toList());
  }

  static Future<Set<String>> get startedCooking async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(_startedCookingKey)?.toSet() ?? {};
  }

  static Future<void> addToStartedCooking(String recipeId) async {
    final SharedPreferences prefs = await _prefs;
    Set<String> currentCooking = await startedCooking;
    currentCooking.add(recipeId);
    await prefs.setStringList(_startedCookingKey, currentCooking.toList());
  }

  static Future<Set<String>> get cooked async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(_cookedKey)?.toSet() ?? {};
  }

  static Future<void> addToCooked(String recipeId) async {
    final SharedPreferences prefs = await _prefs;
    Set<String> currentCooked = await cooked;
    currentCooked.add(recipeId);
    await prefs.setStringList(_cookedKey, currentCooked.toList());
  }

  static Future<void> clearAll() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(_recipeVisitKey);
    await prefs.remove(_startedCookingKey);
    await prefs.remove(_cookedKey);
  }
}
