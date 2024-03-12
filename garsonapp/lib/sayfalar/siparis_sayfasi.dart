import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';
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
        onPressed: () {},
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
                          Color categoryColor =
                              Color.fromARGB(255, 120, 0, 240);
                          return Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(10),
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
                                        return Container(
                                            height: 100,
                                            width: 350,
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255,
                                                  0,
                                                  0,
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
                                                              EdgeInsets.all(5),
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
                                                              EdgeInsets.all(5),
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
                                                                EdgeInsets.all(
                                                                    0),
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

                                                              icon: Icon(
                                                                  Icons
                                                                      .note_add_rounded,
                                                                  color: Colors
                                                                      .white), // Kullanılacak ikon
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 40,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
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
                                                                bosStringListesi.add(
                                                                    utf8.decode(menu[
                                                                            'name']
                                                                        .runes
                                                                        .toList()));
                                                                debugPrint(
                                                                    bosStringListesi
                                                                        .toString());
                                                              },

                                                              icon: Icon(
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
                                                                  EdgeInsets
                                                                      .all(0),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 30,
                                                              width: 70,
                                                              child: Text(
                                                                  "Adet: 5")),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
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
                                                              icon: Icon(
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
                  return Center(child: Text('No data available'));
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
