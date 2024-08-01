import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shops_app/providers/cart.dart';

class OrderItem{
  final String id;
  final double amouunt;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({required this.id, required this.amouunt, required this.products, required this.dateTime});
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];

  List<OrderItem> get orders{
    return [..._orders];
  }

  final String authToken;
  final String userId;

  Orders(this.authToken, this._orders, this.userId);

  Future<void> fetchAndSetOrders() async {
    try {
      final url = Uri.parse('https://shopsapp-7286e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;

      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, orderData) {
        final amount = double.parse(orderData['amount'].toString());

        final List<CartItem> products = (orderData['products'] as List<dynamic>).map((item) =>
          CartItem(
            id: item['id'], 
            title: item['title'], 
            quantity: item['quantity'], 
            price: item['price']
          )
        ).toList();

        // ignore: unused_local_variable
        final dateTime = DateTime.parse(orderData['dateTime'] ?? '');

        final orderItem = OrderItem(
          id: orderId,
          amouunt: amount,
          products: products,
          dateTime: DateTime.parse(orderData['dateTime']),
        );

        loadedOrders.add(orderItem);
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching orders: $error');
      // Handle error (e.g., show error message to user)
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse('https://shopsapp-7286e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(url,
    body: json.encode({
      'amount': total.toString(),
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts.map((cp) => {
        'id': cp.id,
        'title': cp.title,
        'quantity': cp.quantity,
        'price': cp.price,
      }).toList(),
    })
    );
    _orders.insert(0, OrderItem(id: json.decode(response.body)['name'], amouunt: total, products: cartProducts, dateTime: timestamp));
    notifyListeners();
  }

}