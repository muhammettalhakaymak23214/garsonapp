import 'package:flutter/material.dart';
import 'package:garsonapp/sabitler/boxDecoreation.dart';
import 'package:garsonapp/sabitler/renkler.dart';
import 'package:garsonapp/sabitler/text_style.dart';

class SiparisSayfasi extends StatefulWidget {
  const SiparisSayfasi({super.key});

  @override
  State<SiparisSayfasi> createState() => _SiparisSayfasiState();
}

class _SiparisSayfasiState extends State<SiparisSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arkaPlanRengi,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: boxDecoreation,
              height: 40,
              width: 350,
              alignment: Alignment.center,
              child: Text(
                "MASA: 10",
                style: baslikTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
