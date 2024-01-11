import 'package:flutter/material.dart';

import '../../services/databasemanager_service.dart';

class AddSalaryPage extends StatefulWidget {
  final Employee employee;

  AddSalaryPage({required this.employee});

  @override
  _AddSalaryPageState createState() => _AddSalaryPageState();
}

class _AddSalaryPageState extends State<AddSalaryPage> {
  final DatabaseManager _databaseManager = DatabaseManager.instance;
  final TextEditingController _amountController = TextEditingController();

  List<Employee> matchingEmployees =
      []; // Bonus eklemek için eşleşen çalışanlar

  @override
  void initState() {
    super.initState();
    _fetchMatchingEmployees(); // Kimlik numarasının son hanesiyle eşleşen çalışanları çek
  }

  void _fetchMatchingEmployees() async {
    // Kimlik numarasının son hanesiyle eşleşen çalışanları veritabanından çek
    List<Employee> allEmployees = await _databaseManager.getAllEmployees();

    String lastDigit = widget.employee.identityNumber!
        .substring(widget.employee.identityNumber!.length - 1);

    List<Employee> matchingList = allEmployees.where((employee) {
      String employeeLastDigit = employee.identityNumber!
          .substring(employee.identityNumber!.length - 1);
      return employeeLastDigit == lastDigit;
    }).toList();

    setState(() {
      matchingEmployees = matchingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maaş Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Seçilen Çalışan: ${widget.employee.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Kimlik Numarasının Son Hanesi: ${widget.employee.identityNumber!.substring(widget.employee.identityNumber!.length - 1)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Çalışanın şu anki maaşı: ${widget.employee.salary} TL\n'
              'Zamlı maaşı: ${widget.employee.calculateSalaryWithBonus()} TL',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addBonusToMatchingEmployees(); // Eşleşen çalışanlara bonus ekle
              },
              child: Text('Bonus Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  void _addBonusToMatchingEmployees() async {
    // Eşleşen çalışanlara bonus eklemek için döngü
    for (Employee matchingEmployee in matchingEmployees) {
      // Eğer seçilen çalışan ile aynı kimliğe sahip değilse, bonus ekleyin
      if (matchingEmployee.id != widget.employee.id) {
        double updatedAmount = matchingEmployee.calculateSalaryWithBonus();
        Salary newSalary = Salary(
          employeeId: matchingEmployee.id!,
          amount: updatedAmount,
          date: DateTime.now().toIso8601String(),
        );
        await _databaseManager.insertSalary(newSalary);
      }
    }
    Navigator.pop(context); // Ekranı kapat
  }
}
