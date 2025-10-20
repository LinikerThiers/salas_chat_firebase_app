import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var nicknameController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text("Chats"),
      ),
      body: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
      return ListTile(
        title: Text("Sala ${index + 1}"),
        leading: const Icon(Icons.chat),
        onTap: () {
          setState(() {
          });
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text("Entre com um nickname"),
              content: TextField(
                controller: nicknameController,
                decoration: const InputDecoration(
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
                  onPressed: () {
                    String nickname = nicknameController.text.trim();
                    if (nickname.isNotEmpty) {
                      // Lógica para entrar na sala com o nickname
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Entrar"),
                ),
              ],
            );
          });
        },
      );
              },
            ),
    );
  }
}
