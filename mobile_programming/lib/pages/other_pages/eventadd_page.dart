import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_programming/services/database_service.dart';

class EventAddPage extends StatefulWidget {
  const EventAddPage({Key? key}) : super(key: key);

  @override
  State<EventAddPage> createState() => _EventAddPageState();
}

class _EventAddPageState extends State<EventAddPage> {
  late double peopleCounter;
  late TextEditingController eventNameController;
  late DateTime selectedDate;
  late XFile? selectedImage;

  @override
  void initState() {
    peopleCounter = 0;
    eventNameController = TextEditingController();
    selectedDate = DateTime.now();
    selectedImage = null;
    super.initState();
  }

  void _savetodb() async {
    // Resim yolu null kontrolü yapılır
    String imageRoute = selectedImage?.path ?? '';
    // DateTime nowTime = DateTime.now();
    // Eklenen etkinlik veritabanına eklenir
    await DatabaseHelper.instance.insertEvent(
      Event(
        eventName: eventNameController.text,
        numberOfPeople: peopleCounter.toInt(),
        dateSelection: "${selectedDate.toLocal().day}.${selectedDate.toLocal().month}.${selectedDate.toLocal().year}",
        imageRoute: imageRoute,
      ),
    );
    // Geri dönüş ekranına gidilir
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Etkinlik Planlayıcı',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Text("Kişi Sayısı: $peopleCounter"),
            // Slider
            Slider(
              value: peopleCounter,
              min: 0,
              max: 1000,
              onChanged: (value) {
                setState(() {
                  peopleCounter = (value.toInt()).toDouble();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("0"),
                Text("1000"),
              ],
            ),
            // Event Name Textfield
            TextField(
              controller: eventNameController,
              decoration: InputDecoration(
                hintText: "Etkinlik Adı",
              ),
            ),
            // Event Datetime picker
            ListTile(
              title: Text(
                "Etkinlik Tarihi: ${selectedDate.toLocal().day}.${selectedDate.toLocal().month}.${selectedDate.toLocal().year}",
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            // Image add (image_picker)
            ElevatedButton(
              onPressed: _selectImage,
              child: const Text(
                "Resim Ekle",
              ),
            ),
            // Selected Date Preview
            selectedImage != null
                ? CircleAvatar(
                    backgroundImage: FileImage(File(selectedImage!.path)),
                  )
                : SizedBox.shrink(), // Boşluk bırak
            // Show selected date

            ElevatedButton(
              onPressed: _savetodb,
              child: const Text(
                "Kaydet",
              ),
            ),
          ],
        ),
      ),
    );
  }
}