import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pizza.dart';
import '../providers/pizza_provider.dart';
import '../utils/app_theme.dart';

class PizzaFormScreen extends StatefulWidget {
  final Pizza? pizza;

  const PizzaFormScreen({super.key, this.pizza});

  @override
  State<PizzaFormScreen> createState() => _PizzaFormScreenState();
}

class _PizzaFormScreenState extends State<PizzaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _optionsController = TextEditingController();
  
  String _selectedCategory = 'Veg';
  final List<String> _categories = ['Veg', 'Non-Veg', 'Wings', 'Beverages'];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.pizza != null) {
      _nameController.text = widget.pizza!.name;
      _descController.text = widget.pizza!.description;
      _priceController.text = widget.pizza!.price.toString();
      _imageController.text = widget.pizza!.imageUrl;
      _selectedCategory = widget.pizza!.category;
      _optionsController.text = widget.pizza!.availableOptions.join(', ');
    } else {
      // Default placeholder image just in case
      _imageController.text = 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=2070&auto=format&fit=crop';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final options = _optionsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final newPizza = Pizza(
      id: widget.pizza?.id ?? '',
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      imageUrl: _imageController.text.trim(),
      category: _selectedCategory,
      availableOptions: options.isEmpty
          ? (_selectedCategory == 'Wings'
              ? ['Baked', 'Fried']
              : (_selectedCategory == 'Beverages'
                  ? ['Cold', 'No Ice']
                  : ['Thin Crust', 'Pan Pizza']))
          : options,
    );

    final provider = Provider.of<PizzaProvider>(context, listen: false);
    bool success;
    if (widget.pizza == null) {
      success = await provider.addPizza(newPizza);
    } else {
      success = await provider.updatePizza(widget.pizza!.id, newPizza);
    }

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.pizza == null ? 'Pizza added successfully!' : 'Pizza updated successfully!'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Operation failed. Please try again.'),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.pizza != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Menu Item' : 'Add Menu Item'),
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
                    Text(
                      isEditMode ? 'Update Product details' : 'Create new menu item',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 25),
                    
                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'e.g., Spicy Chicken Feast',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter item name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Price & Category
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Price (\$)',
                              hintText: '14.99',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                filled: false,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              items: _categories.map((cat) {
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedCategory = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Description
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Describe ingredients or taste...',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Image URL
                    TextFormField(
                      controller: _imageController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        hintText: 'https://...',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter image URL';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Available Options
                    TextFormField(
                      controller: _optionsController,
                      decoration: const InputDecoration(
                        labelText: 'Available Options (Comma separated)',
                        hintText: 'e.g., Thin Crust, Pan Pizza, Cheese Burst',
                        helperText: 'Leave empty for defaults based on category',
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _saveForm,
                      child: Text(isEditMode ? 'UPDATE ITEM' : 'ADD ITEM'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
