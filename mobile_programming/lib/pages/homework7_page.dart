import 'dart:io';

import 'package:flutter/material.dart';
import '../services/database_service.dart'; // Path to your database helper file

class HomeWork7Page extends StatefulWidget {
  const HomeWork7Page({Key? key}) : super(key: key);

  @override
  State<HomeWork7Page> createState() => _HomeWork7PageState();
}

class _HomeWork7PageState extends State<HomeWork7Page> {
  late List<Event> events;
  late List<bool> checkedList;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    events = [];
    checkedList = [];
    databaseHelper = DatabaseHelper.instance;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    List<Event> loadedEvents = await databaseHelper.getAllEvents();
    setState(() {
      events = loadedEvents;
      checkedList = List<bool>.filled(events.length, false);
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
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          Event event = events[index];
          return ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
                child: Image.file(
                  File(event.imageRoute), // Dosya yolu burada kullanılıyor
                ),
              ),
            ),
            title: Text(event.eventName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Kişi Sayısı: ${event.numberOfPeople}"),
                Text(event.dateSelection),
              ],
            ),
            trailing: Checkbox(
              value: checkedList[index],
              onChanged: (value) {
                setState(() {
                  checkedList[index] = value!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/eventadd",
          ).then((_) {
            _loadEvents(); // Reload  events after adding a new one
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 20,
          bottom: 20,
        ),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _deleteCheckedEvents();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 40,
                ),
                child: Text(
                  "Sil",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteCheckedEvents() async {
    for (int i = 0; i < checkedList.length; i++) {
      if (checkedList[i]) {
        await databaseHelper.deleteEvent(events[i].id!);
      }
    }
    _loadEvents();
  }
}