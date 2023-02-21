import 'dart:convert';
import 'dart:math';
import 'package:flutter_auth/Signup/signup_screen.dart';

import 'api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home.dart';
import 'package:flutter_auth/Screens/Login/components/api_provider.dart';
import 'package:flutter_auth/service/service.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../Home/home.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController ctrUsername = TextEditingController();
  TextEditingController ctrPasswprd = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  ApiProvider apiProvider = ApiProvider();

  Future doLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        var rs = await apiProvider.doLogin(ctrUsername.text, ctrPasswprd.text);
        if (rs.statusCode == 200) {
          print(rs.body);
          var jsonRes = json.decode(rs.body);

          if (jsonRes["ok"]) {
            String token = jsonRes['token'];
            print(token);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeScreen(obj: "")));
          } else {
            print(jsonRes['error']);
          }
        } else {
          print('server error:');
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: ctrUsername,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Username",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: ctrPasswprd,
              validator: ((value) {
                if (value!.isEmpty) {
                  return "Please enter a password";
                }
              }),
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () => doLogin(),
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
