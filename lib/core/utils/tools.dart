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

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 10) {
    return "Now";
  } else if (difference.inSeconds < 60) {
    return "${difference.inSeconds} seconds ago";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else if (difference.inDays < 30) {
    return "${(difference.inDays / 7).floor()} weeks ago";
  } else if (difference.inDays < 365) {
    return "${(difference.inDays / 30).floor()} months ago";
  } else {
    return "${(difference.inDays / 365).floor()} years ago";
  }
}
