import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final String nigga_k = "nigga_k_"; // api key

  Future<void> saveApiKey(String apiKey) async {
    await storage.write(key: nigga_k, value: apiKey);
  }

  Future<String?> getApiKey() async {
    return await storage.read(key: nigga_k);
  }
}
