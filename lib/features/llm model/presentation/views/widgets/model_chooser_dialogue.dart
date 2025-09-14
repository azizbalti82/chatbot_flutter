import 'package:chatbot/core/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/getx_chat.dart';
import '../../../../../core/services/shared.dart';
import '../../../../../core/widgets/basics.dart';
import '../../../domain/api/llm_service.dart';
import '../../../domain/api/service_gemini.dart';
import '../../../domain/service/secret_service.dart';
import '../../../domain/service/shared_preferences_service.dart';

class LLMSettingsSheetView extends StatefulWidget {
  const LLMSettingsSheetView({super.key});

  @override
  State<LLMSettingsSheetView> createState() => _LLMSettingsSheetViewState();
}

class _LLMSettingsSheetViewState extends State<LLMSettingsSheetView> {
  final chatProvider = Get.find<ProviderChat>();
  final List<String> llmModels = [
    "Default",
    //"gpt-4.1",
    //"gpt-4o",
    //"gpt-4-mini",
    //"gpt-3.5-turbo",
    "gemini-2.5-pro",
    "gemini-2.5-flash",
    "gemini-2.5-flash-lite",
    "gemini-2.0-flash",
    "gemini-2.0-flash-lite",
    //"llama-3-70b",
    //"llama-3-8b",
  ];
  late RxString selectedModel;
  late TextEditingController apiKeyController;

  bool isVerifying = false;

  @override
  void initState() {
    super.initState();

    // load from shared (or fallback)
    selectedModel =
        (shared.llmModel.isNotEmpty ? shared.llmModel : llmModels.first).obs;
    apiKeyController = TextEditingController(text: shared.apiKey ?? "");
  }

  @override
  void dispose() {
    apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              simpleAppBar(context, text: ''), // your cancel/close app bar
              const SizedBox(height: 15),
              _buildModelSelector(context),
              const SizedBox(height: 20),
              if (selectedModel.value != "Default") _buildApiKeyInput(context),
              if (selectedModel.value != "Default") const SizedBox(height: 25),
              _buildSaveResetButtons(context),
              const SizedBox(height: 15),
            ],
          );
        }),
      ),
    );
  }


  Widget _buildModelSelector(BuildContext context) => _buildSection(
    context: context,
    title: "Select LLM Model",
    icon: Icons.memory_outlined,
    children: [
      Obx(
        () => DropdownButtonFormField<String>(
          value: selectedModel.value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: llmModels.map(
                (model) => DropdownMenuItem(value: model, child: Text(model)),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) selectedModel.value = val ;
          },
        ),
      ),
    ],
  );

  Widget _buildApiKeyInput(BuildContext context) => _buildSection(
    context: context,
    title: "API Key",
    icon: Icons.vpn_key_outlined,
    children: [
      TextField(
        controller: apiKeyController,
        decoration: InputDecoration(
          hintText: "Enter your API key",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
        obscureText: true, // hide API key by default
      ),
    ],
  );

  Widget _buildSaveResetButtons(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: _resetSettings,
          child: const Text("Reset"),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: FilledButton(
          onPressed: _saveSettings,
          child: isVerifying
              ? const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white, // adjust color if needed
                  ),
                )
              : const Text("Save"),
        ),
      ),
    ],
  );

  void _resetSettings() {
    selectedModel.value = llmModels.first;
    apiKeyController.clear();
  }

  void _saveSettings() async {
    if (!isVerifying) {
      setState(() {
        isVerifying = true;
      });
      print("Model: ${selectedModel.value}");
      print("API Key: ${apiKeyController.text}");
      //lets verify api key
      bool isVerified = false;
      if (selectedModel.value.startsWith("gemini")) {
        LlmService llm = GeminiService(
          model: selectedModel.value,
          otherApiKey: apiKeyController.text,
        );
        String? result = await llm.generateResponse(prompt: "hello");
        print(
          "result is ---------------------------------------------------------------------------------",
        );
        print(result);
        isVerified = result != null;
        print("result:$result");
      } else if (selectedModel.value.trim().toLowerCase()=="default") {
        isVerified = true;
      }

      if (isVerified) {
        //lets save the selected options
        SharedPrefFineTuningService.saveLLMModel(selectedModel.value);
        SecureStorageService().saveApiKey(apiKeyController.text);
        shared.loadFineTuningSettings();
        chatProvider.changeLLM(selectedModel.value,apiKeyController.text);
        Get.back();
      } else {
        Toast.showError("Invalid api key", context);
      }

      setState(() {
        isVerifying = false;
      });
    }
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    List<Widget>? children,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 22),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          if (children != null) ...children,
        ],
      ),
    );
  }
}
