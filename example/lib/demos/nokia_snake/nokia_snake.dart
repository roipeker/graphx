/// Ismail Alam Khan and roipeker, 2020.
///
/// snake game in graphx.
///

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphx/graphx.dart';

import 'game_page_widget.dart';

class NokiaSnakeMain extends StatefulWidget {
  const NokiaSnakeMain({Key key}) : super(key: key);

  @override
  _NokiaSnakeMainState createState() => _NokiaSnakeMainState();
}

class _NokiaSnakeMainState extends State<NokiaSnakeMain> {
  // int startTime = 3;
  // Timer startTimer;
  int speed = 6;
  final List<Map<String, dynamic>> levels = [
    {'text': 'Easy', 'value': 6},
    {'text': 'Normal', 'value': 4},
    {'text': 'Hard', 'value': 2}
  ];

  @override
  void initState() {
    // startTimer = Timer.periodic(
    //   Duration(milliseconds: 3),
    //   (timer) {
    //     setState(() {
    //       startTime--;
    //     });
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'pressstart',
        primaryColor: const Color(0xFF9A9626),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF9A9626),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 50,
          backgroundColor: Color(0xFF949425),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'NOKIA SNAKE',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF41361F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'BY ISMAIL ALAM KHAN',
                style: TextStyle(
                  color: Color(0xFF41361F),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => GamePage(speed: speed)),
                );
              },
              trailing: PopupMenuButton(
                initialValue: speed,
                onSelected: (value) => setState(() {
                  speed = value;
                }),
                itemBuilder: (_) => levels
                    .map(
                      (e) => PopupMenuItem(
                        child: Text(
                          e['text'].toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFF41361F),
                            fontSize: 8,
                          ),
                        ),
                        value: e['value'],
                      ),
                    )
                    .toList(),
              ),
              title: Text(
                'START GAME',
                style: TextStyle(
                  color: Color(0xFF42371C),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
