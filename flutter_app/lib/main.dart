import 'package:flutter/material.dart';
import 'package:flutter_app/models/FoodViewModel.dart';
import 'package:flutter_app/new/login/loginmodel.dart';
import 'package:flutter_app/new/login/loginpage.dart';
import 'package:flutter_app/new/login/user_cubit.dart';
import 'package:flutter_app/state/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit(User())),
        ChangeNotifierProvider<FoodViewModel>(
          create: (context) => FoodViewModel(),
        ),
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
    return ChangeNotifierProvider(
        create: (context) => CartState(userCubit.state.token),
        child: const MaterialApp(home: LoginPage()));
  }
}
