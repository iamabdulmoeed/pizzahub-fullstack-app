import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_form_screen.dart';
import '../utils/app_theme.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OrderProvider>(context, listen: false).fetchOrders());
  }

  void _cancelOrder(BuildContext context, String id, String itemName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel your order for $itemName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              minimumSize: const Size(80, 40),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await Provider.of<OrderProvider>(context, listen: false).cancelOrder(id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cancelled order for $itemName successfully.'),
                    backgroundColor: AppColors.primaryRed,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to cancel order.'),
                    backgroundColor: Colors.black,
                  ),
                );
              }
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
          )
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
          }

          if (provider.error.isNotEmpty && provider.orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_outlined, size: 60, color: AppColors.primaryRed),
                    const SizedBox(height: 16),
                    Text(provider.error, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchOrders(),
                      child: const Text('RETRY'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 60, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    'No orders placed yet.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchOrders(),
            color: AppColors.primaryRed,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.orders.length,
              itemBuilder: (context, index) {
                final order = provider.orders[index];
                final formattedDate = "${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year} ${order.orderDate.hour}:${order.orderDate.minute.toString().padLeft(2, '0')}";
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: AppColors.surfaceWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${order.quantity}x ${order.pizzaName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                            Text(
                              '\$${order.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textMain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Option Selected: ${order.crustOption}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),

                        // Delivery Info
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.chipBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 14, color: AppColors.primaryRed),
                                  const SizedBox(width: 6),
                                  Text(order.customerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 14, color: AppColors.primaryRed),
                                  const SizedBox(width: 6),
                                  Text(order.customerPhone, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: AppColors.primaryRed),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      order.customerAddress,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Cancel and Edit Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderFormScreen(order: order),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.blue),
                              label: const Text('Edit Order', style: TextStyle(color: Colors.blue, fontSize: 13)),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => _cancelOrder(context, order.id, order.pizzaName),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryRed),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.primaryRed),
                              label: const Text('Cancel Order', style: TextStyle(color: AppColors.primaryRed, fontSize: 13)),
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
    );
  }
}
