import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webshop/account.dart';
import 'package:webshop/model/shopping_cart_model.dart';
import 'package:webshop/shop_items.dart';
import 'package:webshop/shopping_cart.dart';
import 'package:webshop/model/shopping_cart_model.dart';
import 'package:http/http.dart' as http;

import 'model/product_model.dart';

class ShopScreen extends StatefulWidget {
  ShopScreen(this.token, {Key? key}) : super(key: key);
  String token;

  @override
  State<StatefulWidget> createState() => _ShopScreenState();

}

class _ShopScreenState extends State<ShopScreen> {
  List<bool> selectedPage = [true, false, false];
  ShoppingCartModel cart = ShoppingCartModel("", []);

  void onItemBuy(ProductModel item) {
    setState(() {
      cart.addToCart(item);
    });
  }

  @override
  void initState() {
    super.initState();
    http.get(Uri.parse("https://limitless-bastion-9783240.herokuapp.com/cart"),
        headers: {"Authorization": "Bearer ${widget.token}"})
        .then((response) {
          if (response.statusCode != 200) {
            throw Exception("Something went wrong trying to get shopping cart!");
          } else {
            cart = ShoppingCartModel.fromJson(jsonDecode(response.body));
          }
    });
  }

  Widget getSelectedPage() {
    if (selectedPage[0] == true) {
      return ShopItems(onItemBuy);
    } else if (selectedPage[1] == true) {
      return ShoppingCart(cart, widget.token);
    }
    return const Account();
  }

  void setSelectedPage(int page) {

    setState(() {
      for (int i = 0; i < selectedPage.length; i++) {
        if (i == page) {
          selectedPage[i] = true;
        }
        else {
          selectedPage[i] = false;
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Stack(
                children: [
                  const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xffc32c37),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text(
                            cart.getSize().toString(),
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () { Scaffold.of(context).openDrawer(); },
            );
          },
        )
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 80,
              child: DrawerHeader(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(color: Colors.blue[300]),
                child: const Image(image:  AssetImage("assets/logo.png"), fit: BoxFit.fitHeight),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Image(image: const AssetImage("assets/logo.png"), fit: BoxFit.fitWidth, width: 35, color: Colors.blue[200]),
                  const Text(
                    "Winkel",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  )
                ],
              ),
              selected: selectedPage[0],
              selectedColor: Colors.indigo,
              selectedTileColor: Colors.blue[50],
              onTap: () {
                setSelectedPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children:  [
                  Image(image: const AssetImage("assets/shopping-cart.png"), fit: BoxFit.fitWidth, width: 35, color: Colors.blue[200]),
                    const Text(
                      "Winkelmand",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  )
                ],
              ),
              selected: selectedPage[1],
              selectedColor: Colors.indigo,
              selectedTileColor: Colors.blue[50],
              onTap: () {
                setSelectedPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children:  [
                  Image(image: const AssetImage("assets/account.png"), fit: BoxFit.fitWidth, width: 30, color:  Colors.blue[200]),
                  const Text(
                    "Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  )
                ],
              ),
              selected: selectedPage[2],
              selectedColor: Colors.indigo,
              selectedTileColor: Colors.blue[50],
              onTap: () {
                setSelectedPage(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: getSelectedPage(),
    );
  }

}