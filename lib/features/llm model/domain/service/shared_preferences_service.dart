import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefFineTuningService {
  static final Future<SharedPreferences> _prefs = SharedPreferences
      .getInstance();

  static Future<void> saveRelationshipWithLLM(String value) async {
    (await _prefs).setString('relationship_with_llm', value);
  }
  static Future<String> getRelationshipWithLLM() async {
    return (await _prefs).getString('relationship_with_llm') ?? '';
  }

  static Future<void> saveBehaviorLLM(List<String> value) async {
    (await _prefs).setStringList('behavior_llm', value);
  }
  static Future<List<String>> getBehaviorLLM() async {
    return (await _prefs).getStringList('behavior_llm') ?? [];
  }

  static Future<void> saveLLMModel(String value) async {
    (await _prefs).setString('llm_model', value);
  }
  static Future<String> getLLMModel() async {
    return (await _prefs).getString('llm_model') ?? 'Default';
  }
}