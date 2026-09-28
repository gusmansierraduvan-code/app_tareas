import 'package:flutter/material.dart';
import 'api_service.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      // Ahora la app empieza en el login, no en la lista
      home: const LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.token});

  final String title;
  final String token; // el "pase" que nos dio el login

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _tareas = [];
  final TextEditingController _controladorTexto = TextEditingController();

  // initState se ejecuta UNA vez, cuando la pantalla se abre
  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  // LEER: trae las tareas desde la base de datos
  Future<void> _cargarTareas() async {
    final tareas = await ApiService.obtenerTareas(widget.token);
    setState(() {
      _tareas = tareas;
    });
  }

  // CREAR
  Future<void> _agregarTarea() async {
    if (_controladorTexto.text.isNotEmpty) {
      await ApiService.agregarTarea(widget.token, _controladorTexto.text);
      _controladorTexto.clear();
      _cargarTareas();
    }
  }

  // ACTUALIZAR
  Future<void> _actualizarTarea(int id, bool completada) async {
    await ApiService.actualizarTarea(widget.token, id, completada);
    _cargarTareas();
  }

  // ELIMINAR
  Future<void> _eliminarTarea(int id) async {
    await ApiService.eliminarTarea(widget.token, id);
    _cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorTexto,
                    decoration: const InputDecoration(
                      labelText: 'Nueva tarea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _agregarTarea,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return CheckboxListTile(
                  value: tarea['completada'] == 1,
                  title: Text(tarea['titulo']),
                  onChanged: (bool? nuevoValor) {
                    _actualizarTarea(tarea['id'], nuevoValor ?? false);
                  },
                  secondary: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarTarea(tarea['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}