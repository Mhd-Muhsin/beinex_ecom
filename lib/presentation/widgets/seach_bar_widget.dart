// import 'package:flutter/material.dart';
//
// class SearchBarWidget extends StatefulWidget {
//   const SearchBarWidget({super.key});
//
//   @override
//   State<SearchBarWidget> createState() => _SearchBarWidgetState();
// }
//
// class _SearchBarWidgetState extends State<SearchBarWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Search input field
//         Expanded(
//           child: Consumer<ProductViewModel>(
//             builder: (context, provider, _) {
//               return TextFormField(
//                 onChanged: (value) {
//                   provider.updateSearchProduct(value); // ✅ call viewmodel
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
//                   prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//
//         SizedBox(width: 12),
//         // Search button
//         Container(
//           height: 40,
//           width: 45,
//           margin: EdgeInsets.only(right: 20),
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(Icons.search, color: Colors.white, size: 24),
//         ),
//       ],
//     );
//   }
// }
