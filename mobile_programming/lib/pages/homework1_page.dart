
import 'package:flutter/material.dart';

class HomeWork1Page extends StatefulWidget {
  const HomeWork1Page({Key? key}) : super(key: key);

  @override
  _HomeWork1PageState createState() => _HomeWork1PageState();
}

class _HomeWork1PageState extends State<HomeWork1Page> {
  // Data for input fields
  Map<String, String> _formData = {
    'First Name': '',
    'Last Name': '',
    'Hometown': '',
    'Birthdate': '',
    'Student ID': '',
  };

  // Controllers for input fields
  Map<String, TextEditingController> _controllers = {
    'First Name': TextEditingController(),
    'Last Name': TextEditingController(),
    'Hometown': TextEditingController(),
    'Birthdate': TextEditingController(),
    'Student ID': TextEditingController(),
  };

  // Define keyboard types
  Map<String, TextInputType> _keyboardTypes = {
    'First Name': TextInputType.text,
    'Last Name': TextInputType.text,
    'Hometown': TextInputType.text,
    'Birthdate': TextInputType.text,
    'Student ID': TextInputType.number,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information Entry'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var entry in _formData.entries)
              Padding(
                padding: const EdgeInsets.all(16.0), // Add padding
                child: TextField(
                  controller: _controllers[entry.key],
                  keyboardType: _keyboardTypes[entry.key],
                  onChanged: (value) {
                    setState(
                      () {
                        _formData[entry.key] = value;
                      },
                    );
                  },
                  decoration: InputDecoration(
                    labelText: entry.key,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                // Check for empty text fields
                if (_formData.values.any((value) => value.isEmpty)) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please fill in all fields.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentInfo(
                        formData: _formData,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentInfo extends StatelessWidget {
  final Map<String, String> formData;

  const StudentInfo({
    Key? key,
    required this.formData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var entry in formData.entries)
              Text('${entry.key}: ${formData[entry.key]}'),
          ],
        ),
      ),
    );
  }
}
