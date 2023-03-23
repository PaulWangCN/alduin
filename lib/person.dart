import 'package:flutter/material.dart';

class Person extends StatefulWidget {
  const Person({super.key});

  @override
  State<StatefulWidget> createState() => _Person();
}

class _Person extends State<Person> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'welcome to alduin person page',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
