import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/api/ordering.dart';
import 'package:saatmenumobileapp/models/order_data.dart';

enum OrderType {
  pending('pendingOrders'),
  accepted('acceptedOrders'),
  completed('completedOrders'),
  served('servedOrders');

  const OrderType(this.apiEndpoint);
  final String apiEndpoint;
}

class ChefOrderProvider with ChangeNotifier {
  // Data for each order type
  OrderDataList _pendingOrders = OrderDataList(orders: []);
  OrderDataList _acceptedOrders = OrderDataList(orders: []);
  OrderDataList _completedOrders = OrderDataList(orders: []);
  OrderDataList _servedOrders = OrderDataList(orders: []);
  
  // Loading states
  bool _isPendingLoading = false;
  bool _isAcceptedLoading = false;
  bool _isCompletedLoading = false;
  bool _isServedLoading = false;

  // Error states
  String? _pendingError;
  String? _acceptedError;
  String? _completedError;
  String? _servedError;
  
  // Last updated timestamps
  DateTime? _pendingLastUpdated;
  DateTime? _acceptedLastUpdated;
  DateTime? _completedLastUpdated;
  DateTime? _servedLastUpdated;

  // Getters for pending orders (backward compatibility)
  OrderDataList get orders => _pendingOrders;
  bool get isLoading => _isPendingLoading;
  String? get error => _pendingError;
  DateTime? get lastUpdated => _pendingLastUpdated;
  bool get hasOrders => _pendingOrders.orders.isNotEmpty;

  // Getters for pending orders (explicit)
  OrderDataList get pendingOrders => _pendingOrders;
  bool get isPendingLoading => _isPendingLoading;
  String? get pendingError => _pendingError;
  DateTime? get pendingLastUpdated => _pendingLastUpdated;
  bool get hasPendingOrders => _pendingOrders.orders.isNotEmpty;

  // Getters for accepted orders
  OrderDataList get acceptedOrders => _acceptedOrders;
  bool get isAcceptedLoading => _isAcceptedLoading;
  String? get acceptedError => _acceptedError;
  DateTime? get acceptedLastUpdated => _acceptedLastUpdated;
  bool get hasAcceptedOrders => _acceptedOrders.orders.isNotEmpty;

  // Getters for completed orders
  OrderDataList get completedOrders => _completedOrders;
  bool get isCompletedLoading => _isCompletedLoading;
  String? get completedError => _completedError;
  DateTime? get completedLastUpdated => _completedLastUpdated;
  bool get hasCompletedOrders => _completedOrders.orders.isNotEmpty;

  // Getters for served orders
  OrderDataList get servedOrders => _servedOrders;
  bool get isServedLoading => _isServedLoading;
  String? get servedError => _servedError;
  DateTime? get servedLastUpdated => _servedLastUpdated;
  bool get hasServedOrders => _servedOrders.orders.isNotEmpty;

  // Combined getters
  bool get isAnyLoading => _isPendingLoading || _isAcceptedLoading || _isCompletedLoading || _isServedLoading;
  bool get hasAnyOrders => hasPendingOrders || hasAcceptedOrders || hasCompletedOrders || hasServedOrders;
  List<String?> get allErrors => [_pendingError, _acceptedError, _completedError, _servedError].where((e) => e != null).toList();

  // Additional getters for the new structure (pending orders for backward compatibility)
  int get totalOrdersCount => _pendingOrders.count;
  int get totalItemsCount => _pendingOrders.totalItemsCount;
  int get totalQuantity => _pendingOrders.totalQuantity;
  double get totalUsd => _pendingOrders.totalUsd;
  double get totalKhr => _pendingOrders.totalKhr;
  List<String> get uniqueTables => _pendingOrders.uniqueTables;

  // Combined statistics
  int get allOrdersCount => _pendingOrders.count + _acceptedOrders.count + _completedOrders.count + _servedOrders.count;
  int get allItemsCount => _pendingOrders.totalItemsCount + _acceptedOrders.totalItemsCount + _completedOrders.totalItemsCount + _servedOrders.totalItemsCount;
  int get allQuantity => _pendingOrders.totalQuantity + _acceptedOrders.totalQuantity + _completedOrders.totalQuantity + _servedOrders.totalQuantity;
  double get allTotalUsd => _pendingOrders.totalUsd + _acceptedOrders.totalUsd + _completedOrders.totalUsd + _servedOrders.totalUsd;
  double get allTotalKhr => _pendingOrders.totalKhr + _acceptedOrders.totalKhr + _completedOrders.totalKhr + _servedOrders.totalKhr;

  List<String> get allUniqueTables {
    final tables = <String>{};
    tables.addAll(_pendingOrders.uniqueTables);
    tables.addAll(_acceptedOrders.uniqueTables);
    tables.addAll(_completedOrders.uniqueTables);
    tables.addAll(_servedOrders.uniqueTables);
    return tables.toList();
  }

  // Get orders by type
  OrderDataList getOrdersByType(OrderType type) {
    switch (type) {
      case OrderType.pending:
        return _pendingOrders;
      case OrderType.accepted:
        return _acceptedOrders;
      case OrderType.completed:
        return _completedOrders;
      case OrderType.served:
        return _servedOrders;
    }
  }

  // Get loading state by type
  bool getLoadingStateByType(OrderType type) {
    switch (type) {
      case OrderType.pending:
        return _isPendingLoading;
      case OrderType.accepted:
        return _isAcceptedLoading;
      case OrderType.completed:
        return _isCompletedLoading;
      case OrderType.served:
        return _isServedLoading;
    }
  }

  // Get error by type
  String? getErrorByType(OrderType type) {
    switch (type) {
      case OrderType.pending:
        return _pendingError;
      case OrderType.accepted:
        return _acceptedError;
      case OrderType.completed:
        return _completedError;
      case OrderType.served:
        return _servedError;
    }
  }

  // Fetch orders for specific type
  Future<void> fetchOrdersByType(OrderType type) async {
    switch (type) {
      case OrderType.pending:
        await _fetchPendingOrders();
        break;
      case OrderType.accepted:
        await _fetchAcceptedOrders();
        break;
      case OrderType.completed:
        await _fetchCompletedOrders();
        break;
      case OrderType.served:
        await _fetchServedOrders();
        break;
    }
  }

  // Private method to fetch pending orders
  Future<void> _fetchPendingOrders() async {
    _isPendingLoading = true;
    _pendingError = null;
    notifyListeners();

    try {
      final result = await Ordering.chefOrders(OrderType.pending.apiEndpoint);
      _pendingOrders = result;
      _pendingLastUpdated = DateTime.now();
      _pendingError = null;
    } catch (e) {
      _pendingError = e.toString();
      _pendingOrders = OrderDataList(orders: []);
    } finally {
      _isPendingLoading = false;
      notifyListeners();
    }
  }

  // Private method to fetch accepted orders
  Future<void> _fetchAcceptedOrders() async {
    _isAcceptedLoading = true;
    _acceptedError = null;
    notifyListeners();

    try {
      final result = await Ordering.chefOrders(OrderType.accepted.apiEndpoint);
      _acceptedOrders = result;
      _acceptedLastUpdated = DateTime.now();
      _acceptedError = null;
    } catch (e) {
      log('Error fetching accepted orders: $e');
      _acceptedError = e.toString();
      _acceptedOrders = OrderDataList(orders: []);
    } finally {
      _isAcceptedLoading = false;
      notifyListeners();
    }
  }

  // Private method to fetch completed orders
  Future<void> _fetchCompletedOrders() async {
    _isCompletedLoading = true;
    _completedError = null;
    notifyListeners();

    try {
      final result = await Ordering.chefOrders(OrderType.completed.apiEndpoint);
      _completedOrders = result;
      _completedLastUpdated = DateTime.now();
      _completedError = null;
    } catch (e) {
      _completedError = e.toString();
      _completedOrders = OrderDataList(orders: []);
    } finally {
      _isCompletedLoading = false;
      notifyListeners();
    }
  }

  // Private method to fetch served orders
  Future<void> _fetchServedOrders() async {
    _isServedLoading = true;
    _servedError = null;
    notifyListeners();

    try {
      final result = await Ordering.chefOrders(OrderType.served.apiEndpoint);
      _servedOrders = result;
      _servedLastUpdated = DateTime.now();
      _servedError = null;
    } catch (e) {
      _servedError = e.toString();
      _servedOrders = OrderDataList(orders: []);
    } finally {
      _isServedLoading = false;
      notifyListeners();
    }
  }

  // Load orders (backward compatibility - fetches pending orders)
  Future<void> fetchOrders() async {
    await _fetchPendingOrders();
  }

  // Fetch all order types
  Future<void> fetchAllOrders() async {
    await Future.wait([
      _fetchPendingOrders(),
      _fetchAcceptedOrders(),
      _fetchCompletedOrders(),
    ]);
  }

  // Refresh specific order type
  Future<void> refreshOrdersByType(OrderType type) => fetchOrdersByType(type);

  // Refresh all orders
  Future<void> refreshAllOrders() => fetchAllOrders();

  // Refresh orders (backward compatibility)
  Future<void> refresh() => fetchOrders();

  // Get orders by table for specific type
  Map<String, List<PendingOrder>> getOrdersByTableForType(OrderType type) {
    return getOrdersByType(type).groupByTable();
  }

  // Get orders by table (backward compatibility - pending orders)
  Map<String, List<PendingOrder>> getOrdersByTable() {
    return _pendingOrders.groupByTable();
  }

  // Get orders for specific table and type
  List<PendingOrder> getOrdersForTableByType(String tableName, OrderType type) {
    return getOrdersByType(type).getOrdersForTable(tableName);
  }

  // Get orders for specific table (backward compatibility - pending orders)
  List<PendingOrder> getOrdersForTable(String tableName) {
    return _pendingOrders.getOrdersForTable(tableName);
  }

  // Get orders by status for specific type
  List<PendingOrder> getOrdersByStatusForType(String status, OrderType type) {
    return getOrdersByType(type).getOrdersByStatus(status);
  }

  // Get orders by status (backward compatibility - pending orders)
  List<PendingOrder> getOrdersByStatus(String status) {
    return _pendingOrders.getOrdersByStatus(status);
  }

  // Get orders count by status for specific type
  int getOrdersCountByStatusForType(String status, OrderType type) {
    return getOrdersByType(type).getOrdersByStatus(status).length;
  }

  // Get orders count by status (backward compatibility - pending orders)
  int getOrdersCountByStatus(String status) {
    return _pendingOrders.getOrdersByStatus(status).length;
  }

  // Get all orders combined (for scenarios where you need all orders together)
  List<PendingOrder> getAllOrdersCombined() {
    final allOrders = <PendingOrder>[];
    allOrders.addAll(_pendingOrders.orders);
    allOrders.addAll(_acceptedOrders.orders);
    allOrders.addAll(_completedOrders.orders);
    return allOrders;
  }

  // Get all orders by table combined
  Map<String, List<PendingOrder>> getAllOrdersByTableCombined() {
    final combinedOrders = <String, List<PendingOrder>>{};
    
    // Add pending orders
    final pendingByTable = _pendingOrders.groupByTable();
    for (final entry in pendingByTable.entries) {
      combinedOrders[entry.key] = [...entry.value];
    }
    
    // Add accepted orders
    final acceptedByTable = _acceptedOrders.groupByTable();
    for (final entry in acceptedByTable.entries) {
      if (combinedOrders.containsKey(entry.key)) {
        combinedOrders[entry.key]!.addAll(entry.value);
      } else {
        combinedOrders[entry.key] = [...entry.value];
      }
    }
    
    // Add completed orders
    final completedByTable = _completedOrders.groupByTable();
    for (final entry in completedByTable.entries) {
      if (combinedOrders.containsKey(entry.key)) {
        combinedOrders[entry.key]!.addAll(entry.value);
      } else {
        combinedOrders[entry.key] = [...entry.value];
      }
    }
    
    return combinedOrders;
  }
}