import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/shared.dart';
import '../../../../../core/widgets/basics.dart';
import '../../../domain/service/shared_preferences_service.dart';

class FineTuningLLMSheetView extends StatefulWidget {
  const FineTuningLLMSheetView({super.key});

  @override
  State<FineTuningLLMSheetView> createState() => _FineTuningLLMSheetViewState();
}

class _FineTuningLLMSheetViewState extends State<FineTuningLLMSheetView> {
  late RxString selectedRole;
  late TextEditingController customRoleController;
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
  final RxMap<String, bool> behaviorOptions = <String, bool>{
    "Explain like a teacher": shared.behavior.contains("Explain like a teacher"),
    "Be concise": shared.behavior.contains("Be concise"),
    "Focus on coding": shared.behavior.contains("Focus on coding"),
    "Friendly tone": shared.behavior.contains("Friendly tone"),
    "Professional tone": shared.behavior.contains("Professional tone"),
    "Creative style": shared.behavior.contains("Creative style"),
    "Humorous": shared.behavior.contains("Humorous"),
  }.obs;

  @override
  void initState() {
    super.initState();
    selectedRole = ((predefinedRoles.contains(shared.relationship))?shared.relationship : "").obs;
    customRoleController = TextEditingController(text:!predefinedRoles.contains(shared.relationship) ? shared.relationship : "");
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            simpleAppBar(context, text: ''),
            const SizedBox(height: 15),
            _buildRoleSection(context),
            const SizedBox(height: 20),
            _buildBehaviorOptions(context),
            const SizedBox(height: 25),
            _buildSaveResetButtons(context),
            const SizedBox(height: 15),
          ],
        ),
    );
  }


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
          hintText: "Enter your custom relationship",
          // remove labelText so it won't float on focus
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // adjust radius
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
        onChanged: (val) => selectedRole.value = val,
      )
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
            showCheckmark: false,
            selectedColor: (Theme.brightnessOf(context)==Brightness.dark)? Color(
                0xFF70533D) : Color(0xFFFBDDD1),
          ),
        )
            .toList(),
      )),
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
          child: const Text("Save"),
        ),
      ),
    ],
  );

  void _resetSettings() {
    selectedRole.value = "";
    customRoleController.clear();
    behaviorOptions.keys.forEach((key) => behaviorOptions[key] = false);
  }

  void _saveSettings() {
    print("Role: ${selectedRole.value}");
    print("Behavior: ${behaviorOptions.entries.where((e) => e.value).map((e) => e.key).toList()}");

    //save settings
    SharedPrefFineTuningService.saveRelationshipWithLLM(selectedRole.value);
    SharedPrefFineTuningService.saveBehaviorLLM(behaviorOptions.entries.where((e) => e.value).map((e) => e.key).toList());
    //load settings
    shared.loadFineTuningSettings();
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
