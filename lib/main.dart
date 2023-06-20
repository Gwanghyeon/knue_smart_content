import 'package:flutter/material.dart';
import 'package:knue_smart_content/common/const/design.dart';
import 'package:knue_smart_content/view/initial_screen.dart';

void main() async {
  //  데이터베이스 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KNUE Smart Contents',
      theme: mainTheme(true),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const InitialScreen(),
    );
  }
}
