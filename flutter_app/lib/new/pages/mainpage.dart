import 'package:flutter/material.dart';
import 'package:flutter_app/new/pages/orderpage.dart';
import 'package:flutter_app/new/pages/historypage.dart';
import 'package:flutter_app/new/pages/menupage.dart';


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
        const CartScreens(),
        const CheckOutPage(),
        const Text("Profile")
      ].elementAt(_currentIndex),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Badge(child: Icon(Icons.home)),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Badge(
                label: Text('2'),
                // Consumer<FoodViewModel>(builder: (context, data, child) {
                //   return Text(data.countCart.toString());
                // }),
                child: Icon(Icons.shopping_cart)),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
