class AuthValidators {
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 3) return 'Name is too short';
    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[a-zA-Z]{2,}$',
    ).hasMatch(value.trim())) {
      return 'Invalid email';
    }
    return null;
  }

  // Password validation
  static String? validateStrongPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    final password = value.trim();

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain an uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain a lowercase letter";
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
      return 'Add at least one letter';
    }
    if ((!RegExp(r'\d').hasMatch(password))) {
      return 'Add at least one number';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  // Login password validation
    static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }
}
