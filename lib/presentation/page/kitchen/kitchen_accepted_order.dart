import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/convertor.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/models/order_data.dart';

class KitchenAcceptedOrderPage extends StatefulWidget {
  const KitchenAcceptedOrderPage({super.key});

  @override
  State<KitchenAcceptedOrderPage> createState() =>
      KitchenAcceptedOrderStatePage();
}

class KitchenAcceptedOrderStatePage extends State<KitchenAcceptedOrderPage> {
  PendingOrder? orderData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Handle data loading with a small delay to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderData();
    });
  }

  void _loadOrderData() {
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        if (args is Map<String, dynamic>) {
          orderData = PendingOrder.fromJson(args);
        } else if (args is String) {
          // Handle string JSON if passed as string
          orderData =
              PendingOrder.fromJson(Map<String, dynamic>.from(args as Map));
        }
        setState(() {
          isLoading = false;
        });
      } else {
        // Handle case where no arguments are passed
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('No order data received');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Error loading order data: $e');
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: fontmd('Error'),
            content: fontsm(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back
                },
                child: fontsm('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: fontlgbold('Accepted Orders'),
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  fontsm('Loading order details...', color: Colors.grey[600]),
                ],
              ),
            )
          : orderData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_outlined,
                          size: 60, color: Colors.blue[400]),
                      const SizedBox(height: 16),
                      fontmd('No accepted order data found',
                          color: Colors.grey[600]),
                      const SizedBox(height: 8),
                      fontsm('Please try again', color: Colors.grey[500]),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: fontsm('Go Back'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      acceptedOrderContainer(orderData),
                    ],
                  ),
                ),
      bottomNavigationBar: orderData == null
          ? null
          : Container(
              height:
                  Platform.isIOS ? 120 : 110, // Extra height for iOS safe area
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(
                  color: Colors.transparent,
                ),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom:
                    Platform.isIOS ? 20 : 10, // Extra bottom padding for iOS
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _handleCancelOrder();
                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xfffE60039),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: fontsm('Cancel', color: white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _handleCompleteOrder();
                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: fontsm('Complete', color: white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _handleCompleteOrder() {
    if (orderData != null) {
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Complete Order'),
            content: Text(
                'Are you sure you want to mark Order #${orderData!.orderId} as completed?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context,
                      {'action': 'complete', 'orderId': orderData!.orderId});
                  // Return result to previous screen
                },
                isDefaultAction: true,
                child: Text('Complete'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: fontmd('Complete Order'),
            content: fontsm(
                'Are you sure you want to mark Order #${orderData!.orderId} as completed?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: fontsm('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context,
                      {'action': 'complete', 'orderId': orderData!.orderId});
                  // Return result to previous screen
                },
                child: fontsm('Complete', color: Colors.green),
              ),
            ],
          ),
        );
      }
    }
  }

  void _handleCancelOrder() {
    if (orderData != null) {
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Cancel Order'),
            content: Text(
                'Are you sure you want to cancel Order #${orderData!.orderId}?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text('No'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context,
                      {'action': 'cancel', 'orderId': orderData!.orderId});
                  // Return result to previous screen
                },
                isDestructiveAction: true,
                child: Text('Yes, Cancel'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: fontmd('Cancel Order'),
            content: fontsm(
                'Are you sure you want to cancel Order #${orderData!.orderId}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: fontsm('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context,
                      {'action': 'cancel', 'orderId': orderData!.orderId});
                  // Return result to previous screen
                },
                child: fontsm('Yes, Cancel', color: Colors.red),
              ),
            ],
          ),
        );
      }
    }
  }
}

Widget acceptedOrderContainer(PendingOrder? orderData) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      // Add shadow for better visual on both platforms
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with accepted status
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border(
              bottom: BorderSide(color: Colors.blue[200]!),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment_turned_in,
                          color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      fontmdbold('Order #${orderData!.orderId}',
                          color: Colors.blue[800]),
                    ],
                  ),
                  const SizedBox(height: 5),
                  fontsm('Accepted at ${formatTime(orderData.createdAt)}',
                      color: Colors.blue[700]),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.table_restaurant, color: white, size: 16),
                    const SizedBox(width: 4),
                    fontsmbold('Table ${orderData.tableName}', color: white),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Order summary section
        if (orderData.hasAnyExtras || orderData.hasAnyVariants)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                if (orderData.hasAnyVariants) ...[
                  Icon(Icons.tune, size: 16, color: Colors.blue[600]),
                  const SizedBox(width: 6),
                  fontsm('Has Variants', color: Colors.blue[600]),
                ],
                if (orderData.hasAnyVariants && orderData.hasAnyExtras)
                  const SizedBox(width: 20),
                if (orderData.hasAnyExtras) ...[
                  Icon(Icons.add_circle, size: 16, color: Colors.orange[600]),
                  const SizedBox(width: 6),
                  fontsm('${orderData.totalExtrasCount} Extras',
                      color: Colors.orange[600]),
                ],
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: fontmdbold('\$${orderData.totalPrice}',
                      color: Colors.blue[800]),
                ),
              ],
            ),
          ),

        // Preparation status section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            border: Border(
              bottom: BorderSide(color: Colors.amber[200]!),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.timer, size: 18, color: Colors.amber[700]),
              const SizedBox(width: 8),
              fontmd('In Preparation', color: Colors.amber[800]),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: fontsm('PREPARING', color: white),
              ),
            ],
          ),
        ),

        // Order Items
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: fontmdbold('Order Items', color: Colors.grey[700]),
        ),
        const SizedBox(height: 10),
        ...orderData.items.map((item) => buildAcceptedOrderItem(item)),
        const SizedBox(height: 15),
      ],
    ),
  );
}

Widget buildAcceptedOrderItem(OrderItem item) {
  return Container(
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Row(
      children: [
        // Preparation status indicator
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.amber[600],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fontmdbold(item.menuName),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 3),
                fontsm(item.description, color: Colors.grey[600]),
              ],

              if (item.hasVariant) ...[
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.tune, size: 14, color: Colors.blue[600]),
                    const SizedBox(width: 4),
                    fontsm('${item.variantOptionName}', color: Colors.blue[600]),
                  ],
                ),
              ],

              // Extras text (if exists)
              if (item.hasExtras) ...[
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.add_circle_outline, size: 14, color: Colors.orange[600]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: fontsm(item.extrasNames, color: Colors.orange[600]),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            fontmdbold('\$${item.usdPrice}', color: Colors.blue[700]),
            fontsm('${item.khrPrice} KHR', color: Colors.grey[600]),
          ],
        ),
      ],
    ),
  );
}