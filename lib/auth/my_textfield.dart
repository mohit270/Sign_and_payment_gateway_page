import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controllers;
  final bool obsecureText;
  final String hintText;
  const MyTextField(
      {super.key,
      required this.controllers,
      required this.hintText,
      required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controllers,
        obscureText: obsecureText,
        decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            fillColor: Colors.grey.shade200,
            filled: true),
      ),
    );
  }
}
