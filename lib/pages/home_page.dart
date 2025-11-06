import 'package:flutter/material.dart';
import 'package:flutter_drud/pages/post_detail_page.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicaciones')),
      body: FutureBuilder<List<Post>>(
        future: api.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(child: Text('No hay publicaciones.'));
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(post.title),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(postId: post.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: const Text('Nueva Publicación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: bodyCtrl,
                decoration: const InputDecoration(labelText: 'Contenido'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialog),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nuevo = Post(
                  id: 0,
                  userId: 1,
                  title: titleCtrl.text,
                  body: bodyCtrl.text,
                );
                await api.createPost(nuevo);
                if (!mounted) return;
                if (!contextDialog.mounted) return;
                Navigator.pop(contextDialog);
                setState(() {}); 
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
