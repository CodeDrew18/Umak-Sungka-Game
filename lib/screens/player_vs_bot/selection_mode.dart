import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectionMode extends StatelessWidget {
  const SelectionMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text("Select your Mode", style: GoogleFonts.poppins(
                fontSize: 42,
              
              ),),
            ),
        
            ElevatedButton(onPressed: () {}, child: Text("Easy"), style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              fixedSize: Size.fromHeight(70)
            ),),
            Gap(15),
            ElevatedButton(onPressed: () {}, child: Text("Medium"), style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              fixedSize: Size.fromHeight(70)
            ),),
            Gap(15),
            ElevatedButton(onPressed: () {}, child: Text("Imposible"), style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              fixedSize: Size.fromHeight(70)
            ),),
          ],
        ),
      ),
    );
  }
}
