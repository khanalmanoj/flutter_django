import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/homepage.dart';
import 'package:flutter_app/canteenapp/orders_state.dart';
import 'package:flutter_app/models/FoodViewModel.dart';
import 'package:flutter_app/new/authentication/loginmodel.dart';
import 'package:flutter_app/new/authentication/loginpage.dart';
import 'package:flutter_app/new/authentication/registerpage.dart';
import 'package:flutter_app/new/authentication/user_cubit.dart';
import 'package:flutter_app/state/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit(User())),
        ChangeNotifierProvider<OrderState>(
          create: (context) => OrderState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    return MultiProvider(providers: [
      ChangeNotifierProvider<CartState>(
          create: (context) => CartState(userCubit.state.token)),
      ChangeNotifierProvider<FoodViewModel>(
          create: (context) => FoodViewModel(userCubit.state.token)),
    ], child: const MaterialApp(home: RegisterPage()));
  }
}
