import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../api/recipe_api.dart';

class RecipeProvider with ChangeNotifier {
  Recipe? _currentRecipe;
  RecipeApi _recipeApi = RecipeApi();

  Recipe? get currentRecipe => _currentRecipe;

  Future<void> fetchRecipe(String dishName) async {
    try {
      _currentRecipe = await _recipeApi.fetchRecipe(dishName);
      notifyListeners();
    } catch (error) {
      print("Failed to fetch recipe: $error");
      throw error;
    }
  }
}
