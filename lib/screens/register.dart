import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible, // Tampilkan atau sembunyikan password
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible, // Tampilkan atau sembunyikan password
              decoration: InputDecoration(
                labelText: "Confirm Password",
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final error = authProvider.register(
                  _usernameController.text.trim(),
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                  _confirmPasswordController.text.trim(),
                );
                if (error != null) {
                  setState(() {
                    _errorMessage = error;
                  });
                } else {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: const Text(
                "Register",
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
