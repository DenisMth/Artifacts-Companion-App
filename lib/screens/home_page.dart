import 'dart:convert';

import 'package:flutter/material.dart';
import '../auth/api_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final ApiClient api = ApiClient();

  final nameController = TextEditingController();
  final actionController = TextEditingController();
  final targetController = TextEditingController();
  final optionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    actionController.dispose();
    targetController.dispose();
    optionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Artifacts Companion App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name(s)",
                ),
              ),

              TextFormField(
                controller: actionController,
                decoration: const InputDecoration(
                  labelText: "Action",
                ),
              ),

              TextFormField(
                controller: targetController,
                decoration: const InputDecoration(
                  labelText: "Target",
                ),
              ),

              TextFormField(
                controller: optionController,
                decoration: const InputDecoration(
                  labelText: "Options",
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    final characters = nameController.text
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    final target = targetController.text.trim().isEmpty
        ? null
        : targetController.text.trim();

    final option = optionController.text.trim().isEmpty
        ? null
        : optionController.text.trim();

    try {
      final response = await api.post(
        "/command",
        body: jsonEncode({
          "characters": characters,
          "action": actionController.text,
          "target": target,
          "option": option,
        }),
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        print("Success!");
        print(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Request failed: $e");
    }
  }


}