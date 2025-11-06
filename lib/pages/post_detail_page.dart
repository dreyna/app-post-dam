import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostDetailPage extends StatelessWidget {
  final int postId;
  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final ApiService api = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Publicación')),
      body: FutureBuilder<Post>(
        future: api.fechPostBytId(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final post = snapshot.data;
          if (post == null) {
            return const Center(child: Text('Publicación no encontrada'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(post.body, style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
