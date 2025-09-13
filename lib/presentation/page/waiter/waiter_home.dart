import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saatmenumobileapp/helper/preferences.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/models/auth.dart';
import 'package:saatmenumobileapp/presentation/widget/drawer.dart';
import 'package:saatmenumobileapp/presentation/widget/kitchen_order_detail.dart';
import 'package:saatmenumobileapp/providers/chef_order.dart';

class WaiterHomePage extends StatefulWidget {
  const WaiterHomePage({super.key});

  @override
  State<WaiterHomePage> createState() => _WaiterHomePageState();
}

class _WaiterHomePageState extends State<WaiterHomePage> {
  int indexSelected = 1;
  Auth? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  String _getStatusName(int index) {
    switch (index) {
      case 1:
        return 'Ready to Serve';
      case 2:
        return 'Served';
      default:
        return 'Unknown';
    }
  }

  // Get the OrderType based on selected index
  OrderType _getOrderType(int index) {
    switch (index) {
      case 1:
        return OrderType.accepted;
      case 2:
        return OrderType.completed;
      default:
        return OrderType.pending;
    }
  }

  initializeData() async {
    try {
      Auth userDataString = await AppPreferences.getUserData();

      if (userDataString.staff != null) {
        if (userDataString is String) {
          userData = jsonDecode(userDataString.staff.toString());
        } else {
          userData = userDataString;
        }
      } else {
        userData = Auth(staff: null, token: null);
      }

      if (mounted) {
        // Debug: Log before fetching

        await context.read<ChefOrderProvider>().fetchAllOrders();
      }
    } catch (e) {
      userData = Auth(staff: null, token: null);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to refresh orders for current tab
  Future<void> _refreshCurrentOrders() async {
    final provider = context.read<ChefOrderProvider>();
    final orderType = _getOrderType(indexSelected);
    await provider.fetchOrdersByType(orderType);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: fontlgbold('Waiter Side'),
          backgroundColor: backgroundColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: fontlgbold(
            userData != null && userData?.staff?.restaurantUsername != null
                ? '${userData?.staff?.restaurantUsername} Waiter Side'
                : 'Waiter Side'),
        backgroundColor: backgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          // Add refresh button
          Consumer<ChefOrderProvider>(
            builder: (context, provider, child) {
              final orderType = _getOrderType(indexSelected);
              final isCurrentLoading =
                  provider.getLoadingStateByType(orderType);

              return IconButton(
                icon: isCurrentLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.refresh),
                onPressed: isCurrentLoading ? null : _refreshCurrentOrders,
              );
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(userType: 0),
      body: RefreshIndicator(
        onRefresh: _refreshCurrentOrders,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          indexSelected = 1;
                        });
                        // Fetch accepted orders when tab is selected
                        context
                            .read<ChefOrderProvider>()
                            .fetchOrdersByType(OrderType.accepted);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor,
                          ),
                          color: indexSelected == 1 ? primaryColor : white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              fontsm(_getStatusName(1),
                                  color: indexSelected == 1 ? white : primaryColor),
                              const SizedBox(width: 4),
                              Consumer<ChefOrderProvider>(
                                builder: (context, provider, child) {
                                  final count = provider.acceptedOrders.count;
                                  if (count > 0) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color:
                                            indexSelected == 1 ? white : primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: fontsm('$count',
                                          color: indexSelected == 1
                                              ? primaryColor
                                              : white),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          indexSelected = 2;
                        });
                        // Fetch completed orders when tab is selected
                        context
                            .read<ChefOrderProvider>()
                            .fetchOrdersByType(OrderType.completed);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: blue,
                          ),
                          color: indexSelected == 2
                              ? blue
                              : white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              fontsm(_getStatusName(2),
                                  color: indexSelected == 2
                                      ? white
                                      : blue),
                              const SizedBox(width: 4),
                              Consumer<ChefOrderProvider>(
                                builder: (context, provider, child) {
                                  final count = provider.completedOrders.count;
                                  if (count > 0) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: indexSelected == 2
                                            ? white
                                            : blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: fontsm('$count',
                                          color: indexSelected == 2
                                              ? blue
                                              : white),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Consumer<ChefOrderProvider>(
                builder: (context, provider, child) {
                  final orderType = _getOrderType(indexSelected);
                  final orders = provider.getOrdersByType(orderType);
                  final isLoading = provider.getLoadingStateByType(orderType);
                  final error = provider.getErrorByType(orderType);

                  if (isLoading && orders.orders.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          fontmd(
                            'Loading ${_getStatusName(indexSelected).toLowerCase()} orders...',
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    );
                  }

                  // Show error message
                  if (error != null && orders.orders.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          font2xl('Error loading orders', color: Colors.red),
                          const SizedBox(height: 8),
                          fontsm(error, color: Colors.grey[600]),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshCurrentOrders,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Show empty state
                  if (orders.orders.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const Icon(Icons.inbox, size: 60, color: Colors.grey),
                          const SizedBox(height: 16),
                          font2xl(
                            'No ${_getStatusName(indexSelected).toLowerCase()} orders',
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          fontsm(
                            'Pull down to refresh',
                            color: Colors.grey[500],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  }

                  // Show orders list
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order summary
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                fontsm('${orders.count} Orders',
                                    color: Colors.grey[700]),
                                fontsm('${orders.totalItemsCount} Items',
                                    color: Colors.grey[700]),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                fontsm(
                                    '\$${orders.totalUsd.toStringAsFixed(2)}',
                                    color: Colors.grey[700]),
                                fontsm(
                                    '${orders.totalKhr.toStringAsFixed(0)} KHR',
                                    color: Colors.grey[700]),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ...orders.orders.asMap().entries.map((entry) {
                        final order = entry.value;
                        return Column(
                          children: [
                            kitchenOrderingDetailWidget(
                              context,
                              indexSelected,
                              order,
                              indexSelected == 2 ? true : false,
                              indexSelected == 1
                                  ? 'waiter_incoming_order'
                                  : 'waiter_served_order',
                              0,
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }),
                      // Loading indicator at bottom when refreshing
                      if (isLoading && orders.orders.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
