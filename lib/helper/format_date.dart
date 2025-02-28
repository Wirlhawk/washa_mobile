import 'package:intl/intl.dart';

String formatDate(date) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
}