import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';

class SepetSayfasi extends StatefulWidget {
  final int masaNumber;
  final Map<String, dynamic> gelenMap;

  SepetSayfasi({required this.masaNumber, required this.gelenMap});

  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}

class _SepetSayfasiState extends State<SepetSayfasi> {
  Map<String, List<double>> gercekVerilerMap = {};
  @override
  void initState() {
    // TODO: implement initState
    widget.gelenMap.forEach((key, value) {
      // value[1] yani yemek adedi 0'dan büyükse
      if (value[1] > 0) {
        // Gerçek verilere ekle
        gercekVerilerMap[key] = value;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arkaPlanRengi,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            // Masa bilgisi(başlık)
            Container(
              height: 40,
              width: 350,
              alignment: Alignment.center,
              decoration: boxDecoreation,
              child: Text(
                "Masa : ${widget.masaNumber.toString()}",
                style: baslikTextStyle,
              ),
            ),
            // Boşluk
            const SizedBox(
              height: 100,
            ),
            // Gelen Map içindeki her bir anahtar için container oluşturma
            Container(
              color: Colors.blue,
              height: 350,
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    height: 50,
                    color: const Color.fromARGB(255, 255, 0, 132),
                    child: const Text(
                      "Siparişler",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    color: Colors.amber,
                    child: SingleChildScrollView(
                      child: Column(
                        children: gercekVerilerMap.keys.map((key) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(10),
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Anahtar
                                Text(key),
                                // Değer listesinin ilk elemanı (sol)
                                Text(gercekVerilerMap[key]?[0]?.toString() ??
                                    ''),
                                // Değer listesinin ikinci elemanı (sağ)
                                Text(gercekVerilerMap[key]?[1]?.toString() ??
                                    ''),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        widget.gelenMap.clear();
                        gercekVerilerMap.clear();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Alert dialog oluşturma
                            return const AlertDialog(
                              title: Text('Sipariş Gönderildi'),
                              // content: Text('Bu bir alerttir.'),
                            );
                          },
                        );
                        Timer(Duration(seconds: 1), () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => AnaSayfa(),
                            ),
                          );
                        });
                      },
                      child: const Text("Siparişi Gönder")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
