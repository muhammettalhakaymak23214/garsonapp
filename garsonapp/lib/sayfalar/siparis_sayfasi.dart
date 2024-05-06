import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';
import 'package:garsonapp/sayfalar/sepet_sayfasi.dart';
import 'package:http/http.dart' as http;

import 'package:garsonapp/sabitler/api_url.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  final int masaNumber;
  final int masaId;

  MenuPage({required this.masaNumber, required this.masaId});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _isLoading = true;
  String secilenIp = "";
  String apiUrl = "";
  String apiUrlMasaGetir = "";
  String apiUrlMenuGetir = "";
  late Future<List<Map<String, dynamic>>> _menuData;
  TextEditingController textEditingControllerSiparisNotu =
      TextEditingController();
  String savedTextSiparisNotu = '';
  String siparisNotuKaydedildimi = '';

  List<String> bosStringListesi = [];

//sepet sayfasına gidecek örnek veri
  Map<String, List<double>> yemekMap = {};

  // double adet = 0;
//-------------------------

  @override
  void initState() {
    _getirSecilenIp();
    super.initState();
    //_menuData = fetchData();
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
    _menuData = fetchData();
  }

  void _saveText() {
    setState(() {
      savedTextSiparisNotu = textEditingControllerSiparisNotu.text;
      textEditingControllerSiparisNotu.text = "";
      siparisNotuKaydedildimi = "Sipariş Notu Kaydedildi.";
    });
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    yemekMap.clear();
    final response = await http.get(Uri.parse(
        apiUrlMenuGetir)); //*********************************************************sdsgdgfdgfdgfdgfdgdfg */
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Map<String, dynamic>> menuData = [];
      for (var category in jsonData) {
        List<dynamic> menus = category['menus'];
        for (var menu in menus) {
          String name = utf8.decode(menu['name'].runes.toList());
          double price = menu['price'];
          int menuId = menu['id'];
          yemekMap[name] = [
            price,
            0,
            menuId.toDouble()
          ]; // Adet başlangıçta 0 olarak ekleniyor.
        }
        menuData.add({
          'name': utf8.decode(category['name'].runes.toList()),
          'isCategory': true,
          'menus': category['menus'],
        });
      }
      _isLoading = false;
      setState(() {});
      return menuData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında giriş sayfasına yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AnaSayfa(), // Giriş sayfası widget'ı
          ),
        );

        // Geri tuşunun işlenmesini durdur
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: yesilButonRengi,
          onPressed: () {
            bool anyNonZeroQuantity =
                yemekMap.values.any((value) => value[1] > 0);
            if (anyNonZeroQuantity) {
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Color.fromARGB(255, 0, 0, 0).withOpacity(0.80),
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor:
                        Color.fromRGBO(47, 47, 47, 1), // Arka plan rengi gri
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side:
                          BorderSide(color: Colors.black), // Border rengi siyah
                    ),
                    title: Text(
                      "Not Ekleme Ekranı",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Container(
                      height: 200,
                      width: 300,
                      child: Column(
                        children: <Widget>[
                          const Divider(color: Colors.white),
                          const SizedBox(height: 20),
                          TextField(
                            controller: textEditingControllerSiparisNotu,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Sipariş notu giriniz.',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              _saveText();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SepetSayfasi(
                                    masaNumber: widget.masaNumber,
                                    gelenMap: yemekMap,
                                    masaId: widget.masaId,
                                    siparisNotu: savedTextSiparisNotu,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.black, width: 2)),
                              child: const Text(
                                "Sepet Sayfasına Git",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              // Hiçbir üründen seçim yapılmamış, uyarı gösterilebilir veya başka bir işlem yapılabilir.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.red, // Arka plan rengi kırmızı
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side:
                          BorderSide(color: Colors.black), // Border rengi siyah
                    ),
                    title: Text(
                      "Uyarı",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Text(
                      "Sepete eklemek için en az bir ürün seçmelisiniz.",
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Tamam",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Icon(Icons.send, color: Colors.black),
        ),
        backgroundColor: arkaPlanRengi,
        body: _isLoading // Yükleme durumuna göre gösterilecek widget
            ? Center(
                child: CircularProgressIndicator()) // Yükleme çubuğu göster
            : Center(
                child: Column(
                  children: [
                    //Ekran üstü boşluk
                    const SizedBox(
                      height: 50,
                    ),
                    //Masa bilgisi(başlık)
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
                    //Boşluk
                    const SizedBox(
                      height: 10,
                    ),
                    //Menü oluşturuluyor----------------
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _menuData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<Map<String, dynamic>> menuData = snapshot.data!;
                          return Container(
                            height: 750,
                            //color: Colors.pink,
                            // color: arkaPlanRengi,
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: menuData.map<Widget>((category) {
                                  Color categoryColor =
                                      Color.fromARGB(255, 120, 0, 240);
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      // color: categoryColor,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            category['name'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Column(
                                            children: List.generate(
                                              category['menus'].length,
                                              (menuIndex) {
                                                var menu = category['menus']
                                                    [menuIndex];
                                                double adet = yemekMap
                                                        .containsKey(utf8
                                                            .decode(menu['name']
                                                                .runes
                                                                .toList()))
                                                    ? yemekMap[utf8.decode(
                                                        menu['name']
                                                            .runes
                                                            .toList())]![1]
                                                    : 0;
                                                return Container(
                                                    height: 100,
                                                    width: 350,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255,
                                                          53,
                                                          49,
                                                          49), // Yemek container rengi
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          // margin: EdgeInsets.all(5),
                                                          width: 250,

                                                          //color: Colors.amber,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: 30,
                                                                  width: 220,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  child: Text(
                                                                    utf8.decode(menu[
                                                                            'name']
                                                                        .runes
                                                                        .toList()),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )),
                                                              Container(
                                                                height: 40,
                                                                width: 220,
                                                                /*color:
                                                                    Colors.pink,*/
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                0),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .white,
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        alignment: Alignment
                                                                            .center,
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            90,
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        child: Text(
                                                                            menu['price'].toString())),
                                                                    SizedBox(
                                                                      width: 40,
                                                                    ),
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .white,
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            90,
                                                                        child: Text(
                                                                            adet.toString())),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 30,
                                                        ),
                                                        Container(
                                                          height: 80,
                                                          width: 50,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                //color: Colors.white,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 40,
                                                                width: 40,
                                                                child:
                                                                    IconButton(
                                                                  iconSize: 25,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  onPressed:
                                                                      () {
                                                                    // İkon butona tıklandığında yapılacak işlemler
                                                                    /*
                                                                  bosStringListesi.add(
                                                                      utf8.decode(menu[
                                                                              'name']
                                                                          .runes
                                                                          .toList()));
                                                                  debugPrint(
                                                                      bosStringListesi
                                                                          .toString());
    */
                                                                    adet++;
                                                                    //adet--;
                                                                    yemekMap
                                                                        .addAll({
                                                                      utf8.decode(menu[
                                                                              'name']
                                                                          .runes
                                                                          .toList()): [
                                                                        menu[
                                                                            'price'],
                                                                        adet,
                                                                        menu['id']
                                                                            .toDouble()
                                                                      ]
                                                                    });
                                                                    setState(
                                                                        () {});
                                                                    debugPrint(
                                                                        yemekMap
                                                                            .toString());
                                                                  },

                                                                  icon: const Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white), // Kullanılacak ikon
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                //color: Colors.white,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 40,
                                                                width: 40,
                                                                child:
                                                                    IconButton(
                                                                  iconSize: 25,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  onPressed:
                                                                      () {
                                                                    // İkon butona tıklandığında yapılacak işlemler

                                                                    if (adet >
                                                                        0) {
                                                                      adet =
                                                                          adet -
                                                                              1;
                                                                    }

                                                                    yemekMap
                                                                        .addAll({
                                                                      utf8.decode(menu[
                                                                              'name']
                                                                          .runes
                                                                          .toList()): [
                                                                        menu[
                                                                            'price'],
                                                                        adet
                                                                      ]
                                                                    });
                                                                    debugPrint(adet
                                                                        .toString());
                                                                    setState(
                                                                        () {});
                                                                    debugPrint(
                                                                        yemekMap
                                                                            .toString());
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .white),
                                                                  //iconSize: 10,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )

                                                    //----

                                                    //--
                                                    );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        } else {
                          return const Center(child: Text('No data available'));
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/*
ListTile(
                                        title: Text(
                                          utf8.decode(
                                              menu['name'].runes.toList()),
                                        ),
                                        subtitle: Text(
                                          'Fiyat: ${menu['price']}',
                                        ),
                                      ),
*/


/*
Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              10)),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          30,
                                                                      width: 70,
                                                                      child: Text(
                                                                          adet.toString())),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
*/