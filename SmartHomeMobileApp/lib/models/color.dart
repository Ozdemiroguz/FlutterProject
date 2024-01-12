import 'dart:ui';
Color darkBack=ColorConverter.hexToColor("49108B");
Color softBack=ColorConverter.hexToColor("7E30E1");
Color pink=ColorConverter.hexToColor("E26EE5");
class ColorConverter {
  static Color hexToColor(String hexString) {
    // Hex renk kodunu geçerli bir renk nesnesine dönüştürme
    final buffer = StringBuffer();

    // Hex kodun başında # işareti varsa onu kaldırma
    if (hexString.length == 7 || hexString.length == 9) {
      hexString = hexString.replaceFirst('#', '');
    }

    // Opaklık değeri olup olmadığını kontrol etme
    if (hexString.length == 6) {
      buffer.write('ff'); // Opaklık değeri yoksa, varsayılan olarak 'ff' (255) kullan
    }

    buffer.write(hexString);

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}