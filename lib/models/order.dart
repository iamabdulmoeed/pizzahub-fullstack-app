class Order {
  final String id;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String pizzaName;
  final String crustOption;
  final int quantity;
  final double price;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.pizzaName,
    required this.crustOption,
    required this.quantity,
    required this.price,
    required this.orderDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      customerName: json['customerName'] ?? '',
      customerAddress: json['customerAddress'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      pizzaName: json['pizzaName'] ?? '',
      crustOption: json['crustOption'] ?? '',
      quantity: json['quantity'] != null ? int.parse(json['quantity'].toString()) : 1,
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate'].toString()) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'pizzaName': pizzaName,
      'crustOption': crustOption,
      'quantity': quantity,
      'price': price,
    };
  }
}
