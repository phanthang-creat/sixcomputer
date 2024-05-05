import 'package:flutter/material.dart';
import 'package:sixcomputer/src/app.dart';
import 'package:sixcomputer/src/app_settings/app_settings.dart';
import 'package:sixcomputer/src/model/admin_model.dart';
import 'package:sixcomputer/src/repo/sign_in_repo.dart';
import 'package:sixcomputer/src/widget/tabbar/tabbar.dart';

class SignInAdminView extends StatefulWidget {
  const SignInAdminView({super.key});

  static const String routeName = '/sign-in';

  @override
  State<SignInAdminView> createState() => _SignInAdminViewState();
}

class _SignInAdminViewState extends State<SignInAdminView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    final isLogin = AppSettings.getIsLogin();
    if (isLogin) {
      navigatorKey.currentState!.pushNamed(TabbarController.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'SIGN IN',
                  // Upercase the text
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 20),
            Material(
              shadowColor: Colors.black,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'username',
                  hintText: 'Enter your username',
                  fillColor: const Color.fromARGB(255, 126, 126, 126),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Material(
              shadowColor: Colors.black,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  fillColor: const Color.fromARGB(255, 126, 126, 126),
                  
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  onSignIn();
                },
                child: const Text('Sign In', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSignIn() async {
    final AdminModel admin = AdminModel(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    SignInClient signInClient = SignInClient();

    final result = await signInClient.signIn(admin);

    if (result) {
      AppSettings.setIsLogin('true');
      navigatorKey.currentState!.pushNamed(TabbarController.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username or password is incorrect'),
        ),
      );
    }
  }
}
