import 'package:flutter/material.dart';

/*
class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomButton({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: 200,
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ));
  }
}
*/
class MyTextBox extends StatelessWidget {
  final String hintTextYazi;
  const MyTextBox({required this.hintTextYazi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      // height: 60,
      child: TextField(
        decoration: InputDecoration(
          hintText: hintTextYazi,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
