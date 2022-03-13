import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:my_custom_alarm/DB/db.dart';
import 'package:my_custom_alarm/data/alarm.dart';
// Todo : edit
class CreateAlarm extends StatefulWidget {
  const CreateAlarm({Key? key}) : super(key: key);

  @override
  _CreateAlarmState createState() => _CreateAlarmState();
}
class _CreateAlarmState extends State<CreateAlarm> {
  DateTime _settingTime = DateTime.now(); // 알람 울리는 시각
  List<bool> _days = [false, false, false, false, false, false, false];
  DateTime? _settingDay; // 알람이 울리는 특정일
  String? _alarmName = '';
  List<bool> _option = [
    false,
    false,
    false
  ]; //_isSound = false, _isVib = false, _isRepeat = false;
  List<String> _optionStr = ['', '', ''];

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

    var fido = testAlarm(
      id: 0, // Todo : id autoincrement
      alarmName: _settingTime.toString()
    );

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
        child: TimePickerSpinner(
          is24HourMode: false,
          spacing: 70,
          isForce2Digits: true,
          normalTextStyle: TextStyle(fontSize: 25, color: Colors.black26),
          highlightedTextStyle: TextStyle(fontSize: 35, color: Colors.white70),
          onTimeChange: (time) {
            setState(() {
              _settingTime = time;
              print(_settingTime); // TODO: second 를 0으로 세팅
            });
          },
        ));
  }

  Widget Inner() {
    return Container(
        child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: new Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 10)),
          _showChild1_check_day(),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          _showChild2_set_name(),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          _showChild3_switch(),
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
                          })
                        });
                  },
                  icon: Icon(Icons.calendar_today),
                  color: Colors.white70,
                ),
                Text(
                  _settingDay != null ? "$_settingDay" : "매일", // TODO:_mon 사용
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 요일 체크
              _dayChecker("월", 0),
              _dayChecker("화", 1),
              _dayChecker("수", 2),
              _dayChecker("목", 3),
              _dayChecker("금", 4),
              _dayChecker("토", 5),
              _dayChecker("일", 6),
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
    return Column(
      children: <Widget>[
        _optionChecker("소리", _sound, 0),
        _optionChecker("진동", _vib, 1),
        _optionChecker("반복", _repeat, 2)
      ],
    );
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          onPressed: func,
          child: Text(
            optText +
                " | " +
                (_optionStr[opt] == '' ? "default" : _optionStr[opt]),
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
        Switch(
          value: _option[opt],
          onChanged: (value) {
            setState(() {
              _option[opt] = !_option[opt];
            });
          },
          activeColor: Colors.white70,
          inactiveThumbColor: Colors.black,
        )
      ],
    );
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
}

// time_picker_spinner example https://pub.dev/packages/flutter_time_picker_spinner/example
// Scrollable Column https://stackoverflow.com/questions/52053850/flutter-how-to-make-a-column-screen-scrollable
// layout https://flutter-ko.dev/docs/development/ui/layout/tutorial
// calendar DatePicker https://kyungsnim.net/77
// EdgeInsets.symmetric https://negabaro.github.io/archive/flutter-painting-EdgeInsets
// border https://api.flutter.dev/flutter/painting/Border-class.html
// TextField https://dev-yakuza.posstree.com/ko/flutter/widget/textfield/
// call by reference 를 List 사용하기 https://devmemory.tistory.com/34
