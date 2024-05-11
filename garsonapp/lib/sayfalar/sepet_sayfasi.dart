import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
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

  /*  
    ! Ip Adresi Telefondan Getiriliyor. <-------Başladı-------
  */

  Future<void> _getirSecilenIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secilenIp = prefs.getString('secilenIp') ?? "192.168.1.100";
    apiUrlcreateOrder = 'http://${secilenIp}:8080/createOrder';
    apiUrlOrderDetails = 'http://${secilenIp}:8080/createOrderDetails';
  }

  /*  
    ! Ip Adresi Telefondan Getiriliyor. -------Bitti------->
  */

  /*  
    ? Apiler. <-------Başladı-------
  */

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

  /*  
    ? Apiler. <-------Başladı-------
  */

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi =
        MediaQuery.of(context).size.width; // Ekran genişliğini al
    double ekranYuksekligi =
        MediaQuery.of(context).size.height; // Ekran yüksekliğini al
    double ekranUstBosluk = (ekranYuksekligi / 100) * 5;
    double ekranYatayBosluk = (ekranGenisligi / 100) * 5;
    double ekranYaziBoyutu = (ekranYuksekligi / 100) * 2.5;
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında yapılacak işlemler
        // Örneğin:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                MenuPage(masaNumber: widget.masaNumber, masaId: widget.masaId),
          ),
        ); // Bir önceki sayfaya gitmek için
        // true döndürerek geri tuşunun varsayılan işlemi olan uygulamayı kapatmayı önleyebilirsiniz
        return false; // false döndürerek uygulamanın kapanmasını önleyebilirsiniz
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: arkaPlanRengi,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: ekranUstBosluk,
              ),
              // Masa bilgisi(başlık)
              Container(
                height: (ekranYuksekligi / 100) * 6,
                width: (ekranGenisligi / 100) * 50,
                alignment: Alignment.center,
                decoration: boxDecoreation,
                child: Text(
                  "Masa : ${widget.masaNumber.toString()}",
                  style: TextStyle(
                      fontSize: ekranYaziBoyutu,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              // Boşluk
              SizedBox(
                height: (ekranYuksekligi / 100) * 2,
              ),
              // Gelen Map içindeki her bir anahtar için container oluşturma
              Container(
                height: (ekranYuksekligi / 100) * 78,
                width: (ekranGenisligi / 100) * 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(255, 76, 72, 72),
                ),
                // padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    SizedBox(
                      height: (ekranYuksekligi / 100) * 2,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: (ekranYuksekligi / 100) * 6,
                      width: (ekranGenisligi / 100) * 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(255, 254, 254, 1),
                      ),
                      child: Text(
                        "Siparişler",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ekranYaziBoyutu,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: (ekranYuksekligi / 100) * 2,
                    ),
                    Container(
                      height: (ekranYuksekligi / 100) * 65,
                      width: (ekranGenisligi / 100) * 90,
                      // color: Color.fromARGB(255, 0, 252, 84),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            //  padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            height: (ekranYuksekligi / 100) * 6,
                            width: (ekranGenisligi / 100) * 85,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: (ekranYuksekligi / 100) * 4,
                                  width: (ekranGenisligi / 100) * 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromARGB(255, 50, 50, 50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Ad",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: (ekranYuksekligi / 100) * 2.0,
                                        //fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                  ),
                                ),
                                Container(
                                  height: (ekranYuksekligi / 100) * 4,
                                  width: (ekranGenisligi / 100) * 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 50, 50, 50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Fiyat",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: (ekranYuksekligi / 100) * 2.0,
                                        //fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                  ),
                                ),
                                Container(
                                  height: (ekranYuksekligi / 100) * 4,
                                  width: (ekranGenisligi / 100) * 15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 50, 50, 50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Adet",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: (ekranYuksekligi / 100) * 2.0,
                                        //fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //CustomDivider(),
                          Divider(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            //height: 20,
                            thickness: 2,
                          ),
                          Container(
                            //  color: Colors.pink,
                            height: (ekranYuksekligi / 100) * 54,
                            width: (ekranGenisligi / 100) * 85,
                            //   color: const Color.fromARGB(251, 0, 0, 0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: gercekVerilerMap.keys.map((key) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    //padding: EdgeInsets.all(10),
                                    height: (ekranYuksekligi / 100) * 6,
                                    width: (ekranGenisligi / 100) * 85,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Anahtar
                                        Container(
                                            height: (ekranYuksekligi / 100) * 4,
                                            width: (ekranGenisligi / 100) * 35,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromARGB(
                                                  255, 50, 50, 50),
                                            ),
                                            child: Text(
                                              key,
                                              style: TextStyle(
                                                  fontSize:
                                                      (ekranYuksekligi / 100) *
                                                          2.0,
                                                  //fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            )),
                                        // Değer listesinin ilk elemanı (sol)
                                        Container(
                                          height: (ekranYuksekligi / 100) * 4,
                                          width: (ekranGenisligi / 100) * 30,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                Color.fromARGB(255, 50, 50, 50),
                                          ),
                                          child: Text(
                                            gercekVerilerMap[key]?[0]
                                                    ?.toString() ??
                                                '',
                                            style: TextStyle(
                                                fontSize:
                                                    (ekranYuksekligi / 100) *
                                                        2.0,
                                                //fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                          ),
                                        ),
                                        // Değer listesinin ikinci elemanı (sağ)
                                        Container(
                                          height: (ekranYuksekligi / 100) * 4,
                                          width: (ekranGenisligi / 100) * 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                Color.fromARGB(255, 50, 50, 50),
                                          ),
                                          child: Text(
                                            gercekVerilerMap[key]?[1]
                                                    ?.toInt()
                                                    .toString() ??
                                                '',
                                            style: TextStyle(
                                                fontSize:
                                                    (ekranYuksekligi / 100) *
                                                        2.0,
                                                //fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                          ),
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
                    SizedBox(
                      height: (ekranYuksekligi / 100) * 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: (ekranYuksekligi / 100) * 2,
              ),
              Container(
                height: (ekranYuksekligi / 100) * 6,
                width: ekranGenisligi,
                // color: Color.fromARGB(255, 1, 254, 246),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // color: Color.fromARGB(255, 112, 0, 249),
                      height: (ekranYuksekligi / 100) * 5,
                      width: (ekranGenisligi / 100) * 35,
                      margin: EdgeInsets.only(left: (ekranGenisligi / 100) * 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: status401,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        onPressed: () {
                          //_postData();
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: (ekranYuksekligi / 100) * 2.0,
                              // fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: (ekranGenisligi / 100) * 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            siparisIptal,
                            siparisHazir
                          ], // Sol taraf kırmızı, sağ taraf yeşil
                        ),
                      ),
                    ),
                    Container(
                      height: (ekranYuksekligi / 100) * 5,
                      width: (ekranGenisligi / 100) * 35,
                      margin:
                          EdgeInsets.only(right: (ekranGenisligi / 100) * 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: yesilButonRengi),
                          onPressed: () {
                            _postData();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // Alert dialog oluşturma
                                return AlertDialog(
                                  backgroundColor:
                                      siparisHazir, // Arka plan rengi kırmızı
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5.0), // Border radius 5
                                    side: BorderSide(
                                        color:
                                            Colors.black), // Border rengi siyah
                                  ),
                                  title: Text(
                                    'Sipariş Gönderildi',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                          child: Text(
                            "Siparişi Gönder",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: (ekranYuksekligi / 100) * 2.0,
                                // fontWeight: FontWeight.bold,
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: (ekranYuksekligi / 100) * 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
