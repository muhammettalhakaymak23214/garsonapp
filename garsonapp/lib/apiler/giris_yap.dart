import 'package:garsonapp/models/snack_bar.dart';
import 'package:garsonapp/sabitler/api_url.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sayfalar/ana_sayfa.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class GirisYap {
  static Future<void> login(
    BuildContext context,
    TextEditingController controller,
    TextEditingController controller2,
  ) async {
    final String userId = controller.text;
    final String password = controller2.text;
    try {
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
        snackBarGoruntule(
            context, "Hatalı kullancı adı veya parola !", status401);
      } else {
        // Sunucuya bağlanılamadı durumunda
        snackBarGoruntule(
            context, "Bilinmeyen bir hata meydana geldi !", statusUnknownError);
      }
    } catch (e) {
      snackBarGoruntule(
          context, "Zaman aşımı: Sunucuya bağlanılamadı !", statusTimeOut);
    }
  }
}
