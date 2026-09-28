import 'package:flutter/material.dart';
import 'api_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';
  bool _cargando = false;

  Future<void> _registrarse() async {
    if (_nombreController.text.isEmpty ||
        _apellidosController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _error = 'Todos los campos son obligatorios';
      });
      return;
    }

    setState(() {
      _cargando = true;
      _error = '';
    });

    try {
      await ApiService.registro(
        _nombreController.text,
        _apellidosController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso, ahora inicia sesión')),
      );
      Navigator.pop(context); // vuelve al login
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
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                  labelText: 'Nombre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _apellidosController,
              decoration: const InputDecoration(
                  labelText: 'Apellidos', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Contraseña', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            _cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registrarse,
                    child: const Text('Registrarme'),
                  ),
          ],
        ),
      ),
    );
  }
}