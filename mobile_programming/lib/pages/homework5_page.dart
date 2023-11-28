import 'dart:math';
import 'package:flutter/material.dart';

class HomeWork5Page extends StatefulWidget {
  @override
  _HomeWork5PageState createState() => _HomeWork5PageState();
}

class _HomeWork5PageState extends State<HomeWork5Page> {
  String _text = '';
  double _fontSize = 16.0;
  TextEditingController _controller = TextEditingController();

  void _changeFontSize(bool increase) {
    setState(
      () {
        if (increase) {
          _fontSize += 2;
        } else {
          _fontSize = 16.0;
        }
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: 16,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              // Random color generation
            });
          },
          child: Container(
            margin: EdgeInsets.all(4),
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homework 5'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter text here'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _text = _controller.text;
              });
            },
            child: Text('Submit'),
          ),
          GestureDetector(
            onDoubleTap: () => _changeFontSize(true),
            onLongPress: () => _changeFontSize(false),
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[300],
              child: Text(
                _text,
                style: TextStyle(fontSize: _fontSize),
              ),
            ),
          ),
          Spacer(),
          Flexible(
            child: _buildGridView(),
          ),
        ],
      ),
    );
  }
}
