import 'package:intl/intl.dart';

/// Formatting utilities
class Formatters {
  Formatters._(); // Private constructor

  /// Formats phone number to E.164 format (+919876543210)
  static String formatPhoneToE164(String phone, {String countryCode = '+91'}) {
    // Remove any non-digit characters
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Add country code if not already present
    if (cleanedPhone.startsWith('91') && cleanedPhone.length == 12) {
      return '+$cleanedPhone';
    }

    return '$countryCode$cleanedPhone';
  }

  /// Formats phone number for display (9876543210)
  static String formatPhoneForDisplay(String phone) {
    // Remove country code and special characters
    String cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');

    // If it starts with 91 and has 12 digits, remove the 91
    if (cleaned.startsWith('91') && cleaned.length == 12) {
      cleaned = cleaned.substring(2);
    }

    return cleaned;
  }

  /// Formats date to readable format (e.g., "Jan 15, 2024")
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Formats date to short format (e.g., "15/01/2024")
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formats time to readable format (e.g., "3:30 PM")
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Formats date and time (e.g., "Jan 15, 2024 at 3:30 PM")
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy \'at\' h:mm a').format(dateTime);
  }

  /// Calculates number of days between two dates
  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  /// Capitalizes first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;

    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Converts enum to readable string (e.g., "sick_leave" -> "Sick Leave")
  static String enumToReadable(String enumValue) {
    return enumValue
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
