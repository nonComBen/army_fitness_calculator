class Apft {
  int? id;
  String? date;
  String? rank;
  String? name;
  String gender;
  String age;
  String puRaw;
  String puScore;
  String suRaw;
  String suScore;
  String runRaw;
  String runScore;
  String runEvent;
  String total;
  int altPass;
  int pass;

  Apft({
    this.id,
    this.date,
    this.rank,
    this.name,
    required this.gender,
    required this.age,
    required this.puRaw,
    required this.puScore,
    required this.suRaw,
    required this.suScore,
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
      'puRaw': puRaw,
      'puScore': puScore,
      'suRaw': suRaw,
      'suScore': suScore,
      'runRaw': runRaw,
      'runScore': runScore,
      'runEvent': runEvent,
      'total': total,
      'altPass': altPass,
      'pass': pass
    };
    return map;
  }

  factory Apft.fromMap(Map<String, dynamic> map) {
    String newRank = '', newAge = '22';
    int altGo = 1;
    try {
      newRank = map['rank'] ?? '';
      newAge = map['age'] ?? '22';
      altGo = map['altPass'] ?? 1;
    } catch (e) {
      print('Error: $e');
    }

    return Apft(
      id: map['id'],
      date: map['date'],
      rank: newRank,
      name: map['name'],
      gender: map['gender'],
      age: newAge,
      puRaw: map['puRaw'],
      puScore: map['puScore'],
      suRaw: map['suRaw'],
      suScore: map['suScore'],
      runRaw: map['runRaw'],
      runScore: map['runScore'],
      runEvent: map['runEvent'],
      total: map['total'],
      altPass: altGo,
      pass: map['pass'],
    );
  }
}
