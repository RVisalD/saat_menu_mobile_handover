import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/convertor.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/models/order_data.dart';
import 'package:saatmenumobileapp/presentation/page/kitchen/kitchen_incoming_order.dart';

class KitchenCompletedOrderPage extends StatefulWidget {
  const KitchenCompletedOrderPage({super.key});

  @override
  State<KitchenCompletedOrderPage> createState() =>
      _KitchenCompletedOrderPageState();
}

class _KitchenCompletedOrderPageState extends State<KitchenCompletedOrderPage> {
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
        title: fontlgbold('Completed Orders'),
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
                      Icon(Icons.check_circle_outline,
                          size: 60, color: Colors.green[400]),
                      const SizedBox(height: 16),
                      fontmd('No completed order data found',
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
                      completedOrderContainer(orderData),
                    ],
                  ),
                ),
      bottomNavigationBar: orderData == null
          ? null
          : Container(
              height: Platform.isIOS ? 100 : 90,
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
                bottom: Platform.isIOS ? 20 : 10,
              ),
            ),
    );
  }
}

Widget completedOrderContainer(PendingOrder? orderData) {
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
        // Header with completed status
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border(
              bottom: BorderSide(color: Colors.green[200]!),
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
                      Icon(Icons.check_circle,
                          color: Colors.green[600], size: 20),
                      const SizedBox(width: 8),
                      fontmdbold('Order #${orderData!.orderId}',
                          color: Colors.green[800]),
                    ],
                  ),
                  const SizedBox(height: 5),
                  fontsm('Completed at ${formatTime(orderData.createdAt)}',
                      color: Colors.green[700]),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[600],
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
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: fontmdbold('Order Items', color: Colors.grey[700]),
        ),
        const SizedBox(height: 10),
        ...orderData.items.map((item) => buildOrderItem(item)),
        const SizedBox(height: 15),
      ],
    ),
  );
}
