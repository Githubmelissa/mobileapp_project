class Order {
  final String orderId;
  final String userId;
  final String totalPrice;
  final String deliveryAddress;
  final String orderStatus;
  final String orderDate;

  Order({
    required this.orderId,
    required this.userId,
    required this.totalPrice,
    required this.deliveryAddress,
    required this.orderStatus,
    required this.orderDate,
  });
}