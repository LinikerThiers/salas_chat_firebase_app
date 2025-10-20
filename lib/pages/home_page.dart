import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salas_chat_firebase_app/pages/chat/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var nicknameController = TextEditingController();

  IconData getIconFromString(String iconName) {
    switch (iconName) {
      case 'chat':
        return Icons.chat;
      case 'bookmark':
        return Icons.bookmark;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'sports_football':
        return Icons.sports_football;
      case 'food_bank':
        return Icons.food_bank;
      case 'motorcycle_rounded':
        return Icons.motorcycle_rounded;
      case 'music_note':
        return Icons.music_note;
      default:
        return Icons.chat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text("Chats"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('salas').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhuma sala disponível"));
          }

          final salas = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: salas.length,
            itemBuilder: (context, index) {
              final data = salas[index].data() as Map<String, dynamic>;
              final salaNome = data['sala'] ?? 'Sala sem nome';
              final iconName = data['icon'] ?? 'chat';
              final salaIcon = getIconFromString(iconName);

              return ListTile(
                title: Text(salaNome),
                leading: Icon(salaIcon),
                onTap: () {
                  setState(() {});
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Entre com um nickname"),
                          content: TextField(
                            controller: nicknameController,
                            decoration: InputDecoration(
                              hintText: "Nickname",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                var userId = prefs.getString('user_id')!;
                                String nickname =
                                    nicknameController.text.trim();
                                if (nickname.isNotEmpty) {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ChatPage(
                                                chatName: salaNome,
                                                nickname: nickname,
                                                userId: userId,
                                              )));
                                }
                                nicknameController.clear();
                              },
                              child: const Text("Entrar"),
                            ),
                          ],
                        );
                      });
                },
              );
            },
          );
        },
      ),
    );
  }
}
