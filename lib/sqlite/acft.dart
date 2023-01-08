class Acft {
  int? id;
  String? date;
  String? rank;
  String? name;
  String gender;
  String age;
  String mdlRaw;
  String mdlScore;
  String sptRaw;
  String sptScore;
  String hrpRaw;
  String hrpScore;
  String sdcRaw;
  String sdcScore;
  String plkRaw;
  String plkScore;
  String runRaw;
  String runScore;
  String runEvent;
  String total;
  int altPass;
  int pass;

  Acft({
    this.id,
    this.date,
    this.rank,
    this.name,
    required this.gender,
    required this.age,
    required this.mdlRaw,
    required this.mdlScore,
    required this.sptRaw,
    required this.sptScore,
    required this.hrpRaw,
    required this.hrpScore,
    required this.sdcRaw,
    required this.sdcScore,
    required this.plkRaw,
    required this.plkScore,
    required this.runRaw,
    required this.runScore,
    required this.runEvent,
    required this.total,
    required this.altPass,
    required this.pass,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'rank': rank,
      'name': name,
      'gender': gender,
      'age': age,
      'mdlRaw': mdlRaw,
      'mdlScore': mdlScore,
      'sptRaw': sptRaw,
      'sptScore': sptScore,
      'hrpRaw': hrpRaw,
      'hrpScore': hrpScore,
      'sdcRaw': sdcRaw,
      'sdcScore': sdcScore,
      'ltkRaw': plkRaw,
      'ltkScore': plkScore,
      'runRaw': runRaw,
      'runScore': runScore,
      'runEvent': runEvent,
      'total': total,
      'altPass': altPass,
      'pass': pass
    };
    return map;
  }

  factory Acft.fromMap(Map<String, dynamic> map) {
    String mapRank = '', mapGender = 'Male', mapAge = '22';
    int altGo = 1;
    try {
      mapRank = map['rank'] ?? '';
      mapGender = map['gender'] ?? 'Male';
      mapAge = map['age'] ?? '22';
      altGo = map['altPass'] ?? 1;
    } catch (e) {
      print('Error: $e');
    }
    return Acft(
      id: map['id'],
      date: map['date'],
      rank: mapRank,
      name: map['name'],
      gender: mapGender,
      age: mapAge,
      mdlRaw: map['mdlRaw'],
      mdlScore: map['mdlScore'],
      sptRaw: map['sptRaw'],
      sptScore: map['sptScore'],
      hrpRaw: map['hrpRaw'],
      hrpScore: map['hrpScore'],
      sdcRaw: map['sdcRaw'],
      sdcScore: map['sdcScore'],
      plkRaw: map['ltkRaw'],
      plkScore: map['ltkScore'],
      runRaw: map['runRaw'],
      runScore: map['runScore'],
      runEvent: map['runEvent'],
      total: map['total'],
      altPass: altGo,
      pass: map['pass'],
    );
  }
}
