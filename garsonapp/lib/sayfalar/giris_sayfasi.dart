import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:garsonapp/widgets/my_textbox.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset('assets/garson_logo.png', height: 300),
            const MyTextBox(hintTextYazi: "Kullancı Adı"),
            const SizedBox(
              height: 50,
            ),
            const MyTextBox(hintTextYazi: "Parola"),
          ],
        ),
      ),
    );
  }
}
//Color.fromRGBO(51, 51, 51, 0),
//Color.fromRGBO(0, 0, 0, 100),