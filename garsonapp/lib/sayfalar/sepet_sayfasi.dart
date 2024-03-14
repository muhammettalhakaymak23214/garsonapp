import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:garsonapp/sabitler/divider.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';
import 'package:garsonapp/sayfalar/siparis_sayfasi.dart';

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
              height: 10,
            ),
            // Gelen Map içindeki her bir anahtar için container oluşturma
            Container(
              height: 670,
              width: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(103, 253, 253, 253),
              ),
              // padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
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
                    height: 590,
                    //  color: Color.fromARGB(255, 0, 252, 84),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    //padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          height: 50,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 72, 72, 61),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: Text("Ad", textAlign: TextAlign.center),
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child:
                                    Text("Fiyat", textAlign: TextAlign.center),
                              ),
                              Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child:
                                    Text("Adet", textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                        CustomDivider(),
                        Container(
                          height: 500,
                          //   color: const Color.fromARGB(251, 0, 0, 0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: gercekVerilerMap.keys.map((key) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.all(10),
                                  width: 350,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 72, 72, 61),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Anahtar
                                      Container(
                                          height: 30,
                                          width: 150,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: Text(key)),
                                      // Değer listesinin ilk elemanı (sol)
                                      Container(
                                        height: 30,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: Text(gercekVerilerMap[key]?[0]
                                                ?.toString() ??
                                            ''),
                                      ),
                                      // Değer listesinin ikinci elemanı (sağ)
                                      Container(
                                        height: 30,
                                        width: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: Text(gercekVerilerMap[key]?[1]
                                                ?.toString() ??
                                            ''),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              // color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // color: Color.fromARGB(255, 112, 0, 249),
                    width: 150,
                    margin: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: status401,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                MenuPage(masaNumber: widget.masaNumber),
                          ),
                        );
                      },
                      child: Text(
                        "Vazgeç",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    //color: Colors.amber,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: yesilButonRengi),
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
                        child: const Text(
                          "Siparişi Gönder",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
