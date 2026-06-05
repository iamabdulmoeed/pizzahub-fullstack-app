import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pizza.dart';
import '../utils/api_config.dart';

class PizzaProvider with ChangeNotifier {
  List<Pizza> _pizzas = [];
  bool _isLoading = false;
  String _error = '';

  List<Pizza> get rawPizzas => _pizzas;
  bool get isLoading => _isLoading;
  String get error => _error;

  String _searchQuery = '';
  String _selectedCategory = 'All';

  String get selectedCategory => _selectedCategory;

  // Filter pizzas based on category and search query
  List<Pizza> get pizzas {
    return _pizzas.where((pizza) {
      final matchesSearch = pizza.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || pizza.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Fetch Pizzas from Node.js Express API
  Future<void> fetchPizzas() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/pizzas'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _pizzas = data.map((json) => Pizza.fromJson(json)).toList();
      } else {
        _error = 'Failed to load pizzas from server.';
      }
    } catch (e) {
      _error = 'Could not connect to the backend server. Make sure it is running.';
      print('Fetch pizzas error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE: Add a new pizza
  Future<bool> addPizza(Pizza pizza) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/pizzas'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pizza.toJson()),
      );
      if (response.statusCode == 201) {
        await fetchPizzas(); // Reload database items
        return true;
      }
      return false;
    } catch (e) {
      print('Add pizza error: $e');
      return false;
    }
  }

  // UPDATE: Edit an existing pizza
  Future<bool> updatePizza(String id, Pizza pizza) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/pizzas/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pizza.toJson()),
      );
      if (response.statusCode == 200) {
        await fetchPizzas(); // Reload items
        return true;
      }
      return false;
    } catch (e) {
      print('Update pizza error: $e');
      return false;
    }
  }

  // DELETE: Delete a pizza
  Future<bool> deletePizza(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/pizzas/$id'),
      );
      if (response.statusCode == 200) {
        await fetchPizzas(); // Reload items
        return true;
      }
      return false;
    } catch (e) {
      print('Delete pizza error: $e');
      return false;
    }
  }

  // Search box handling
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Category selection handling
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
