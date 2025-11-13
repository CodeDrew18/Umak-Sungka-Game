// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// // --- DATA MODEL (Unchanged) ---
// class BoardOption {
//   final String title;
//   final String description;
//   final String imageFileName;
//   final Color cardBackgroundColor;
//   final Color textColor;

//   BoardOption({
//     required this.title,
//     required this.description,
//     required this.imageFileName,
//     required this.cardBackgroundColor,
//     this.textColor = Colors.black,
//   });
// }

// // --- DATA LIST (Unchanged) ---
// final List<BoardOption> boardOptions = [
//   BoardOption(
//     title: 'Classic Wood Grain',
//     description: 'Natural and simple light tan wood texture.',
//     imageFileName: 'assets/images/assets/texture_plain.jpg',
//     cardBackgroundColor: Colors.brown[100]!,
//     textColor: Colors.black,
//   ),
//   BoardOption(
//     title: 'Rainbow Plank Tiles',
//     description: 'Vibrant, playful spectrum of multicolored planks.',
//     imageFileName: 'assets/images/assets/texture_light.jpg',
//     cardBackgroundColor: Colors.teal.shade200,
//     textColor: Colors.black,
//   ),
//   BoardOption(
//     title: 'Geometric Walnut Blocks',
//     description: 'Dynamic, textured geometric mosaic of dark wood.',
//     imageFileName: 'assets/images/assets/texture_test.jpg',
//     cardBackgroundColor: Colors.brown[800]!,
//     textColor: Colors.white,
//   ),
// ];

// class BoardSelectionScreen extends StatefulWidget {
//   const BoardSelectionScreen({super.key});

//   @override
//   State<BoardSelectionScreen> createState() => _BoardSelectionScreenState();
// }

// class _BoardSelectionScreenState extends State<BoardSelectionScreen> {
//   late String _currentBackgroundImagePath;
//   late Color _currentDominantColor;

//   @override
//   void initState() {
//     super.initState();
//     _currentBackgroundImagePath = boardOptions.first.imageFileName;
//     _currentDominantColor = boardOptions.first.cardBackgroundColor;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: const Text('Choose Your Board'),
//         backgroundColor: _currentDominantColor.withOpacity(0.5),
//         elevation: 0,
//         iconTheme: IconThemeData(
//             color: _currentDominantColor.computeLuminance() > 0.5 ? Colors.black : Colors.white),
//         titleTextStyle: TextStyle(
//             color: _currentDominantColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
//             fontSize: 20),
//       ),
      
//       // Use a STACK to layer the animated background and the carousel.
//       body: Stack(
//         children: [
//           // 1. Animated Background Layer (only this changes state)
//           Positioned.fill(
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 600),
//               child: Container(
//                 key: ValueKey(_currentBackgroundImagePath), // This key causes the background to transition
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(_currentBackgroundImagePath),
//                     fit: BoxFit.cover,
//                     colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.7), 
//                       BlendMode.darken,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // 2. Carousel Layer (This remains stable and keeps its scroll state)
//           Center(
//             child: CarouselSlider(
//               options: CarouselOptions(
//                 height: 400.0,
//                 enlargeCenterPage: true,
//                 enableInfiniteScroll: true,
//                 aspectRatio: 16 / 9,
//                 viewportFraction: 0.8,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _currentBackgroundImagePath = boardOptions[index].imageFileName;
//                     _currentDominantColor = boardOptions[index].cardBackgroundColor;
//                     // _currentIndex = index; // If needed for other logic
//                   });
//                 },
//               ),
//               items: boardOptions.map((option) {
//                 // The card building logic remains the same
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Card(
//                       elevation: 12,
//                       clipBehavior: Clip.antiAlias,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16.0),
//                         side: BorderSide(color: Colors.white.withOpacity(0.6), width: 2),
//                       ),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           color: option.cardBackgroundColor,
//                           borderRadius: BorderRadius.circular(16.0),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: <Widget>[
//                             // Image Preview
//                             Expanded(
//                               flex: 3,
//                               child: Image.asset(
//                                 option.imageFileName,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
//                               ),
//                             ),
//                             // Text Details
//                             Expanded(
//                               flex: 1,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       option.title,
//                                       style: TextStyle(
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                         color: option.textColor,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       option.description,
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: option.textColor.withOpacity(0.7),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }