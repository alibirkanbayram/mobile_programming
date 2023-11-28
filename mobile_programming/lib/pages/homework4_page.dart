// Main Libs
import 'package:flutter/material.dart';
import 'dart:math';
// import 'package:flutter/services.dart';

class HomeWork4Page extends StatefulWidget {
  final double height, width;
  const HomeWork4Page({
    required this.height,
    required this.width,
    super.key,
  });

  @override
  State<HomeWork4Page> createState() => _HomeWork4PageState();
}

class _HomeWork4PageState extends State<HomeWork4Page> {
  TextEditingController textfieldController = TextEditingController();
  List<List<String>> texts = [[], [], []];
  void generateRandomWord(int length, String text) {
    List<int> randomIndex = [];
    String word = "";
    for (int i = 0; i < length; i++) {
      while (true) {
        int tempInt = Random().nextInt(text.length);
        if (randomIndex.contains(tempInt)) {
          continue;
        } else {
          randomIndex.add(tempInt);
          word += text[tempInt];
          break;
        }
      }
    }
    setState(
      () {
        switch (length) {
          case 4:
            texts[0].add(word);
            break;
          case 5:
            texts[1].add(word);
            break;
          case 6:
            texts[2].add(word);
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bottomButtomTextList = [
      "4 Harfli",
      "5 Harfli",
      "6 Harfli"
    ];
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(widget.height * 0.02),
                ),
                child: TextField(
                  controller: textfieldController,

                  decoration: InputDecoration(
                    hintText: 'Enter a character',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.height * 0.02),
                    ),
                  ),
                  // decoration: InputDecoration(labelText: 'Bir harf girin'),
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: i != 0 ? widget.width * 0.02 : 0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: widget.height * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(widget.height * 0.02),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            widget.height * 0.02),
                                        topRight: Radius.circular(
                                            widget.height * 0.02),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: widget.height * 0.02,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Sütun ${i + 1}",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: texts[i].isEmpty
                                        ? const Text(
                                            "Boş",
                                          )
                                        : Column(
                                            children: [
                                              for (int j = 0;
                                                  j < texts[i].length;
                                                  j++)
                                                Text(
                                                  texts[i][j],
                                                ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: widget.height * 0.02),
                              child: InkWell(
                                onTap: () {
                                  if (textfieldController.text.length < 6 ||
                                      RegExp(r'^[a-zA-Z]+$')
                                          .hasMatch(textfieldController.text)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Lütfen 6 harften fazla bir harf giriniz",
                                        ),
                                      ),
                                    );
                                    return;
                                  } else {
                                    int length = i + 4;
                                    generateRandomWord(
                                      length,
                                      textfieldController.text,
                                    );
                                    textfieldController.clear();
                                    textfieldController.text = "";
                                  }
                                },
                                child: Container(
                                  color: Colors.amberAccent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: widget.height * 0.02,
                                    ),
                                    child: Text(
                                      bottomButtomTextList[i],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
