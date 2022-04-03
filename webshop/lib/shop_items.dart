import 'package:flutter/cupertino.dart';

class ShopItems extends StatefulWidget {
  const ShopItems({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShopItemsState();

}
class _ShopItemsState extends State<ShopItems> {
  @override
  Widget build(BuildContext context) {
    return Text("items");
  }

}