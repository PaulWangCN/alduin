import 'package:flutter/material.dart';
import 'package:alduin/zhihu.dart';
import 'package:alduin/person.dart';

void main() {
  runApp(const AlduinApp());
}

class AlduinApp extends StatelessWidget {
  const AlduinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '发现每天热点',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '发现每天热点'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentIndex = 0;

  currentPage() {
    switch (currentIndex) {
      case 0:
        return const ZhihuHot();
      case 1:
        return const Person();
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: ((index) {
          setState(() {
            currentIndex = index;
          });
        }),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: '知乎'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '我的'
          ),
        ],
      ),
    );
  }
}
