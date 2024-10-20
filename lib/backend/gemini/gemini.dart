import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_util.dart';

// API key for Gemini. Replace this with your actual API key.
const _kGeminiApiKey = '';

/// Generates text using the Gemini 1.5 Pro model.
///
/// This function takes a [prompt] as input and returns a [Future<String?>]
/// containing the generated text.
///
/// Parameters:
///   - context: The BuildContext for showing error messages.
///   - prompt: A string containing the input prompt for text generation.
///
/// Returns:
///   A Future that resolves to the generated text, or null if an error occurs.
Future<String?> geminiGenerateText(
  BuildContext context,
  String prompt,
) async {
  final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: _kGeminiApiKey);
  final content = [Content.text(prompt)];

  try {
    final response = await model.generateContent(content);
    return response.text;
  } catch (e) {
    showSnackbar(context, e.toString());
    return null;
  }
}

/// Counts the number of tokens in the given prompt using the Gemini 1.5 Pro model.
///
/// Parameters:
///   - context: The BuildContext for showing error messages.
///   - prompt: A string containing the input prompt for token counting.
///
/// Returns:
///   A Future that resolves to the token count as a string, or null if an error occurs.
Future<String?> geminiCountTokens(
  BuildContext context,
  String prompt,
) async {
  final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: _kGeminiApiKey);
  final content = [Content.text(prompt)];

  try {
    final response = await model.countTokens(content);
    return response.totalTokens.toString();
  } catch (e) {
    showSnackbar(context, e.toString());
    return null;
  }
}

/// Loads image bytes from a given URL.
///
/// Parameters:
///   - imageUrl: The URL of the image to load.
///
/// Returns:
///   A Future that resolves to the image bytes as Uint8List.
///
/// Throws:
///   An exception if the image fails to load.
Future<Uint8List> loadImageBytesFromUrl(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

/// Generates text based on an image and a prompt using the Gemini 1.5 Flash model.
///
/// This function takes either an image URL or uploaded image bytes along with a prompt,
/// and returns a [Future<String?>] containing the generated text description.
///
/// Parameters:
///   - context: The BuildContext for showing error messages.
///   - prompt: A string containing the input prompt for image-based text generation.
///   - imageNetworkUrl: Optional. The URL of the image to analyze.
///   - uploadImageBytes: Optional. The uploaded image bytes to analyze.
///
/// Returns:
///   A Future that resolves to the generated text description, or null if an error occurs.
///
/// Note: Either imageNetworkUrl or uploadImageBytes must be provided.
Future<String?> geminiTextFromImage(
  BuildContext context,
  String prompt, {
  String? imageNetworkUrl = '',
  FFUploadedFile? uploadImageBytes,
}) async {
  assert(
    imageNetworkUrl != null || uploadImageBytes != null,
    'Either imageNetworkUrl or uploadImageBytes must be provided.',
  );

  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _kGeminiApiKey);
  final imageBytes = uploadImageBytes != null
      ? uploadImageBytes.bytes
      : await loadImageBytesFromUrl(imageNetworkUrl!);
  final content = [
    Content.multi([
      TextPart(prompt),
      DataPart('image/jpeg', imageBytes!),
    ])
  ];

  try {
    final response = await model.generateContent(content);
    return response.text;
  } catch (e) {
    showSnackbar(context, e.toString());
    return null;
  }
}
