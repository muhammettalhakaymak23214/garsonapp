import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:garsonapp/widgets/my_textbox.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  //
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String yazi = '';
  String yazi2 = '';
  //
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
            Container(
              width: 350,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Kullanıcı Adı",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 350,
              child: TextField(
                controller: controller2,
                decoration: InputDecoration(
                  hintText: "Parola",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    yazi = controller.text;
                    yazi2 = controller2.text;
                  });
                },
                child: const Text("Giriş Yap")),
            Text(
              yazi,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              yazi2,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

//Color.fromRGBO(51, 51, 51, 0),
//Color.fromRGBO(0, 0, 0, 100),
class MyTextBox extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String yazi = '';
  final String hintTextYazi;
  MyTextBox({required this.hintTextYazi});

  void esitle() {
    yazi = controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      // height: 60,
      child: TextField(
        controller: controller,
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
