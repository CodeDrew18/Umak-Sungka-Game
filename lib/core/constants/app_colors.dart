import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF1E1E1E);
  static const primary = Color(0xFFE53935);
  static const white = Colors.white;
  static const black = Colors.black;

  // Title
  static const titleColor = Color(0xFFF04651);

  // -- Card 1 --
  //gradient top
  static const cg1 = Color(0xFF302235);

  //gradient bottom
  static const cg2 = Color(0xFF6F272F);

  static const LinearGradient gradient1 = LinearGradient(
  colors: [cg1, cg2],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);

  // -- Card 2 --
  //gradient top
  static const cg3 = Color(0xFF452027);

  //gradient bottom
  static const cg4 = Color(0xFF6F272F);

  static const LinearGradient gradient2 = LinearGradient(
  colors: [cg3, cg4],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
 
  // -- Card 3 --
  //gradient top
  static const cg5 = Color(0xFF2A2034);

  //gradient bottom
  static const cg6 = Color(0xFF3D3068);

  static const LinearGradient gradient3 = LinearGradient(
  colors: [cg5, cg6],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
}
