import 'package:flutter/material.dart';

import '../sabitler/renkler.dart';

void snackBarGoruntule(
    BuildContext context, String mesaj, Color arkaPlanRengi) {
  final snackBar = SnackBar(
    content: Text(
      mesaj,
      style: const TextStyle(
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    ),
    backgroundColor: arkaPlanRengi,
    padding: EdgeInsets.all(0),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
