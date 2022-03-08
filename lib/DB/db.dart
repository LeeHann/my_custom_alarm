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
final String columnIsSound = 'isSound';
final String columnIsVib = 'isVib';
final String columnIsRepeat = 'isRepeat';


class AlarmProvider {
  static Database _database;

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
      test_alarm.id = await db.insert(tableName);
      return test_alarm;
    }

}


// https://jvvp.tistory.com/1149