import 'package:flutter/cupertino.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShoppingCartState();

}
class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Text("cart");
  }

}