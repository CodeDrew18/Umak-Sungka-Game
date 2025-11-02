import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/core/constants/app_sizes.dart';

class NameInputDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback cancel;
  final VoidCallback save;

  const NameInputDialog({
    super.key,
    required this.controller,
    required this.cancel,
    required this.save,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),

        Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.all(AppSizes.padding20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C1A0C).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter Your Name",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFFFD700),
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                          color: const Color(0xFFE67E22).withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.gap20),
            
                  TextField(
                    controller: controller,
                    cursorColor: AppColors.primary,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      hintText: "Your name...",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      filled: true,
                      fillColor: Colors.brown.shade700.withOpacity(0.6),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.orangeAccent.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                  ),
            
                  SizedBox(height: 30),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel button
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 12),
                            elevation: 6,
                            // shadowColor: Colors.redAccent,
                          ),
                          onPressed: cancel,
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Gap(15),
                      // Save button
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            elevation: 10,
                            // shadowColor: Colors.amberAccent,
                          ),
                          onPressed: save,
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              color: Colors.brown.shade900,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
