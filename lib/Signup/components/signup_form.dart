import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/api_provider.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';


class SignUpForm extends StatefulWidget {
  final Object obj;
  SignUpForm({Key? key, required this.obj}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController dialogUsername = TextEditingController();
  TextEditingController dialogPassword = TextEditingController();
  TextEditingController dialogFullname = TextEditingController();
  TextEditingController dialogEmail = TextEditingController();

  ApiProvider apiProvider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: dialogUsername,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "username",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: dialogPassword,
              decoration: const InputDecoration(
                hintText: "password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.password),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              controller: dialogFullname,
              decoration: const InputDecoration(
                hintText: "fullname",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.abc),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              controller: dialogEmail,
              decoration: const InputDecoration(
                hintText: "email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () async {
              if (dialogUsername.text != "" ||
                  dialogPassword.text != "" ||
                  dialogFullname.text != "" ||
                  dialogEmail.text != "") {
                log("ok");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var token = prefs.getString('token') ?? "";
                ApiProvider()
                    .createUser(
                        token: token,
                        username: dialogUsername.text,
                        password: dialogPassword.text,
                        fullname: dialogFullname.text,
                        email: dialogEmail.text)
                    .then((value) => Navigator.pop(context));
              } else {
                log("not ok");
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
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