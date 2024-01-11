import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/databasemanager_service.dart';

class EditEmployeePage extends StatefulWidget {
  final Employee employee;

  const EditEmployeePage({Key? key, required this.employee}) : super(key: key);

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _identityNumberController =
      TextEditingController();
  double _workYear = 0.0;

  @override
  void initState() {
    super.initState();
    // Seçilen çalışanın mevcut bilgilerini kontrolörler ile doldur
    _nameController.text = widget.employee.name;
    _departmentController.text = widget.employee.department;
    _salaryController.text = widget.employee.salary.toString();
    _addressController.text = widget.employee.address;
    _identityNumberController.text = widget.employee.identityNumber ?? '';
    _workYear = widget.employee.workYear.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Çalışan Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Adı'),
            ),
            TextFormField(
              controller: _departmentController,
              decoration: InputDecoration(labelText: 'Departmanı'),
            ),
            TextFormField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Maaşı'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Adresi'),
            ),
            TextFormField(
              controller: _identityNumberController,
              decoration: InputDecoration(labelText: 'Kimlik Numarası'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,11}$')),
              ],
            ),
            SizedBox(height: 16),
            Text('Çalışma Yılı: $_workYear Yıl'),
            Slider(
              value: _workYear,
              onChanged: (value) {
                setState(() {
                  _workYear = value;
                });
              },
              min: 0,
              max: 30,
              divisions: 30,
              label: _workYear.toString(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateEmployee();
              },
              child: Text('Çalışanı Güncelle'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateEmployee() async {
    String name = _nameController.text.trim();
    String department = _departmentController.text.trim();
    double salary = double.tryParse(_salaryController.text.trim()) ?? 0.0;
    String address = _addressController.text.trim();
    String identityNumber = _identityNumberController.text.trim();

    if (name.isNotEmpty &&
        department.isNotEmpty &&
        salary > 0 &&
        address.isNotEmpty &&
        identityNumber.isNotEmpty) {
      // Güncellenmiş bilgileri içeren yeni bir Employee nesnesi oluştur
      Employee updatedEmployee = Employee(
        id: widget.employee.id,
        name: name,
        department: department,
        salary: salary,
        address: address,
        workYear: _workYear.toInt(),
        imagePath: widget.employee.imagePath,
        identityNumber: identityNumber,
      );

      // DatabaseManager üzerinden güncelleme işlemini yap
      await DatabaseManager.instance.updateEmployee(updatedEmployee);

      // Ana sayfaya geri dön
      Navigator.pop(context);
    } else {
      // Eksik veya geçersiz bilgi uyarısı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Lütfen tüm alanları doldurun ve geçerli bilgiler girin.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
