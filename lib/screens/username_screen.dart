import 'package:flutter/material.dart';

class UsernameScreen extends StatelessWidget {
  UsernameScreen({super.key});

  final key = GlobalKey<FormFieldState>();
  final username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Column(children: [
        Text("Username"),
        Form(key: key, child: TextFormField(controller: username, decoration: InputDecoration(labelText: "Username"),))]),
    );
  }
}
