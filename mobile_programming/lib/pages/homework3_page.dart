// Main Libs
import 'package:flutter/material.dart';
import 'package:mobile_programming/shared/constants_shared.dart';
import 'dart:math';

class HomeWork3Page extends StatefulWidget {
  final double height, width;
  const HomeWork3Page({
    required this.height,
    required this.width,
    super.key,
  });

  @override
  State<HomeWork3Page> createState() => _HomeWork3PageState();
}

class _HomeWork3PageState extends State<HomeWork3Page> {
  List<Color> pageColors = [];
  List<Color> textColors = [];
  late int colorCode;

  @override
  void initState() {
    pageColors.add(Colors.white);
    pageColors.add(Colors.grey);

    textColors.add(Colors.black);
    textColors.add(Colors.black);
    colorCode = 0;
    super.initState();
  }

  void changePageColor(int index, Color color) {
    setState(
      () {
        pageColors[index] = color;
        index == 0
            ? textColors[1] = _setTextColor(color)
            : textColors[0] = _setTextColor(color);
        colorCode = color.value;
      },
    );
  }

  Color _getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  Color _setTextColor(Color backgroundColor) {
    final luminance = (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.width * SharedConstants.generalPadding,
                  vertical: widget.height * SharedConstants.generalPadding * 2,
                ),
                child: Text(
                  colorCode == 0
                      ? "Renk kodu: Yok"
                      : "Renk kodu: 0x${colorCode.toString().substring(2, 10)}",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  for (int i = 0; i < 2; i++)
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: pageColors[i],
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.width *
                                SharedConstants.generalPadding *
                                2,
                            vertical: widget.height *
                                SharedConstants.generalPadding *
                                2,
                          ),
                          child: Column(
                            children: [
                              Text(
                                i == 0 ? "Kişisel Bilgiler" : "Memleket bigisi",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: i == 0
                                          ? textColors[1]
                                          : textColors[0],
                                    ),
                              ),
                              Spacer(),
                              // Button
                              InkWell(
                                onTap: () {
                                  changePageColor(
                                    i,
                                    _getRandomColor(),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:
                                        i == 0 ? pageColors[1] : pageColors[0],
                                    borderRadius: BorderRadius.circular(
                                      widget.height *
                                          SharedConstants.generalPadding,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: widget.height *
                                          SharedConstants.generalPadding,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Button ${i + 1}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              color: textColors[i],
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
