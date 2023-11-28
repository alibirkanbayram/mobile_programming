import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeWork6Page extends StatefulWidget {
  const HomeWork6Page({super.key});

  @override
  State<HomeWork6Page> createState() => _HomeWork6PageState();
}

class _HomeWork6PageState extends State<HomeWork6Page> {
  final xController = TextEditingController();
  final yController = TextEditingController();
  final xAxisTitleController = TextEditingController();
  final yAxisTitleController = TextEditingController();

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    xAxisTitleController.dispose();
    yAxisTitleController.dispose();
    super.dispose();
  }

  void showGraph() {
    List<String> xValues =
        xController.text.split(' ').where((e) => e.isNotEmpty).toList();
    List<String> yValues =
        yController.text.split(' ').where((e) => e.isNotEmpty).toList();

    // Verilerin sayısal olup olmadığını kontrol etme
    if (!xValues.every((x) => double.tryParse(x) != null) ||
        !yValues.every((y) => double.tryParse(y) != null) ||
        xValues.length != yValues.length) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text(
                'Lütfen geçerli sayısal değerler girin veya eşit sayıda değer girin.'),
            actions: <Widget>[
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    } else {
      List<FlSpot> spots = [];
      for (int i = 0; i < xValues.length; i++) {
        double x = double.parse(xValues[i]);
        double y = double.parse(yValues[i]);
        spots.add(FlSpot(x, y));
      }
      LineChartData data = LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == yValues[yValues.length - 1]) {
                  return Text(
                    yAxisTitleController.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                } else {
                  // Diğer değerler için boş bir widget döndür
                  return Text(
                    '${value.toInt()}',
                  );
                }
              },
              reservedSize: 40,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [LineChartBarData(spots: spots)],
      );
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Grafik'),
            content: Container(
              height: 300,
              width: 300,
              child: LineChart(data),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Kapat'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grafik Oluşturucu'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'graph') {
                showGraph();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'info',
                child: Text('Grafik Bilgileri'),
              ),
              const PopupMenuItem<String>(
                value: 'graph',
                child: Text('Grafik'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: xController,
                decoration: InputDecoration(
                  labelText: 'X Değerleri (boşlukla ayrılmış)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: yController,
                decoration: InputDecoration(
                  labelText: 'Y Değerleri (boşlukla ayrılmış)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: xAxisTitleController,
                decoration: InputDecoration(
                  labelText: 'X Ekseni Başlığı',
                ),
              ),
              TextField(
                controller: yAxisTitleController,
                decoration: InputDecoration(
                  labelText: 'Y Ekseni Başlığı',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Grafik Oluştur'),
                onPressed: () {
                  showGraph();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
