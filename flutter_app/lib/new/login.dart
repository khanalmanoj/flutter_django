import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isvisible = true;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 80,
          ),
          children: [
            Image.asset(
              'assets/logo.png',
              width: 147,
              height: 135,
            ),
            const Center(
              child: Text(
                'Log in to continue',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: 'Username',
                prefixIcon: Icon(
                  Icons.person,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: isvisible,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(
                  Icons.person,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isvisible = !isvisible;
                    });
                  },
                  child: Icon(
                      isvisible ? Icons.remove_red_eye : Icons.visibility_off),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
              ),
            ),
            ElevatedButton(child: const Text("Login"), onPressed: () async {})
          ],
        ),
      ),
    );
  }
}
