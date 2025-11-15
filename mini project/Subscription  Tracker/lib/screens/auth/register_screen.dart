import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';   // 🔥 REQUIRED
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../services/auth_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

void _register() async {
  if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All fields are required")),
    );
    return;
  }

  try {
    final user = await AuthService().register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );

    if (user != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful!")),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    }

  } on FirebaseAuthException catch (e) {
    String message = "Registration failed";

    if (e.code == "email-already-in-use") {
      message = "This email is already registered. Try logging in instead.";
    } else if (e.code == "weak-password") {
      message = "Password must be at least 6 characters.";
    } else if (e.code == "invalid-email") {
      message = "Enter a valid email address.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Unexpected error occurred")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Account", style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 30),
              CustomTextField(controller: _nameCtrl, label: "Name"),
              const SizedBox(height: 16),
              CustomTextField(controller: _emailCtrl, label: "Email"),
              const SizedBox(height: 16),
              CustomTextField(controller: _passwordCtrl, label: "Password", obscure: true),
              const SizedBox(height: 24),
              CustomButton(text: "Register", onPressed: _register),
            ],
          ),
        ),
      ),
    );
  }
}