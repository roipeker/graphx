import 'package:flutter/material.dart';

import 'game_page_widget.dart';

class NokiaSnakeMain extends StatefulWidget {
  const NokiaSnakeMain({super.key});
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
          backgroundColor: const Color(0xFF949425),
          centerTitle: true,
          title: const Column(
            children: [
              Text(
                'NOKIA SNAKE',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF41361F),
                ),
              ),
              SizedBox(height: 4),
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
                onSelected: (dynamic value) => setState(() {
                  speed = value;
                }),
                itemBuilder: (_) => levels
                    .map(
                      (e) => PopupMenuItem(
                        value: e['value'],
                        child: Text(
                          e['text'].toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF41361F),
                            fontSize: 8,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              title: const Text(
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
