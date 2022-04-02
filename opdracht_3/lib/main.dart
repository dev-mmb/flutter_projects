import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opdracht_3/facts.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MaterialApp(
      title: "Cat App",
      home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<CatBreeds> facts;
  CatFileHandler handler = CatFileHandler();

  @override
  void initState() {
    super.initState();
    facts = fetchCatFacts();
  }

  Future<CatBreeds> fetchCatFacts() async {
    return await getData();
  }

  Future<bool> saveData(CatBreeds cats) async {
    var file = await handler.writeCats(jsonEncode(cats.toJson()));
    return await file.exists();
  }

  // either gets from disk if file exists, else get from api and saves to disk
  Future<CatBreeds> getData() async {
    String json = "";
    // attempt to load from disk
    String? data = await handler.readCats();

    if (data != null) {
      json = data;
    }
    else {
      final response = await http.get(Uri.parse("https://catfact.ninja/breeds"));
      if (response.statusCode == 200) {
        json = response.body;
      }
      else {
        throw Exception("failed to load cat facts");
      }
    }
    var cats = CatBreeds.fromJson(jsonDecode(json));
    saveData(cats);
    return cats;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Cat App"),
              ),
              body: FutureBuilder<CatBreeds>(
                future: facts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: buildFactRows(snapshot.data),
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text("${snapshot.error}", textDirection: TextDirection.ltr);
                  }
                  return const CircularProgressIndicator();
                },
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                          color: Colors.blue
                      ),
                      child: Text("Pages"),
                    ),
                    ListTile(
                      title: const Text("Facts"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FactsPage()));
                      },
                    )
                  ],
                ),
              ),
            );
          }
          else {
            return Image.network("https://http.cat/405");
          }
        }
      );
  }

  List<Widget> buildFactRows(CatBreeds? facts) {
    List<Widget> widgets = [];
    if (facts == null) {
      widgets.add(const Text("facts is null", textDirection: TextDirection.ltr));
      return widgets;
    }
    for (int i = 0; i < facts.data.length; i++) {
      widgets.add(CatRow(facts.data[i]));
    }
    return widgets;
  }
}

class CatBreeds {
  List<CatBreed> data;
  int to = 0;
  CatBreeds(this.data, this.to);

  factory CatBreeds.fromJson(Map<String, dynamic> json) {
    List<CatBreed> facts = [];
    int length = json["to"];
    for (int i = 0; i < length; i++)  {
      CatBreed fact = CatBreed.fromJson(json["data"][i], i);
      facts.add(fact);
    }
    return CatBreeds(facts, length);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    var jsonData = [];
    for (int i = 0; i < data.length; i++) {
      jsonData.add(data[i].toJson());
    }
    json["data"] = jsonData;
    json["to"] = to;
    return json;
  }
}

class CatBreed {
  String breed;
  String country;
  String origin;
  String coat;
  String pattern;
  int num = 0;

  CatBreed(
      this.breed,
      this.country,
      this.origin,
      this.coat,
      this.pattern
      );

  factory CatBreed.fromJson(Map<String, dynamic> json, int num) {
    CatBreed fact = CatBreed(json["breed"], json["country"], json["origin"], json["coat"], json["pattern"]);
    fact.num = num;
    return fact;
  }

  Map<String, dynamic> toJson() {
    return {
      "breed": breed,
      "country": country,
      "origin": origin,
      "coat": coat,
      "pattern": pattern
    };
  }
}

class CatRow extends StatelessWidget {
  final CatBreed cat;

  const CatRow(this.cat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue.shade900,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          child:  Row(
            textDirection: TextDirection.ltr,
            children: [
              Flexible(
                  child: Text(cat.num.toString() + ": " + cat.breed, textDirection: TextDirection.ltr)
              )
            ],
          ),
          onTap: () { onCatClicked(context); },
        )
    );
  }

  void onCatClicked(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CatFactPage(cat))
    );
  }
}

class CatFactPage extends StatelessWidget {
  const CatFactPage(this.cat, {Key? key}) : super(key: key);
  final CatBreed cat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat.breed),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("Origin: " + cat.origin),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("Country: " + cat.country),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("Coat: " + cat.coat),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("Pattern: " + cat.pattern),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CatFileHandler {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/cat_app.json');
  }
  Future<File> writeCats(String json) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json);
  }
  // returns null if no file found
  Future<String?> readCats() async {
    try {
      final file = await _localFile;

      final exists = await file.exists();
      if (!exists) return null;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }
  Future<bool> deleteCats() async {
    try {
      final file = await _localFile;

      await file.delete();
      return true;

    } catch (e) {
      return false;
    }
  }
}