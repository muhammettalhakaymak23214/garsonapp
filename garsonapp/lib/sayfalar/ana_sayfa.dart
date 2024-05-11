import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:garsonapp/bildirim/flutter_local_notification.dart';
import 'package:garsonapp/sayfalar/giris_sayfasi.dart';
import 'package:garsonapp/sayfalar/siparis_sayfasi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:garsonapp/apiler/masa_getir.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'dart:async';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart'; //

late Timer _timer;

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  Map<int, String> tableStatusMapEski = {};
  String secilenIp = "";

  String apiUrlMasaGetir = "";
  String apiUrlMenuGetir = "";
  String apiUrlSiparisGetir = "";
  String apiUrlSiparisSil = "";
  List<Map<String, dynamic>> orders = [];
  Map<int, String> myMap = {};
  Map<int, String> tableStatusMap = {};
  Map<int, List<String>> my2Map =
      {}; //Galiba sipariş mapiibool sesDurumu = true;
  bool sesDurumu = true;
  bool titresimDurumu = true;
  int bildirimSinirlama = 0;

  @override
  void initState() {
    super.initState();
    _getirSecilenIp();
    _startTimer();
  }

  void sesCal() {
    if (sesDurumu == true) {
      final player = AudioPlayer();
      player.play(AssetSource('pokemon-a-button.wav'));
      titresimCal();
    }
  }

  void titresimCal() async {
    // Telefonun titreşim özelliğinin bulunup bulunmadığını kontrol et
    bool? hasVibrator = await Vibration.hasVibrator();

    // hasVibrator değeri null değilse ve true ise, titreşimi başlat
    if ((hasVibrator == true) && (titresimDurumu == true)) {
      Vibration.vibrate(duration: 75);
    }
  }

  /* 
    ! Dispose ve Start Timer. <-------Başladı-------
  */

  @override
  void dispose() {
    // Timer durdurulmalı, aksi halde hafızada sızıntı olabilir
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const Duration refreshDuration = Duration(seconds: 1);
    _timer = Timer.periodic(refreshDuration, (timer) {
      fetchTableDataSetStateKontrol(); // Masalarda değişiklik tespit etmek için kullanılan api
      fetchOrdersDegisiklikTespitApisi(); //Siparişlerde değişiklik tespit etmek için kullanılan api
    });
  }

  /* 
    ! Dispose ve Start Timer. -------Bitti------->
  */

  /*  
    ! Kullanıcı Adı , Şifre Telefona Kaydediliyor. <-------Başladı-------
  */

  Future<void> _kaydetKullaniciAdi(String kullaniciAdi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kullaniciAdi', kullaniciAdi);
    kullaniciAdi = prefs.getString('kullaniciAdi') ?? "";
  }

  Future<void> _kaydetParola(String parola) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('parola', parola);
    parola = prefs.getString('parola') ?? "";
  }

  /*  
    ! Kullanıcı Adı , Şifre Telefona Kaydediliyor. -------Bitti------->
  */

  /*  
    ! Ip Adresi Telefondan Getiriliyor. <-------Başladı-------
  */

  Future<void> _getirSecilenIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secilenIp = prefs.getString('secilenIp') ?? "192.168.1.100";

    apiUrlMasaGetir = 'http://${secilenIp}:8080/tables';
    apiUrlSiparisGetir = 'http://${secilenIp}:8080/getOrdersByStatus';
    apiUrlSiparisSil = 'http://${secilenIp}:8080/dontShowOrder';
  }

  /*  
    ! Ip Adresi Telefondan Getiriliyor. -------Bitti------->
  */

  /*  
    ? Apiler. <-------Başladı-------
  */

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
      }
      debugPrint("**********************************************************");
      debugPrint(my2Map.toString());
      debugPrint("**********************************************************");
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

        if (bildirimSinirlama == 1) {
          NotificationHelper.showNotification(
            id: 0,
            title: 'Sipariş Durumunda Güncelleme',
            body: '',
            payload: 'ekstra veri',
          );
        }
        bildirimSinirlama = 1;

        setState(() {});
      }
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
      print('API : PostDataSil Apisi başarılı bir şekilde gönderildi.');
    } else {
      // İstekte bir hata oluştu.
      print(
          'API : PostDataSil Api isteğinde hata oluştu: ${response.statusCode}');
    }
  }

  // Eski veri ile yeni veriyi karşılaştırma işlemini yapan fonskiyon Table için
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

  // Eski veri ile yeni veriyi karşılaştırma işlemini yapan fonskiyon Siparişler için
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

  /*  
    ? Apiler. -------Bitti------->
  */

  /*  
    TODO: Oturumdan Çıkma ve Uygulamayı Kapatma Alerti. <-------Başladı-------
  */

  //Burada Oturumdan çıkma ve uygulamayı kapatma alerti var.
  Future<void> _oturumuKapatYadaCik(BuildContext context,
      double ekranYuksekligi, double ekranGenisligi) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.80),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(
                  color: const Color.fromARGB(255, 0, 0, 0), width: 2.0),
            ),
            backgroundColor: alertArkaPlanRengi,
            title: Text(
              'Oturumu Kapat veya Uygulamadan Çık',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: (ekranYuksekligi / 100) * 2.5),
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Divider(color: Colors.white),
                  SizedBox(height: (ekranYuksekligi / 100) * 2.0),
                  GestureDetector(
                    onTap: () {
                      sesCal();
                      _kaydetKullaniciAdi("");
                      _kaydetParola("");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GirisSayfasi(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: (ekranGenisligi / 100) * 40, // Genişlik değeri
                      height: (ekranYuksekligi / 100) * 6,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Oturumu Kapat",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: (ekranYuksekligi / 100) * 2.0),
                      ),
                    ),
                  ),
                  SizedBox(height: (ekranYuksekligi / 100) * 2.0),
                  GestureDetector(
                    onTap: () {
                      sesCal();
                      SystemNavigator.pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: (ekranGenisligi / 100) * 40, // Genişlik değeri
                      height: (ekranYuksekligi / 100) * 6,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Uygulamayı Kapat",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: (ekranYuksekligi / 100) * 2.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  /*  
    TODO: Oturumdan Çıkma ve Uygulamayı Kapatma Alerti. -------Bitti------->
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
        // Geri tuşuna basıldığında giriş sayfasına yönlendir
        SystemNavigator.pop();
        // Geri tuşunun işlenmesini durdur
        return true;
      },
      child: Scaffold(
        backgroundColor: arkaPlanRengi, //arkaPlanRengi
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: ekranUstBosluk,
              ),
              Container(
                //color: Colors.yellow,
                height: (ekranYuksekligi / 100) * 6,
                width: ekranGenisligi,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: ekranYatayBosluk,
                    ),
                    Container(
                      width: (ekranGenisligi / 100) * 15,
                      height: (ekranYuksekligi / 100) * 6,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5)),
                      child: IconButton(
                          onPressed: () {
                            sesCal();
                            _oturumuKapatYadaCik(
                                context, ekranYuksekligi, ekranGenisligi);
                          },
                          icon: const Icon(Icons.person),
                          iconSize: (ekranYuksekligi / 100) * 3, // İkon boyutu
                          color: Colors.black // İkon rengi
                          ),
                    ),
                    Container(
                      width: ekranYatayBosluk,
                      height: 4,
                      color: Colors.white,
                    ),
                    Container(
                      decoration: boxDecoreation,
                      height: (ekranYuksekligi / 100) * 6,
                      width: (ekranGenisligi / 100) * 50,
                      alignment: Alignment.center,
                      child: Text(
                        "MASALAR",
                        style: TextStyle(
                            fontSize: ekranYaziBoyutu,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: (ekranGenisligi / 100) * 25,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: (ekranYuksekligi / 100) * 2,
              ),

              Container(
                //color: Color.fromARGB(255, 84, 30, 233),
                width: (ekranGenisligi / 100) * 90,
                height: (ekranYuksekligi / 100) * 35,
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
                              sesCal();
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
                              height: (ekranYuksekligi / 100) * 10,
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
                                    fontSize: ekranYaziBoyutu),
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
              //CustomDivider(),
              Container(
                width: (ekranGenisligi / 100) * 90,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
              ),
              Container(
                width: 5,
                height: 10,
                color: Colors.white,
              ),
              Container(
                decoration: boxDecoreation,
                height: (ekranYuksekligi / 100) * 6,
                width: (ekranGenisligi / 100) * 50,
                alignment: Alignment.center,
                child: Text(
                  "SİPARİŞLER",
                  style: TextStyle(
                      fontSize: ekranYaziBoyutu,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: (ekranGenisligi / 100) * 2,
              ),
              Container(
                // color: const Color.fromARGB(255, 40, 30, 233),
                width: (ekranGenisligi / 100) * 90,
                height: (ekranYuksekligi / 100) * 37,
                child: ListView.builder(
                  itemCount: my2Map.length,
                  itemBuilder: (context, index) {
                    var key = my2Map.keys.elementAt(index);
                    var value = my2Map[key];
                    if (value?[1] == "gosterme" ||
                        value?[1] == "gostermeonay") {
                      return SizedBox
                          .shrink(); // Boş bir widget döndürerek hiçbir şey göstermeyeceğiz
                    }
                    return Container(
                      height: (ekranYuksekligi / 100) * 7,
                      width: (ekranGenisligi / 100) * 90,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      //padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                        color: value?[1] == 'hazirlaniyor'
                            ? statusTimeOut // Sarı
                            : (value?[1] == 'iptal'
                                ? status401 // Kırmızı
                                : (value?[1] == 'onaylandi'
                                    ? yesilButonRengi
                                    : Colors.transparent)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: (ekranGenisligi / 100) * 2,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: (ekranYuksekligi / 100) * 4,
                            width: (ekranGenisligi / 100) * 25,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              'Masa : ${value?[0]}',
                              style: TextStyle(
                                  fontSize: (ekranYaziBoyutu / 100) * 90,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: (ekranGenisligi / 100) * 2.5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: (ekranYuksekligi / 100) * 4,
                            width: (ekranGenisligi / 100) * 38,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              '${value?[1]}', //Status:
                              style: TextStyle(
                                  fontSize: (ekranYaziBoyutu / 100) * 90,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: (ekranGenisligi / 100) * 10,
                          ),
                          Container(
                            height: (ekranGenisligi / 100) * 10,
                            width: (ekranGenisligi / 100) * 10,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5)),
                            child: IconButton(
                                onPressed: () {
                                  sesCal();
                                  bildirimSinirlama = 0;
                                  _postDataSil(key.toString());
                                },
                                icon: Icon(Icons.clear),
                                iconSize:
                                    (ekranYuksekligi / 100) * 2, // İkon boyutu
                                color: Colors.black // İkon rengi
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}

// belki sonra kullanırım diye 
/*
Text(
                            'OrderId: $key',
                            style: TextStyle(color: Colors.white),
                          ),
*/

  /*
                          TextButton(
                              onPressed: () {
                                _postDataSil(key.toString());
                              },
                              child: Text(
                                "Bİr daha gösterme",
                                style: TextStyle(color: Colors.white),
                              ))*/

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