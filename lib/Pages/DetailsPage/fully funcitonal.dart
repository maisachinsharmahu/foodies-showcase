import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class RecipeDetailsfalse extends StatefulWidget {
  final dynamic recipe;

  const RecipeDetailsfalse({super.key, required this.recipe});

  @override
  _RecipeDetailsfalseState createState() => _RecipeDetailsfalseState();
}

class _RecipeDetailsfalseState extends State<RecipeDetailsfalse> {
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
    // printAvailableVoices();
  }
// Call this function to print available voices

  @override
  Widget build(BuildContext context) {
    Future<String?> downloadImage(String imageUrl) async {
      try {
        // Create a temporary directory
        Directory tempDir = await Directory.systemTemp.createTemp();
        String imagePath = "${tempDir.path}/recipe_image.jpg";

        // Download the image file
        await Dio().download(imageUrl, imagePath);

        // Return the local path of the downloaded image file
        return imagePath;
      } catch (e) {
        print("Error downloading image: $e");
        return null;
      }
    }

    String formatIngredients(Map<String, dynamic> ingredients) {
      return ingredients.entries.map((entry) {
        return "${entry.key}:\n${entry.value.map((ingredient) => "- $ingredient").join('\n')}";
      }).join('\n');
    }

    String formatInstructions(List<dynamic> steps) {
      return steps.map((step) => "- $step").join('\n');
    }

    List<String> splitTextContent(Map<String, dynamic> recipe) {
      // Create a list to store text chunks
      List<String> chunks = [];

      // Add recipe details to text chunks
      String text = '${recipe['Name']}\n\n'
          'Prep Time: ${recipe['Prep Time']}\n'
          'Cook Time: ${recipe['Cook Time']}\n'
          'Servings: ${recipe['Recipe Servings']}\n\n'
          'Ingredients:\n${formatIngredients(recipe['Ingredients'])}\n\n'
          'Ingredients:\n${formatIngredients(recipe['Ingredients'])}\n\n'
          'Ingredients:\n${formatIngredients(recipe['Ingredients'])}\n\n'
          'Ingredients:\n${formatIngredients(recipe['Ingredients'])}\n\n'
          'Ingredients:\n${formatIngredients(recipe['Ingredients'])}\n\n'
          'Ingredients:\n${formatIngredients(recipe['Ingredients'])}\n\n'
          'Ingredients:\n${formatIngredients(recipe['Ingredients'])}\n\n'
          'Ingredients:\n${formatIngredients(recipe['Ingredients'])}\n\n'
          'Instructions:\n${formatInstructions(recipe['Steps'])}';

      // Split text into chunks based on available space on a page
      final int maxLinesPerPage = 40; // Maximum lines per page
      final int maxLinesPerFirstPage = 20; // Adjusted for image
      List<String> lines = text.split('\n');
      String currentChunk = lines[0];

      // Use different maximum lines per page for the first page
      int linesPerPage = maxLinesPerFirstPage;

      for (int i = 1; i < lines.length; i++) {
        if (currentChunk.split('\n').length >= linesPerPage) {
          chunks.add(currentChunk);
          currentChunk = '';
          // Use the standard maximum lines per page for subsequent pages
          linesPerPage = maxLinesPerPage;
        }
        currentChunk += '\n${lines[i]}';
      }

      if (currentChunk.isNotEmpty) {
        chunks.add(currentChunk);
      }

      return chunks;
    }

    Future<Uint8List> loadImageFromAssets(String assetName) async {
      final ByteData data = await rootBundle.load(assetName);
      return data.buffer.asUint8List();
    }

    void sharePage() async {
      // Download the image file
      String? imagePath = await downloadImage("${widget.recipe['Image']}");

      if (imagePath != null) {
        // Create PDF document
        final pdf = pw.Document();

        // Split text content into chunks to fit on pages
        List<String> textChunks = splitTextContent(widget.recipe);
        Uint8List imageBytes =
            await loadImageFromAssets('assets/images/logo2.png');

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pw.MemoryImage(imageBytes)),
              );
            },
          ),
        );

        // Add the image to the first page
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Image(
                    pw.MemoryImage(File(imagePath).readAsBytesSync()),
                  ),
                  pw.SizedBox(
                      height: 20.h), // Add some space between image and text
                  pw.Text(textChunks.isNotEmpty
                      ? textChunks[0]
                      : 'No text available'), // Add the first text chunk or display a message if empty
                ],
              );
            },
          ),
        );

        // Add the remaining text chunks to subsequent pages
        for (int i = 1; i < textChunks.length; i++) {
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(textChunks[i]), // Add the text chunk
                  ],
                );
              },
            ),
          );
        }

        // Save the PDF to a temporary file
        final pdfFile =
            File("${Directory.systemTemp.path}/${widget.recipe['Name']}.pdf");
        await pdfFile.writeAsBytes(await pdf.save());

        // Share the PDF file
        try {
          await Share.shareXFiles([XFile(pdfFile.path)],
              text: 'Check out this recipe!');
        } catch (e) {
          print("Error sharing: $e");
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['Name']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.recipe['Image']),
            SizedBox(height: 16.0.h),
            Text('Total Time: ${widget.recipe['Total Time']}'),
            Text('Prep Time: ${widget.recipe['Prep Time']}'),
            Text('Cook Time: ${widget.recipe['Cook Time']}'),
            Text('Recipe Servings: ${widget.recipe['Recipe Servings']}'),
            Text('Difficulty: ${widget.recipe['Difficulty']}'),
            SizedBox(height: 16.0.h),
            Text('Ingredients:',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (widget.recipe['Ingredients'] as Map<String, dynamic>)
                  .entries
                  .map((entry) {
                // For each entry (section) in the Ingredients map
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle for the section
                    Text(entry.key,
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    // List of ingredients for the section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          (entry.value as List<dynamic>).map((ingredient) {
                        return Text('- $ingredient');
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 16.0.h),
            Text('Steps:',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (widget.recipe['Steps'] as List<dynamic>).map((step) {
                return Text('- $step');
              }).toList(),
            ),
            SizedBox(height: 16.0.h),
            ElevatedButton(
              onPressed: () {
                sharePage();
              },
              child: Text('share'),
            ),
            ElevatedButton(
              onPressed: speakRecipeSteps,
              child: Text('Read Recipe Steps'),
            ),
          ],
        ),
      ),
    );
  }
}


            // IconButton(
            //     onPressed: () {
            //       print(userData);
            //     },
            //     icon: Icon(Icons.abc_outlined))