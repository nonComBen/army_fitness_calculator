class Bodyfat {
  int? id;
  String? date;
  String? rank;
  String? name;
  String gender;
  String age;
  String height;
  String weight;
  String maxWeight;
  int bmiPass;
  String heightDouble;
  String neck;
  String waist;
  String hip;
  String bfPercent;
  String maxPercent;
  String overUnder;
  int bfPass;

  Bodyfat({
    this.id,
    this.date,
    this.rank,
    this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.maxWeight,
    required this.bmiPass,
    required this.heightDouble,
    required this.neck,
    required this.waist,
    required this.hip,
    required this.bfPercent,
    required this.maxPercent,
    required this.overUnder,
    required this.bfPass,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'rank': rank,
      'name': name,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'maxWeight': maxWeight,
      'bmiPass': bmiPass,
      'heightDouble': heightDouble,
      'neck': neck,
      'waist': waist,
      'hip': hip,
      'bfPercent': bfPercent,
      'maxPercent': maxPercent,
      'overUnder': overUnder,
      'bfPass': bfPass,
    };
    return map;
  }

  factory Bodyfat.fromMap(Map<String, dynamic> map) {
    String? newRank = '', newAge = '22', newHeightDouble = map['height'];
    try {
      newRank = map['rank'] ?? '';
      newAge = map['age'] ?? '22';
      newHeightDouble = map['heightDouble'] ?? map['height'];
    } catch (e) {
      print('Error: $e');
    }
    return Bodyfat(
      id: map['id'],
      date: map['date'],
      rank: newRank,
      name: map['name'],
      gender: map['gender'],
      age: newAge!,
      height: map['height'],
      weight: map['weight'],
      maxWeight: map['maxWeight'],
      bmiPass: map['bmiPass'],
      heightDouble: newHeightDouble!,
      neck: map['neck'],
      waist: map['waist'],
      hip: map['hip'],
      bfPercent: map['bfPercent'],
      maxPercent: map['maxPercent'],
      overUnder: map['overUnder'],
      bfPass: map['bfPass'],
    );
  }
}
