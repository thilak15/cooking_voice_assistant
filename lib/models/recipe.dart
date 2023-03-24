class Recipe {
  final String name;
  final List<Ingredient> ingredients;
  final List<String> steps;

  Recipe({required this.name, required this.ingredients, required this.steps});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['title'],
      ingredients: (json['extendedIngredients'] as List)
          .map((ingredient) => Ingredient.fromJson(ingredient))
          .toList(),
      steps: _parseSteps(json['analyzedInstructions']),
    );
  }

  static List<String> _parseSteps(List<dynamic> instructions) {
    List<String> steps = [];
    if (instructions.isNotEmpty) {
      for (final step in instructions[0]['steps']) {
        steps.add(step['step']);
      }
    }
    return steps;
  }
}

class Ingredient {
  final String name;
  final String unit;
  final double amount;

  Ingredient({required this.name, required this.unit, required this.amount});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      unit: json['unit'],
      amount: json['amount'],
    );
  }
}
