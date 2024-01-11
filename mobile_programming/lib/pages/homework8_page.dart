import 'dart:io';

import 'package:flutter/material.dart';

import '../services/databasemanager_service.dart';
import 'other_pages/addemployee_page.dart';
import 'other_pages/editemployee_page.dart';
import 'other_pages/pay_page.dart';

class HomeWork8Page extends StatefulWidget {
  const HomeWork8Page({super.key});

  @override
  _HomeWork8PageState createState() => _HomeWork8PageState();
}

class _HomeWork8PageState extends State<HomeWork8Page> {
  final DatabaseManager _databaseManager = DatabaseManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maaş Yönetimi Uygulaması'),
      ),
      body: FutureBuilder<List<Employee>>(
        future: _databaseManager.getAllEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Hata oluştu: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Henüz kullanıcı eklenmedi.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Employee employee = snapshot.data![index];
                return _buildUserListItem(employee, snapshot);
              },
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              // Yeni kullanıcı ekleme ekranına yönlendirme
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddEmployeePage()));
              // Yeni kullanıcı ekledikten sonra sayfayı tekrar yükle
              setState(() {});
            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              // Maaş ödeme ekranına yönlendirme
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaySalaryScreen()));
            },
            child: Icon(Icons.attach_money),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(
      Employee employee, AsyncSnapshot<List<Employee>> snapshot) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: FileImage(
          File(employee.imagePath),
        ),
        // Varsayılan bir avatar ekleyebilirsiniz.
      ),
      title: Text(employee.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${employee.workYear} Yıl'),
          Text('${employee.salary}TL'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          Employee? updatedEmployee = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditEmployeePage(employee: employee)),
          );

          if (updatedEmployee != null) {
            setState(() {
              // Güncellenen çalışanı listeye ekle
              int index = snapshot.data!
                  .indexWhere((element) => element.id == updatedEmployee.id);
              if (index != -1) {
                snapshot.data![index] = updatedEmployee;
                snapshot = AsyncSnapshot<List<Employee>>.withData(
                  ConnectionState.done,
                  snapshot.data!, // Güncellenmiş verileri kullan
                );
              }
            });
          }
        },
      ),
    );
  }
}
