import 'package:intl/intl.dart';

String formatCurrency(double value) {
  return NumberFormat.compactSimpleCurrency(
    locale: 'en-US', // FIXME: Forcing Dollar for testing
  ).format(value);
}
