import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import './ppw.dart';
import './acft.dart';
import './apft.dart';
import './bodyfat.dart';

class DBHelper {
  static Database _db;
  static const String DB_NAME = 'scores.db';

  static const String ID = 'id';
  static const String DATE = 'date';
  static const String NAME = 'name';
  static const String GENDER = 'gender';
  static const String AGE = 'age';
  static const String AGE_GROUP = 'ageGroup';
  static const String TOTAL = 'total';
  static const String PASS = 'pass';

  static const String ACFT_TABLE = 'AcftTable';
  static const String PHYS_CAT = 'physCat';
  static const String MDL_RAW = 'mdlRaw';
  static const String MDL_SCORE = 'mdlScore';
  static const String SPT_RAW = 'sptRaw';
  static const String SPT_SCORE = 'sptScore';
  static const String HRP_RAW = 'hrpRaw';
  static const String HRP_SCORE = 'hrpScore';
  static const String SDC_RAW = 'sdcRaw';
  static const String SDC_SCORE = 'sdcScore';
  static const String LTK_RAW = 'ltkRaw';
  static const String LTK_SCORE = 'ltkScore';
  static const String RUN_RAW = 'runRaw';
  static const String RUN_SCORE = 'runScore';

  static const String APFT_TABLE = 'ApftTable';
  static const String PU_RAW = 'puRaw';
  static const String PU_SCORE = 'puScore';
  static const String SU_RAW = 'suRaw';
  static const String SU_SCORE = 'suScore';
  static const String RUN_EVENT = 'runEvent';
  static const String ALT_PASS = 'altPass';

  static const String BF_TABLE = 'bfTable';
  static const String HEIGHT = 'height';
  static const String WEIGHT = 'weight';
  static const String MAX_WEIGHT = 'maxWeight';
  static const String BMI_PASS = 'bmiPass';
  static const String HEIGHT_DOUBLE = 'heightDouble';
  static const String NECK = 'neck';
  static const String WAIST = 'waist';
  static const String HIP = 'hip';
  static const String BF_PERCENT = 'bfPercent';
  static const String MAX_PERCENT = 'maxPercent';
  static const String OVER_UNDER = 'overUnder';
  static const String BF_PASS = 'bfPass';

  static const String PPW_TABLE = 'ppwTable';
  static const String RANK = 'rank';
  static const String VERSION = 'version';
  static const String PT_TEST = 'ptTest';
  static const String WEAPONS = 'weapons';
  static const String AWARDS = 'awards';
  static const String BADGES = 'badges';
  static const String AIRBORNE = 'airborne';
  static const String NCOES = 'ncoes';
  static const String WBC = 'wbc';
  static const String RESIDENT = 'resident';
  static const String TABS = 'tabs';
  static const String AR_350 = 'ar350';
  static const String SEM_HOURS = 'semesterHours';
  static const String DEGREE = 'degree';
  static const String CERTS = 'certs';
  static const String LANGUAGE = 'language';
  static const String MIL_TRAIN = 'milTrain';
  static const String AWARDS_TOTAL = 'awardsTotal';
  static const String MIL_ED = 'milEd';
  static const String CIV_ED = 'civEd';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $ACFT_TABLE ($ID INTEGER PRIMARY KEY, $DATE TEXT, $RANK TEXT, $NAME TEXT, $GENDER TEXT, $AGE TEXT, $MDL_RAW TEXT,"
        "$MDL_SCORE TEXT, $SPT_RAW TEXT, $SPT_SCORE TEXT, $HRP_RAW TEXT, $HRP_SCORE TEXT, $SDC_RAW TEXT, $SDC_SCORE TEXT, "
        "$LTK_RAW TEXT, $LTK_SCORE TEXT, $RUN_RAW TEXT, $RUN_SCORE TEXT, $RUN_EVENT TEXT, $ALT_PASS INTEGER, $TOTAL TEXT, $PASS INTEGER)");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS $APFT_TABLE ($ID INTEGER PRIMARY KEY, $DATE TEXT, $RANK TEXT, $NAME TEXT, $GENDER TEXT, $AGE TEXT, "
        "$PU_RAW TEXT, $PU_SCORE TEXT, $SU_RAW TEXT, $SU_SCORE TEXT, $RUN_RAW TEXT, $RUN_SCORE TEXT, $RUN_EVENT TEXT, $TOTAL TEXT, "
        "$ALT_PASS INTEGER, $PASS INTEGER)");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS $BF_TABLE ($ID INTEGER PRIMARY KEY, $DATE TEXT, $RANK TEXT, $NAME TEXT, $GENDER TEXT, $AGE TEXT, "
        "$HEIGHT TEXT, $WEIGHT TEXT, $MAX_WEIGHT TEXT, $BMI_PASS INTEGER, $HEIGHT_DOUBLE TEXT, $NECK TEXT, $WAIST TEXT, $HIP TEXT, $BF_PERCENT TEXT, "
        "$MAX_PERCENT TEXT, $OVER_UNDER TEXT, $BF_PASS INTEGER)");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS $PPW_TABLE ($ID INTEGER PRIMARY KEY, $DATE TEXT, $NAME TEXT, $RANK TEXT, $VERSION INTEGER, $PT_TEST INTEGER, $WEAPONS INTEGER, "
        "$AWARDS INTEGER, $BADGES INTEGER, $AIRBORNE INTEGER, $NCOES INTEGER, $WBC INTEGER, $RESIDENT INTEGER, $TABS INTEGER, $AR_350 INTEGER, "
        "$SEM_HOURS INTEGER, $DEGREE INTEGER, $CERTS INTEGER, $LANGUAGE INTEGER, $MIL_TRAIN INTEGER, $AWARDS_TOTAL INTEGER, "
        "$MIL_ED INTEGER, $CIV_ED INTEGER, $TOTAL INTEGER)");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      try {
        await db.execute("ALTER TABLE $ACFT_TABLE ADD $RANK TEXT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $ACFT_TABLE ADD $GENDER TEXT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $ACFT_TABLE ADD $AGE TEXT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $ACFT_TABLE DROP $PHYS_CAT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $APFT_TABLE ADD $RANK TEXT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $APFT_TABLE ADD $AGE TEXT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $APFT_TABLE DROP $AGE_GROUP");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $BF_TABLE ADD $RANK TEXT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $BF_TABLE ADD $AGE TEXT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $BF_TABLE ADD $HEIGHT_DOUBLE TEXT");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $BF_TABLE DROP $AGE_GROUP");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $APFT_TABLE ADD $ALT_PASS INTEGER");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
      try {
        await db.execute("ALTER TABLE $ACFT_TABLE ADD $ALT_PASS INTEGER");
      } on Exception catch (e) {
        print('SQLite Error: $e');
      }
    }
  }

  //ACFT functions
  Future<void> saveAcft(Acft acft) async {
    var dbClient = await db;
    acft.id = await dbClient.insert(ACFT_TABLE, acft.toMap());
  }

  Future<List<Acft>> getAcfts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .rawQuery("SELECT * FROM $ACFT_TABLE ORDER BY $NAME, $DATE ASC");
    List<Acft> acfts = maps.map((e) => Acft.fromMap(e)).toList();
    // if (maps.length > 0) {
    //   for (int i = 0; i < maps.length; i++) {
    //     acfts.add(Acft.fromMap(maps[i]));
    //   }
    // }
    return acfts;
  }

  Future<int> deleteAcft(int id) async {
    var dbClient = await db;
    return await dbClient.delete(ACFT_TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateAcft(Acft acft) async {
    var dbClient = await db;
    return await dbClient.update(ACFT_TABLE, acft.toMap(),
        where: '$ID = ?', whereArgs: [acft.id]);
  }

  //APFT functions
  Future<Apft> saveAPft(Apft apft) async {
    var dbClient = await db;
    apft.id = await dbClient.insert(APFT_TABLE, apft.toMap());
    return apft;
  }

  Future<List<Apft>> getApfts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .rawQuery("SELECT * FROM $APFT_TABLE ORDER BY $NAME, $DATE ASC");
    List<Apft> apfts = maps.map((e) => Apft.fromMap(e)).toList();
    // if (maps.length > 0) {
    //   for (int i = 0; i < maps.length; i++) {
    //     apfts.add(Apft.fromMap(maps[i]));
    //   }
    // }
    return apfts;
  }

  Future<int> deleteApft(int id) async {
    var dbClient = await db;
    return await dbClient.delete(APFT_TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateApft(Apft apft) async {
    var dbClient = await db;
    return await dbClient.update(APFT_TABLE, apft.toMap(),
        where: '$ID = ?', whereArgs: [apft.id]);
  }

  //BF functions
  Future<Bodyfat> saveBodyfat(Bodyfat bf) async {
    var dbClient = await db;
    bf.id = await dbClient.insert(BF_TABLE, bf.toMap());
    return bf;
  }

  Future<List<Bodyfat>> getBodyfats() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .rawQuery("SELECT * FROM $BF_TABLE ORDER BY $NAME, $DATE ASC");
    List<Bodyfat> bodyfats = maps.map((e) => Bodyfat.fromMap(e)).toList();
    // if (maps.length > 0) {
    //   for (int i = 0; i < maps.length; i++) {
    //     bodyfats.add(Bodyfat.fromMap(maps[i]));
    //   }
    // }
    return bodyfats;
  }

  Future<int> deleteBodyfat(int id) async {
    var dbClient = await db;
    return await dbClient.delete(BF_TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateBodyfat(Bodyfat bf) async {
    var dbClient = await db;
    return await dbClient
        .update(BF_TABLE, bf.toMap(), where: '$ID = ?', whereArgs: [bf.id]);
  }

  //PPW functions
  Future<PPW> savePPW(PPW ppw) async {
    var dbClient = await db;
    ppw.id = await dbClient.insert(PPW_TABLE, ppw.toMap());
    return ppw;
  }

  Future<List<PPW>> getPPWs() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .rawQuery("SELECT * FROM $PPW_TABLE ORDER BY $NAME, $DATE ASC");
    List<PPW> ppws = maps.map((e) => PPW.fromMap(e)).toList();
    // if (maps.length > 0) {
    //   for (int i = 0; i < maps.length; i++) {
    //     ppws.add(PPW.fromMap(maps[i]));
    //   }
    // }
    return ppws;
  }

  Future<int> deletePPW(int id) async {
    var dbClient = await db;
    return await dbClient.delete(PPW_TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updatePPW(PPW ppw) async {
    var dbClient = await db;
    return await dbClient
        .update(PPW_TABLE, ppw.toMap(), where: '$ID = ?', whereArgs: [ppw.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
