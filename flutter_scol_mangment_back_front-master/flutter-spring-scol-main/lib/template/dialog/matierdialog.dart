import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp70/entities/classe.dart';
import 'package:tp70/entities/matier.dart';
import 'package:tp70/entities/student.dart';
import 'package:tp70/services/classeservice.dart';
import 'package:tp70/services/studentservice.dart';

class MatierDialog extends StatefulWidget {
  final Function()? notifyParent;
  Matier? matier;

  MatierDialog({super.key, @required this.notifyParent, this.matier});
  @override
  State<MatierDialog> createState() => _MatierDialogState();
}

class _MatierDialogState extends State<MatierDialog> {
  TextEditingController nameMat = TextEditingController();
  TextEditingController coefMat = TextEditingController();
  TextEditingController dateMat = TextEditingController(); // New date controller
  Classe? selectedClass;
  List<Classe> classes = [];

  String title = "Ajouter Matier";
  bool modif = false;

  late int idMatier;
  
  int get matiereId =>  idMatier;

  @override
  void initState() {
    super.initState();
    getAllClasses().then((result) {
      setState(() {
        classes = result;
      });
    });

    if (widget.matier != null) {
      modif = true;
      title = "Modifier matier";
      nameMat.text = (widget.matier!.matiereName).toString();
      coefMat.text = (widget.matier!.matiereCoef).toString();
      dateMat.text = (widget.matier!.matiereNbh).toString(); // Set date value
      idMatier = widget.matier!.matiereId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(title),
            TextFormField(
              controller: nameMat,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "nom"),
            ),
            TextFormField(
              controller: coefMat,
              decoration: const InputDecoration(labelText: "coef"),
            ),
            TextFormField(
              controller: dateMat, // Add TextFormField for date
              decoration: const InputDecoration(labelText: "date"),
            ),
            DropdownButtonFormField<Classe>(
              value: selectedClass,
              onChanged: (Classe? value) {
                setState(() {
                  selectedClass = value;
                });
              },
              items: classes.map((Classe classe) {
                return DropdownMenuItem<Classe>(
                  value: classe,
                  child: Text(classe.nomClass),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: "Classe"),
            ),
            ElevatedButton(
              onPressed: () async {
                /* 
                  Your logic for adding/updating Matier goes here
                */
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}