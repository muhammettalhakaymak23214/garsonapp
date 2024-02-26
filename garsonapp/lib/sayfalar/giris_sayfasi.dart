import 'dart:ui';
import 'package:flutter/material.dart';

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
  Color butonColor = Color.fromARGB(255, 255, 255, 255);
  Color butonYaziRengi = Color.fromARGB(255, 0, 0, 0);
  //

  @override
  Widget build(BuildContext context) {
    bool isFilled1 = controller.text.isNotEmpty;
    bool isFilled2 = controller2.text.isNotEmpty;
    Color buttonColor = isFilled1 && isFilled2 ? Colors.green : Colors.white;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset('assets/garson_logo.png', height: 300),
              Container(
                width: 350,
                child: TextField(
                  onChanged: (value) {
                    setState(
                      () {
                        butonColor = isFilled1 && isFilled2
                            ? Colors.green
                            : Colors.white;
                        butonYaziRengi = isFilled1 && isFilled2
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Color.fromARGB(255, 0, 0, 0);
                      },
                    );
                  },
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
                  onChanged: (value) {
                    setState(
                      () {
                        butonColor = isFilled1 && isFilled2
                            ? Colors.green
                            : Colors.white;
                        butonYaziRengi = isFilled1 && isFilled2
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Color.fromARGB(255, 0, 0, 0);
                      },
                    );
                  },
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
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: butonColor == Colors.green
                      ? () {
                          setState(() {
                            yazi = controller.text;
                            yazi2 = controller2.text;
                          });
                        }
                      : () {},
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(color: butonYaziRengi),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: butonColor,
                  ),
                ),
              ),

              //
              //
              //
              //-----------silinecek----------------------
              Text(
                yazi,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                yazi2,
                style: TextStyle(color: Colors.white),
              ),
              //------------------------------------------------
              //
              //
              //
            ],
          ),
        ),
      ),
    );
  }
}

/*
buton tıklanamaz da olmalı
*/
