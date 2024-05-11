import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';
import 'package:garsonapp/sayfalar/sepet_sayfasi.dart';
import 'package:http/http.dart' as http;
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart'; //

class MenuPage extends StatefulWidget {
  final int masaNumber;
  final int masaId;

  MenuPage({required this.masaNumber, required this.masaId});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  double _keyboardHeight = 313;
  bool _isLoading = true;
  String secilenIp = "";
  String apiUrlMenuGetir = "";
  late Future<List<Map<String, dynamic>>> _menuData;
  TextEditingController textEditingControllerSiparisNotu =
      TextEditingController();
  String savedTextSiparisNotu = '';
  String siparisNotuKaydedildimi = '';

  List<String> bosStringListesi = [];

//sepet sayfasına gidecek örnek veri
  Map<String, List<double>> yemekMap = {};
  bool sesDurumu = true;
  bool titresimDurumu = true;

  // double adet = 0;
//-------------------------

  @override
  void initState() {
    _getirSecilenIp();
    super.initState();
    //_menuData = fetchData();
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
    ! Ip Adresi Telefondan Getiriliyor. <-------Başladı-------
  */
  Future<void> _getirSecilenIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secilenIp = prefs.getString('secilenIp') ?? "192.168.1.100";
    apiUrlMenuGetir = 'http://${secilenIp}:8080/categories';
    _menuData = fetchData();
  }
  /*  
    ! Ip Adresi Telefondan Getiriliyor. -------Bitti------->
  */

  /*  
    ! Sipariş Notunu Kaydet. <-------Başladı-------
  */
  void _saveText() {
    setState(() {
      savedTextSiparisNotu = textEditingControllerSiparisNotu.text;
      textEditingControllerSiparisNotu.text = "";
      siparisNotuKaydedildimi = "Sipariş Notu Kaydedildi.";
    });
  }
  /*  
    ! Sipariş Notunu Kaydet. -------Bitti------->
  */

  /*  
    ? Apiler. <-------Başladı-------
  */

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

  /*  
    ? Apiler. -------Bitti------->
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
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: yesilButonRengi,
          mini: true,
          onPressed: () {
            sesCal();
            bool anyNonZeroQuantity =
                yemekMap.values.any((value) => value[1] > 0);
            if (anyNonZeroQuantity) {
              /*  
    TODO: Not Ekleme Alerti. <-------Başladı-------
  */
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Color.fromARGB(255, 0, 0, 0).withOpacity(0.80),
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: alertArkaPlanRengi, // Arka plan rengi gri
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side:
                          BorderSide(color: Colors.black), // Border rengi siyah
                    ),
                    title: Text(
                      "Not Ekleme Ekranı",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: (ekranYuksekligi / 100) * 2.5),
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
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Sipariş notu giriniz.',
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: (ekranYuksekligi / 100) * 2.0),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              sesCal();
                              _saveText();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => SepetSayfasi(
                                    masaNumber: widget.masaNumber,
                                    gelenMap: yemekMap,
                                    masaId: widget.masaId,
                                    siparisNotu: savedTextSiparisNotu,
                                  ),
                                ),
                                (Route<dynamic> route) => false,
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
                              child: Text(
                                "Sepet Sayfasına Git",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: (ekranYuksekligi / 100) * 2.0,
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
              /*  
    TODO: Not Ekleme Alerti. -------Bitti------->
  */
            } else {
              // Hiçbir üründen seçim yapılmamış, uyarı gösterilebilir veya başka bir işlem yapılabilir.
              /*  
    TODO: Uyarı En Az Bir Ürün Seç Alerti. <-------Başladı-------
  */
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color.fromARGB(
                        255, 255, 17, 0), // Arka plan rengi kırmızı
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side:
                          BorderSide(color: Colors.black), // Border rengi siyah
                    ),
                    title: Text(
                      "Uyarı",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: (ekranYuksekligi / 100) * 2.5),
                    ),
                    content: Text(
                      "Sepete eklemek için en az bir ürün seçmelisiniz.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: (ekranYuksekligi / 100) * 2.0),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          sesCal();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Tamam",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: (ekranYuksekligi / 100) * 2.0),
                        ),
                      ),
                    ],
                  );
                },
              );
              /*  
    TODO: Uyarı En Az Bir Ürün Seç Alerti. -------Bitti------->
  */
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
                    SizedBox(
                      height: ekranUstBosluk,
                    ),
                    //Masa bilgisi(başlık)
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
                    //Boşluk
                    SizedBox(
                      height: (ekranYuksekligi / 100) * 2,
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
                            height: (ekranYuksekligi / 100) * 87,
                            width: ekranGenisligi,
                            //color: Colors.pink,
                            color: arkaPlanRengi,
                            //padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: menuData.map<Widget>((category) {
                                  return Container(
                                    //  width: (ekranGenisligi / 100) * 20,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: (ekranGenisligi / 100) * 5,
                                        vertical: (ekranYuksekligi / 100) * 2),
                                    //padding: const EdgeInsets.all(10),
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
                                          SizedBox(
                                            height: (ekranYuksekligi / 100) * 2,
                                          ),
                                          Text(
                                            category['name'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  (ekranYuksekligi / 100) * 2.5,
                                            ),
                                          ),
                                          SizedBox(
                                            height: (ekranYuksekligi / 100) * 2,
                                          ),
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
                                                    height: (ekranYuksekligi /
                                                            100) *
                                                        10,
                                                    width:
                                                        (ekranGenisligi / 100) *
                                                            84,
                                                    /*
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                            */
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: const Color
                                                          .fromARGB(255, 53, 49,
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
                                                          width:
                                                              (ekranGenisligi /
                                                                      100) *
                                                                  60,
                                                          height:
                                                              (ekranYuksekligi /
                                                                      100) *
                                                                  10,

                                                          // color: Colors.amber,
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
                                                                  height: (ekranYuksekligi /
                                                                          100) *
                                                                      4,
                                                                  width: (ekranGenisligi /
                                                                          100) *
                                                                      55,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    vertical:
                                                                        (ekranYuksekligi /
                                                                                100) *
                                                                            0.5,
                                                                  ),
                                                                  child: Text(
                                                                    utf8.decode(
                                                                      menu['name']
                                                                          .runes
                                                                          .toList(),
                                                                    ),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            (ekranYuksekligi / 100) *
                                                                                1.5,
                                                                        color: Colors
                                                                            .black),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )),
                                                              Container(
                                                                height:
                                                                    (ekranYuksekligi /
                                                                            100) *
                                                                        4,
                                                                width:
                                                                    (ekranGenisligi /
                                                                            100) *
                                                                        55,
                                                                /* color:
                                                                    Colors.pink,*/
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                  vertical:
                                                                      (ekranYuksekligi /
                                                                              100) *
                                                                          0.5,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .white,
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        height:
                                                                            (ekranYuksekligi / 100) *
                                                                                4,
                                                                        width: (ekranGenisligi /
                                                                                100) *
                                                                            25,
                                                                        child:
                                                                            Text(
                                                                          "${menu['price'].toString()} TL",
                                                                          style: TextStyle(
                                                                              fontSize: (ekranYuksekligi / 100) * 1.5,
                                                                              color: Colors.black),
                                                                        )),
                                                                    SizedBox(
                                                                      width:
                                                                          (ekranGenisligi / 100) *
                                                                              5,
                                                                    ),
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .white,
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        height:
                                                                            (ekranYuksekligi / 100) *
                                                                                4,
                                                                        width: (ekranGenisligi /
                                                                                100) *
                                                                            25,
                                                                        child:
                                                                            Text(
                                                                          "${adet.toInt().toString()} Adet",
                                                                          style: TextStyle(
                                                                              fontSize: (ekranYuksekligi / 100) * 1.5,
                                                                              color: Colors.black),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              (ekranGenisligi /
                                                                      100) *
                                                                  12,
                                                        ),
                                                        Container(
                                                          //color: Colors.blue,
                                                          height:
                                                              (ekranYuksekligi /
                                                                      100) *
                                                                  10,
                                                          width:
                                                              (ekranGenisligi /
                                                                      100) *
                                                                  10,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height:
                                                                    (ekranYuksekligi /
                                                                            100) *
                                                                        5,
                                                                width:
                                                                    (ekranYuksekligi /
                                                                            100) *
                                                                        5,
                                                                child:
                                                                    IconButton(
                                                                  iconSize:
                                                                      (ekranYuksekligi /
                                                                              100) *
                                                                          2.5,
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
                                                                    sesCal();
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
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height:
                                                                    (ekranYuksekligi /
                                                                            100) *
                                                                        5,
                                                                width:
                                                                    (ekranYuksekligi /
                                                                            100) *
                                                                        5,
                                                                child:
                                                                    IconButton(
                                                                  iconSize:
                                                                      (ekranYuksekligi /
                                                                              100) *
                                                                          2.5,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  onPressed:
                                                                      () {
                                                                    sesCal();
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
                          return const Center(
                              child: Text('DATA YOK - DATA YOK'));
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