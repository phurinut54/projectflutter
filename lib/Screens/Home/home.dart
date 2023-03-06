import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_auth/Screens/Login/components/api_provider.dart';
import 'package:flutter_auth/Screens/Login/components/login_form.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final Object obj;
  HomeScreen({Key? key, required this.obj}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController dialogUsername = TextEditingController();
  TextEditingController dialogPassword = TextEditingController();
  TextEditingController dialogFullname = TextEditingController();
  TextEditingController dialogEmail = TextEditingController();

  ApiProvider apiProvider = ApiProvider();

  var datalist = [];

  Future createUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    var username = dialogUsername.text;
    var password = dialogPassword.text;
    var fullname = dialogFullname.text;
    var email = dialogEmail.text;
    var rs = await apiProvider.createUser(
        token: token,
        username: username,
        password: password,
        fullname: fullname,
        email: email);
    // var jsonRes = json.decode(rs.body);
    if (!mounted) return;
    Navigator.pop(context);
    getUsers();
    log(username);
    log(password);
    log(fullname);
    log(email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  Future getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    var rs = await apiProvider.getUser(token);
    var jsonRes = json.decode(rs.body);
    var uerList = List.from(jsonRes["rows"] as List);
    setState(() {
      datalist = uerList.reversed.toList();
    });
    log(uerList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("User ทั้งหมด"),
        backgroundColor: Color.fromARGB(255, 40, 207, 236),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: datalist.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(datalist[index]["username"]),
              subtitle: Text(datalist[index]["email"]),
            );
          },
        ),
      ),
    );
  }
}
