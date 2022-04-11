import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

// for localhost: http://10.0.2.2:8080/
class LoginScreen extends StatefulWidget {
  LoginScreen(this.onLoggedIn, {Key? key}) : super(key: key);

  Function(String) onLoggedIn;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double inputWidth = 300;
  String email = "";
  String password = "";
  bool hasError = false;
  late Future<String> token = Future<String>(() { return "";});

  @override
  LoginScreen get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: SizedBox(
            width: inputWidth,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text("Login", style: TextStyle(color: Colors.blue[200], fontSize: 45, fontWeight: FontWeight.bold)),
                  createInputRow("email", (value) { email = value; }),
                  createInputRow("Wachtwoord", (value) { password = value; }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: register, child: const Text("Registreer")),
                      TextButton(onPressed: login, child: const Text("Log in")),
                    ],
                  ),
                  FutureBuilder(
                    future: token,
                    builder: futureBuilder
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget futureBuilder(BuildContext context, AsyncSnapshot snapshot) {
    Widget widgetToReturn = const SizedBox.shrink();
    if (hasError || snapshot.hasError) {
      widgetToReturn = Text("Email of Wachtwoord incorrect!", style: TextStyle(
        color: Colors.red[900]
      ),);
    }
    // keep hasData and data != "" separate so else is not triggered when data == ""
    if (snapshot.hasData) {
      if (snapshot.data != "") {
        onSuccess(snapshot.data as String);
      }
    }
    else {
      widgetToReturn = const CircularProgressIndicator();
    }
    return widgetToReturn;
  }
  
  Widget createInputRow(String text, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          SizedBox(
            width: inputWidth - 10,
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: text
              ),
            ),
          )
        ],
      ),
    );
  }

  void login() async {
    token = authenticate(email, password);
    setState(() {});
  }
  void register() async {
    var response = await registerAccount(email, password);
    if (response != "") {
      token = authenticate(email, password);
    }
    setState(() {});
  }

  void onSuccess(String token) {
    widget.onLoggedIn(token);
  }

  Future<String> authenticate(String email, String password) async {
    var convertedPassword = md5.convert(utf8.encode(password));
    var body = {"email": email, "password": convertedPassword.toString()};
    final response = await http.post(
        Uri.parse("https://limitless-bastion-9783240.herokuapp.com/account/authenticate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body));
    if (response.statusCode != 200) {
      hasError = true;
      return "";
    }

    return jsonDecode(response.body)["token"];
  }

  Future<String> registerAccount(String email, String passowrd) async {
    var convertedPassword = md5.convert(utf8.encode(password));
    var body = {"email": email, "password": convertedPassword.toString()};

    final response = await http.post(
        Uri.parse("https://limitless-bastion-9783240.herokuapp.com/account/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body));

    if (response.statusCode != 200) {
      hasError = true;
      return "";
    }
    return "Success";
  }
}