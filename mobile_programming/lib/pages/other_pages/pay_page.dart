import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/databasemanager_service.dart';
import 'addsalary_page.dart';
import 'salarydetails_page.dart';

class PaySalaryScreen extends StatefulWidget {
  @override
  _PaySalaryScreenState createState() => _PaySalaryScreenState();
}

class _PaySalaryScreenState extends State<PaySalaryScreen> {
  final DatabaseManager _databaseManager = DatabaseManager.instance;
  late List<Employee> _employees;
  Employee? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _selectedEmployee = null;
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    List<Employee> employees = await _databaseManager.getAllEmployees();
    if (employees.isNotEmpty) {
      setState(() {
        _employees = employees;
        _selectedEmployee = _employees.first; // İlk çalışanı seç
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maaş Ödeme Ekranı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Çalışan Seç:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<Employee>(
              value: _selectedEmployee,
              items: _employees.map((Employee employee) {
                return DropdownMenuItem<Employee>(
                  value: employee,
                  child: Text(
                      '${employee.name} - ${employee.identityNumber ?? ""}'),
                );
              }).toList(),
              onChanged: (Employee? employee) {
                setState(() {
                  _selectedEmployee = employee;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedEmployee != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalaryDetailsPage(
                        employee: _selectedEmployee!,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lütfen bir çalışan seçin.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Bordro Göster'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedEmployee != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSalaryPage(
                        employee: _selectedEmployee!,
                      ),
                    ),
                  ).then((_) {
                    // Maaş ekledikten sonra çalışanı tekrar yükle
                    _loadEmployees();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lütfen bir çalışan seçin.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Maaş Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
