import 'package:flutter/material.dart';
import 'package:flutter_app/new/authentication/auth_api.dart';
import 'package:flutter_app/new/authentication/loginmodel.dart';
import 'package:flutter_app/new/authentication/user_cubit.dart';
import 'package:flutter_app/new/pages/mainpage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_app/new/authentication/auth_api.dart';
// import 'package:flutter_app/new/authentication/loginmodel.dart';
// import 'package:flutter_app/new/authentication/user_cubit.dart';
// import 'package:flutter_app/new/pages/mainpage.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  bool check = false;
  bool isvisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Image(image: AssetImage('assets/qrunch.png')),
            const Text(
              'Register  your account',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter username',
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person, color: Colors.green),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(width: 2, color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username cant be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter email',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.green),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(width: 2, color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username cant be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: password1Controller,
                  obscureText: isvisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password cant be empty";
                    } else if (value.length < 6) {
                      return "Password cant be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      Icons.password,
                      color: Colors.green,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isvisible = !isvisible;
                        });
                      },
                      child: Icon(
                          isvisible
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          color: Colors.green),
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(width: 2, color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: password2Controller,
                  obscureText: isvisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password cant be empty";
                    } else if (value.length < 6) {
                      return "Password cant be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      Icons.password,
                      color: Colors.green,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isvisible = !isvisible;
                        });
                      },
                      child: Icon(
                        isvisible ? Icons.remove_red_eye : Icons.visibility_off,
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: 2, color: Colors.green)),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(width: 2, color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        child: const Text("Register"),
                        onPressed: () async {
                          final String username = usernameController.text;
                          final String email = emailController.text;
                          final String password1 = password1Controller.text;
                          final String password2 = password2Controller.text;
                          var authRes = await registerUser(
                              username, email, password1, password2);
                          print("registercheck:${authRes.runtimeType}");
                          if (authRes.runtimeType == User) {
                            User user = authRes;
                            context.read<UserCubit>().emit(user);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MainPage()));
                          } else if (authRes.runtimeType == String) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Error"),
                                    content: Text(authRes),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Ok"))
                                    ],
                                  );
                                });
                          } else {
                            // Fluttertoast.showToast(
                            //     msg: "Something went wrong",
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.BOTTOM,
                            //     timeInSecForIosWeb: 1,
                            //     backgroundColor: Colors.red,
                            //     textColor: Colors.white,
                            //     fontSize: 16.0);
                          }
                        })),
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
