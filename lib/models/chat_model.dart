import 'package:cloud_firestore/cloud_firestore.dart';

class Sala {
  String nome = "";
  String id = "";
  List<Mensagem>? mensagens;

  Sala({required this.id, required this.nome, this.mensagens});

  Sala.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    if (json['mensagens'] != null) {
      mensagens = <Mensagem>[];
      json['mensagens'].forEach((v) {
        mensagens!.add(Mensagem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nome'] = nome;
    if (mensagens != null) {
      data['mensagens'] = mensagens!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mensagem {
  DateTime dataHora = DateTime.now();
  String text = "";
  String userId = "";
  String nickname = "";

  Mensagem({required this.text, required this.userId, required this.nickname});

  Mensagem.fromJson(Map<String, dynamic> json) {
    dataHora = (json['data_hora'] as Timestamp).toDate();
    text = json['text'];
    userId = json['user_id'];
    nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data_hora'] = Timestamp.fromDate(dataHora);
    data['text'] = text;
    data['user_id'] = userId;
    data['nickname'] = nickname;
    return data;
  }
}
