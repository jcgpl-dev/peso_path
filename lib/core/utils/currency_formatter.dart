import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _pesoFormat = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
    decimalDigits: 2,
  );

  static final NumberFormat _compactFormat = NumberFormat.compactSimpleCurrency(
    locale: 'en_PH',
  );

  static String format(num amount) {
    return _pesoFormat.format(amount);
  }

  static String formatRaw(num amount) {
    return NumberFormat('#,##0.00', 'en_US').format(amount);
  }

  static String formatCompact(num amount) {
    return _compactFormat.format(amount);
  }
}

extension CurrencyFormatterExtension on num {
  String toCurrency() => CurrencyFormatter.format(this);

  String toRawCurrency() => CurrencyFormatter.formatRaw(this);

  String toCompactCurrency() => CurrencyFormatter.formatCompact(this);
}
