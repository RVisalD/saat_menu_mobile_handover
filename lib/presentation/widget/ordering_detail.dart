// import 'package:flutter/material.dart';
// import 'package:saatmenumobileapp/helper/utils/fonts.dart';
// import 'package:saatmenumobileapp/models/order_data.dart';

// Widget orderingDetailWidget(OrderItem item) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // You can add actual image handling here
//         Image.asset(
//           'assets/images/burger.png', // Default image or handle item images
//           width: 50,
//           height: 50,
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Food Name with quantity
//               fontmdbold('x${item.quantity} ${item.menuName}'),
              
//               // Variant if exists
//               if (item.hasVariant)
//                 fontsm('${item.variantOptionName}'),
              
//               // Description
//               if (item.description.isNotEmpty)
//                 fontsm(item.description, color: Colors.grey[600]),
//             ],
//           ),
//         ),
//         // Price
//         fontmd('\$${item.totalUsdPrice.toStringAsFixed(2)}'),
//       ],
//     ),
//   );
// }