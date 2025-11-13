// import 'package:flutter/material.dart';

// class AdventureCards extends StatelessWidget {
//   final String name;
//   final int score;
//   final bool isActive;
//   final IconData? avatarIcon; 

//   const AdventureCards({
//     Key? key,
//     required this.name,
//     required this.score,
//     required this.isActive,
//     this.avatarIcon, 
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // --- Styles and Colors ---
//     final primaryColor = isActive ? const Color(0xFFFF4D67) : const Color(0xFF4B4B4B); // Active: Red/Pink, Inactive: Dark Gray
//     final secondaryColor = isActive ? const Color(0xFF1E0E0E) : const Color(0xFF1E0E0E); // Dark background

//     // Determine the icon
//     IconData getIcon() {
//       if (avatarIcon != null) return avatarIcon!;
//       if (name.toLowerCase().contains('adventure')) {
//         return Icons.memory; 
//       }
//       return Icons.person_4; 
//     }

//     return Container(
//       width: 150, // Slightly increased width for readability, but flexible
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: secondaryColor.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(16),
//         // Border and glow when active
//         border: Border.all(
//           color: primaryColor.withOpacity(isActive ? 1.0 : 0.3),
//           width: 3.0,
//         ),
//         boxShadow: isActive 
//           ? [
//               BoxShadow(
//                 color: primaryColor.withOpacity(0.4),
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               )
//             ] 
//           : null,
//       ),
//       child: Row( // Changed to Row for horizontal efficiency
//         children: [
//           // --- 1. AVATAR ICON ---
//           Container(
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: primaryColor.withOpacity(0.15),
//               border: Border.all(color: primaryColor, width: 2),
//             ),
//             child: Icon(
//               getIcon(),
//               size: 18,
//               color: primaryColor,
//             ),
//           ),
//           const SizedBox(width: 8),
          
//           // --- 2. NAME & SCORE (Column) ---
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min, // Essential for tight fit
//               children: [
//                 // Name (smaller)
//                 Text(
//                   name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 2),

//                 // Score Badge (more compact)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//                   decoration: BoxDecoration(
//                     color: primaryColor, 
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     'Score: ${score.toString()}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w900,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class PlayerCards extends StatelessWidget {
  final String name;
  final int score;
  final bool isActive;
  final IconData? avatarIcon; 

  const PlayerCards({
    Key? key,
    required this.name,
    required this.score,
    required this.isActive,
    this.avatarIcon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- Styles and Colors ---
    final primaryColor = isActive ? const Color(0xFFFF4D67) : const Color(0xFF4B4B4B); // Active: Red/Pink, Inactive: Dark Gray
    final secondaryColor = isActive ? const Color(0xFF1E0E0E) : const Color(0xFF1E0E0E); // Dark background

    // Determine the icon
    IconData getIcon() {
      if (avatarIcon != null) return avatarIcon!;
      if (name.toLowerCase().contains('adventure')) {
        return Icons.memory; 
      }
      return Icons.person_4; 
    }

    return Container(
      width: 150, // Compacted width
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        // Border and glow when active
        border: Border.all(
          color: primaryColor.withOpacity(isActive ? 1.0 : 0.3),
          width: 3.0,
        ),
        boxShadow: isActive 
          ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ] 
          : null,
      ),
      child: Row( // Changed to Row for horizontal efficiency
        children: [
          // --- 1. AVATAR ICON ---
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.15),
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: Icon(
              getIcon(),
              size: 18,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          
          // --- 2. NAME & SCORE (Column) ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Essential for tight fit
              children: [
                // Name (smaller)
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),

                // Score Badge (more compact)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: primaryColor, 
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Score: ${score.toString()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}