import 'package:flutter/material.dart';
import 'package:salas_chat_firebase_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    carregarHomePage();
  }

  carregarHomePage() async {
    final prefs = await SharedPreferences.getInstance();
    var uuid = Uuid();
    var userId = prefs.getString('user_id');
    if (userId == null || userId.isEmpty) {
      userId = uuid.v4();
      await prefs.setString('user_id', userId);
    }
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage(title: "Chats")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
