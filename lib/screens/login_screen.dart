import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/guest_provider.dart';
import 'form_screen.dart';
import 'history_screen.dart';
import 'admin_screen.dart';
import 'main_app_screen.dart'; // ✅ Tambahkan ini!

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username == 'akbar' && password == 'puki') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainAppScreen()), // ✅ Sekarang sudah bisa
      );
    } else {
      setState(() {
        _errorText = 'Username atau password salah!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Login Admin", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Text(_errorText!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
