
class ProductModel {
  String id;
  String name;
  double price;
  String description;
  String specs;
  List<TagModel> tags;
  String image;

  ProductModel(this.id, this.name, this.price, this.description, this.specs,
      this.image, this.tags);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<TagModel> tags = [];
    List<dynamic> jsonTags = json["filterTags"];
    for (var tag in jsonTags) {
      tags.add(TagModel.fromJson(tag));
    }
    return ProductModel(
      json["id"],
      json["name"],
      json["price"],
      json["description"],
      json["specs"],
      json["image"],
      tags
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonTags = [];
    for (var tag in tags) {
      jsonTags.add(tag.toJson());
    }
    return {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "specs": specs,
      "image": image,
      "tags": jsonTags
    };
  }
}

class TagModel {
  String name;
  GroupModel group;

  TagModel(this.name, this.group);

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(json["name"], GroupModel.fromJson(json["filterGroup"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "filterGroup": group.toJson()
    };
  }
}
class GroupModel {
  String name;

  GroupModel(this.name);

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(json["name"]);
  }

  Map<String, dynamic> toJson() {
    return {"name": name};
  }
}