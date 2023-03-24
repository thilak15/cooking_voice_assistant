import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../utils/constants.dart';
class RecipeApi {
  Future<Recipe> fetchRecipe(String dishName) async {
    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?query=$dishName&apiKey=$spoonacularApiKey'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Assuming the API returns a list of recipes and you want to get the first one.
      int recipeId = jsonData['results'][0]['id'];
      return await fetchRecipeDetails(recipeId);
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  Future<Recipe> fetchRecipeDetails(int recipeId) async {
    final response = await http
        .get(Uri.parse('https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$spoonacularApiKey'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Recipe.fromJson(jsonData);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}