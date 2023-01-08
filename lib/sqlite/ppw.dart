class PPW {
  int? id;
  String? date;
  String? name;
  String rank;
  int version;
  int ptTest;
  int weapons;
  int awards;
  int badges;
  int airborne;
  int ncoes;
  int wbc;
  int resident;
  int tabs;
  int ar350;
  int semesterHours;
  int degree;
  int certs;
  int language;
  int milTrainMax;
  int awardsMax;
  int milEdMax;
  int civEdMax;
  int total;

  PPW({
    this.id,
    this.date,
    this.name,
    required this.rank,
    required this.version,
    required this.ptTest,
    required this.weapons,
    required this.awards,
    required this.badges,
    required this.airborne,
    required this.ncoes,
    required this.wbc,
    required this.resident,
    required this.tabs,
    required this.ar350,
    required this.semesterHours,
    required this.degree,
    required this.certs,
    required this.language,
    required this.milTrainMax,
    required this.awardsMax,
    required this.milEdMax,
    required this.civEdMax,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'name': name,
      'rank': rank,
      'version': version,
      'ptTest': ptTest,
      'weapons': weapons,
      'awards': awards,
      'badges': badges,
      'airborne': airborne,
      'ncoes': ncoes,
      'wbc': wbc,
      'resident': resident,
      'tabs': tabs,
      'ar350': ar350,
      'semesterHours': semesterHours,
      'degree': degree,
      'certs': certs,
      'language': language,
      'milTrain': milTrainMax,
      'awardsTotal': awardsMax,
      'milEd': milEdMax,
      'civEd': civEdMax,
      'total': total,
    };
    return map;
  }

  factory PPW.fromMap(Map<String, dynamic> map) {
    return PPW(
      id: map['id'],
      date: map['date'],
      name: map['name'],
      rank: map['rank'],
      version: map['version'],
      ptTest: map['ptTest'],
      weapons: map['weapons'],
      awards: map['awards'],
      badges: map['badges'],
      airborne: map['airborne'],
      ncoes: map['ncoes'],
      wbc: map['wbc'],
      resident: map['resident'],
      tabs: map['tabs'],
      ar350: map['ar350'],
      semesterHours: map['semesterHours'],
      degree: map['degree'],
      certs: map['certs'],
      language: map['language'],
      milTrainMax: map['milTrain'],
      awardsMax: map['awardsTotal'],
      milEdMax: map['milEd'],
      civEdMax: map['civEd'],
      total: map['total'],
    );
  }
}
