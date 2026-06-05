import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../models/pizza.dart';
import '../providers/order_provider.dart';
import '../utils/app_theme.dart';

class OrderFormScreen extends StatefulWidget {
  final Pizza? pizza; // Used when creating new order
  final String? selectedOption; // Used when creating new order
  final Order? order; // Used when editing existing order

  const OrderFormScreen({
    super.key,
    this.pizza,
    this.selectedOption,
    this.order,
  });

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  
  late String _pizzaName;
  late String _selectedCrust;
  int _quantity = 1;
  late double _unitPrice;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      // Edit Mode
      _nameController.text = widget.order!.customerName;
      _addressController.text = widget.order!.customerAddress;
      _phoneController.text = widget.order!.customerPhone;
      _pizzaName = widget.order!.pizzaName;
      _selectedCrust = widget.order!.crustOption;
      _quantity = widget.order!.quantity;
      // Calculate unit price from overall price and quantity
      _unitPrice = widget.order!.price / widget.order!.quantity;
    } else {
      // Create Mode
      _pizzaName = widget.pizza!.name;
      _selectedCrust = widget.selectedOption ?? widget.pizza!.availableOptions.first;
      _unitPrice = widget.pizza!.price;
      
      // Default mock profile info to make testing faster
      _nameController.text = 'Guest User';
      _phoneController.text = '0300-1234567';
      _addressController.text = 'Street 4, Sector F-8, Islamabad';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get _totalPrice => _unitPrice * _quantity;

  void _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final finalOrder = Order(
      id: widget.order?.id ?? '',
      customerName: _nameController.text.trim(),
      customerAddress: _addressController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      pizzaName: _pizzaName,
      crustOption: _selectedCrust,
      quantity: _quantity,
      price: _totalPrice,
      orderDate: widget.order?.orderDate ?? DateTime.now(),
    );

    final provider = Provider.of<OrderProvider>(context, listen: false);
    bool success;
    if (widget.order == null) {
      success = await provider.createOrder(finalOrder);
    } else {
      success = await provider.updateOrder(widget.order!.id, finalOrder);
    }

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.order == null ? 'Order placed successfully!' : 'Order updated successfully!'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      // Pop back twice if placing order from DetailsScreen (to return to Home Screen)
      if (widget.order == null) {
        Navigator.pop(context); // Pop Form Screen
        Navigator.pop(context); // Pop Details Screen
      } else {
        Navigator.pop(context); // Pop Form Screen
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit order. Check backend connection.'),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.order != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Modify Order' : 'Checkout & Order Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryRed))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card of what's being ordered
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryRed.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _pizzaName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.textMain,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Style/Option: $_selectedCrust',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${_unitPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.primaryRed,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      'Customer Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryRed),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please enter name';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primaryRed),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please enter phone number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Address',
                        prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primaryRed),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please enter delivery address';
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),

                    // Quantity Counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quantity:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline, size: 28),
                              color: AppColors.primaryRed,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _quantity++),
                              icon: const Icon(Icons.add_circle_outline, size: 28),
                              color: AppColors.primaryRed,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 40),

                    // Total Order Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Bill:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${_totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _submitOrder,
                      child: Text(isEditMode ? 'CONFIRM CHANGES' : 'PLACE ORDER NOW'),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
