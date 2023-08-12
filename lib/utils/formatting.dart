import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:intl/intl.dart';

String formatCurrency(Decimal value) {
  // FIXME: Forcing Dollar for testing
  // FIXME: Can we replace this with correct currency formatter with Decimal
  final format = NumberFormat.decimalPattern('en-US');
  format.minimumFractionDigits = 2;
  return '\$${format.format(DecimalIntl(value))}';
}
