class OrderExtra {
  final int extraId;
  final String extraName;
  final String extraUsdPrice;
  final String extraKhrPrice;

  OrderExtra({
    required this.extraId,
    required this.extraName,
    required this.extraUsdPrice,
    required this.extraKhrPrice,
  });

  factory OrderExtra.fromJson(Map<String, dynamic> json) {
    return OrderExtra(
      extraId: json['extra_id'],
      extraName: json['extra_name'],
      extraUsdPrice: json['extra_usd_price'],
      extraKhrPrice: json['extra_khr_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extra_id': extraId,
      'extra_name': extraName,
      'extra_usd_price': extraUsdPrice,
      'extra_khr_price': extraKhrPrice,
    };
  }

  double get usdPrice => double.tryParse(extraUsdPrice) ?? 0.0;
  double get khrPrice => double.tryParse(extraKhrPrice) ?? 0.0;
}

class OrderItem {
  final int orderItemId;
  final int quantity;
  final String unitPrice;
  final String usdPrice;
  final String khrPrice;
  final int? variantOptionId;
  final int menuId;
  final String menuName;
  final String description;
  final String menuUsdPrice;
  final int categoryId;
  final String? variantOptionName;
  final String? variantUsdPrice;
  final String? variantKhrPrice;
  final List<OrderExtra> extras;

  OrderItem({
    required this.orderItemId,
    required this.quantity,
    required this.unitPrice,
    required this.usdPrice,
    required this.khrPrice,
    this.variantOptionId,
    required this.menuId,
    required this.menuName,
    required this.description,
    required this.menuUsdPrice,
    required this.categoryId,
    this.variantOptionName,
    this.variantUsdPrice,
    this.variantKhrPrice,
    required this.extras,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: json['order_item_id'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      usdPrice: json['USD_price'],
      khrPrice: json['KHR_price'],
      variantOptionId: json['variant_option_id'],
      menuId: json['menu_id'],
      menuName: json['menu_name'],
      description: json['description'],
      menuUsdPrice: json['menu_usd_price'],
      categoryId: json['category_id'],
      variantOptionName: json['variant_option_name'],
      variantUsdPrice: json['variant_usd_price'],
      variantKhrPrice: json['variant_khr_price'],
      extras: (json['extras'] as List? ?? [])
          .map((extra) => OrderExtra.fromJson(extra))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_item_id': orderItemId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'USD_price': usdPrice,
      'KHR_price': khrPrice,
      'variant_option_id': variantOptionId,
      'menu_id': menuId,
      'menu_name': menuName,
      'description': description,
      'menu_usd_price': menuUsdPrice,
      'category_id': categoryId,
      'variant_option_name': variantOptionName,
      'variant_usd_price': variantUsdPrice,
      'variant_khr_price': variantKhrPrice,
      'extras': extras.map((extra) => extra.toJson()).toList(),
    };
  }

  bool get hasVariant => variantOptionId != null;
  bool get hasExtras => extras.isNotEmpty;
  double get totalUsdPrice => double.tryParse(usdPrice) ?? 0.0;
  double get totalKhrPrice => double.tryParse(khrPrice) ?? 0.0;
  
  // Calculate total extras price
  double get extrasUsdPrice => extras.fold(0.0, (sum, extra) => sum + extra.usdPrice);
  double get extrasKhrPrice => extras.fold(0.0, (sum, extra) => sum + extra.khrPrice);
  
  // Get extras names as a comma-separated string
  String get extrasNames => extras.map((extra) => extra.extraName).join(', ');
  
  // Get count of extras
  int get extrasCount => extras.length;
}

class PendingOrder {
  final int orderId;
  final String createdAt;
  final String tableName;
  final String orderStatus;
  final String totalPrice;
  final List<OrderItem> items;

  PendingOrder({
    required this.orderId,
    required this.createdAt,
    required this.tableName,
    required this.orderStatus,
    required this.totalPrice,
    required this.items,
  });

  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    return PendingOrder(
      orderId: json['order_id'],
      createdAt: json['created_at'],
      tableName: json['table_name'],
      orderStatus: json['order_status'].toString(),
      totalPrice: json['total_price'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'created_at': createdAt,
      'table_name': tableName,
      'order_status': orderStatus,
      'total_price': totalPrice,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  double get totalUsdPrice => double.tryParse(totalPrice) ?? 0.0;
  double get totalKhrPrice {
    return items.fold(0.0, (sum, item) => sum + item.totalKhrPrice);
  }
  
  DateTime? get orderDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }

  int get itemsCount => items.length;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
  
  String get menuNames => items.map((item) => item.menuName).join(', ');
  
  // Get total extras count across all items
  int get totalExtrasCount => items.fold(0, (sum, item) => sum + item.extrasCount);
  
  // Get all extras across all items
  List<OrderExtra> get allExtras {
    List<OrderExtra> allExtras = [];
    for (var item in items) {
      allExtras.addAll(item.extras);
    }
    return allExtras;
  }
  
  // Check if any item has extras
  bool get hasAnyExtras => items.any((item) => item.hasExtras);
  
  // Check if any item has variants
  bool get hasAnyVariants => items.any((item) => item.hasVariant);
}

class OrderDataList {
  final bool success;
  final List<PendingOrder> orders;

  OrderDataList({this.success = true, required this.orders});

  factory OrderDataList.fromJson(Map<String, dynamic> json) {
    return OrderDataList(
      success: json['success'] ?? true,
      orders: (json['data'] as List? ?? [])
          .map((orderJson) => PendingOrder.fromJson(orderJson))
          .toList(),
    );
  }

  // Keep backward compatibility with List constructor
  factory OrderDataList.fromList(List<dynamic> jsonList) {
    return OrderDataList(
      success: true,
      orders: jsonList.map((json) => PendingOrder.fromJson(json)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': orders.map((order) => order.toJson()).toList(),
    };
  }

  List<Map<String, dynamic>> toJsonList() {
    return orders.map((order) => order.toJson()).toList();
  }

  // Group orders by table
  Map<String, List<PendingOrder>> groupByTable() {
    Map<String, List<PendingOrder>> grouped = {};
    for (var order in orders) {
      if (grouped[order.tableName] == null) {
        grouped[order.tableName] = [];
      }
      grouped[order.tableName]!.add(order);
    }
    return grouped;
  }

  // Calculate total for all orders
  double get totalUsd => orders.fold(0.0, (sum, order) => sum + order.totalUsdPrice);
  double get totalKhr => orders.fold(0.0, (sum, order) => sum + order.totalKhrPrice);

  // Get total items count across all orders
  int get totalItemsCount => orders.fold(0, (sum, order) => sum + order.itemsCount);
  
  // Get total quantity across all orders
  int get totalQuantity => orders.fold(0, (sum, order) => sum + order.totalQuantity);
  
  // Get total extras count across all orders
  int get totalExtrasCount => orders.fold(0, (sum, order) => sum + order.totalExtrasCount);

  // Get orders count
  int get count => orders.length;

  bool get isEmpty => orders.isEmpty;
  bool get isNotEmpty => orders.isNotEmpty;

  List<String> get uniqueTables {
    return orders
        .map((order) => order.tableName)
        .toSet()
        .toList()
        ..sort();
  }

  List<PendingOrder> getOrdersByStatus(String status) {
    return orders.where((order) => order.orderStatus == status).toList();
  }

  List<PendingOrder> getOrdersForTable(String tableName) {
    return orders.where((order) => order.tableName == tableName).toList();
  }

  List<PendingOrder> get ordersWithExtras {
    return orders.where((order) => order.hasAnyExtras).toList();
  }

  List<PendingOrder> get ordersWithVariants {
    return orders.where((order) => order.hasAnyVariants).toList();
  }
}