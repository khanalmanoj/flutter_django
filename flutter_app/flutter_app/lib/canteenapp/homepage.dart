import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/orderspage.dart';
import 'package:flutter_app/canteenapp/qrscanpage.dart';
import 'package:flutter_app/canteenapp/sales_analysis.dart';
import 'package:flutter_app/user_app/pages/color_schemes.g.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightColorScheme,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Qrunch(Admin)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        body: [
          const AllOrdersPage(),
          const QRScannerScreen(),
          const SalesAnalysis(),
        ].elementAt(_currentIndex),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedIndex: _currentIndex,
          destinations: const [
            NavigationDestination(
              icon: Badge(child: Icon(Icons.menu)),
              label: 'All Orders',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.qr_code_scanner)),
              label: 'Scan QR',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics),
              label: 'Sales Analysis',
            ),
          ],
        ),
      ),
    );
  }
}
