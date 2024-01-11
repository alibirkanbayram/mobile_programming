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

  @override
  void initState() {
    super.initState();
    // Otomatik bonuslu maaşı varsayılan olarak göster
    double bonusSalary = widget.employee.calculateSalaryWithBonus();
    _amountController.text = bonusSalary.toString();
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
              'Çalışan: ${widget.employee.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Miktar (TL)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addSalary();
              },
              child: Text('Maaş Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  void _addSalary() async {
    double amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    if (amount > 0) {
      // Zam oranını dikkate alarak maaşı güncelle
      double updatedAmount =
          widget.employee.calculateSalaryWithBonus() + amount;

      Salary newSalary = Salary(
        employeeId: widget.employee.id!,
        amount: updatedAmount,
        date: DateTime.now().toIso8601String(),
      );

      await _databaseManager.insertSalary(newSalary);

      Navigator.pop(context); // Ekranı kapat
    } else {
      // Geçersiz miktar uyarısı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen geçerli bir miktar girin.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
