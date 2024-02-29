import 'package:flutter/material.dart';

import 'renkler.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      // Düz yatay çizgi
      color: dividerRengi, // Çizgi rengi
      thickness: 2, // Çizgi kalınlığı
      height: 20, // Çizgi yüksekliği
      indent: 20, // Çizginin başlangıç boşluğu
      endIndent: 20,
    );
  }
}
