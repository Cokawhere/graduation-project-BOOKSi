class Validators {
  static bool validateName(String name) {
    return name.isNotEmpty && name.length >= 2;
  }

  static bool validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool validateAddress(String address) {
    return address.isNotEmpty && address.length >= 5;
  }
}