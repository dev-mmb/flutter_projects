import 'product_model.dart';

class ShoppingCartModel {
  String id;
  List<ShoppingCartProductModel> shoppingCartProducts;

  ShoppingCartModel(this.id, this.shoppingCartProducts);

  factory ShoppingCartModel.fromJson(Map<String, dynamic> json) {
    List<ShoppingCartProductModel> products = [];
    List<dynamic> jsonProducts = json["products"];
    for (var element in jsonProducts) {
      products.add(ShoppingCartProductModel.fromJson(element));
    }
    return ShoppingCartModel(json["id"], products);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> productsJson = [];
    for (var product in shoppingCartProducts) {
      productsJson.add(product.toJson());
    }
    return {
      "id": id,
      "products": productsJson
    };
  }

  void addToCart(ProductModel product) {
    for (var shoppingCartProduct in shoppingCartProducts) {
      if (shoppingCartProduct.product.id == product.id) {
        shoppingCartProduct.amount += 1;
        return;
      }
    }
    shoppingCartProducts.add(ShoppingCartProductModel(null, product, 1));
  }

  void removeFromCart(ProductModel product) {
    ShoppingCartProductModel? model;
    for (var shoppingCartProduct in shoppingCartProducts) {
      if (shoppingCartProduct.product.id == product.id) {
        model = shoppingCartProduct;
        break;
      }
    }
    if (model != null) {
      model.amount -= 1;
      if (model.amount <= 0) {
        shoppingCartProducts.remove(model);
      }
    }
  }

  int getSize() {
    int total = 0;
    for (var product in shoppingCartProducts) {
      total += product.amount;
    }
    return total;
  }

  double getTotalCost() {
    double total = 0;
    for (var product in shoppingCartProducts) {
      total += (product.amount * product.product.price);
    }
    return total;
  }
}

class ShoppingCartProductModel {
  String? id;
  ProductModel product;
  int amount;

  ShoppingCartProductModel(this.id, this.product, this.amount);

  factory ShoppingCartProductModel.fromJson(Map<String, dynamic> json) {
    return ShoppingCartProductModel(json["id"], ProductModel.fromJson(json["product"]), json["amount"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "product": product.toJson(),
      "amount": amount
    };
  }
}