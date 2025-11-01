import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: EdgeInsets.all(AppSizes.padding20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter Your Name"),
            Gap(AppSizes.gap15),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Your name..."),
            ),
            Gap(AppSizes.gap15),
            ElevatedButton(onPressed: cancel, child: Text("Cancel")),
            ElevatedButton(onPressed: save, child: Text("Save")),
          ],
        ),
      ),
    );
  }
}
