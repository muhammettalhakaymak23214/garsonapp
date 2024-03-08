import 'package:flutter/material.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';
import 'package:garsonapp/sayfalar/giris_sayfasi.dart';
import 'package:garsonapp/sayfalar/siparis_sayfasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GirisSayfasi(),
    );
  }
}
