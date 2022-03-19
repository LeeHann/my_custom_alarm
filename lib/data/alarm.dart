import '../DB/db.dart';

class testAlarm{
  int? id;
  DateTime? _settingTime;
  List<bool> _days = [false, false, false, false, false, false, false];
  DateTime? _settingDay; // 알람이 울리는 특정일
  String? alarmName;
  List<bool> _option = [false, false, false];
  // bool _isSound = false, _isVib = false, _isRepeat = false;

  testAlarm({this.id, required this.alarmName});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAlarmName: alarmName
    };
    if(id != null){
      map[columnId] = id;
    }
    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    alarmName = map[columnAlarmName];
    print('$id $alarmName');
  }

}