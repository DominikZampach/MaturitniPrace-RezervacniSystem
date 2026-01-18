import 'package:flutter/material.dart';

class Consts {
  static final Color primary = const Color.fromRGBO(72, 209, 77, 1.0);
  static final Color secondary = const Color.fromRGBO(176, 240, 128, 1.0);
  static final Color background = const Color.fromRGBO(234, 255, 218, 1.0);
  static final Color error = const Color.fromARGB(255, 231, 113, 129);
  static final Color success = const Color.fromRGBO(70, 236, 86, 1.0);
  static final Color info = const Color.fromRGBO(148, 251, 251, 1.0);
  static final ColorScheme colorScheme = ColorScheme.light(
    primary: primary,
    secondary: secondary,
    surface: background,
    error: error,
    tertiary: info,
    onPrimary: Colors.black,
  );
  static const String ADMIN_EMAIL = "bookmycut@seznam.cz";
  static const String ADMIN_UID = "4iUvFGRtE9Zrk6YLUIrRK8n3B0D3";

  static const httpHeaders = {
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept":
        "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
  };
}
