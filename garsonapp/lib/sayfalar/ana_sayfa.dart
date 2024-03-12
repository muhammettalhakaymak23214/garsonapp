import 'dart:convert';
import 'package:garsonapp/sabitler/api_url.dart';
import 'package:garsonapp/sayfalar/giris_sayfasi.dart';
import 'package:garsonapp/sayfalar/siparis_sayfasi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:garsonapp/apiler/masa_getir.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:garsonapp/sabitler/divider.dart';
import 'dart:async';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';

// Timer'ı sınıfın dışında tanımlayın ki dispose işlevi içinde kullanabilelim
late Timer _timer;

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  Map<int, bool> tableStatusMapEski = {};

  final List<String> myList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "40",
  ];
  // Rastgele eleman sayısı belirleme

  Map<int, bool> myMap = {};

  Map<int, bool> tableStatusMap = {};

  Map<int, String> my2Map = {
    0: "Sipariş Hazır",
    1: "Sipariş Hazır",
    2: "Sipariş İptal",
    3: "Sipariş Beklemede",
    4: "Sipariş Hazır",
    5: "Sipariş Hazır",
    6: "Sipariş Hazır",
    7: "Sipariş İptal",
    8: "Sipariş Beklemede",
    9: "Sipariş Hazır",

    // Diğer anahtar-değer çiftleri buraya eklenir...
  };

  Map<String, Color> statusColors = {
    "Sipariş Hazır": siparisHazir,
    "Sipariş İptal": siparisIptal,
    "Sipariş Beklemede": siparisBeklemede,
  };

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    // Timer durdurulmalı, aksi halde hafızada sızıntı olabilir
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const Duration refreshDuration = Duration(seconds: 3);
    _timer = Timer.periodic(refreshDuration, (timer) {
      //Apiler
      fetchTableData(); // Ekrana bilgileri basan api
      fetchTableDataSetStateKontrol(); // Değişiklik tespit etmek için kullanılan api
    });
  }

  Future<List<TableData>> fetchTableData() async {
    final response = await http.get(Uri.parse(apiUrlMasaGetir));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<TableData> tableDataList =
          data.map((item) => TableData.fromJson(item)).toList();
      return tableDataList;
    } else {
      throw Exception(' Hata => Fonksiyon : fetchTableData');
    }
  }

  Future<void> fetchTableDataSetStateKontrol() async {
    final response = await http.get(Uri.parse(apiUrlMasaGetir));
    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);
      Map<int, bool> tempMap = {};
      for (var data in responseData) {
        tempMap[data['tableNumber']] = data['status'];
      }
      if (!mapsEqual(tableStatusMapEski, tempMap)) {
        debugPrint(
            "eski : $tableStatusMapEski"); //Hata kontrolü için konsola basma işlemi
        debugPrint("yeni : $tempMap"); //Hata kontrolü için konsola basma işlemi

        tableStatusMapEski = tempMap;
        setState(() {});
      }
    } else {
      throw Exception(' Hata => Fonksiyon : fetchTableDataSetStateKontrol');
    }
  }

  // Eski veri ile yeni veriyi karşılaştırma işlemini yapan fonskiyon
  bool mapsEqual(Map<int, bool> map1, Map<int, bool> map2) {
    if (map1.length != map2.length) {
      return false;
    }
    for (var key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında giriş sayfasına yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GirisSayfasi(), // Giriş sayfası widget'ı
          ),
        );
        // Geri tuşunun işlenmesini durdur
        return false;
      },
      child: Scaffold(
        backgroundColor: arkaPlanRengi,
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                decoration: boxDecoreation,
                height: 40,
                width: 350,
                alignment: Alignment.center,
                child: Text(
                  "MASALAR",
                  style: baslikTextStyle,
                ),
              ),
              //------------------------------------------------------------------------------------
              Container(
                width: 350,
                height: 280,
                child: FutureBuilder<List<TableData>>(
                  future: fetchTableData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<TableData>? tableData = snapshot.data;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, // 5 öğe yatayda sıralanacak
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: tableData!.length,
                        itemBuilder: (context, index) {
                          Color containerColor = tableData[index].status
                              ? doluMasaRengi
                              : bosMasaRengi;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuPage(
                                      masaNumber: tableData[index].tableNumber),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: containerColor,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${tableData[index].tableNumber}',
                                style: TextStyle(
                                    color: siyahYaziRengi,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              //------------------------------------------------------------------------------------
              CustomDivider(),
              Container(
                decoration: boxDecoreation,
                height: 40,
                width: 350,
                alignment: Alignment.center,
                child: Text(
                  "SİPARİŞLER",
                  style: baslikTextStyle,
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                width: 350,
                height: 400,
                child: ListView.builder(
                  itemCount: my2Map.length,
                  itemBuilder: (BuildContext context, int index) {
                    int key = my2Map.keys.elementAt(index);
                    String value = my2Map.values.elementAt(index);
                    return Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 50,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: statusColors[my2Map.values.elementAt(index)] ??
                            Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: boxDecoreation,
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            width: 80,
                            height: 30,
                            child: Text(
                              'Masa: $key',
                              style: containerTextStyle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: boxDecoreation,
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            width: 150,
                            height: 30,
                            child: Text(
                              value,
                              style: containerTextStyle,
                            ),
                          ),
                          const SizedBox(width: 35),
                          Container(
                            height: 50,
                            width: 50,
                            child: IconButton(
                                onPressed: () {
                                  // Butona basıldığında yapılacak işlemler buraya yazılır
                                  setState(() {
                                    my2Map.remove(key);
                                  });
                                },
                                icon: const Icon(Icons.clear), // Çarpı ikonu
                                iconSize: 30, // İkon boyutu
                                color: ikonRengi // İkon rengi
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}
