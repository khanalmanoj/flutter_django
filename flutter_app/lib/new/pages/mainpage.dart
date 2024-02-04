import 'package:flutter/material.dart';
import 'package:flutter_app/models/FoodViewModel.dart';
import 'package:flutter_app/new/pages/menupage.dart';
import 'package:flutter_app/new/pages/orderpage.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qrunch'),
      ),
      body: [
        const MenuPage(),
        const OrderPage(),
        const Text('History'),
        const Text('Profile'),
      ].elementAt(_currentIndex),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Badge(child: Icon(Icons.home)),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Badge(
                label: Consumer<FoodViewModel>(builder: (context, data, child) {
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
    );
  }
}
