// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

// API key for OpenAI. Replace this with your actual API key.
final String _apiKey = '';

/// Generates an image using OpenAI's DALL-E 3 model.
///
/// This function takes a [prompt] as input and returns a [Future<String>]
/// containing the URL of the generated image.
///
/// Parameters:
///   - prompt: A string describing the image to be generated.
///
/// Returns:
///   A Future that resolves to the URL of the generated image.
///
/// Throws:
///   An exception if the API request fails.
Future<String> generateImage(String prompt) async {
  // API endpoint for OpenAI's image generation
  final url = 'https://api.openai.com/v1/images/generations';

  try {
    // Send POST request to OpenAI API
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'dall-e-3',
        'prompt': prompt,
        'size': '1024x1024', // Specifies the size of the generated image
      }),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Extract and return the URL of the generated image
      return data['data'][0]['url'];
    } else {
      // Throw an exception if the request failed
      throw Exception('Failed to generate image: ${response.body}');
    }
  } catch (e) {
    // Handle any errors that occur during the API request
    throw Exception('Error generating image: $e');
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
