import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_p_2/api/auth.dart';
import 'package:flutter_application_p_2/config/appConfig.dart';
import 'package:flutter_application_p_2/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late String msg = "";

  Future<dynamic> signIn() async {
    if (usernameController.text == '' || passwordController.text == '') {
      setState(() {
        msg = 'incorrect username or password';
      });
    } else {
      APIAuth.login(usernameController.text, passwordController.text)
          .then((value) {
        if (value.success == true) {
          setPref(value.data);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          setState(() {
            msg = value.data['message'];
          });
        }
      }).catchError((onError) {
        setState(() {
          msg = onError.toString();
        });
      });
    }
  }

  void setPref(Map<String, dynamic> data) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("user", jsonEncode(data));
    if (!context.mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage('assets/images/logo_small.png'),
              //logo design by <a href="https://www.flaticon.com/free-icons/production" title="production icons">Production icons created by Eucalyp - Flaticon</a>
              height: 100.0,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              AppConfig.appDes,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            "Please log in.",
            style: TextStyle(fontSize: 20.0, color: Colors.black45),
          ),
          if (msg != "")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                msg,
                style: TextStyle(color: Colors.red[800]),
              ),
            ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: "Email"),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.key),
                      border: InputBorder.none,
                      hintText: "Password"),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 0, 64),
            child: ElevatedButton(
              onPressed: signIn,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
