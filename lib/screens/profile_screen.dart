import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'order_history_screen.dart';
import 'admin_pizzas_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock profile data
  String _name = 'Abdul Moeed';
  String _email = 'abdul@pizzahub.com';
  String _phone = '+92 300 1234567';
  String _address = 'House #123, Street 5, Sector F-11/1, Islamabad';

  void _editProfileDialog() {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);
    final addressController = TextEditingController(text: _address);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Delivery Address'),
                maxLines: 2,
              ),
            ],
          ),
        ),
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
            onPressed: () {
              setState(() {
                _name = nameController.text.trim();
                _email = emailController.text.trim();
                _phone = phoneController.text.trim();
                _address = addressController.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: AppColors.primaryRed,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Gradient Header
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryRed, AppColors.accentRed],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.white),
                            onPressed: _editProfileDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Avatar
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 65,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _editProfileDialog,
                                child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 16,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User identity
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Contact details section
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    items: [
                      _infoItem(Icons.phone_rounded, 'Phone', _phone),
                      _infoItem(Icons.location_on_rounded, 'Address', _address),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Account actions section
                  const Text(
                    'Account Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    items: [
                      _actionItem(
                        Icons.shopping_bag_rounded,
                        'My Orders',
                        'View order history & track items',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                        ),
                      ),
                      _actionItem(
                        Icons.admin_panel_settings_rounded,
                        'Admin Panel',
                        'Manage pizza menu items & options',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminPizzasScreen()),
                        ),
                      ),
                      _actionItem(
                        Icons.logout_rounded,
                        'Log Out',
                        'Sign out of your account',
                        () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Log Out'),
                              content: const Text('Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryRed,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(ctx); // Close dialog
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('Log Out'),
                                ),
                              ],
                            ),
                          );
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> items}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: items,
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryRed.withOpacity(0.1),
            child: Icon(icon, size: 18, color: AppColors.primaryRed),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({required List<Widget> items}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: items,
        ),
      ),
    );
  }

  Widget _actionItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.primaryRed : AppColors.textMain;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isDestructive
                  ? AppColors.primaryRed.withOpacity(0.1)
                  : AppColors.chipBackground,
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? AppColors.primaryRed : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: isDestructive ? AppColors.primaryRed : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
