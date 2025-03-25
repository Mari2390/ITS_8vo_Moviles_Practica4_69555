import 'package:flutter/material.dart';
import '../api_service.dart';
import 'register_screen.dart';
import '../main.dart'; // Importamos TaskScreen desde aquí

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      String token = await ApiService.login(_emailCtrl.text, _passwordCtrl.text);
      print('Token: $token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TaskScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Correo"),
                validator: (value) {
                  if (value == null || !value.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 8) return 'Mínimo 8 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _login, child: const Text("Ingresar")),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text("¿No tienes cuenta? Regístrate"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
