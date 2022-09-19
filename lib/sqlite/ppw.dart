class PPW {
  int id;
  String date;
  String name;
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

  PPW(
      this.id,
      this.date,
      this.name,
      this.rank,
      this.version,
      this.ptTest,
      this.weapons,
      this.awards,
      this.badges,
      this.airborne,
      this.ncoes,
      this.wbc,
      this.resident,
      this.tabs,
      this.ar350,
      this.semesterHours,
      this.degree,
      this.certs,
      this.language,
      this.milTrainMax,
      this.awardsMax,
      this.milEdMax,
      this.civEdMax,
      this.total);

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
      map['id'],
      map['date'],
      map['name'],
      map['rank'],
      map['version'],
      map['ptTest'],
      map['weapons'],
      map['awards'],
      map['badges'],
      map['airborne'],
      map['ncoes'],
      map['wbc'],
      map['resident'],
      map['tabs'],
      map['ar350'],
      map['semesterHours'],
      map['degree'],
      map['certs'],
      map['language'],
      map['milTrain'],
      map['awardsTotal'],
      map['milEd'],
      map['civEd'],
      map['total'],
    );
  }
}
