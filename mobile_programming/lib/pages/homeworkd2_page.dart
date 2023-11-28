import 'dart:math';

import 'package:flutter/material.dart';

class HomeWork2Page extends StatefulWidget {
  const HomeWork2Page({super.key});

  @override
  _HomeWork2PageState createState() => _HomeWork2PageState();
}

class _HomeWork2PageState extends State<HomeWork2Page> {
  double number = 1.0;
  TextEditingController numberController = TextEditingController();

  void doubleNumber() {
    setState(() {
      number *= 2;
      numberController.clear();
    });
  }

  void sqrtNumber() {
    setState(() {
      number = sqrt(number);
      numberController.clear();
    });
  }

  void resetNumber() {
    setState(() {
      number = 1.0;
      numberController.clear();
    });
  }

  void updateNumberFromText() {
    setState(() {
      try {
        number = double.parse(numberController.text);
      } catch (e) {
        number = 1.0; // Geçersiz giriş durumunda sıfıra geri dön
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, VoidCallback> buttonMap = {
      'Double': doubleNumber,
      'Square Root': sqrtNumber,
      'Reset': resetNumber,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Operations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Number: ${number.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter a number'),
                onChanged: (value) {
                  updateNumberFromText();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var key in buttonMap.keys)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: buttonMap[key],
                      child: Text(key),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
