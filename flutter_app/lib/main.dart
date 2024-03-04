import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/orders_state.dart';
import 'package:flutter_app/models/menu_view.dart';
import 'package:flutter_app/user_app/authentication/loginmodel.dart';
import 'package:flutter_app/user_app/authentication/loginpage.dart';
import 'package:flutter_app/user_app/authentication/user_cubit.dart';
import 'package:flutter_app/user_app/pages/mainpage.dart';
import 'package:flutter_app/user_app/state/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit(User())),
        ChangeNotifierProvider<OrderState>(create: (context) => OrderState()),
      ],
      child: const MaterialApp(
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CartState>(
              create: (context) => CartState(userCubit.state.token)),
          ChangeNotifierProvider<FoodViewModel>(
              create: (context) => FoodViewModel(userCubit.state.token)),
        ],
        child: const MaterialApp(
            debugShowCheckedModeBanner: false, home: MainPage()));
  }
}
