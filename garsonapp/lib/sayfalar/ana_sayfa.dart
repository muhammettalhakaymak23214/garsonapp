import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

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
    "Sipariş Hazır": Color.fromARGB(255, 0, 255, 4),
    "Sipariş İptal": const Color.fromARGB(255, 255, 17, 0),
    "Sipariş Beklemede": Colors.grey,
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
      backgroundColor: const Color.fromRGBO(51, 51, 51, 100),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /*
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 50,
                    alignment: Alignment.topLeft,
                    child: PopupMenuButton<int>(
                      icon: Icon(Icons.menu),
                      iconSize: 40,
                      //icon: Icons.menu,
                      color: Colors.white,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 1,
                          child: Text('Seçenek 1'),
                        ),
                        const PopupMenuItem(
                          value: 2,
                          child: Text('Seçenek 2'),
                        ),
                        const PopupMenuItem(
                          value: 3,
                          child: Text('Seçenek 3'),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            // Seçenek 1 seçildiğinde yapılacak işlemler
                            break;
                          case 2:
                            // Seçenek 2 seçildiğinde yapılacak işlemler
                            break;
                          case 3:
                            // Seçenek 3 seçildiğinde yapılacak işlemler
                            break;
                        }
                      },
                    ),
                  ),
                ),
                */
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 50,
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white),
                    //color: Colors.amber,
                    height: 40,
                    width: 190,
                    alignment: Alignment.center,
                    child: const Text(
                      "MASALAR",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 50,
                    )),
              ],
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
                                    ? Color.fromARGB(255, 0, 255, 4)
                                    : Color.fromARGB(255, 255, 255, 255),
                              ),
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: Text(
                                (myMap.keys.elementAt(index))
                                    .toString(), // Sayıları ekrana yazdırıyoruz
                                style: const TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
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
            const Divider(
              // Düz yatay çizgi
              color: Colors.white, // Çizgi rengi
              thickness: 2, // Çizgi kalınlığı
              height: 20, // Çizgi yüksekliği
              indent: 20, // Çizginin başlangıç boşluğu
              endIndent: 20, // Çizginin bitiş boşluğu
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 50,
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white),
                    //color: Colors.amber,
                    height: 40,
                    width: 190,
                    alignment: Alignment.center,
                    child: const Text(
                      "SİPARİŞLER",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 50,
                    )),
              ],
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
                    //  padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      //  color: Colors.green,
                      color: statusColors[my2Map.values.elementAt(index)] ??
                          Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: 80,
                          height: 30,
                          child: Text(
                            'Masa: $key',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 5), //85
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: 150,
                          height: 30,
                          child: Text(
                            '$value',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 35),
                        Container(
                          // color: Colors.black,
                          height: 50,
                          width: 50,
                          //alignment:
                          child: IconButton(
                            onPressed: () {
                              // Butona basıldığında yapılacak işlemler buraya yazılır
                              setState(() {
                                my2Map.remove(key);
                              });
                            },
                            icon: Icon(Icons.clear), // Çarpı ikonu
                            iconSize: 30, // İkon boyutu

                            color: const Color.fromARGB(
                                255, 255, 255, 255), // İkon rengi
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            //),
          ],
        ),
      ),
    );
  }
}
/*
------------------------------------
Ekran genişliği : 411.42857142857144
------------------------------------
Container(
                  padding: const EdgeInsets.all(0),
                  width: 250,
                  height: 310,
                  // color: Colors.amber,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: (myList.length / 4).ceil(), // Satır sayısı
                    itemBuilder: (BuildContext context, int rowIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          4,
                          (int columnIndex) {
                            final index = rowIndex * 4 + columnIndex;
                            if (index < myList.length) {
                              return GestureDetector(
                                onTap: () {
                                  // Container tıklandığında yapılacak işlemler
                                  print(index + 1);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),

                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.all(5.0),
                                  //  padding: const EdgeInsets.all(20.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    myList[index],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.all(5.0),
                              ); // Eksik elemanlar için boş Container
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                */

                /*

                Container(
                  padding: const EdgeInsets.all(0),
                  width: 250,
                  height: 310,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: ((myList.length - startIndex) / 4).ceil(),
                    itemBuilder: (BuildContext context, int rowIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (int columnIndex) {
                            final index =
                                rowIndex * 4 + columnIndex + startIndex;
                            if (index < myList.length) {
                              return GestureDetector(
                                onTap: () {
                                  print(myList[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    myList[index],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.all(5.0),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                */

                /*

                mylist kullanılarak yapılan son yapı daha sonra mymap'e geçtim
                 Container(
              width: 350,
              height: 280,
              //color: Colors.amber,
              //alignment: Alignment.topCenter,
              child: ListView.builder(
                itemCount: (myList.length / 5).ceil(), // Satır sayısı
                itemBuilder: (BuildContext context, int rowIndex) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      5,
                      (int columnIndex) {
                        final index = rowIndex * 5 + columnIndex;
                        if (index < myList.length) {
                          return GestureDetector(
                            onTap: () {
                              // Container tıklandığında yapılacak işlemler
                              print(index + 1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),

                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.all(10.0),
                              //  padding: const EdgeInsets.all(20.0),
                              alignment: Alignment.center,
                              child: Text(
                                myList[index],
                                style: const TextStyle(
                                    color: Color.fromRGBO(51, 51, 51, 100),
                                    fontSize: 20),
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
            */


            /*

/*
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
  ];
  */

            */

            /*
//---------------
            Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white),
              //color: Colors.amber,
              height: 40,
              width: 150,
              alignment: Alignment.center,
              child: const Text(
                "Siparişler",
                style: TextStyle(),
              ),
            ),


            */