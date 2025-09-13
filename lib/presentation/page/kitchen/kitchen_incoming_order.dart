import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/convertor.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/models/order_data.dart';

class KitchenIncomingOrderPage extends StatefulWidget {
  const KitchenIncomingOrderPage({super.key});

  @override
  State<KitchenIncomingOrderPage> createState() =>
      KitchenIncomingOrderStatePage();
}

class KitchenIncomingOrderStatePage extends State<KitchenIncomingOrderPage> {
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
        title: fontlgbold('Incoming Orders'),
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
                      Icon(Icons.error_outline,
                          size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      fontmd('No order data found', color: Colors.grey[600]),
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
                      orderContainer(orderData),
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
                        _handleDeclineOrder();
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
                          child: fontsm('Decline', color: white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _handleAcceptOrder();
                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xfff229116),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: fontsm('Accept', color: white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _handleAcceptOrder() {
    if (orderData != null) {
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Accept Order'),
            content: Text(
                'Are you sure you want to accept Order #${orderData!.orderId}?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context,
                      {'action': 'accept', 'orderId': orderData!.orderId});
                  // Return result to previous screen
                },
                isDefaultAction: true,
                child: Text('Accept'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: fontmd('Accept Order'),
            content: fontsm(
                'Are you sure you want to accept Order #${orderData!.orderId}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: fontsm('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context,
                      {'action': 'accept', 'orderId': orderData!.orderId});
                  // Return result to previous screen
                },
                child: fontsm('Accept', color: Colors.green),
              ),
            ],
          ),
        );
      }
    }
  }

  void _handleDeclineOrder() {
    if (orderData != null) {
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Decline Order'),
            content: Text(
                'Are you sure you want to decline Order #${orderData!.orderId}?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context,
                      {'action': 'decline', 'orderId': orderData!.orderId});
                  // Return result to previous screen
                },
                isDestructiveAction: true,
                child: Text('Decline'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: fontmd('Decline Order'),
            content: fontsm(
                'Are you sure you want to decline Order #${orderData!.orderId}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: fontsm('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context,
                      {'action': 'decline', 'orderId': orderData!.orderId});
                  // Return result to previous screen
                },
                child: fontsm('Decline', color: Colors.red),
              ),
            ],
          ),
        );
      }
    }
  }
}

Widget orderContainer(PendingOrder? orderData) {
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
        Container(
          decoration: BoxDecoration(
            color: green.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.message, size: 24, color: green),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fontmdbold('Order #${orderData!.orderId}',
                      color: green),
                  const SizedBox(height: 5),
                  fontsm(formatTime(orderData.createdAt), color: green),
                ],
              ),
              Spacer(),
              fontmdbold('Table ${orderData.tableName}', color: green),
            ],
          ),
        ),
        ),
        

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
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: fontmdbold('\$${orderData.totalPrice}',
                      color: Colors.green[800]),
                ),
              ],
            ),
          ),

        // Order Items
        const SizedBox(height: 10),
        ...orderData.items.map((item) => buildOrderItem(item)),
        const SizedBox(height: 10),
      ],
    ),
  );
}

Widget buildOrderItem(OrderItem item) {
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

              // Extras text (if exists)
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
