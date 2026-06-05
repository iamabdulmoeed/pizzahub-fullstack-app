import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

// Ye hamari login screen ha, yahan user apna email aur password daal kar enter hota ha
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form ki validation check karne ke liye key
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Login button press hone par ye function chalta ha
  void _login() {
    if (_formKey.currentState!.validate()) {
      // Agar sab sahi ha to home screen par le jao
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                // App Logo ya Icon
                const Center(
                  child: Icon(
                    Icons.local_pizza_rounded,
                    size: 100,
                    color: AppColors.primaryRed,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to your account to continue ordering your favorite pizza.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                ),
                const SizedBox(height: 40),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryRed),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter email';
                    if (!value.contains('@')) return 'Invalid email format';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryRed),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter password';
                    if (value.length < 6) return 'Password too short';
                    return null;
                  },
                ),
                
                // Forgot Password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Login Button
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('LOGIN'),
                ),
                const SizedBox(height: 24),
                
                // Switch to Signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
