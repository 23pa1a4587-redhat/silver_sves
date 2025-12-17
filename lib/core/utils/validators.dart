/// Validation utilities for forms
class Validators {
  Validators._(); // Private constructor

  /// Validates phone number (10 digits for India)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any spaces or special characters
    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length != 10) {
      return 'Phone number must be 10 digits';
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanedValue)) {
      return 'Please enter a valid Indian mobile number';
    }

    return null;
  }

  /// Validates OTP (6 digits)
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }

    return null;
  }

  /// Validates name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  /// Validates leave reason
  static String? validateLeaveReason(String? value) {
    if (value == null || value.isEmpty) {
      return 'Reason is required';
    }

    if (value.trim().length < 10) {
      return 'Please provide a detailed reason (at least 10 characters)';
    }

    return null;
  }

  /// Validates department name
  static String? validateDepartmentName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Department name is required';
    }

    if (value.trim().length < 2) {
      return 'Department name must be at least 2 characters';
    }

    return null;
  }
}
