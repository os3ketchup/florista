class OrderInfo {
  String? name;
  String? phone;
  String? location;
}

class Cart {
  static final Map<int, List<String>> _carts = {};
  static final Map<int, OrderInfo> _orderInfo = {};

  static void addToCart(int userId, String flowerId) {
    _carts.putIfAbsent(userId, () => []);
    _carts[userId]!.add(flowerId);
  }

  static void removeFromCart(int userId, String flowerId) {
    _carts[userId]?.remove(flowerId);
  }

  static List<String> getCart(int userId) {
    return _carts[userId] ?? [];
  }

  static void clearCart(int userId) {
    _carts[userId]?.clear();
    _orderInfo[userId] = OrderInfo(); // reset user info too
  }

  static OrderInfo getOrderInfo(int userId) {
    return _orderInfo.putIfAbsent(userId, () => OrderInfo());
  }
}
