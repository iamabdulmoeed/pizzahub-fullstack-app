import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pizza_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/pizza_card.dart';
import 'details_screen.dart';
import 'admin_pizzas_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load pizzas from backend on startup
    Future.microtask(() =>
        Provider.of<PizzaProvider>(context, listen: false).fetchPizzas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('PizzaHub'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPizzasScreen()),
              );
            },
            icon: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryRed),
            tooltip: 'Admin Panel',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              );
            },
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryRed),
            tooltip: 'My Orders',
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          _buildSearchAndFilter(context),
          Expanded(
            child: Consumer<PizzaProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.pizzas.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
                }

                if (provider.error.isNotEmpty && provider.pizzas.isEmpty) {
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

                return RefreshIndicator(
                  onRefresh: () => provider.fetchPizzas(),
                  color: AppColors.primaryRed,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildPromoBanner(),
                        _buildProductGrid(provider),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // Drawer section - Profile aur baki options ke liye
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryRed, AppColors.accentRed],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_rounded, size: 35, color: AppColors.primaryRed),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Abdul Moeed',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'abdul@pizzahub.com',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          _drawerItem(Icons.home_rounded, 'Home', () => Navigator.pop(context)),
          _drawerItem(Icons.person_rounded, 'My Profile', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }),
          _drawerItem(Icons.history_rounded, 'My Orders', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
            );
          }),
          _drawerItem(Icons.admin_panel_settings_rounded, 'Manage Menu (Admin)', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminPizzasScreen()),
            );
          }),
          _drawerItem(Icons.favorite_rounded, 'Favorites', () => Navigator.pop(context)),
          const Divider(indent: 20, endIndent: 20),
          _drawerItem(Icons.logout_rounded, 'Logout', () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textMain),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  // Search Bar aur Category Chips
  Widget _buildSearchAndFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              Provider.of<PizzaProvider>(context, listen: false).setSearchQuery(value);
            },
            decoration: InputDecoration(
              hintText: 'Search delicious pizza...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryRed),
              filled: true,
              fillColor: AppColors.chipBackground,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Consumer<PizzaProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: ['All', 'Veg', 'Non-Veg', 'Wings', 'Beverages'].map((cat) {
                    final isSelected = provider.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) => provider.setCategory(cat),
                        selectedColor: AppColors.primaryRed,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textMain,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        backgroundColor: Colors.white,
                        elevation: isSelected ? 4 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: isSelected ? AppColors.primaryRed : Colors.grey.shade300),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryRed, AppColors.accentRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.local_pizza_rounded, size: 120, color: Colors.white.withOpacity(0.15)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Flat 50% OFF',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              const Text(
                'On your first order! Use code PIZZA50',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryRed,
                  minimumSize: const Size(130, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: const Text('Order Now', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(PizzaProvider provider) {
    final pizzas = provider.pizzas;
    if (pizzas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: Text('No items found! Try another search.')),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: pizzas.length,
      itemBuilder: (context, index) {
        final pizza = pizzas[index];
        return PizzaCard(
          pizza: pizza,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(pizza: pizza),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      elevation: 10,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primaryRed,
      unselectedItemColor: AppColors.textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        if (index == 3) {
          // Go to Profile Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (index == 2) {
          // Go to Order History
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }
}
