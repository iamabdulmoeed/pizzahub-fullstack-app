import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../utils/api_config.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String _error = '';

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String get error => _error;

  // READ ALL: Fetch all orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/orders'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _orders = data.map((json) => Order.fromJson(json)).toList();
      } else {
        _error = 'Failed to load orders from server.';
      }
    } catch (e) {
      _error = 'Could not connect to the backend server. Make sure it is running.';
      print('Fetch orders error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE: Place a new order
  Future<bool> createOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(order.toJson()),
      );
      if (response.statusCode == 201) {
        await fetchOrders(); // Reload orders
        return true;
      }
      return false;
    } catch (e) {
      print('Create order error: $e');
      return false;
    }
  }

  // UPDATE: Edit order details
  Future<bool> updateOrder(String id, Order order) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/orders/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(order.toJson()),
      );
      if (response.statusCode == 200) {
        await fetchOrders(); // Reload orders
        return true;
      }
      return false;
    } catch (e) {
      print('Update order error: $e');
      return false;
    }
  }

  // DELETE: Cancel/Delete an order
  Future<bool> cancelOrder(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/orders/$id'),
      );
      if (response.statusCode == 200) {
        await fetchOrders(); // Reload orders
        return true;
      }
      return false;
    } catch (e) {
      print('Cancel order error: $e');
      return false;
    }
  }
}
