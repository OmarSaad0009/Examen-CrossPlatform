import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tp70/entities/absence.dart';
import 'package:tp70/entities/classe.dart';
import 'package:tp70/entities/matier.dart';

import '../services/classeservice.dart';

class Absencescreen extends StatefulWidget {
  @override
  _AbsenceScreenState createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<Absencescreen> {
  List<Classe> classes = [];
  List<Absence> absences = [];
  Classe? selectedClass;
  Matier? selectedMatier;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    getAllClasses().then((result) {
      setState(() {
        classes = result;
      });
    });
  }

  Future<void> fetchAbsencesByMatiereIdAndDate(
      Matier? matier, DateTime? date) async {
    if (matier != null && date != null) {
      try {
        final url = Uri.parse(
            'http://10.0.2.2:8083/absence/getByMatiereId/${matier.matiereId}');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
          final List<Absence> fetchedAbsences =
          responseData.map((absence) => Absence.fromJson(absence)).toList();

          String date1 = DateFormat('yyyy-MM-dd').format(date);

          String d;
          List<Absence> lst = [];
          for (Absence i in fetchedAbsences) {
            d = i.date!;
            DateTime parsedDate = DateTime.parse(d);
            String formattedDate =
                '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
            if (formattedDate == date1) {
              lst.add(i);
            }
          }

          setState(() {
            absences = lst;
          });

          if (lst.isEmpty) {
            showNoAbsencesDialog();
          }
        } else {
          print('Failed to fetch absences: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching absences: $error');
      }
    } else {
      print('Select a Matier and Date');
    }
  }

  void showNoAbsencesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Absences'),
          content: Text('There are no absences for the selected date.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildDropdownButton<T>(
      T? value,
      List<T> items,
      String labelText,
      Function(T?) onChanged,
      ) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      decoration: InputDecoration(labelText: labelText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absences Management'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildDropdownButton<Classe>(
              selectedClass,
              classes,
              'Select a Class',
                  (Classe? value) {
                setState(() {
                  selectedClass = value;
                  selectedMatier = null;
                  absences.clear();
                });
              },
            ),
            const SizedBox(height: 20),
            if (selectedClass != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildDropdownButton<Matier>(
                    selectedMatier,
                    selectedClass!.matieres ?? [],
                    'Select a Matier',
                        (Matier? value) async {
                      setState(() {
                        selectedMatier = value;
                        absences.clear();
                      });

                      // Fetch absences when a Matier is selected
                      if (selectedMatier != null && selectedDate != null) {
                        await fetchAbsencesByMatiereIdAndDate(
                            selectedMatier!, selectedDate!);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          absences.clear();
                        });
                      }
                    },
                    child: Text(selectedDate != null
                        ? 'Selected Date: ${selectedDate!.toString()}'
                        : 'Select Date'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedMatier != null && selectedDate != null) {
                        await fetchAbsencesByMatiereIdAndDate(
                            selectedMatier!, selectedDate!);
                      }
                    },
                    child: Text('Fetch Data'),
                  ),
                ],
              ),
            if (absences.isEmpty)
              Center(
                child: Text(
                  'No absences for selected date.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            if (absences.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: absences.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          'Student Name: ${absences[index].etudiant?.nom ?? "Unknown"} ${absences[index].etudiant?.prenom ?? ""}'),
                      subtitle: Text(
                          'Absence Number: ${absences[index].absenceNb?.toString() ?? "N/A"}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () async {
          // Add action for the floating action button
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
