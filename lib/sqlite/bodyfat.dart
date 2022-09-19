class Bodyfat {
  int id;
  String date;
  String rank;
  String name;
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
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.maxWeight,
    this.bmiPass,
    this.heightDouble,
    this.neck,
    this.waist,
    this.hip,
    this.bfPercent,
    this.maxPercent,
    this.overUnder,
    this.bfPass,
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

  Bodyfat.fromMap(Map<String, dynamic> map) {
    String newRank = '', newAge = '', newHeightDouble = map['height'];
    try {
      newRank = map['rank'];
      newAge = map['age'];
      newHeightDouble = map['heightDouble'];
    } catch (e) {
      print('Error: $e');
    }
    id = map['id'];
    date = map['date'];
    rank = newRank;
    name = map['name'];
    gender = map['gender'];
    age = newAge;
    height = map['height'];
    weight = map['weight'];
    maxWeight = map['maxWeight'];
    bmiPass = map['bmiPass'];
    heightDouble = newHeightDouble;
    neck = map['neck'];
    waist = map['waist'];
    hip = map['hip'];
    bfPercent = map['bfPercent'];
    maxPercent = map['maxPercent'];
    overUnder = map['overUnder'];
    bfPass = map['bfPass'];
  }
}
