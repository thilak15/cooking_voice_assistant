import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _configureTts();
  }
Future<void> _configureTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setVoice({"name": "en-us-x-sfg#female_2-local", "locale": "en-US"});

    _flutterTts.setCompletionHandler(() {
      print("TTS: Completed");
    });

    _flutterTts.setErrorHandler((msg) {
      print("TTS: Error: $msg");
    });

    _flutterTts.setProgressHandler((String text, int start, int end, String word) {
      print("TTS: $text - $start / $end - $word");
    });

    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.4);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }



  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<RecipeProvider>(context).currentRecipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe?.name ?? 'Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingredients:',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              ...recipe?.ingredients.map((ingredient) => Text('${ingredient.amount} ${ingredient.unit} ${ingredient.name}')) ?? [],
              SizedBox(height: 24.0),
              Text(
                'Steps:',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              ...recipe?.steps.asMap().entries.map((entry) {
                int index = entry.key;
                String step = entry.value;
                return Text('${index + 1}. $step');
              }) ?? [],
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () => _readRecipe(recipe!),
                  child: Text('Read Recipe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _readRecipe(Recipe recipe) async {
    String ingredients = recipe.ingredients.map((i) => '${i.amount} ${i.unit} ${i.name}').join(', ');
    String steps = recipe.steps.map((step) => step).join(', ');
    String textToRead = 'The recipe for ${recipe.name} is as follows. Ingredients: $ingredients. Steps: $steps.';

    await _flutterTts.stop();
    int result = await _flutterTts.speak(textToRead);
    if (result == 1) {
      print("TTS: Speaking");
    } else {
      print("TTS: Failed to speak");
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
