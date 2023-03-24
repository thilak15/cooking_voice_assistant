import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../providers/recipe_provider.dart';
import '../screens/recipe_screen.dart';
import '../services/text_to_speech_service.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();

  final TextToSpeechService _textToSpeechService = TextToSpeechService();

  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cooking Voice Assistant'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start by saying "Hey Assistant"',
              style: TextStyle(fontSize: 24.0),
            ),
            IconButton(
              icon: Icon(Icons.mic),
              iconSize: 50.0,
              onPressed: () => _listen(),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (val) => print('onError: $val'),
        onStatus: (val) => print('onStatus: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) async {
            if (val.recognizedWords.toLowerCase().contains("hey assistant")) {
              setState(() => _isListening = false);
              await _speech.stop();
              await _speech.cancel();
              await _askForDish();
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _askForDish() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("What do you want to cook today?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _listenForDishName();
            },
            child: Text("Start Listening"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _listenForDishName() async {
    bool available = await _speech.initialize(
      onError: (val) => print('onError: $val'),
      onStatus: (val) => print('onStatus: $val'),
    );
    if (available) {
      _speech.listen(
        onResult: (val) async {
          String dishName = val.recognizedWords.trim();
          if (dishName.isNotEmpty) {
            await _speech.stop();
            await _speech.cancel();
            final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
            try {
              await recipeProvider.fetchRecipe(dishName);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeScreen()),
              );
            } catch (error) {
              print("Error fetching recipe: $error");
              _showErrorDialog();
            }
          }
        },
      );
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("Failed to fetch recipe. Please try again."),
        actions: [
                    TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}


