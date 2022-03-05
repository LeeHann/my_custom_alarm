import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_custom_alarm/screens/create.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:date_format/date_format.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('alarm',
                  style: TextStyle(fontSize: 25, color: Colors.amber),
                ),
              ),
              TimerBuilder.periodic(
                  const Duration(seconds: 1),
                  builder: (context) {
                    return Text(
                        formatDate(
                            DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]),
                        style: const TextStyle(
                          fontSize: 45,
                          color: Colors.amber,
                        )
                    );
                  },
              )
            ],
            //mainAxisAlignment: MainAxisAlignment.center),
        )
      ),
      backgroundColor: Colors.white24,
      floatingActionButton: FloatingActionButton( // 알람 추가 버튼 create를 테스트하기 위해 작성함 - column 안에 넣는 등 레이아웃에 넣어서 배열하면 좋을 듯
        onPressed: () {
          Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => CreateAlarm()))
              .then((value) {
            setState(() {});
          });
        },
        tooltip: '알람을 추가하세요.',
        child: const Icon(Icons.add),
      ),
    );
  }
}
