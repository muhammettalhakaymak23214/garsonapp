import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';

class SepetSayfasi extends StatefulWidget {
  final int masaNumber;
  final Map<String, dynamic> gelenMap;

  SepetSayfasi({required this.masaNumber, required this.gelenMap});

  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}

class _SepetSayfasiState extends State<SepetSayfasi> {
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
                        children: widget.gelenMap.keys.map((key) {
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
                                Text(widget.gelenMap[key][0].toString()),
                                // Değer listesinin ikinci elemanı (sağ)
                                Text(widget.gelenMap[key][1].toString()),
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
                      onPressed: () {}, child: const Text("Siparişi Gönder")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
