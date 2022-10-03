import 'package:flutter/material.dart';

class AgentForm extends StatefulWidget {
  const AgentForm({Key? key}) : super(key: key);

  @override
  State<AgentForm> createState() => _AgentFormState();
}

class _AgentFormState extends State<AgentForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("AGENT FORM"),

      ),
      
    );
  }
}
