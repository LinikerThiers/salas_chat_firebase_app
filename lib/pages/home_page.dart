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

  // IconData getIconFromString(String iconName) {
  //   switch (iconName) {
  //     case 'chat':
  //       return Icons.chat;
  //     case 'bookmark':
  //       return Icons.bookmark;
  //     case 'sports_soccer':
  //       return Icons.sports_soccer;
  //     case 'sports_football':
  //       return Icons.sports_football;
  //     case 'food_bank':
  //       return Icons.food_bank;
  //     case 'motorcycle_rounded':
  //       return Icons.motorcycle_rounded;
  //     case 'music_note':
  //       return Icons.music_note;
  //     default:
  //       return Icons.chat;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        title: Text(
          "Chats",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              color: Colors.grey.shade600,
              height: 0.5,
            )),
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
              // final iconName = data['icon'] ?? 'chat';
              // final salaIcon = getIconFromString(iconName);

              return Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: Text(
                        salaNome,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      leading: Icon(
                        Icons.chat,
                        size: 25,
                        color: Color(0xFF33A7FE),
                      ),
                      onTap: () {
                        setState(() {});
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color(0xFFE4E5E9).withOpacity(0.9),
                                title: const Text(
                                  "Entre com um nickname",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      textAlign: TextAlign.center,
                                      controller: nicknameController,
                                      decoration: InputDecoration(
                                        hintText: "Digite seu nickname",
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 15,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: Color(0xFF0070FA),
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      height: 1,
                                      width: double.infinity,
                                      child: ColoredBox(
                                          color: Colors.grey.shade400),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          var userId =
                                              prefs.getString('user_id')!;
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
                                        child: Text(
                                          "Entrar",
                                          style: TextStyle(
                                            color: Color(0xFF0070FA),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        )),
                                    SizedBox(
                                      height: 1,
                                      width: double.infinity,
                                      child: ColoredBox(
                                          color: Colors.grey.shade400),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancelar",
                                            style: TextStyle(
                                              color: Color(0xFF0070FA),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                            ))),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 1,
                    width: double.infinity,
                    child: ColoredBox(color: Colors.grey.shade400),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
