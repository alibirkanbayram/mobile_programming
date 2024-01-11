import 'package:flutter/material.dart';
import 'package:mobile_programming/shared/constants_shared.dart';

class PatternPage extends StatelessWidget {
  final double height, width;
  const PatternPage({
    required this.height,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> pageList = [
      for (int i = 0; i < 8; i++) 'homework${i + 1}',
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * SharedConstants.generalPadding * 2,
          ),
          child: Column(
            children: [
              Text(
                "Gitmek istediğiniz sayfayı seçiniz.",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              for (int i = 0; i < pageList.length; i++)
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/${pageList[i]}",
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: height * SharedConstants.generalPadding,
                      ),
                      child: Text(
                        pageList[i],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
