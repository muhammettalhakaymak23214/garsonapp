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
import 'package:shared_preferences/shared_preferences.dart';

// Timer'ı sınıfın dışında tanımlayın ki dispose işlevi içinde kullanabilelim
late Timer _timer;

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  Map<int, String> tableStatusMapEski = {};

  String secilenIp = "";
  String apiUrl = "";
  String apiUrlMasaGetir = "";
  String apiUrlMenuGetir = "";
  String apiUrlSiparisGetir = "";
  String apiUrlSiparisSil = "";

  List<Map<String, dynamic>> orders = [];

  Map<int, String> myMap = {};

  Map<int, String> tableStatusMap = {};

  Map<int, List<String>> my2Map = {
    /*
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
    */

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
    _getirSecilenIp();
    //fetchOrders(); //sipariş durum apisi

    _startTimer();
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
    apiUrlSiparisGetir = 'http://192.168.1.${secilenIp}:8080/getOrdersByStatus';
    apiUrlSiparisSil = 'http://192.168.1.${secilenIp}:8080/dontShowOrder';
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
      //fetchTableData(); // Ekrana bilgileri basan api
      fetchTableDataSetStateKontrol();
      //fetchOrders();
      fetchOrdersDegisiklikTespitApisi(); // Değişiklik tespit etmek için kullanılan api
    });
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse(
        apiUrlSiparisGetir)); // apiUrl değişkenini kullanarak API'ye istek gönderin

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      // Gelen verileri my2Map içine ekleyin
      for (var data in responseData) {
        int tableNumber = data['tableNumber'];
        int orderId = data['orderId'];
        String status = data['status'].toString();
        String tableNumberString = tableNumber.toString();

        my2Map[orderId] = [tableNumberString, status];
        // my2Map[tableNumber] = status;
/*
         my2Map[tableNumber] = {
        'status': status,
        'orderId': orderId,
      };*/
      }
      debugPrint("**********************************************************");
      debugPrint(my2Map.toString());
      debugPrint("**********************************************************");

      // setState çağırarak arayüzü yenileyin
      setState(() {});
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> fetchOrdersDegisiklikTespitApisi() async {
    final response = await http.get(Uri.parse(
        apiUrlSiparisGetir)); // apiUrl değişkenini kullanarak API'ye istek gönderin

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      Map<int, List<String>> my2MapTemp = {};
      // Gelen verileri my2Map içine ekleyin
      for (var data in responseData) {
        int tableNumber = data['tableNumber'];
        int orderId = data['orderId'];
        String status = data['status'].toString();
        String tableNumberString = tableNumber.toString();

        my2MapTemp[orderId] = [tableNumberString, status];
        // my2Map[tableNumber] = status;
/*
         my2Map[tableNumber] = {
        'status': status,
        'orderId': orderId,
      };*/
      }
      if (!mapsEqual2(my2Map, my2MapTemp)) {
        debugPrint("eski : $my2Map");
        debugPrint("yeni : $my2MapTemp");
        my2Map = my2MapTemp;
        debugPrint(
            "**********************************************************");
        debugPrint(my2Map.toString());
        debugPrint(
            "**********************************************************");
        setState(() {});
      }

      // setState çağırarak arayüzü yenileyin
      //setState(() {});
    } else {
      throw Exception('Failed to load orders');
    }
  }

  //<--                                                           -->
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
      Map<int, String> tempMap =
          {}; // tempMap değişkenini Map<int, String> olarak tanımla
      for (var data in responseData) {
        tempMap[data['tableNumber']] =
            data['status']; // status alanını String olarak al
      }
      if (!mapsEqual(tableStatusMapEski, tempMap)) {
        debugPrint("eski : $tableStatusMapEski");
        debugPrint("yeni : $tempMap");
        tableStatusMapEski = tempMap;
        setState(() {});
      }
    } else {
      throw Exception('Hata => Fonksiyon : fetchTableDataSetStateKontrol');
    }
  }

  Future<void> _postDataSil(String silinecekId) async {
    final url = Uri.parse(apiUrlSiparisSil);
    debugPrint("------------565656---------------------------");

    final response = await http.post(
      url,
      body: {
        'orderId': silinecekId,
      },
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // Başarılı bir şekilde gönderildi.

      print('oldu oldu oldu oldu oldu.');
    } else {
      // İstekte bir hata oluştu.
      print('Post isteğinde hata oluştu: ${response.statusCode}');
    }
  }

  // Eski veri ile yeni veriyi karşılaştırma işlemini yapan fonskiyon
  bool mapsEqual(Map<int, String> map1, Map<int, String> map2) {
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

  bool mapsEqual2(Map<int, List<String>?> map1, Map<int, List<String>?> map2) {
    if (map1.length != map2.length) {
      return false;
    }
    for (var key in map1.keys) {
      if (!map2.containsKey(key) || !listsEqual(map1[key], map2[key])) {
        return false;
      }
    }
    return true;
  }

  bool listsEqual(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) {
      return true;
    }
    if (list1 == null || list2 == null || list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
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
                          Color containerColor =
                              (tableData[index].status == "DOLU")
                                  ? doluMasaRengi
                                  : bosMasaRengi;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuPage(
                                      masaNumber: tableData[index].tableNumber,
                                      masaId: tableData[index].id),
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
              Container(
                height: 400,
                //padding: EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: my2Map.length,
                  itemBuilder: (context, index) {
                    var key = my2Map.keys.elementAt(index);
                    var value = my2Map[key];
                    if (value?[1] == "gosterme") {
                      return SizedBox
                          .shrink(); // Boş bir widget döndürerek hiçbir şey göstermeyeceğiz
                    }
                    return Container(
                      //  margin: EdgeInsets.symmetric(vertical: 8.0),
                      //padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Container $key',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'OrderId: $key',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Table Number: ${value?[0]}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Status: ${value?[1]}',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                              onPressed: () {
                                _postDataSil(key.toString());
                              },
                              child: Text(
                                "Bİr daha gösterme",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    );
                  },
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              /*
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
              */
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}
