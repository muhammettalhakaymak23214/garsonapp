import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/api_url.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:http/http.dart' as http;

class MenuPage extends StatefulWidget {
  final int masaNumber;

  MenuPage({required this.masaNumber});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<Map<String, dynamic>>> _menuData;

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
          'isCategory': true
        });
        for (var menu in category['menus']) {
          menuData.add({
            'name': utf8.decode(menu['name'].runes.toList()),
            'price': menu['price'],
            'isCategory': false,
          });
        }
      }
      return menuData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 40,
              width: 350,
              alignment: Alignment.center,
              decoration: boxDecoreation,
              child: Text(
                widget.masaNumber.toString(),
                style: TextStyle(color: Colors.amber),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _menuData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> menuData = snapshot.data!;
                  return Container(
                    height: 400,
                    child: ListView.builder(
                      itemCount: menuData.length,
                      itemBuilder: (context, index) {
                        final item = menuData[index];
                        if (item['isCategory']) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            color: Colors.grey[300],
                            child: Text(
                              item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          );
                        } else {
                          return ListTile(
                            title: Text(item['name']),
                            subtitle: Text('Fiyat: ${item['price']}'),
                          );
                        }
                      },
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
