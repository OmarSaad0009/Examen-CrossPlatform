import 'dart:ffi';

class Matier {
  int? matiereId;
  String matiereName;
  double matiereCoef;
  double matiereNbh;

  Matier(this.matiereName, this.matiereCoef, this.matiereNbh, [this.matiereId]);

  // Factory method to create a Matiere object from JSON
  factory Matier.fromJson(Map<String, dynamic> json) {
    return Matier(
      json['matiereName'],
      json['matiereCoef'],
      json['matiereNbh'],
      json['matiereId'],
    );
  }

  // Add a method to convert the Matiere object to JSON
  Map<String, dynamic> toJson() {
    return {
      'matiereName': matiereName,
      'matiereCoef': matiereCoef,
      'matiereNbh': matiereNbh,
      'matiereId': matiereId,
    };
  }

  @override
  String toString() {
    return matiereName;
  }
}
