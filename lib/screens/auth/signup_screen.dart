import 'package:flutter/material.dart';
import 'package:my_flutter/main.dart'; // For AppColors

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign-up',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textColor,
                    fontSize: 32,
                  ),
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail address',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Create password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Handle Sign-up logic
                print('Sign Up Button Pressed');
                print('Full Name: ${_fullNameController.text}');
                print('Email: ${_emailController.text}');
                print('Password: ${_passwordController.text}');
              },
              child: const Text('Sign-up'),
            ),
            const SizedBox(height: 20),
            // Placeholder for Google Sign-up (to be implemented)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Or sign-up with Google', style: TextStyle(color: AppColors.lightGrey)),
                TextButton(
                  onPressed: () {
                    // Handle Google Sign-up
                  },
                  child: const Icon(Icons.g_mobiledata, size: 30, color: AppColors.accentPurple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 