import 'package:flutter/services.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

  final List<Map<String, dynamic>> fontArabs = [
    {"title": "Amiri Quran"},
    {"title": "LPMQ Isep Misbah"},
    {"title": "Spectral"},
    {"title": "Uthmanic"},

  ];


  String formatRupiah(int nominal) {
    final s = nominal.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      buffer.write(s[i]);
      final remaining = s.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
    }
    return 'Rp $buffer';
  }
