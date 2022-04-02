import 'package:flutter/material.dart';
import 'package:webshop/login.dart';

void main() {
  runApp(const MaterialApp(
    title: "Webshop",
    home: WebShop()
  ));
}

class WebShop extends StatefulWidget {
  const WebShop({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebShopState();

}

class _WebShopState extends State<WebShop> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {

    }
    else {
      return const LoginScreen();
    }
    return const LoginScreen();
  }

}