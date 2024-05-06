/*String apiUrl = 'http://192.168.1.116:8080/login';
String apiUrlMasaGetir = 'http://192.168.1.116:8080/tables';
String apiUrlMenuGetir = 'http://192.168.1.116:8080/categories';*/

import 'package:shared_preferences/shared_preferences.dart';

class StringBirlestirici {
  String apiUrl = 'http://192.168.1.116:8080/login';
  String apiUrlMasaGetir = 'http://192.168.1.116:8080/tables';
  String apiUrlMenuGetir = 'http://192.168.1.116:8080/categories';
  String secilenIp = "";

  //StringBirlestirici(this.string1, this.string2, this.string3);

  void birlestir() {
    Future<void> _getirSecilenIp() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      secilenIp = prefs.getString('secilenIp') ?? "100";
    }

    apiUrl = "http://192.168.1.${secilenIp}:8080/login";
    apiUrlMasaGetir = 'http://192.168.1.${secilenIp}:8080/tables';
    apiUrlMenuGetir = 'http://192.168.1.${secilenIp}:8080/categories';
  }
}
