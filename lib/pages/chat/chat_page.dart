import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salas_chat_firebase_app/models/chat_model.dart';

class ChatPage extends StatefulWidget {
  final String chatName;
  final String nickname;
  final String userId;
  const ChatPage(
      {super.key,
      required this.chatName,
      required this.nickname,
      required this.userId});

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
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
          title: Text(
            widget.chatName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(
                color: Colors.grey.shade600,
                height: 0.5,
              )),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 8),
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
                            color:
                                myMsg ? Color(0xFF33A7FE) : Color(0xFFE9E9EB),
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
                        hintText: "Mensagem de Texto",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Color(0xFF989898)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Color(0xFF989898)),
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Color(0xFF33C758),
                    child: IconButton(
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
                      icon: Icon(Icons.arrow_upward, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
