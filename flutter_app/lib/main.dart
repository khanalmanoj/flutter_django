import 'package:flutter/material.dart';
import 'package:flutter_app/models/FoodViewModel.dart';
import 'package:flutter_app/new/login/loginpage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FoodViewModel>(
              create: (context) => FoodViewModel()),
        ],
        child: const MaterialApp(
          home: LoginPage(),
        ));
  }
}
