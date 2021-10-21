import 'package:flutter/material.dart';

extension Extensao on TimeOfDay {
  String formatado() {
    return '${hour}h${minute.toString().padLeft(2, '0')}';
  }

  int toMinutes() => hour * 60 + minute;
}
