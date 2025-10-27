import 'package:flutter/material.dart';
import 'package:sungka/screens/play_with_friends/provider/avatar_model.dart';

class AvatarCard extends StatelessWidget {
  final Avatar avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const AvatarCard({
    Key? key,
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: avatar.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: avatar.color.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(avatar.icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              avatar.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
