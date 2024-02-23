import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/orderspage.dart';
import 'package:flutter_app/canteenapp/qrscanpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qrunch'),
      ),
      body: [
        const CheckOutPage(),
        const QRScannerScreen(),
        const Text("Sales Analysis")
      ].elementAt(_currentIndex),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Badge(child: Icon(Icons.menu)),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Badge(
                child: Icon(Icons.qr_code_scanner)),
            label: 'ScanQR',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Sales Analysis',
          ),
        ],
      ),
    );
  }
}