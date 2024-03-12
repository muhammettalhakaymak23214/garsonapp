import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';
import 'package:garsonapp/sayfalar/sepet_sayfasi.dart';
import 'package:http/http.dart' as http;

import 'package:garsonapp/sabitler/api_url.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';

class MenuPage extends StatefulWidget {
  final int masaNumber;

  MenuPage({required this.masaNumber});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<Map<String, dynamic>>> _menuData;

  List<String> bosStringListesi = [];

//sepet sayfasına gidecek örnek veri
  Map<String, List<double>> yemekMap = {};

  // double adet = 0;
//-------------------------

  @override
  void initState() {
    super.initState();
    _menuData = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrlMenuGetir));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Map<String, dynamic>> menuData = [];
      for (var category in jsonData) {
        List<dynamic> menus = category['menus'];
        for (var menu in menus) {
          String name = utf8.decode(menu['name'].runes.toList());
          double price = menu['price'];
          yemekMap[name] = [price, 0]; // Adet başlangıçta 0 olarak ekleniyor.
        }
        menuData.add({
          'name': utf8.decode(category['name'].runes.toList()),
          'isCategory': true,
          'menus': category['menus'],
        });
      }
      return menuData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SepetSayfasi(
                  masaNumber: widget.masaNumber, gelenMap: yemekMap),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: arkaPlanRengi,
      body: Center(
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
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
                          const Color categoryColor =
                              Color.fromARGB(255, 120, 0, 240);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // color: categoryColor,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        var menu = category['menus'][menuIndex];
                                        double adet = yemekMap.containsKey(
                                                utf8.decode(menu['name']
                                                    .runes
                                                    .toList()))
                                            ? yemekMap[utf8.decode(menu['name']
                                                .runes
                                                .toList())]![1]
                                            : 0;
                                        return Container(
                                            height: 100,
                                            width: 350,
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255,
                                                  255,
                                                  17,
                                                  0), // Yemek container rengi
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // margin: EdgeInsets.all(5),
                                                  //color: Colors.amber,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 30,
                                                          width: 80,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Text(
                                                            utf8.decode(
                                                                menu['name']
                                                                    .runes
                                                                    .toList()),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 30,
                                                          width: 80,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Text(
                                                              menu['price']
                                                                  .toString())),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 120,
                                                ),
                                                Container(
                                                  height: 80,
                                                  width: 120,
                                                  //color: Colors.amber,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            //color: Colors.white,
                                                            alignment: Alignment
                                                                .center,
                                                            height: 40,
                                                            width: 40,
                                                            child: IconButton(
                                                              iconSize: 25,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              onPressed: () {
                                                                // İkon butona tıklandığında yapılacak işlemler
                                                              },

                                                              icon: const Icon(
                                                                  Icons
                                                                      .note_add_rounded,
                                                                  color: Colors
                                                                      .white), // Kullanılacak ikon
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 40,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            //color: Colors.white,
                                                            alignment: Alignment
                                                                .center,
                                                            height: 40,
                                                            width: 40,
                                                            child: IconButton(
                                                              iconSize: 25,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              onPressed: () {
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
                                                                    adet
                                                                  ]
                                                                });
                                                                setState(() {});
                                                                debugPrint(yemekMap
                                                                    .toString());
                                                              },

                                                              icon: const Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white), // Kullanılacak ikon
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10)),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 30,
                                                              width: 70,
                                                              child: Text(adet
                                                                  .toString())),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            //color: Colors.white,
                                                            alignment: Alignment
                                                                .center,
                                                            height: 40,
                                                            width: 40,
                                                            child: IconButton(
                                                              iconSize: 25,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              onPressed: () {
                                                                // İkon butona tıklandığında yapılacak işlemler

                                                                adet = adet - 1;
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
                                                                setState(() {});
                                                                debugPrint(yemekMap
                                                                    .toString());
                                                              },
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .white),
                                                              //iconSize: 10,
                                                            ),
                                                          ),
                                                        ],
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
