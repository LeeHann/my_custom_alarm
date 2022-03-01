import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class CreateAlarm extends StatefulWidget {
  const CreateAlarm({Key? key}) : super(key: key);

  @override
  _CreateAlarmState createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {
  DateTime _settingTime = DateTime.now();
  String _settingDay = "";

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
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            spinner(),
            Inner(),
          ],
        ));
  }

  Widget spinner() {
    return new TimePickerSpinner(
      is24HourMode: false,
      spacing: 50,
      isForce2Digits: true,
      normalTextStyle: TextStyle(fontSize: 35, color: Colors.black26),
      highlightedTextStyle: TextStyle(fontSize: 35, color: Colors.white70),
      onTimeChange: (time) {
        setState(() {
          _settingTime = time;
        });
      },
    );
  }

  Widget Inner() {
    return Container(
        child: SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          _showChild1(),
        ],
      ),
    ));
  }

  Widget _showChild1() {
    return Container(
      child: Column(
        // (매일 / 달력 아이콘) / (요일 체크)
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            Text(
              "매일", // TODO:string _settingDay 사용
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            IconButton(
              onPressed: () {
                Future<DateTime?> selected = showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 5)); // TODO: 달력 날짜 선택 시 action 추가
              },
              icon: Icon(Icons.calendar_today),
              color: Colors.white70,
            )
          ]),
          Row(
            children: [ // TODO:요일 체크
              
            ],
          )
        ],
      ),
    );
  }

  void saveDB() {}
}

// time_picker_spinner example https://pub.dev/packages/flutter_time_picker_spinner/example
// Scrollable Column https://stackoverflow.com/questions/52053850/flutter-how-to-make-a-column-screen-scrollable
// layout https://flutter-ko.dev/docs/development/ui/layout/tutorial
// calendar DatePicker https://kyungsnim.net/77
// EdgeInsets.symmetric https://negabaro.github.io/archive/flutter-painting-EdgeInsets
