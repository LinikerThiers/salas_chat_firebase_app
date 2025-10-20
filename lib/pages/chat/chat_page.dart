import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salas_chat_firebase_app/models/chat_model.dart';

class ChatPage extends StatefulWidget {
  final String chatName;
  final String nickname;
  final String userId;
  const ChatPage({super.key, required this.chatName, required this.nickname, required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messagemController = TextEditingController();
  final db = FirebaseFirestore.instance;
  String userId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chatName),
        ),
        body: Container(
          child: Column(children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('salas')
                    .doc(widget.chatName)
                    .collection('mensagens')
                    .orderBy('data_hora')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final msgData =
                          docs[index].data() as Map<String, dynamic>;
                      final mensagem = Mensagem.fromJson(msgData);

                      bool myMsg = mensagem.userId == widget.userId;

                      return Align(
                        alignment: myMsg
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: myMsg ? Colors.blueAccent : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mensagem.nickname,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: myMsg ? Colors.white : Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mensagem.text,
                                style: TextStyle(
                                    color: myMsg ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 12,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messagemController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[400],
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      if (messagemController.text.trim().isEmpty) return;

                    final msg = Mensagem(
                      text: messagemController.text.trim(),
                      userId: widget.userId,
                      nickname: widget.nickname,
                    );

                    await db
                        .collection('salas')
                        .doc(widget.chatName)
                        .collection('mensagens')
                        .add(msg.toJson());

                    messagemController.clear();
                    },
                    icon: Icon(Icons.send, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
