extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return '';
    } else {
      return this!;
    }
  }
}

extension NonNullint on int? {
  int orZero() {
    if (this == null) {
      return 0;
    } else {
      return this!;
    }
  }

  int orOne() {
    if (this == null) {
      return 1;
    } else {
      return this!;
    }
  }
}

extension NonNulldouble on double? {
  double orZero() {
    if (this == null) {
      return 0.0;
    } else {
      return this!;
    }
  }
}

extension NonNullbool on bool? {
  bool orFalse() {
    if (this == null) {
      return false;
    } else {
      return this!;
    }
  }
}

extension NonNullList on List? {
  List orEmpty() {
    if (this == null) {
      return [];
    } else {
      return this!;
    }
  }
}

extension DateTimeExtention on DateTime? {
  String toStringWithoutTime() {
    final date = toString();
    return date.split(' ')[0];
  }

  DateTime orNow() {
    if (this == null) {
      return DateTime.now();
    } else {
      return this!;
    }
  }
}

extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  bool isValidPhone() {
    return RegExp(
      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
    ).hasMatch(this);
  }
}
