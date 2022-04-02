
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdracht_3/main.dart';
import 'package:http/http.dart' as http;

class FactsPage extends StatefulWidget {
  const FactsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FactsPageState();

}

class _FactsPageState extends State<FactsPage> {
  late Future<CatFacts> facts;


  @override
  void initState() {
    super.initState();
    facts = fetchFacts();
  }
  
  Future<CatFacts> fetchFacts() async {
    String json = "";
    final response = await http.get(Uri.parse("https://catfact.ninja/facts"));
    if (response.statusCode == 200) {
      json = response.body;
    }else {
      throw Exception("failed to load facts");
    }
    var facts = CatFacts.fromJson(jsonDecode(json));
    return facts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cat App"),
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
              title: const Text("Breeds"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<CatFacts>(
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
          }
        ),
    );
  }

  List<Widget> buildFactRows(CatFacts? data) {
    List<Widget> widgets = [];
    if (data == null) {
      widgets.add(const Text("Could not get facts", textDirection: TextDirection.ltr));
    }
    else {
      for (int i = 0; i < data.data.length; i++) {
        widgets.add(CatFactRow(data.data[i]));
      }
    }
    return widgets;
  }
}

class CatFacts {
  List<CatFact> data;

  CatFacts(this.data);

  factory CatFacts.fromJson(Map<String, dynamic> j) {
    List<CatFact> facts = [];
    List<dynamic> list = j["data"];
    for (var fact in list) {
      facts.add(CatFact.fromJson(fact));
    }
    return CatFacts(facts);
  }

}

class CatFact {
  String fact;
  int length;

  CatFact(this.fact, this.length);

  factory CatFact.fromJson(Map<String, dynamic> json) {
    return CatFact(json["fact"], json["length"]);
  }
}

class CatFactRow extends StatelessWidget {
  final CatFact fact;

  const CatFactRow(this.fact, {Key? key}) : super(key: key);

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
                  child: Text(fact.fact)
              )
            ],
          ),
        )
    );
  }
}