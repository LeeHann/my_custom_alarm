import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class CreateAlarm extends StatefulWidget {
  const CreateAlarm({Key? key}) : super(key: key);

  @override
  _CreateAlarmState createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {
  DateTime _settingTime = DateTime.now(); // 알람 울리는 시각
  List<bool> _days = [false, false, false, false, false, false, false];
  DateTime? _settingDay; // 알람이 울리는 특정일
  String? _alarmName;
  bool _isSound = false, _isVib = false, _isRepeat = false;

  @override
  Widget build(BuildContext context) {
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

  void saveDB() {
    print("save");
  } // Todo:saveDB

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
              print(_settingTime); // TODO: second를 0으로 세팅
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
          _showChild1_check_day(),
          _showChild2_set_name(),
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
        Padding(padding: EdgeInsets.only(bottom: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: _sound,
              child: Text(
                "소리 | " + "default",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ), // Todo : default를 알람음 이름으로 변경

            Switch(
              value: _isSound,
              onChanged: (value) {
                setState(() {
                  _isSound = !_isSound;
                  print(_isSound);
                });
              },
              activeColor: Colors.white70,
              inactiveThumbColor: Colors.black,
            )
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: _vib,
              child: Text(
                "진동 | " + "default",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ), // Todo : default를 진동 이름으로 변경
            Switch(
              value: _isVib,
              onChanged: (value) {
                setState(() {
                  _isVib = !_isVib;
                  print(_isVib);
                });
              },
              activeColor: Colors.white70,
              inactiveThumbColor: Colors.black,
            )
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: _repeat,
              child: Text(
                "반복 | " + "default",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ), // Todo : default를 반복 횟수로 변경
            ),
            Switch(
              value: _isRepeat,
              onChanged: (value) {
                setState(() {
                  _isRepeat = !_isRepeat;
                  print(_isRepeat);
                });
              },
              activeColor: Colors.white70,
              inactiveThumbColor: Colors.black,
            )
          ],
        ),
        _optionChecker("optText", _repeat, _isRepeat)
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
  Widget _optionChecker(String optText, func, var val) {  // Todo : flutter call by reference 를 좀 더 조사할 것
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          onPressed: func,
          child: Text(
            optText + " | " + "default",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ), // Todo : default를 함수 반환 값으로 변경
        ),
        Switch(
          value: val,
          onChanged: (value) {
            setState(() {
              val = !val;
              print(val);
            });
          },
          activeColor: Colors.white70,
          inactiveThumbColor: Colors.black,
        )
      ],
    );
  }

  void _sound() {
    print("sound");
  }

  void _vib() {
    print("vib");
  }

  void _repeat() {
    print("repeat");
  }
}

// time_picker_spinner example https://pub.dev/packages/flutter_time_picker_spinner/example
// Scrollable Column https://stackoverflow.com/questions/52053850/flutter-how-to-make-a-column-screen-scrollable
// layout https://flutter-ko.dev/docs/development/ui/layout/tutorial
// calendar DatePicker https://kyungsnim.net/77
// EdgeInsets.symmetric https://negabaro.github.io/archive/flutter-painting-EdgeInsets
// border https://api.flutter.dev/flutter/painting/Border-class.html
// TextField https://dev-yakuza.posstree.com/ko/flutter/widget/textfield/
