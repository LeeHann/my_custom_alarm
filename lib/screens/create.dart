import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:my_custom_alarm/DB/db.dart';
import 'package:my_custom_alarm/data/alarm.dart';
import 'package:intl/intl.dart';

// Todo : edit
class CreateAlarm extends StatefulWidget {
  const CreateAlarm({Key? key}) : super(key: key);

  @override
  _CreateAlarmState createState() => _CreateAlarmState();
}

String convertDay(int i) {
  switch (i) {
    case 0:
      return "월";
    case 1:
      return "화";
    case 2:
      return "수";
    case 3:
      return "목";
    case 4:
      return "금";
    case 5:
      return "토";
    case 6:
      return "일";
    default:
      return "";
  }
}

class _CreateAlarmState extends State<CreateAlarm> {
  DateTime _settingTime = DateTime.now(); // 알람 울리는 시각
  List<bool> _days = [false, false, false, false, false, false, false];
  DateTime? _settingDay = DateTime.now().add(Duration(days: 1)); // 알람이 울리는 특정일
  String? _alarmName = '';
  List<bool> _option = [false, false, false];
  //_isSound = false, _isVib = false, _isRepeat = false;
  List<String> _optionStr = ['', '', ''];
  // 사운드 이름, 진동 이름, 반복 횟수 - 다른 페이지에서 가져오기
  bool _softMode = false, _hardMode = false, _narrMode = false;

  BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextButton(
                onPressed: saveDB,
                child: Text(
                  "저장",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ))
          ],
        ),
        backgroundColor: Colors.indigo,
        // resizeToAvoidBottomInset: false,
        body: GestureDetector(
            // 키보드 외 다른 곳 클릭 시 키보드 감추기
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10)),
                spinner(),
                Inner(), // 스크롤링 가능
              ],
            ))));
  }

  Future<void> saveDB() async {
    AlarmProvider ap = AlarmProvider();

    //  _settingTime // 알람 울리는 시각
    //  _days = [false, false, false, false, false, false, false];
    //   _settingDay = DateTime.now().add(Duration(days: 1)); // 알람이 울리는 특정일
    //   _alarmName = '';
    //   _option = [false, false, false]; //_isSound = false, _isVib = false, _isRepeat = false;
    //   _softMode = false, _hardMode = false, _narrMode = false;
    var fido = testAlarm(alarmName: _settingTime.toString());

    print(await ap.insert(fido));
    Navigator.pop(_context!);
  }

  Widget spinner() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.white12),
        ),
      ),
      child: TextButton(
        child: Text(DateFormat('jm').format(_settingTime),
            style: TextStyle(color: Colors.white70, fontSize: 40)),
        onPressed: () {
          _settingTime =
              _settingTime.subtract(Duration(seconds: _settingTime.second));
          TimeOfDay _time = TimeOfDay.fromDateTime(_settingTime);
          Future<TimeOfDay?> selected = showTimePicker(
            context: context,
            initialTime: _time,
          );
          selected.then((value) => {
                setState(() {
                  final now = new DateTime.now();
                  if (value == null)
                    _settingTime = DateTime(
                        now.year, now.month, now.day, now.hour, now.minute);
                  else
                    _settingTime = DateTime(
                        now.year, now.month, now.day, value.hour, value.minute);
                  // print(_settingTime);
                })
              });
        },
      ),
    );
  }

  Widget Inner() {
    return Container(
        child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 10)),
          _showChild2_set_name(),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          _showChild1_check_day(),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          _showChild3_switch(),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          _showChild4_mode(),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          _showChild5_memo(),
          Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
    ));
  }

  Widget _showChild1_check_day() {
    return Container(
      child: Column(
        // (매일 / 달력 아이콘) / (요일 체크)
        children: <Widget>[
          Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Future<DateTime?> selected = showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 5),
                    ); // 달력 날짜 선택 시 action 추가
                    selected.then((dateTime) => {
                          setState(() {
                            _settingDay = dateTime;
                            print(_settingDay);
                            for (int i = 0; i < 7; i++)
                              _days[i] = false; // _days를 모두 false로 만든다
                          })
                        });
                  },
                  icon: Icon(Icons.calendar_today),
                  color: Colors.white70,
                ),
                Text(
                  _settingDay != null
                      ? DateFormat('M월 d일').format(_settingDay!)
                      : countDay(),
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 요일 체크
              for (var i in [0, 1, 2, 3, 4, 5, 6])
                _dayChecker(convertDay(i), i),
            ],
          ) // 요일 체크
        ],
      ),
    );
  }

  Widget _showChild2_set_name() {
    return Column(
      children: <Widget>[
        TextField(
            decoration: InputDecoration(
              hintText: '알람 이름을 입력하세요',
              hintStyle: TextStyle(color: Colors.white70),
            ),
            maxLines: null,
            style: TextStyle(color: Colors.white70),
            onChanged: (text) {
              setState(() {
                _alarmName = text;
                print(_alarmName);
              });
            }),
      ],
    );
  }

  Widget _showChild3_switch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _optionChecker("소리", _sound, 0),
        Padding(padding: EdgeInsets.only(right: 10)),
        _optionChecker("진동", _vib, 1),
        Padding(padding: EdgeInsets.only(right: 10)),
        _optionChecker("반복", _repeat, 2)
      ],
    );
  }

  Widget _showChild4_mode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _modeChecker(0),
        Padding(padding: EdgeInsets.only(right: 10)),
        _modeChecker(1)
      ],
    );
  }

  Widget _showChild5_memo() {
    return Container(
        width: 350,
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "메모 읽어주기",
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),
                Switch(
                  value: _narrMode,
                  onChanged: (value) {
                    setState(() {
                      _narrMode = !_narrMode;
                    });
                  },
                  activeColor: Colors.white70,
                ),
              ],
            ),
            // if (_narrMode) ...[
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  hintText: '메모를 입력하세요',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                maxLines: null,
                style: TextStyle(color: Colors.white70),
              ),
            // ]
          ],
        ));
  }

  String countDay() {
    String cntDay = "";
    for (int i = 0; i < 7; i++) {
      if (_days[i] == true) {
        if (cntDay != "") cntDay += ", ";
        cntDay += convertDay(i);
      }
    }
    if (!_days.contains(false)) cntDay = "매일";
    return cntDay;
  }

  Widget _dayChecker(String dayText, int day) {
    return Column(children: <Widget>[
      Text(
        dayText,
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
      IconButton(
        icon: Icon(
          _days[day] ? Icons.check_circle : Icons.radio_button_unchecked_sharp,
          color: Colors.white70,
        ),
        onPressed: () {
          _days[day] = !_days[day];
          setState(() {
            _settingDay = null;
            if (!_days.contains(true))
              _settingDay = DateTime.now().add(Duration(days: 1));
            Icon(
              _days[day]
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked_sharp,
              color: Colors.white70,
            );
          });
        },
      ),
    ]);
  }

  Widget _optionChecker(String optText, func, int opt) {
    return Container(
        width: 110,
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: func,
              child: Text(
                optText +
                    "\n" +
                    (_optionStr[opt] == '' ? "default" : _optionStr[opt]),
                style: TextStyle(color: Colors.white70, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Switch(
              value: _option[opt],
              onChanged: (value) {
                setState(() {
                  _option[opt] = !_option[opt];
                  if (opt == 0) // sound
                  {
                    _softMode = false;
                    _hardMode = false;
                  }
                });
              },
              activeColor: Colors.white70,
              inactiveThumbColor: Colors.black,
            )
          ],
        ));
  }

  void _sound() {
    setState(() {
      if (_optionStr[0] == '')
        _optionStr[0] = "sound";
      else
        _optionStr[0] = '';
    });
  }

  void _vib() {
    setState(() {
      if (_optionStr[1] == '')
        _optionStr[1] = "vib";
      else
        _optionStr[1] = '';
    });
  }

  void _repeat() {
    setState(() {
      if (_optionStr[2] == '')
        _optionStr[2] = "repeat";
      else
        _optionStr[2] = '';
    });
  }

  Widget _modeChecker(int pos) {
    // pos == 0; softMode | pos==1; hardMode
    return InkWell(
      onTap: () {
        setState(() {
          if (pos == 0) {
            // softMode
            _softMode = !_softMode;
            _hardMode = false;
          } else {
            // hardMode
            _hardMode = !_hardMode;
            _softMode = false;
          }
          if (_softMode || _hardMode) _option[0] = true;
        });
      },
      child: Container(
        width: 170,
        height: 50,
        decoration: BoxDecoration(
            color: (pos == 0
                ? (_softMode ? Colors.black26 : Colors.white10)
                : (_hardMode ? Colors.black26 : Colors.white10)),
            borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(pos == 0 ? "소프트모드" : "하드모드",
                style: TextStyle(color: Colors.white70, fontSize: 17))
          ],
        ),
      ),
    );
  }
}

// time_picker_spinner example https://pub.dev/packages/flutter_time_picker_spinner/example
// Scrollable Column https://stackoverflow.com/questions/52053850/flutter-how-to-make-a-column-screen-scrollable
// layout https://flutter-ko.dev/docs/development/ui/layout/tutorial
// calendar DatePicker https://kyungsnim.net/77
// EdgeInsets.symmetric https://negabaro.github.io/archive/flutter-painting-EdgeInsets
// border https://api.flutter.dev/flutter/painting/Border-class.html
// TextField https://dev-yakuza.posstree.com/ko/flutter/widget/textfield/
// call by reference 를 List 사용하기 https://devmemory.tistory.com/34
// DateTime Format https://stackoverflow.com/questions/52627973/dart-how-to-set-the-hour-and-minute-of-datetime-object
// DateTime Format Docs https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
// show time picker https://material.io/components/time-pickers/flutter#mobile-time-input-pickers
// TimeOfDay class https://api.flutter.dev/flutter/material/TimeOfDay-class.html
// how to convert TimeOfDay to DateTime https://stackoverflow.com/questions/50198891/how-to-convert-flutter-timeofday-to-datetime
// how to use conditional statement on child widget in flutter https://www.fluttercampus.com/guide/131/how-to-use-conditional-statement-if-else-on-widget-in-flutter/
