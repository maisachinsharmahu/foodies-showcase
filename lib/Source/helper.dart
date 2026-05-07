// // recipe_helper.dart

// List<dynamic> filterRecipesByName(List<dynamic> recipes, String type) {
//   return recipes.where((recipe) => recipe['Name'].contains(type)).toList();
// }

// List<dynamic> filterRecipesByType(List<dynamic> recipes, String type) {
//   return recipes.where((recipe) => recipe['type'].contains(type)).toList();
// }

// List<dynamic> filterRecipesByIngredients(
//     List<dynamic> recipes, String ingredient) {
//   return recipes.where((recipe) {
//     if (recipe['Ingredients'] is Map<String, dynamic>) {
//       final ingredients = recipe['Ingredients'] as Map<String, dynamic>;
//       if (ingredients['Ingredients'] is List<dynamic>) {
//         final ingredientList = ingredients['Ingredients'] as List<dynamic>;
//         if (ingredientList.every((item) => item is String)) {
//           return ingredientList.any((item) => item.contains(ingredient));
//         }
//       }
//     }
//     return false;
//   }).toList();
// }

// Helper function to filter recipes by name
List<dynamic> filterRecipesByName(List<dynamic> recipes, String name) {
  return recipes.where((recipe) {
    if (recipe['Name'] is String) {
      return recipe['Name'].toLowerCase().contains(name.toLowerCase());
    }
    return false;
  }).toList();
}

List<dynamic> filterRecipesBymanyTypes2(
  List<dynamic> recipes,
  List<String> types,
) {
  return recipes.where((recipe) {
    if (recipe['type'] is List<dynamic>) {
      final recipeTypes = recipe['type'] as List<dynamic>;

      // Check for exact matches (case-insensitive)
      final exactMatches = recipeTypes.any(
          (recipeType) => types.contains(recipeType.toString().toLowerCase()));

      // If no exact matches, check for partial matches (case-insensitive)
      final partialMatches = (exactMatches == false)
          ? recipeTypes.any((recipeType) => types.any((type) =>
              recipeType.toString().toLowerCase().contains(type.toLowerCase())))
          : false;

      return exactMatches || partialMatches;
    }
    return false;
  }).toList();
}

List<dynamic> veagon(
  List<dynamic> recipes,
  List<String> types,
) {
  bool hasVegetarian = types.contains('Vegetarian');
  bool hasNonVegetarian = types.contains('Non-Vegetarian');

  // If only contains Vegetarian
  if (hasVegetarian && !hasNonVegetarian) {
    return recipes.where((recipe) {
      List<dynamic> recipeTypes = recipe['type'.toLowerCase()];
      if (recipeTypes.toList().contains('egg') ||
          recipeTypes.contains('chicken') ||
          recipeTypes.contains('meat') ||
          recipeTypes.contains('sea')) {
        return false;
      } else {
        return true;
      }
    }).toList();
  }

  // For other cases, don't filter
  return recipes;
}

List<dynamic> unwantedNames(List<dynamic> recipes) {
  List<String> unwantedNames = [
    'egg',
    'chicken',
    'meat',
    'sea',
    'prawns',
    'prawn',
    'mutton'
  ];
  return recipes.where((recipe) {
    if (recipe['Name'] is String) {
      String recipeName = recipe['Name'].toLowerCase();
      return !unwantedNames
          .any((unwantedName) => recipeName.contains(unwantedName));
    }
    return true; // Keep non-string entries
  }).toList();
}

// Helper function to filter recipes by types
List<dynamic> filterRecipesBymanyTypes(
    List<dynamic> recipes, List<String> types) {
  print(types);
  return recipes.where((recipe) {
    if (recipe['type'] is List<dynamic>) {
      final recipeTypes = recipe['type'] as List<dynamic>;

      return recipeTypes.any(
        (recipeType) => types.contains(
          recipeType.toLowerCase(),
        ),
      );
    }
    return false;
  }).toList();
}

// Helper function to filter recipes by types
List<dynamic> filterRecipesBymanyTypes3(
    List<dynamic> recipes, List<String> types) {
  return recipes.where((recipe) {
    if (recipe['type'] is List<dynamic>) {
      final recipeTypes = recipe['type'] as List<dynamic>;

      return recipeTypes.any(
        (recipeType) => types.any(
          (type) => recipeType.toLowerCase().contains(type.toLowerCase()),
        ),
      );
    }
    return false;
  }).toList();
}

// Helper function to filter recipes by type
List<dynamic> filterRecipesByType(List<dynamic> recipes, String type) {
  return recipes.where((recipe) {
    if (recipe['type'] is List<dynamic>) {
      final types = recipe['type'] as List<dynamic>;
      return types.any((t) => t.toLowerCase() == type.toLowerCase());
    }
    return false;
  }).toList();
}

List<dynamic> filterRecipesByType2(List<dynamic> recipes, String type) {
  return recipes.where((recipe) {
    if (recipe['type'] is List<dynamic>) {
      final types = recipe['type'] as List<dynamic>;
      return types
          .any((t) => t.toString().toLowerCase().contains(type.toLowerCase()));
    } else if (recipe['type'] is String) {
      final recipeType = recipe['type'] as String;
      return recipeType.toLowerCase().contains(type.toLowerCase());
    }
    return false;
  }).toList();
}

List<dynamic> shuffleRecipesforrecommend(List<dynamic> recipes) {
  final tempRecipes = List.from(recipes);
  tempRecipes.shuffle();
  return tempRecipes.take(5).toList();
}

List<dynamic> shuffleRecipes(List<dynamic> recipes) {
  List<dynamic> shuffledRecipes =
      List.from(recipes); // Create a copy of the original list
  shuffledRecipes.shuffle();
  return shuffledRecipes;
}

// Helper function to filter recipes by difficulty
List<dynamic> filterRecipesByDifficulty(
    List<dynamic> recipes, String difficulty) {
  return recipes.where((recipe) {
    if (recipe['Difficulty'] is String) {
      return recipe['Difficulty'].toLowerCase() == difficulty.toLowerCase();
    }
    return false;
  }).toList();
}

// Helper function to filter recipes by steps
List<dynamic> filterRecipesBySteps(List<dynamic> recipes, String step) {
  return recipes.where((recipe) {
    if (recipe['Steps'] is List<dynamic>) {
      final steps = recipe['Steps'] as List<dynamic>;
      return steps
          .any((item) => item.toLowerCase().contains(step.toLowerCase()));
    }
    return false;
  }).toList();
}

// Helper function to filter recipes by id
List<dynamic> filterRecipesById(List<dynamic> recipes, int id) {
  return recipes.where((recipe) {
    if (recipe['id'] is int) {
      return recipe['id'] == id;
    }
    return false;
  }).toList();
}

// Helper function to filter recipes by multiple ids
List<dynamic> filterRecipesByMultipleIds(List<dynamic> recipes, List ids) {
  return recipes.where((recipe) {
    if (recipe['id'] is int) {
      return ids.contains(recipe['id']);
    }
    return false;
  }).toList();
}

Future<String> detectLanguage(String text) async {
  // Check if the text contains characters from the Hindi script
  if (RegExp(r'[अ-ह]+').hasMatch(text)) {
    return 'hi'; // Hindi
  } else {
    return ''; // Unknown language
  }
}

List<dynamic> filterRecipesByHindi(List<dynamic> recipes) {
  List<dynamic> filteredRecipes = [];
  for (var recipe in recipes) {
    if (recipe['Steps'] is List<dynamic>) {
      final types = recipe['Steps'] as List<dynamic>;
      for (var type in types) {
        if (detectLanguageSync(type) == 'hi') {
          filteredRecipes.add(recipe);
          break; // No need to continue checking other types of the same recipe
        }
      }
    }
  }
  return filteredRecipes;
}

String detectLanguageSync(String text) {
  if (RegExp(r'[अ-ह]+').hasMatch(text)) {
    return 'hi'; // Hindi
  } else if (RegExp(r'[a-zA-Z]+').hasMatch(text)) {
    return 'en'; // English
  } else {
    return ''; // Unknown language
  }
}

// // Helper function to filter recipes by types
// List<dynamic> filterRecipesBymanyTypes(List<dynamic> recipes, List<String> types) {
//   return recipes.where((recipe) {
//     if (recipe['type'] is List<dynamic>) {
//       final recipeTypes = recipe['type'] as List<dynamic>;
//       return recipeTypes.any((recipeType) => types.contains(recipeType));
//     }
//     return false;
//   }).toList();
// }

// // Helper function to filter recipes by type
// List<dynamic> filterRecipesByType(List<dynamic> recipes, String type) {
//   return recipes.where((recipe) {
//     if (recipe['type'] is List<dynamic>) {
//       final types = recipe['type'] as List<dynamic>;
//       return types.contains(type);
//     }
//     return false;
//   }).toList();
// }

// // Helper function to filter recipes by difficulty
// List<dynamic> filterRecipesByDifficulty(
//     List<dynamic> recipes, String difficulty) {
//   return recipes.where((recipe) {
//     if (recipe['Difficulty'] is String) {
//       return recipe['Difficulty'] == difficulty;
//     }
//     return false;
//   }).toList();
// }

// // Helper function to filter recipes by steps
// List<dynamic> filterRecipesBySteps(List<dynamic> recipes, String step) {
//   return recipes.where((recipe) {
//     if (recipe['Steps'] is List<dynamic>) {
//       final steps = recipe['Steps'] as List<dynamic>;
//       return steps.any((item) => item.contains(step));
//     }
//     return false;
//   }).toList();
// }

// // Helper function to filter recipes by id
// List<dynamic> filterRecipesById(List<dynamic> recipes, int id) {
//   return recipes.where((recipe) {
//     if (recipe['id'] is int) {
//       return recipe['id'] == id;
//     }
//     return false;
//   }).toList();
// }
