import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class CreateAlarm extends StatefulWidget {
  const CreateAlarm({Key? key}) : super(key: key);

  @override
  _CreateAlarmState createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {
  DateTime _settingTime = DateTime.now(); // 알람 울리는 시각
  bool _mon = false,
      _tue = false,
      _wed = false,
      _thu = false,
      _fri = false,
      _sat = false,
      _sun = false; // 알람 울리는 요일
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
            )
        )
        )
    );
  }

  void saveDB() {}

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
              Column(children: <Widget>[
                Text(
                  "월",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(
                    _mon
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked_sharp,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    _mon = !_mon;
                    setState(() {
                      Icon(
                        _mon
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked_sharp,
                        color: Colors.white70,
                      );
                    });
                  },
                ),
              ]),
              Column(children: <Widget>[
                Text(
                  "화",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(
                    _tue
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked_sharp,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    _tue = !_tue;
                    setState(() {
                      Icon(
                        _tue
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked_sharp,
                        color: Colors.white70,
                      );
                    });
                  },
                ),
              ]),
              Column(children: <Widget>[
                Text(
                  "수",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(
                    _wed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked_sharp,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    _wed = !_wed;
                    setState(() {
                      Icon(
                        _wed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked_sharp,
                        color: Colors.white70,
                      );
                    });
                  },
                ),
              ]),
              Column(children: <Widget>[
                Text(
                  "목",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(
                    _thu
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked_sharp,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    _thu = !_thu;
                    setState(() {
                      Icon(
                        _thu
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked_sharp,
                        color: Colors.white70,
                      );
                    });
                  },
                ),
              ]),
              Column(children: <Widget>[
                Text(
                  "금",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(
                    _fri
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked_sharp,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    _fri = !_fri;
                    setState(() {
                      Icon(
                        _fri
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked_sharp,
                        color: Colors.white70,
                      );
                    });
                  },
                ),
              ]),
              Column(children: <Widget>[
                Text(
                  "토",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(
                    _sat
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked_sharp,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    _sat = !_sat;
                    setState(() {
                      Icon(
                        _sat
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked_sharp,
                        color: Colors.white70,
                      );
                    });
                  },
                ),
              ]),
              Column(children: <Widget>[
                Text(
                  "일",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(
                    _sun
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked_sharp,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    _sun = !_sun;
                    setState(() {
                      Icon(_sun
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked_sharp);
                    });
                  },
                ),
              ]),
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
              hintStyle: TextStyle(color : Colors.white70),
            ),
            style: TextStyle(color : Colors.white70),
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
        Row(
          children: <Widget>[
            Text("알람음 | Default"),
            Switch(value: _isSound, onChanged: (value){
              setState(() {
                _isSound = !_isSound;
                print(_isSound);
              });
            }, activeColor: Colors.white70, inactiveThumbColor: Colors.black,)
          ],
        ),
      ],
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
