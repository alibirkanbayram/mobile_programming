import 'package:flutter/material.dart';
import 'package:mobile_programming/pages/homework3_page.dart';
import 'package:mobile_programming/pages/homework5_page.dart';
import 'package:mobile_programming/pages/pattern_page.dart';
import 'package:mobile_programming/shared/constants_shared.dart';

import 'pages/homework1_page.dart';
import 'pages/homework4_page.dart';
import 'pages/homework6_page.dart';
import 'pages/homeworkd2_page.dart';
import 'shared/theme_shared.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double height = mediaQueryData.size.height,
        width = mediaQueryData.size.width;
    return MaterialApp(
      title: SharedConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: SharedTheme.themeData,
      routes: {
        '/homepage': (context) => PatternPage(
              height: height,
              width: width,
            ),
        '/homework1': (context) => const HomeWork1Page(),
        '/homework2': (context) => const HomeWork2Page(),
        '/homework3': (context) => HomeWork3Page(height: height, width: width),
        '/homework4': (context) => HomeWork4Page(height: height, width: width),
        '/homework5': (context) => HomeWork5Page(),
        '/homework6': (context) => HomeWork6Page(),
      },
      home: PatternPage(
        height: height,
        width: width,
      ),
    );
  }
}
