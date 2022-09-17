import 'package:flutter/material.dart';
import 'package:android_app_todo_list_flutter/pages/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const ToDoListApp());
}

class ToDoListApp extends StatelessWidget {

  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'To-do List',
      home: const HomeScreen(),
      theme: ThemeData(
          primarySwatch: Colors.lime,
          scaffoldBackgroundColor: Colors.black
      ),
    );
  }
}