import 'package:flutter/material.dart';
import 'package:flutter_app/staff_app/state/orders_state.dart';
import 'package:flutter_app/customer_app/models/menu_view.dart';
import 'package:flutter_app/authentication/loginmodel.dart';
import 'package:flutter_app/authentication/loginpage.dart';
import 'package:flutter_app/authentication/user_cubit.dart';
import 'package:flutter_app/customer_app/pages/mainpage.dart';
import 'package:flutter_app/customer_app/state/cart_state.dart';
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

class CustomerApp extends StatelessWidget {
  const CustomerApp({Key? key}) : super(key: key);

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

// class StaffApp extends StatelessWidget {
//   const StaffApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider<OrderState>(create: (context) => OrderState()),
//           BlocProvider(create: (context) => UserCubit(User())),
//         ],
//         child: const MaterialApp(
//             debugShowCheckedModeBanner: false, home: HomePage()));
//   }
// }
