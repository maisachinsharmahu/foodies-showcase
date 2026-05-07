
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:foodie/Pages/DetailsPage/sections/MainDetails.dart';
import 'package:foodie/helper/addtofav.dart';

class RecipeDetails extends StatefulWidget {
  final dynamic recipe;
  final Map<String, dynamic> userData;
  const RecipeDetails({super.key, required this.recipe, required this.userData});

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  FlutterTts flutterTts = FlutterTts(); // Initialize FlutterTts instance

  Future<void> speakRecipeSteps() async {
    // Sample step text to detect language, you can replace it with the actual recipe step
    String sampleStep = widget.recipe['Steps'][2];

    // Detect language of the sample step text
    String detectedLanguage = await detectLanguage(sampleStep);

    // Set language based on detected language
    if (detectedLanguage == 'en') {
      await flutterTts.setLanguage("en-US"); // Set language to English
    } else if (detectedLanguage == 'hi') {
      await flutterTts.setLanguage("hi-IN");
      // await flutterTts
      //     .setVoice({"name": "hi-in-x-hic-local"}); // Set language to Hindi
    } else {
      // Default to English if language detection fails or if it's not English or Hindi
      await flutterTts.setLanguage("en-US");
    }
// AIzaSyAGO3DNN2tJMsZ6tLto1dQkouNVHaSSF_U
    await flutterTts.setPitch(1.0);
    // Iterate through recipe steps and speak each step
    for (final step in widget.recipe['Steps'] as List<dynamic>) {
      await flutterTts.speak(step);
    }
  }

  Future<String> detectLanguage(String text) async {
    // Check if the text contains characters from the Hindi script
    if (RegExp(r'[अ-ह]+').hasMatch(text)) {
      return 'hi'; // Hindi
    }
    // Check if the text contains characters from the English alphabet
    else if (RegExp(r'[a-zA-Z]+').hasMatch(text)) {
      return 'en'; // English
    } else {
      return ''; // Unknown language
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FavoriteFunctions.fetchFavoriteRecipes();

    // printAvailableVoices();
  }
// Call this function to print available voices

  @override
  Widget build(BuildContext context) {
    return mainDetails(
      userData: widget.userData,
      recipe: widget.recipe,
    );
  }
}


            // IconButton(
            //     onPressed: () {
            //       print(userData);
            //     },
            //     icon: Icon(Icons.abc_outlined))