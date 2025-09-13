import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/models/order_data.dart';

Widget kitchenOrderingDetailWidget(
  BuildContext context,
  int index,
  PendingOrder? orderData,
  bool isCompleted,
  String route,
  int userType,
) {
  if (orderData == null) return SizedBox.shrink();

  Color headerColor;
  switch (index) {
    case 1:
      headerColor = primaryColor;
      break;
    case 2:
      headerColor = blue;
      break;
    default:
      headerColor = const Color(0xFFF229116);
  }

  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, route, arguments: orderData.toJson());
    },
    child: Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fontmdbold('Order #${orderData.orderId}', color: white),
                    const SizedBox(height: 5),
                    fontsmbold(_formatTime(orderData.createdAt), color: white),
                  ],
                ),
                const Spacer(),
                fontsmbold('Table ${orderData.tableName}', color: white),
              ],
            ),
          ),
          ...orderData.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: orderingDetailWidgetWithExtras(item),
            ),
          ),
          _buildBottomActions(
            context,
            index,
            orderData,
            isCompleted,
            route,
            userType,
          ),
        ],
      ),
    ),
  );
}

Widget _buildBottomActions(
  BuildContext context,
  int index,
  PendingOrder orderData,
  bool isCompleted,
  String route,
  int userType,
) {
  if (userType == 0) {
    if (isCompleted) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Decline Button
          InkWell(
            onTap: () => _handleDeclineOrder(context, orderData.orderId),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xfffE60039),
                borderRadius: BorderRadius.circular(10),
              ),
              child: fontsm('Decline', color: white),
            ),
          ),

          const SizedBox(width: 10),

          // Accept / Complete Button
          InkWell(
            onTap: () {
              if (index == 0) {
                _handleAcceptOrder(context, orderData.orderId);
              } else if (index == 1) {
                _handleCompleteOrder(context, orderData.orderId);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xfff229116),
                borderRadius: BorderRadius.circular(10),
              ),
              child: fontsm(
                'Served',
                color: white,
              ),
            ),
          ),
        ],
      ),
    );
  } else if (userType == 2 && index == 0) {
    // UserType 2: Show Proceed to Payment button on index 0
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 10),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(color: primaryColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.credit_card, color: white),
            const SizedBox(width: 10),
            fontsm('Proceed to Payment', color: white),
          ],
        ),
      ),
    );
  } else if (index == 0) {
    // Other userTypes & index 0: Show Served button
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route, arguments: orderData.toJson());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          margin: const EdgeInsets.only(bottom: 10, right: 10),
          decoration: BoxDecoration(
            color: const Color(0xfff229116),
            borderRadius: BorderRadius.circular(10),
          ),
          child: fontsm('Served', color: white),
        ),
      ),
    );
  }

  return const SizedBox.shrink();
}

Widget orderingDetailWidgetWithExtras(OrderItem item) {
  return Container(
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fontmdbold(item.menuName),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 3),
                fontsmbold(item.description, color: Colors.grey[600]),
              ],
              if (item.hasVariant) ...[
                const SizedBox(height: 5),
                fontsmbold('Variant: ${item.variantOptionName}'),
              ],
              if (item.hasExtras) ...[
                const SizedBox(height: 5),
                fontsmbold('Extras: ${item.extrasNames}'),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            fontmdbold('\$${item.usdPrice}'),
            fontsmbold('${item.khrPrice} KHR', color: Colors.grey[600]),
          ],
        ),
      ],
    ),
  );
}

String _formatTime(String createdAt) {
  try {
    final dateTime = DateTime.parse(createdAt);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return createdAt;
  }
}

// Placeholder methods - you should implement logic as needed
void _handleAcceptOrder(BuildContext context, int orderId) {
  // Implement accept order logic
}

void _handleCompleteOrder(BuildContext context, int orderId) {
  // Implement complete order logic
}

void _handleDeclineOrder(BuildContext context, int orderId) {
  // Implement decline order logic
}
