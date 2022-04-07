import 'dart:convert';
import 'package:flutter/material.dart';
import 'model/product_model.dart';
import 'package:http/http.dart' as http;

class ShopItems extends StatefulWidget {
  const ShopItems(this.onBuy, {Key? key}) : super(key: key);
  final Function(ProductModel) onBuy;

  @override
  State<StatefulWidget> createState() => _ShopItemsState();

}
class _ShopItemsState extends State<ShopItems> {
  late Future<List<ProductModel>> items;

  @override
  void initState() {
    super.initState();
    items = getItems();
  }

  void buyItem(ProductModel item) {
    widget.onBuy(item);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong trying to get items");
        }
        if (snapshot.hasData) {
          return getItemRows(snapshot.data);
        }
        return const CircularProgressIndicator();
      }
    );
  }

  Widget getItemRows(List<ProductModel>? items) {
    if (items == null) {
      return const Text("something went wrong!");
    }
    List<Widget> widgets = [];
    for (var item in items) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20, top: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xfff7fbf6)
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Image(
                    image: NetworkImage("https://limitless-bastion-9783240.herokuapp.com/product_image/get/${item.image}"),
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
                              item.name,
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
                              item.description,
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
                        "€ ${item.price}",
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () { buyItem(item); },
                        child: const Text(
                          "Koop!"
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xff457b9d)),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              color: Colors.white
                            )
                          )
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ));
    }
    
    return ListView(
      children: widgets,
    );
  }
  
  Future<List<ProductModel>> getItems() async {
    List<ProductModel> items = [];
    final response = await http.get(Uri.parse("https://limitless-bastion-9783240.herokuapp.com/product"));
    if (response.statusCode != 200) {
      throw Exception("something went wrong trying to get items!");
    }
    List<dynamic> json = jsonDecode(response.body);
    for (var item in json) {
      items.add(ProductModel.fromJson(item));
    }
    return items;
  }

}