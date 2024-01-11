import 'dart:io';

import 'package:flutter/material.dart';
import '../../services/databasemanager_service.dart';

class SalaryDetailsPage extends StatelessWidget {
  final Employee employee;

  SalaryDetailsPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maaş Bilgileri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: FileImage(
                File(employee.imagePath),
              ),
              radius: 40,
            ),
            SizedBox(height: 10),
            Text('Çalışan: ${employee.name}'),
            Text('Maaş: ${employee.salary}TL'),
            Text('Çalışma Yılı: ${employee.workYear} Yıl'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showSalaries(context);
              },
              child: Text('Maaşları Göster'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Ekranı kapat
              },
              child: Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSalaries(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeSalariesPage(employee: employee),
      ),
    );
  }
}

class EmployeeSalariesPage extends StatelessWidget {
  final Employee employee;

  EmployeeSalariesPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${employee.name} - Maaşları'),
      ),
      body: FutureBuilder<List<Salary>>(
        // Assume that getEmployeeSalaries is a function to retrieve salaries for a given employee.
        future: DatabaseManager.instance.getEmployeeSalaries(employee.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('Bu çalışanın henüz maaşı bulunmamaktadır.');
          } else {
            List<Salary> salaries = snapshot.data!;
            return ListView.builder(
              itemCount: salaries.length,
              itemBuilder: (context, index) {
                Salary salary = salaries[index];
                return ListTile(
                  title: Text('Maaş: ${salary.amount}TL'),
                  subtitle: Text('Tarih: ${salary.date}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
