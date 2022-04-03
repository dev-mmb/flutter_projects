import 'package:flutter/material.dart';
import 'package:webshop/account.dart';
import 'package:webshop/shop_items.dart';
import 'package:webshop/shopping_cart.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShopScreenState();

}

class _ShopScreenState extends State<ShopScreen> {
  List<bool> selectedPage = [true, false, false];

  Widget getSelectedPage() {
    if (selectedPage[0] == true) {
      return ShopItems();
    } else if (selectedPage[1] == true) {
      return ShoppingCart();
    }
    return Account();
  }
  void setSelectedPage(int page) {
    for (int i = 0; i < selectedPage.length; i++) {
      if (i == page) {
        selectedPage[i] = true;
      }
      else {
        selectedPage[i] = false;
      }
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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