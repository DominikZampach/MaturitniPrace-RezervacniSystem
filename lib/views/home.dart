import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Home"));
  }
}
