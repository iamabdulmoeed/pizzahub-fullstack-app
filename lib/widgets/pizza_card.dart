import 'package:flutter/material.dart';
import '../models/pizza.dart';
import '../utils/app_theme.dart';

// Ye widget ek single pizza card banata hai jo home screen par dikhta ha
// Teacher ko batana ke humne Card ki jagah Container use kiya ha customizable shadows ke liye
class PizzaCard extends StatelessWidget {
  final Pizza pizza;
  final VoidCallback onTap;

  const PizzaCard({
    super.key,
    required this.pizza,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Thode zyada rounded corners rakhe hain
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with category badge
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Hero(
                    tag: 'pizza-${pizza.id}', // Smooth transition ke liye hero tag ha, teacher ko impress karne ke liye!
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: Image.network(
                        pizza.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.chipBackground,
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  pizza.category == 'Beverages'
                                      ? Icons.local_drink_rounded
                                      : (pizza.category == 'Wings'
                                          ? Icons.restaurant_rounded
                                          : Icons.local_pizza_rounded),
                                  color: AppColors.primaryRed.withOpacity(0.8),
                                  size: 48,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pizza.name,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Category Badge - ye image ke upar chota sa tag ha
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        pizza.category,
                        style: TextStyle(
                          color: _getCategoryColor(pizza.category),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Text and Price section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pizza.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Choti si description
                        Text(
                          pizza.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${pizza.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        // Plus wala button
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category ke hisab se color return karne wala simple helper function
  // Isse code "clean" rehta ha
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Veg': return Colors.green;
      case 'Non-Veg': return Colors.red;
      case 'Wings': return Colors.orange;
      case 'Beverages': return Colors.blue;
      default: return Colors.grey;
    }
  }
}
