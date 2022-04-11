// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:webshop/main.dart' as app;


import 'package:flutter_test/flutter_test.dart';
import 'package:webshop/main.dart';
import 'package:webshop/model/product_model.dart';
import 'package:webshop/shop.dart';

void main() {
  testWidgets("Webshop creates loading screen with CircularProgressIndicator", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        title: "Webshop",
        home: WebShop()
    ));
    app.main();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("test logout button", (WidgetTester tester) async {
    // value to check
    bool hasBeenChanged = false;

    await tester.pumpWidget(MaterialApp(
      title: "Webshop",
      // lambda will change our value
      home: ShopScreen("fake token", () {
        hasBeenChanged = true;
      })
    ));

    // open drawer
    await tester.dragFrom(tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pumpAndSettle();

    // click logout button
    final Finder tile = find.byKey(Key("logout"));
    await tester.tap(tile);
    expect(hasBeenChanged, true);
  });

  test("", () {
    String value = "foo";
    var json = {"name": value};
    GroupModel group = GroupModel.fromJson(json);

    expect(group.name == value, true);
  });
}
