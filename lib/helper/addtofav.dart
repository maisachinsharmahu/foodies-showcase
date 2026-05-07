import 'package:shared_preferences/shared_preferences.dart';

class FavoriteFunctions {
  static const String _favoritesKey = "favorite_recipes";
  static List<int> _favoriteRecipes = [];

  static List<int> get favoriteRecipes => _favoriteRecipes;

  static Future<void> fetchFavoriteRecipes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
      _favoriteRecipes = favorites.map((e) => int.parse(e)).toList();
    } catch (error) {
      print(error);
    }
  }

  static Future<void> addFavoriteRecipe(int recipeId) async {
    try {
      if (!_favoriteRecipes.contains(recipeId)) {
        _favoriteRecipes.add(recipeId);
        final prefs = await SharedPreferences.getInstance();
        List<String> strFavorites = _favoriteRecipes.map((e) => e.toString()).toList();
        await prefs.setStringList(_favoritesKey, strFavorites);
      }
    } catch (error) {
      print(error);
    }
  }

  static Future<void> removeFavoriteRecipe(int recipeId) async {
    try {
      if (_favoriteRecipes.contains(recipeId)) {
        _favoriteRecipes.remove(recipeId);
        final prefs = await SharedPreferences.getInstance();
        List<String> strFavorites = _favoriteRecipes.map((e) => e.toString()).toList();
        await prefs.setStringList(_favoritesKey, strFavorites);
      }
    } catch (error) {
      print(error);
    }
  }

  static Future<bool> isRecipeFavorite(int recipeId) async {
    try {
      await fetchFavoriteRecipes(); 
      return _favoriteRecipes.contains(recipeId);
    } catch (error) {
      print('Error checking favorite recipe: $error');
      return false;
    }
  }

  static Future<void> toggleFavorite(int? recipeId) async {
    if (recipeId == null) {
      return;
    }
    await fetchFavoriteRecipes();
    bool isFavorite = _favoriteRecipes.contains(recipeId);

    if (isFavorite) {
      await removeFavoriteRecipe(recipeId);
    } else {
      await addFavoriteRecipe(recipeId);
    }
  }
}
