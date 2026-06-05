import 'package:flutter/material.dart';
import '../models/pizza.dart';
import '../utils/app_theme.dart';
import 'order_form_screen.dart';

// Ye screen kisi bhi item ki detail dikhati ha aur customization allow karti ha
// Isme humne StatefulWidget use kiya ha taake crust/style selection save ho sake
class DetailsScreen extends StatefulWidget {
  final Pizza pizza;

  const DetailsScreen({super.key, required this.pizza});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // Default option select karne ke liye, teacher ko bolna ke ye logic hamne initState mein dala ha
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    // Shuru mein pehla option select hoga, easy peasy!
    _selectedOption = widget.pizza.availableOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          // Scrolling content ke liye CustomScrollView use kiya ha taake header "sticky" rahe
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildDescription(),
                      const SizedBox(height: 30),
                      _buildOptionsSection(), // Crust ya style select karne ke liye
                      const SizedBox(height: 30),
                      _buildIngredients(),
                      const SizedBox(height: 120), // Neeche wale button ke liye thodi jagah
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Add to Cart wala floating button
          _buildBottomButton(),
        ],
      ),
    );
  }

  // Header image aur back button
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryRed,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'pizza-${widget.pizza.id}', // Ye hero tag home screen ke card se match karta ha
          child: Image.network(
            widget.pizza.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.chipBackground,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.pizza.category == 'Beverages'
                            ? Icons.local_drink_rounded
                            : (widget.pizza.category == 'Wings'
                                ? Icons.restaurant_rounded
                                : Icons.local_pizza_rounded),
                        color: AppColors.primaryRed.withOpacity(0.8),
                        size: 96,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.pizza.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textMain),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.favorite_border_rounded, color: AppColors.textMain),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  // Name, Price aur Rating wala section
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.pizza.name,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '\$${widget.pizza.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.primaryRed,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.pizza.category,
                style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 15),
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            const Text('4.8 (2.5k reviews)', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  // Item ki choti si detail
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(
          widget.pizza.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Crust ya Wings ka style select karne wala section
  Widget _buildOptionsSection() {
    // Category dekh kar hum title set karte hain
    String title = widget.pizza.category == 'Wings' ? 'Choose Style' : (widget.pizza.category == 'Beverages' ? 'Preference' : 'Choose Crust');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 12,
          children: widget.pizza.availableOptions.map((option) {
            final isSelected = _selectedOption == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (val) {
                setState(() => _selectedOption = option); // Option update karne ke liye setState
              },
              selectedColor: AppColors.primaryRed,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textMain,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppColors.chipBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              side: BorderSide.none,
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Key Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _featureItem(Icons.timer_outlined, '25-30 min'),
            _featureItem(Icons.local_fire_department_outlined, '450 Cal'),
            _featureItem(Icons.verified_user_outlined, 'Freshly Made'),
          ],
        ),
      ],
    );
  }

  Widget _featureItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryRed),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderFormScreen(
                  pizza: widget.pizza,
                  selectedOption: _selectedOption,
                ),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined),
              SizedBox(width: 12),
              Text('ORDER NOW'),
            ],
          ),
        ),
      ),
    );
  }
}
