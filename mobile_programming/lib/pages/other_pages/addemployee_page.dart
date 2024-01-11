import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_programming/pages/other_pages/mapview_page.dart';
import '../../services/databasemanager_service.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final DatabaseManager _databaseManager = DatabaseManager.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _identityNumberController =
      TextEditingController(); // Kimlik numarası için controller
  double _workYear = 0.0;
  late String _imagePath; // Seçilen fotoğrafın dosya yolu

  @override
  void initState() {
    super.initState();
    _imagePath = ''; // Başlangıçta boş bir fotoğraf yolu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Çalışan Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                _pickImage(); // Fotoğraf seçme fonksiyonu
              },
              child: _imagePath.isEmpty
                  ? Container(
                      height: 100,
                      color: Colors.grey,
                      child: Icon(Icons.add_a_photo,
                          size: 40, color: Colors.white),
                      alignment: Alignment.center,
                    )
                  : Image.file(
                      File(_imagePath),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
            ),
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
              decoration: InputDecoration(
                labelText: 'Kimlik Numarası',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(
                    r'^\d{0,11}$')), // Sadece sayılar ve maksimum 11 hane
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
                _addEmployee();
              },
              child: Text('Çalışanı Ekle'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapView(
                      onSelectLocation: (LatLng location) {
                        String selectedAddress =
                            "Seçilen Adres: ${location.latitude}, ${location.longitude}";
                        print(selectedAddress);
                        _addressController.text = selectedAddress;
                      },
                    ),
                  ),
                );
              },
              child: Text('Haritayı Göster'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _addEmployee() async {
    try {
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
        Employee newEmployee = Employee(
          id: DateTime.now().toIso8601String(),
          name: name,
          department: department,
          salary: salary,
          address: address,
          workYear: _workYear.toInt(),
          imagePath: _imagePath,
          identityNumber: identityNumber,
        );

        await _databaseManager.insertEmployee(newEmployee);

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Lütfen tüm alanları doldurun ve geçerli bilgiler girin.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e, stackTrace) {
      print("Hata: $e");
      print("Hata izi: $stackTrace");
    }
  }
}
