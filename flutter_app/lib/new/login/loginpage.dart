import 'package:flutter/material.dart';
import 'package:flutter_app/new/login/auth_api.dart';
import 'package:flutter_app/new/login/loginmodel.dart';
import 'package:flutter_app/new/mainpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool check = false;

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
              'Login to your account',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter email',
                    labelText: 'Username',
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
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password cant be empty";
                    } else if (value.length < 6) {
                      return "Password cant be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: check,
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              check = value;
                            });
                          }
                        },
                      ),
                      const Text('Remember Me'),
                      const SizedBox(
                        width: 100,
                      ),
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                        child: const Text("Login"),
                        onPressed: () async {
                          var authRes = await userAuth(
                              emailController.text, passwordController.text);
                          print(authRes.runtimeType);
                          if (authRes.runtimeType == User) {
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
                            Fluttertoast.showToast(
                                msg: "Something went wrong",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
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
