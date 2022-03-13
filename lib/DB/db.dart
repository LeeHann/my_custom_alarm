import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/alarm.dart';

final String tableName = 'alarm';
final String columnId = 'id';
final String columnDateTime = 'settingTime';
final String columnDays = 'days';
final String columnSettingDay = 'settingDay';
final String columnAlarmName = 'alarmName';
final String columnOption = 'option';
// final String columnIsSound = 'isSound';
// final String columnIsVib = 'isVib';
// final String columnIsRepeat = 'isRepeat';


class AlarmProvider {
  // static Database _database;
  var _database;

  Future<Database> get database async {
    if(_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'alarm.db');

    return await openDatabase(path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $tableName(
            $columnId integer primary key autoincrement,
            $columnAlarmName text not null
          )
          '''
        );
      },
      onUpgrade: (db, oldVersion, newVersion){}
    );
  }

    Future<testAlarm> insert(testAlarm test_alarm) async {
      final db = await database;
      print(test_alarm.toMap());
      test_alarm.id = await db.insert(tableName, test_alarm.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      // await db.insert(tableName, test_alarm.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return test_alarm;
    }

  Future<List<testAlarm>> alarms() async {  // 질의
    final db = await database;

    // 모든 Alarm를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps = await db.query('memos');

    // List<Map<String, dynamic>를 List<testAlarm>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return testAlarm(
          id: maps[i][columnId],
          alarmName: maps[i][columnAlarmName]
      );
    });
  }
}


// https://jvvp.tistory.com/1149