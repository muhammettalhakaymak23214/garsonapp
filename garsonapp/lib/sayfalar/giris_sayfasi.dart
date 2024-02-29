//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';

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
  Color butonColor = const Color.fromARGB(255, 255, 255, 255);
  Color butonYaziRengi = siyahYaziRengi;
  //

  @override
  Widget build(BuildContext context) {
    bool isFilled1 = controller.text.isNotEmpty;
    bool isFilled2 = controller2.text.isNotEmpty;
    // Color buttonColor = isFilled1 && isFilled2 ? Colors.green : Colors.white;
    return Scaffold(
      backgroundColor: girisEkraniArkaPlanRengi,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset('assets/garson_logo.png', height: 300),
              SizedBox(
                width: 350,
                child: TextField(
                  onChanged: (value) {
                    setState(
                      () {
                        butonColor = isFilled1 && isFilled2
                            ? yesilButonRengi
                            : beyazButonRengi;
                        butonYaziRengi = isFilled1 && isFilled2
                            ? beyazYaziRengi
                            : siyahYaziRengi;
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
              SizedBox(
                width: 350,
                child: TextField(
                  controller: controller2,
                  onChanged: (value) {
                    setState(
                      () {
                        butonColor = isFilled1 && isFilled2
                            ? yesilButonRengi
                            : beyazButonRengi;
                        butonYaziRengi = isFilled1 && isFilled2
                            ? beyazYaziRengi
                            : siyahYaziRengi;
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
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: butonColor == yesilButonRengi
                      ? () {
                          setState(() {
                            yazi = controller.text;
                            yazi2 = controller2.text;

                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const AnaSayfa(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          });
                        }
                      : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: butonColor,
                  ),
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      color: butonYaziRengi,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              //
              //
              //
              //-----------silinecek----------------------
              Text(
                yazi,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                yazi2,
                style: const TextStyle(color: Colors.white),
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
