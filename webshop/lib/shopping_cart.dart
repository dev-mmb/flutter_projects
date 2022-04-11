import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webshop/model/shopping_cart_model.dart';
import 'package:http/http.dart' as http;

class ShoppingCart extends StatefulWidget {
  ShoppingCart(this.cart, this.token, this.onOrder, {Key? key}) : super(key: key);
  ShoppingCartModel cart;
  String token;
  Function() onOrder;

  @override
  State<StatefulWidget> createState() => _ShoppingCartState();

}
class _ShoppingCartState extends State<ShoppingCart> {
  late Future<ShoppingCartModel> cartFuture;
  static const double iconWidth = 12;
  static const double buttonWidth = 42;

  @override
  void initState() {
      super.initState();
      cartFuture = getCart();
  }

  Future<ShoppingCartModel> getCart() async {

    final response = await http.post(
      Uri.parse("https://limitless-bastion-9783240.herokuapp.com/cart"),
      headers: {"Authorization": "bearer ${widget.token}", "Content-Type": "application/json"},
      body: jsonEncode(widget.cart.toJson())
    );

    if (response.statusCode != 200) {
      return widget.cart;
    }
    return ShoppingCartModel.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ShoppingCartModel>(
      future: cartFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong getting your cart");
        }
        if (snapshot.hasData) {
          return getCartWidgets(snapshot.data);
        }
        return const CircularProgressIndicator();
      }
    );
  }
  void checkout() {
      widget.onOrder();
  }
  Widget getCartWidgets(ShoppingCartModel? cartModel) {
    if (cartModel == null) return const Text("Cart does not exist!");
    List<Widget> widgets = [];

    for (var product in cartModel.shoppingCartProducts) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xfff7fbf6)
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Image(
                      image: NetworkImage("https://limitless-bastion-9783240.herokuapp.com/product_image/get/${product.product.image}"),
                      fit: BoxFit.fitWidth,
                      width: 50,
                    )
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                product.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                product.product.description,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "€  ${product.product.price * product.amount}",
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                width: _ShoppingCartState.buttonWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.cart.removeFromCart(product.product);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    size: _ShoppingCartState.iconWidth,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text("${widget.cart.getAmount(product)}")
                              ),
                              SizedBox(
                                width: _ShoppingCartState.buttonWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.cart.addToCart(product.product);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    size: _ShoppingCartState.iconWidth,
                                  ),

                                ),
                              )
                            ],
                          )
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )
      );
    }
    // the total price and buy button
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xfff7fbf6)
          ),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                        onPressed: () => checkout(),
                        child: const Text(
                            "Bestel"
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xff457b9d)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              color: Colors.white
                          )
                        ),
                      )
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Totaal: € ${widget.cart.getTotalCost().toStringAsFixed(2)}"
                    )
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );

    return ListView(
      children: widgets,
    );


  }

}