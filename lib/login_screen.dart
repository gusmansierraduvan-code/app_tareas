import 'package:flutter/material.dart';
import 'api_service.dart';
import 'main.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _error = '';
  bool _cargando = false;

  Future<void> _iniciarSesion() async {
    setState(() {
      _cargando = true;
      _error = '';
    });

    try {
      final datos = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );
      final token = datos['token'];

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyHomePage(title: 'Mi lista de tareas', token: token),
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
                _cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _iniciarSesion,
                    child: const Text('Entrar'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistroScreen()),
                );
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}