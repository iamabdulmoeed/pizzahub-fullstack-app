import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      // Direct local IP address of the host machine
      return 'http://192.168.100.160:5000/api';
    }
    return 'http://192.168.100.160:5000/api';
  }
}
