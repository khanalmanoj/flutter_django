import 'package:flutter/material.dart';
import 'package:flutter_app/new/CartPage.dart';
import 'package:flutter_app/new/FoodViewModel.dart';
import 'package:flutter_app/new/MyHomePage.dart';
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
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FoodViewModel>(
            create: (context) => FoodViewModel()),
      ],
      child: MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text('JSON Retrieval Example'),
        ),
        body: [
          const HomePage(),
          const CartPage(),
          const Text('History Page'),
          const Text('Profile Page'),
        ].elementAt(_currentIndex),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations:  [
            const NavigationDestination(
              icon: Badge(child: Icon(Icons.home)),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Badge(
                  label:
                      Consumer<FoodViewModel>(builder: (context, data, child) {
                    return Text(data.countCart.toString());
                  }),
                  child: const Icon(Icons.shopping_cart)),
              label: 'Orders',
            ),
            const NavigationDestination(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      )),
    );
  }
}
