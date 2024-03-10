import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garsonapp/apiler/giris_yap.dart';
import 'package:garsonapp/models/snack_bar.dart';
import 'package:garsonapp/sabitler/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:garsonapp/sayfalar/ana_sayfa.dart';
import 'package:garsonapp/sabitler/renkler.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  Color butonColor = Colors.white;
  Color butonYaziRengi = Colors.black;

  Future<void> _login() async {
    await GirisYap.login(context, controller, controller2);
  }

  @override
  Widget build(BuildContext context) {
    bool isFilled1 = controller.text.isNotEmpty;
    bool isFilled2 = controller2.text.isNotEmpty;

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
                      borderRadius: BorderRadius.circular(10.0),
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
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: _login,

                ///butonColor == yesilButonRengi ? _login : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: butonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // İstediğiniz border radius değerini buraya yazabilirsiniz
                  ),
                ),
                child: Container(
                  width: 150, // Genişlik değeri
                  height: 50, // Yükseklik değeri
                  child: Center(
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(
                          color: butonYaziRengi,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
