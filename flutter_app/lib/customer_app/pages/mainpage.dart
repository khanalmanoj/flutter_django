// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_app/authentication/auth_api.dart';
import 'package:flutter_app/authentication/loginmodel.dart';
import 'package:flutter_app/authentication/loginpage.dart';
import 'package:flutter_app/authentication/user_cubit.dart';
import 'package:flutter_app/customer_app/pages/color_schemes.g.dart';
import 'package:flutter_app/customer_app/pages/orderpage.dart';
import 'package:flutter_app/customer_app/pages/historypage.dart';
import 'package:flutter_app/customer_app/pages/menupage.dart';
import 'package:flutter_app/customer_app/pages/profile_page.dart';
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
    User user = context.read<UserCubit>().state;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: lightColorScheme),
      home: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          _showBackDialog();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Qrunch',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await logoutUser(user.token!);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  },
                  child: const Text(
                    'Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ))
            ],
          ),
          body: [
            const MenuPage(),
            const CartScreens(),
            const CheckOutPage(),
            const ProfilePage()
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
        ),
      ),
    );
  }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to logout and exit?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                logoutUser(context.read<UserCubit>().state.token!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
