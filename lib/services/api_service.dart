import 'dart:convert';

import 'package:flutter_drud/models/post.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const baseUrl= 'https://jsonplaceholder.typicode.com/posts';
  Future<List<Post>> fetchPosts() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Error ${response.statusCode}: No se pudo leer los datos');
    }
  } catch (e) {
    throw Exception('❌ Error de conexión: $e');
  }
}

  Future<Post> fechPostBytId(int id) async{
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if(response.statusCode==200){
      return Post.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error al leer los datos...!');
    }
  }
  Future<void> createPost(Post post) async{
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode(post.toJson()),
    );
    if(response.statusCode !=201){
      throw Exception('Error al crear la publicación...!');
    }
  }
    Future<void> deletePost(int id) async{
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if(response.statusCode !=201){
      throw Exception('Error al eliminar la publicación...!');
    }
    }

}