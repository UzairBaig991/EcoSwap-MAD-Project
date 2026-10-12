import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class AppFormatters {
  AppFormatters._();

  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1.0) {
      final meters = (distanceInKm * 1000).round();
      return '$meters m away';
    }
    return '${distanceInKm.toStringAsFixed(1)} km away';
  }

  static String formatCo2(double kg) {
    if (kg >= 1000) {
      final tons = kg / 1000;
      return '${tons.toStringAsFixed(1)} tons CO₂ saved';
    }
    return '${kg.toStringAsFixed(1)} kg CO₂ saved';
  }

  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(price);
  }

  static String formatTimeAgo(DateTime dateTime) {
    return timeago.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}
