import 'package:intl/intl.dart';

class HumanFormats {
  // Se usa corchetes [] para indicar que es un parámetro opcional
  static String number(double number, [int decimals = 0]) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en'
    ).format(number);

    return formattedNumber;
  }
}