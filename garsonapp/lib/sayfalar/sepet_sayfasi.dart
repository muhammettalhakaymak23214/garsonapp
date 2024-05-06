import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:garsonapp/sabitler/divider.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';
import 'package:garsonapp/sayfalar/siparis_sayfasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SepetSayfasi extends StatefulWidget {
  final int masaNumber;
  final int masaId;
  final Map<String, dynamic> gelenMap;
  final String siparisNotu;

  SepetSayfasi(
      {required this.masaNumber,
      required this.gelenMap,
      required this.masaId,
      required this.siparisNotu});

  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}

class _SepetSayfasiState extends State<SepetSayfasi> {
  int orderId = 0;
  int tableId = 0; //-----------------------
  String secilenIp = "";
  String apiUrl = "";
  String apiUrlMasaGetir = "";
  String apiUrlMenuGetir = "";
  String apiUrlcreateOrder = "";
  String apiUrlOrderDetails = "";
  Map<String, List<double>> gercekVerilerMap = {};
  @override
  void initState() {
    _getirSecilenIp();
    debugPrint("Gelen Map: ${widget.gelenMap.toString()}");
    debugPrint("Gelen Sipariş Notu: ${widget.siparisNotu}");
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

  Future<void> _kaydetSecilenIp(String secilenIp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('secilenIp', secilenIp);
    secilenIp = prefs.getString('secilenIp') ?? "100";
  }

  Future<void> _getirSecilenIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secilenIp = prefs.getString('secilenIp') ?? "100";
    apiUrl = "http://192.168.1.${secilenIp}:8080/login";
    apiUrlMasaGetir = 'http://192.168.1.${secilenIp}:8080/tables';
    apiUrlMenuGetir = 'http://192.168.1.${secilenIp}:8080/categories';
    apiUrlcreateOrder = 'http://192.168.1.${secilenIp}:8080/createOrder';
    apiUrlOrderDetails =
        'http://192.168.1.${secilenIp}:8080/createOrderDetails';
  }

  Future<void> _postData() async {
    final url = Uri.parse(apiUrlcreateOrder);
    debugPrint("------------565656---------------------------");
    debugPrint(widget.masaId.toString());

    final response = await http.post(
      url,
      body: {
        'tableId': widget.masaId.toString(),
      },
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // Başarılı bir şekilde gönderildi.
      orderId = int.parse(response.body);
      print('Post isteği başarıyla yapıldı.');
      print("orderId : ${orderId}");
      herYemekIcinApiGonder();
    } else {
      // İstekte bir hata oluştu.
      print('Post isteğinde hata oluştu: ${response.statusCode}');
    }
  }

  void herYemekIcinApiGonder() {
    widget.gelenMap.forEach((anahtar, degerler) {
      double fiyat = degerler[0];
      int miktar = degerler[1].toInt();
      int menuId = degerler[2].toInt();
      if (miktar != 0) {
        _sendDataToApi(miktar, orderId, menuId, widget.siparisNotu);
      }

      debugPrint(
          "--------------------------------------api---------------------------------------");
    });
    widget.gelenMap.clear();
    gercekVerilerMap.clear();
  }

  Future<void> _sendDataToApi(
      int quantity, int orderId, int menuId, String orderNote) async {
    final url = Uri.parse(apiUrlOrderDetails);
    debugPrint("------------565656---------------------------");
    debugPrint(widget.masaId.toString());

    final response = await http.post(
      url,
      body: {
        "quantity": quantity.toString(),
        "orderId": orderId.toString(),
        "menuId": menuId.toString(),
        "orderNote": orderNote,
      },
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // Başarılı bir şekilde gönderildi.

      print('Post isteği başarıyla yapıldı.');
    } else {
      // İstekte bir hata oluştu.
      print('Post isteğinde hata oluştu: ${response.statusCode}');
    }
  }

//-----------------------------

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
                        _postData();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MenuPage(
                                masaNumber: widget.masaNumber,
                                masaId: widget.masaId),
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
                          _postData();
/*
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
                          });*/
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
