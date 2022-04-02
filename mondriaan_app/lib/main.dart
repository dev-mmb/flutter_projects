import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

const double BORDER_WIDTH = 4;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MondriaanRow(100, 410, 3),
        MondriaanRow(200, 410, 2),
        MondriaanRow(50, 410, 1),
        MondriaanRow(300, 410, 3),
        MondriaanRow(50, 410, 1),
      ]
    );
  }
}

class MondriaanRow extends StatelessWidget {
  MondriaanRow(this._height, this._width, this._amountOfChildren, {Key? key}) : super(key: key);

  final double _height;
  final double _width;
  final int _amountOfChildren;
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      children: _createBoxes()
    );
  }

  List<Widget> _createBoxes() {
    List<Widget> boxes = [];
    double widthLeft = _width;
    double totalUsed = 0;
    for (int i = 0; i < _amountOfChildren; i++) {

      if (widthLeft <= 0) break;
      double w = widthLeft;
      if (i != _amountOfChildren - 1) {
        w = Random().nextDouble() * widthLeft;
        widthLeft -= w;
      }
      totalUsed += w;
      boxes.add(MondriaanBox(getRandomColor(), w, _height - BORDER_WIDTH));
    }
    return boxes;
  }
  Color getRandomColor() {
    return [
      Colors.white,
      Colors.yellow,
      Colors.blue,
      Colors.red
    ][Random().nextInt(4)];
  }
}
class MondriaanBox extends StatelessWidget {
  MondriaanBox(this._color, this._width, this._height, {Key? key}) : super(key: key);

  final Color _color;
  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width, height: _height,
      child: DecoratedBox(decoration: BoxDecoration(
        border: const Border(
            top: BorderSide(color: Colors.black, width: BORDER_WIDTH),
            right: BorderSide(color: Colors.black, width: BORDER_WIDTH),
        ),
        color: _color
      )),
    );
  }


}

