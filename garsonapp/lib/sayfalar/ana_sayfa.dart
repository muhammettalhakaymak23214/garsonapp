import 'package:flutter/material.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  Map<int, bool> myMap = {
    0: true,
    1: true,
    2: false,
    3: false,
    4: false,
    5: true,
    6: false,
    7: true,
    8: true,
    9: true,
    10: true,
    11: true,
    12: false,
    13: true,
    14: false,
    15: false,
    16: false,
    17: false,
    18: true,
    19: true,
    20: false,
    // Diğer anahtar-değer çiftleri buraya eklenir...
  };

  int startIndex = 0;

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                      style: TextStyle(fontSize: 20),
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
                                ),
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
                      style: TextStyle(fontSize: 20),
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