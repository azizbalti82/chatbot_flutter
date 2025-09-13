import 'dart:math';

Future<String> simulateLLMResponse(String prompt) async {
  // Simulated delay to mimic network + llm model processing time
  await Future.delayed(Duration(seconds: 3));

  // Some fake random responses
  final responses = [
    "That's an interesting question!",
    "Let me think about it...",
    "I believe the answer might surprise you.",
    "Can you clarify a bit more?",
    "Here's what I came up with just now...",
    "Absolutely, let’s dive into it.",
  ];

  final random = Random();
  return responses[random.nextInt(responses.length)];
}