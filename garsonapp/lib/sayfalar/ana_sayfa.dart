import 'dart:math';

import 'package:flutter/material.dart';
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

  // Veri havuzundan myMap'i dolduran bir fonksiyon
  void fillMyMapFromDataSource() {
    // Burada, gerçek veri kaynağından verileri alarak myMap'i doldurmalısınız
    // Örnek olarak rastgele değerler ekleyelim
    final random = Random();
    for (int i = 0; i < myList.length; i++) {
      myMap[i] =
          random.nextBool(); // Rastgele true veya false değerler ekleniyor
    }
  }

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

  int startIndex = 0;

  @override
  void initState() {
    super.initState();
    // Timer'ı başlat
    _startTimer();
  }

  @override
  void dispose() {
    // Timer durdurulmalı, aksi halde hafızada sızıntı olabilir
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const Duration refreshDuration = Duration(seconds: 5);
    _timer = Timer.periodic(refreshDuration, (timer) {
      // setState çağrarak sayfayı güncelle
      setState(() {
        fillMyMapFromDataSource();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: arkaPlanRengi,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: beyazContainerRengi),
              height: 40,
              width: 350,
              alignment: Alignment.center,
              child: Text(
                "MASALAR",
                style: baslikTextStyle,
              ),
            ),
            Container(
              width: 350,
              height: 280,
              child: ListView.builder(
                itemCount: (myMap.length / 5).ceil(), // Satır sayısı
                itemBuilder: (BuildContext context, int rowIndex) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (int columnIndex) {
                        final index = rowIndex * 5 + columnIndex;
                        final mapValue = myMap[index];
                        if (index < myMap.length) {
                          return GestureDetector(
                            onTap: () {
                              // Container tıklandığında yapılacak işlemler
                              // print(index + 1 + );
                              print(
                                  'Key: ${myMap.keys.elementAt(index)}, Value: ${mapValue != null ? (mapValue ? 'true' : 'false') : 'null'}');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: mapValue != null && mapValue
                                    ? doluMasaRengi
                                    : bosMasaRengi,
                              ),
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: Text(
                                (myMap.keys.elementAt(index))
                                    .toString(), // Sayıları ekrana yazdırıyoruz
                                style: baslikTextStyle,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: 60,
                            width: 60,
                            margin: const EdgeInsets.all(5.0),
                          ); // Eksik elemanlar için boş Container
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Divider(
              // Düz yatay çizgi
              color: dividerRengi, // Çizgi rengi
              thickness: 2, // Çizgi kalınlığı
              height: 20, // Çizgi yüksekliği
              indent: 20, // Çizginin başlangıç boşluğu
              endIndent: 20, // Çizginin bitiş boşluğu
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: beyazContainerRengi),
              //color: Colors.amber,
              height: 40,
              width: 350,
              alignment: Alignment.center,
              child: Text(
                "SİPARİŞLER",
                style: baslikTextStyle,
              ),
            ),
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
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: statusColors[my2Map.values.elementAt(index)] ??
                          Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: beyazContainerRengi,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: 80,
                          height: 30,
                          child: Text(
                            'Masa: $key',
                            style: containerTextStyle,
                          ),
                        ),
                        const SizedBox(width: 5), //85
                        Container(
                          decoration: BoxDecoration(
                            color: beyazContainerRengi,
                            //border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: 150,
                          height: 30,
                          child: Text(
                            '$value',
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
          ],
        ),
      ),
    );
  }
}
