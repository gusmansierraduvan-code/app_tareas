import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Usamos localhost porque corres la app en Chrome
  static const String _baseUrl = 'http://localhost:3000';

  // LOGIN: manda email y password, recibe el token
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final respuesta = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final datos = jsonDecode(respuesta.body);
    if (respuesta.statusCode == 200) {
      return datos;
    } else {
      throw Exception(datos['error']);
    }
  }
    // REGISTRO: crea un usuario nuevo
  static Future<void> registro(
      String nombre, String apellidos, String email, String password) async {
    final respuesta = await http.post(
      Uri.parse('$_baseUrl/registro'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'apellidos': apellidos,
        'email': email,
        'password': password,
      }),
    );
    if (respuesta.statusCode != 201) {
      final datos = jsonDecode(respuesta.body);
      throw Exception(datos['error']);
    }
  }

  // LEER: trae las tareas del usuario
  static Future<List<dynamic>> obtenerTareas(String token) async {
    final respuesta = await http.get(
      Uri.parse('$_baseUrl/tareas'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(respuesta.body);
  }

  // CREAR: agrega una tarea nueva
  static Future<void> agregarTarea(String token, String titulo) async {
    await http.post(
      Uri.parse('$_baseUrl/tareas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'titulo': titulo}),
    );
  }

  // ACTUALIZAR: marca una tarea como completada o no
  static Future<void> actualizarTarea(String token, int id, bool completada) async {
    await http.put(
      Uri.parse('$_baseUrl/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'completada': completada ? 1 : 0}),
    );
  }

  // ELIMINAR: borra una tarea
  static Future<void> eliminarTarea(String token, int id) async {
    await http.delete(
      Uri.parse('$_baseUrl/tareas/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}