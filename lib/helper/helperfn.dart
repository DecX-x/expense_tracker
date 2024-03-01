// convert string to double
import 'package:intl/intl.dart';
double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}
//formay doubke into rupiah
String formatRupiah(double amount) {
  return "Rp " + amount.toStringAsFixed(0).replaceAllMapped(
      new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},');
}

//calculate the number of months since the first start month
int calculateMonthCount(int startYear, startMonth, currentYear, currentMonth) {
  int monthCount = (currentYear - startYear) * 12 + currentMonth - startMonth + 1;
  return monthCount;
}