import 'package:garsonapp/models/circularProgressIndicator.dart';
import 'package:garsonapp/models/snack_bar.dart';
import 'package:garsonapp/sabitler/api_url.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class GirisYap {
  static Future<void> login(
    BuildContext context,
    TextEditingController controller,
    TextEditingController controller2,
  ) async {
    /*
    if(){

    }
    else{

    }
    */
    final String userId = controller.text;
    final String password = controller2.text;
    try {
      // Burada işlem başlamadan önce bir bekleme göstergesi gösterilebilir
      showDialog(
        context: context,
        barrierDismissible: false, // Kullanıcının dışarı tıklamasını engelle
        builder: (BuildContext context) {
          return Center(
              child: MyCircularProgressContainer(
            size: 150, // Genişlik ve yükseklik
            color: circularProgressIndicatorRengi, // Renk
            strokeWidth: 15, // Çizgi kalınlığı
          ) // Dairesel ilerleme göstergesi
              );
        },
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'userId': userId, 'password': password},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Başarılı giriş durumunda
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AnaSayfa(),
          ),
        );
      } else if (response.statusCode == 401) {
        // Hatalı giriş durumunda
        Navigator.pop(context); // Bekleme göstergesini kaldır
        snackBarGoruntule(
            context, "Hatalı kullancı adı veya parola !", status401);
      } else {
        // Sunucuya bağlanılamadı durumunda
        Navigator.pop(context); // Bekleme göstergesini kaldır
        snackBarGoruntule(
            context, "Bilinmeyen bir hata meydana geldi !", statusUnknownError);
      }
    } catch (e) {
      Navigator.pop(context); // Bekleme göstergesini kaldır
      snackBarGoruntule(
          context, "Zaman aşımı: Sunucuya bağlanılamadı !", statusTimeOut);
    }
  }
/*
  void saveData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
*/
}
