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
  const MyTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.clear),
        labelText: 'Filled',
        hintText: 'hint text',
        helperText: 'supporting text',
        filled: true,
      ),
    );
  }
}
