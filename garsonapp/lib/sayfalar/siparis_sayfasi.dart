import 'package:flutter/material.dart';

class SiparisSayfasi extends StatefulWidget {
  const SiparisSayfasi({super.key});

  @override
  State<SiparisSayfasi> createState() => _SiparisSayfasiState();
}

class _SiparisSayfasiState extends State<SiparisSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(51, 51, 51, 100),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white),
              height: 40,
              width: 350,
              alignment: Alignment.center,
              child: const Text(
                "MASA: 10",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
