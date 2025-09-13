abstract class LlmService {
  /// Sends a prompt to the LLM and returns the response.
  Future<String?> generateResponse({
    required String prompt,
    Map<String, dynamic>? options, // optional extra params like temperature, max tokens
  });
}
