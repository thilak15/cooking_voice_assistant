import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cooking_voice_assistant/screens/home_screen.dart';
import 'package:cooking_voice_assistant/providers/recipe_provider.dart';

void main() {
  testWidgets('HomeScreen displays the "Listen" button', (WidgetTester tester) async {
    // Build the HomeScreen widget wrapped with a ChangeNotifierProvider for RecipeProvider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => RecipeProvider(),
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Find the "Listen" button
    final listenButtonFinder = find.text('Listen');

    // Check if the "Listen" button is in the widget tree
    expect(listenButtonFinder, findsOneWidget);
  });
}
