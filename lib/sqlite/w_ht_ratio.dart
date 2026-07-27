class WHtR {
  int? id;
  String? date;
  String? rank;
  String? name;
  String height;
  String waist;
  String wHtRatio;
  int whtPass;

  WHtR({
    this.id,
    this.date,
    this.rank,
    this.name,
    required this.height,
    required this.waist,
    required this.wHtRatio,
    required this.whtPass,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'rank': rank,
      'name': name,
      'height': height,
      'waist': waist,
      'wHtRatio': wHtRatio,
      'whtPass': whtPass,
    };
    return map;
  }

  factory WHtR.fromMap(Map<String, dynamic> map) {
    return WHtR(
      id: map['id'],
      date: map['date'],
      rank: map['rank'],
      name: map['name'],
      height: map['height'],
      waist: map['waist'],
      wHtRatio: map['wHtRatio'],
      whtPass: map['whtPass'],
    );
  }
}
