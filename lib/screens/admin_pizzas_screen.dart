import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pizza_provider.dart';
import 'pizza_form_screen.dart';
import '../utils/app_theme.dart';

class AdminPizzasScreen extends StatefulWidget {
  const AdminPizzasScreen({super.key});

  @override
  State<AdminPizzasScreen> createState() => _AdminPizzasScreenState();
}

class _AdminPizzasScreenState extends State<AdminPizzasScreen> {
  @override
  void initState() {
    super.initState();
    // Load latest data on enter
    Future.microtask(() =>
        Provider.of<PizzaProvider>(context, listen: false).fetchPizzas());
  }

  void _deletePizza(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete "$name" from the menu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              minimumSize: const Size(80, 40),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await Provider.of<PizzaProvider>(context, listen: false).deletePizza(id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted "$name" successfully.'),
                    backgroundColor: AppColors.primaryRed,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete item.'),
                    backgroundColor: Colors.black,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                Provider.of<PizzaProvider>(context, listen: false).fetchPizzas(),
          )
        ],
      ),
      body: Consumer<PizzaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.rawPizzas.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
          }

          if (provider.error.isNotEmpty && provider.rawPizzas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 60, color: AppColors.primaryRed),
                    const SizedBox(height: 16),
                    Text(provider.error, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchPizzas(),
                      child: const Text('RETRY'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.rawPizzas.isEmpty) {
            return const Center(
              child: Text(
                'No menu items found. Tap "+" to add one!',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchPizzas(),
            color: AppColors.primaryRed,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: provider.rawPizzas.length,
              itemBuilder: (context, index) {
                final pizza = provider.rawPizzas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: AppColors.surfaceWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Pizza image thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            pizza.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 70,
                              height: 70,
                              color: AppColors.chipBackground,
                              child: const Icon(Icons.local_pizza_rounded, color: AppColors.primaryRed),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pizza.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textMain,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${pizza.price.toStringAsFixed(2)} - ${pizza.category}',
                                style: const TextStyle(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pizza.availableOptions.join(', '),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Edit & Delete Actions
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PizzaFormScreen(pizza: pizza),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.primaryRed),
                              onPressed: () => _deletePizza(context, pizza.id, pizza.name),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PizzaFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
