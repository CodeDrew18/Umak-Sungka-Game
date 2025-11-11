import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF1E1E1E);
  static const primary = Color(0xFFE53935);
  static const white = Colors.white;
  static const black = Colors.black;

  static const titleColor = Color(0xFFF04651);

  static const cg1 = Color(0xFF302235);
  static const cg2 = Color(0xFF6F272F);

  static const LinearGradient gradient1 = LinearGradient(
    colors: [cg1, cg2],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const cg3 = Color(0xFF452027);
  static const cg4 = Color(0xFF6F272F);

  static const LinearGradient gradient2 = LinearGradient(
    colors: [cg3, cg4],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cg5 = Color(0xFF2A2034);
  static const cg6 = Color(0xFF3D3068);

  static const LinearGradient gradient3 = LinearGradient(
    colors: [cg5, cg6],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static var grey800 = Colors.grey.shade800;
  static var grey700 = Colors.grey.shade700;

  static var gamebuttonPrimary = Color(0xFFE6B428);
}
