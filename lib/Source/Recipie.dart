import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Recipe {
  final int id;
  final String name;
  final String image;
  final List<String> type;
  final List<String> dishOverview;
  final String totalTime;
  final String prepTime;
  final String cookTime;
  final String recipeServings;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.dishOverview,
    required this.totalTime,
    required this.prepTime,
    required this.cookTime,
    required this.recipeServings,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['Name'],
      image: json['Image'],
      type: List<String>.from(json['type']),
      dishOverview: List<String>.from(json['Dish Overview']),
      totalTime: json['Total Time'],
      prepTime: json['Prep Time'],
      cookTime: json['Cook Time'],
      recipeServings: json['Recipe Servings'],
      difficulty: json['Difficulty'],
      ingredients: List<String>.from(json['Ingredients']['Ingredients']),
      steps: List<String>.from(json['Steps']),
    );
  }
}

class RecipeModel {
  List<Recipe> recipes = [];

  Future<void> loadRecipes() async {
    String jsonString = await rootBundle.loadString('assets/finally.json');
    List<dynamic> jsonList = json.decode(jsonString);
    recipes = jsonList.map((json) => Recipe.fromJson(json)).toList();
  }

  List<Recipe> getRecipesByName(String name) {
    return recipes
        .where(
            (recipe) => recipe.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  List<Recipe> getRecipesByType(String type) {
    return recipes
        .where((recipe) => recipe.type.contains(type.toLowerCase()))
        .toList();
  }

  Recipe getRecipeById(int id) {
    return recipes.firstWhere((recipe) => recipe.id == id);
  }
}

// Usage
void main() async {
  RecipeModel model = RecipeModel();
  await model.loadRecipes();
  Recipe recipe = model.getRecipeById(1);
  print(recipe.name);
}
