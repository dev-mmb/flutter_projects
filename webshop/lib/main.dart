import 'package:flutter/material.dart';
import 'package:webshop/login.dart';
import 'package:webshop/shop.dart';
import 'package:http/http.dart' as http;

import 'cache.dart';

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
  late Future<String> token;
  Cache cache = Cache("token.txt");

  @override
  void initState()  {
    super.initState();
    token = getTokenFromCache();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(builder: (context, snapshot) {
      if (snapshot.hasError || !snapshot.hasData) {
        return const CircularProgressIndicator();
      }
      var t = snapshot.data;
      if (t != null && t != "") {
        return ShopScreen(t);
      }
      else {
        return LoginScreen(_onLoggedIn);
      }
    }, future: token);
    
  }

  void _onLoggedIn(String token) {
    Future.delayed(Duration.zero, () async {
      setState(() {
        this.token = Future(() {return token;});
      });
      await cache.delete();
      await cache.write(token);
    });
  }
  
  Future<String> getTokenFromCache() async {
    var t = await cache.read();
    if (t != null) {
      var valid = await _validateToken(t);
      if (valid) {
        return t;
      }
    }
    return "";
  }
  Future<bool> _validateToken(token) async {
    var response = await http.get(
      Uri.parse("https://limitless-bastion-9783240.herokuapp.com/jwt/validate"),
      headers: {"Authorization": "Bearer $token"}
    );
    if (response.statusCode != 200) return false;
    return (response.body == "true");
  }
}