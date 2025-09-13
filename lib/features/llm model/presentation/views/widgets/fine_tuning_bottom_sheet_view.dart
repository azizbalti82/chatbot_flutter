import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FineTuningLLMSheetView extends StatelessWidget {
  FineTuningLLMSheetView({super.key});

  final RxString selectedRole = "".obs;
  final TextEditingController customRoleController = TextEditingController();

  final RxMap<String, bool> behaviorOptions = <String, bool>{
    "Explain like a teacher": false,
    "Be concise": false,
    "Focus on coding": false,
    "Friendly tone": false,
    "Professional tone": false,
    "Creative style": false,
    "Humorous": false,
  }.obs;

  final RxDouble temperature = 0.7.obs;
  final RxInt maxTokens = 150.obs;

  final List<String> predefinedRoles = [
    "Mom",
    "Dad",
    "Boyfriend",
    "Girlfriend",
    "Friend",
    "Teacher",
    "Developer",
    "Coach",
    "Mentor",
    "Therapist",
    "Assistant",
    "Tutor",
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(colorScheme),
          const SizedBox(height: 15),
          _buildRoleSection(context),
          const SizedBox(height: 20),
          _buildBehaviorOptions(context),
          const SizedBox(height: 20),
          _buildAdvancedSettings(context),
          const SizedBox(height: 25),
          _buildSaveResetButtons(context),
        ],
      ),
    );
  }

  Widget _buildHandle(ColorScheme colorScheme) => Container(
    width: 40,
    height: 5,
    decoration: BoxDecoration(
      color: colorScheme.primary.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  Widget _buildRoleSection(BuildContext context) => _buildSection(
    context: context,
    title: "Relationship with LLM",
    icon: Icons.person_outline,
    children: [
      Obx(() => Wrap(
        spacing: 8,
        runSpacing: 5,
        children: predefinedRoles
            .map(
              (role) => ChoiceChip(
            label: Text(role),
            selected: selectedRole.value == role,
            onSelected: (_) {
              selectedRole.value = role;
              customRoleController.text = "";
            },
          ),
        )
            .toList(),
      )),
      const SizedBox(height: 10),
      TextField(
        controller: customRoleController,
        decoration: InputDecoration(
          labelText: "Custom role",
          hintText: "Enter your custom relationship",
          border: const OutlineInputBorder(),
        ),
        onChanged: (val) => selectedRole.value = val,
      ),
    ],
  );

  Widget _buildBehaviorOptions(BuildContext context) => _buildSection(
    context: context,
    title: "Behavior Options",
    icon: Icons.settings,
    children: [
      Obx(() => Wrap(
        spacing: 8,
        runSpacing: 5,
        children: behaviorOptions.keys
            .map(
              (key) => FilterChip(
            label: Text(key),
            selected: behaviorOptions[key]!,
            onSelected: (val) => behaviorOptions[key] = val,
            checkmarkColor: Colors.white,
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
        )
            .toList(),
      )),
    ],
  );

  Widget _buildAdvancedSettings(BuildContext context) => _buildSection(
    context: context,
    title: "Advanced Settings",
    icon: Icons.tune,
    children: [
      Obx(() => Column(
        children: [
          _buildSliderWithDescription(
            "Temperature",
            temperature.value,
            0.0,
            1.0,
                (val) => temperature.value = val,
            description:
            "Controls the randomness of the LLM. Higher → more creative responses.",
          ),
          _buildSliderWithDescription(
            "Max Tokens",
            maxTokens.value.toDouble(),
            10,
            500,
                (val) => maxTokens.value = val.toInt(),
            description:
            "Maximum length of the generated response. Higher → longer responses.",
            divisions: 49,
          ),
        ],
      ))
    ],
  );

  Widget _buildSliderWithDescription(String label, double value, double min,
      double max, Function(double) onChanged,
      {int? divisions, String? description}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label),
                const Spacer(),
                Text(value.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
          ],
        ),
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
        child: ElevatedButton(
          onPressed: _saveSettings,
          child: const Text("Save"),
        ),
      ),
    ],
  );

  void _resetSettings() {
    selectedRole.value = "";
    customRoleController.clear();
    behaviorOptions.keys.forEach((key) => behaviorOptions[key] = false);
    temperature.value = 0.7;
    maxTokens.value = 150;
  }

  void _saveSettings() {
    print("Role: ${selectedRole.value}");
    print(
        "Behavior: ${behaviorOptions.entries.where((e) => e.value).map((e) => e.key).toList()}");
    print("Temperature: ${temperature.value}");
    print("Max Tokens: ${maxTokens.value}");
    Get.back();
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
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (children != null) ...children,
        ],
      ),
    );
  }
}
