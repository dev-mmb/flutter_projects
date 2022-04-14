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

  testWidgets("ShopScreen logout button click calls onLogout callback", (WidgetTester tester) async {
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
    await tester.dragFrom(tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
    await tester.pumpAndSettle();

    // click logout button
    final Finder tile = find.byKey(const Key("logout"));
    await tester.tap(tile);
    expect(hasBeenChanged, true);
  });

  test("GroupModel.fromJson correctly gets name value from json", () {
    const String value = "foo";
    const json = {"name": value};
    final GroupModel group = GroupModel.fromJson(json);

    expect(group.name == value, true);
  });
}
