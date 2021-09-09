/// roipeker 2021

/// sample video:
/// https://media.giphy.com/media/xC8rB3jR9nXDJDMwQM/source.mp4

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'dialer_scene.dart';

class DialerMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Color(0xff19191B),
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_outlined),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SceneBuilderWidget(
              builder: () => SceneController(front: DialerScene()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  _buildTemperature(),
                  SizedBox(height: 30),

                  /// smart schedule
                  Row(
                    children: [
                      Opacity(opacity: .2, child: Icon(Icons.access_time)),
                      SizedBox(width: 8),
                      Text(
                        'Set smart schedule',
                        style: TextStyle(
                          color: pinkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          letterSpacing: .3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  /// buttons.
                  Row(children: [
                    _buildCircButton(Icons.ac_unit, true),
                    _buildCircButton(Icons.wb_cloudy_outlined, false),
                    _buildCircButton(Icons.wb_sunny, false),
                  ]),
                  SizedBox(height: 30),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.radio_button_off_outlined,
                        color: pinkColor,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          'Hold on to turn AC off',
                          style: TextStyle(
                            color: Colors.white24,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -.1,
                          ),
                          strutStyle:
                              StrutStyle(fontSize: 10, forceStrutHeight: true),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTemperature() {
    return FittedBox(
      child: Container(
        // color: Colors.red,
        // width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'TEMPERATURE, C',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
                height: 16 / 16,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 14),
            Text(
              '72',
              style: TextStyle(
                fontSize: 143,
                letterSpacing: .7,
                fontWeight: FontWeight.bold,
                // backgroundColor: Colors.red.withOpacity(.3),
                // height: 143 / 143,
              ),
              textAlign: TextAlign.left,
              strutStyle: StrutStyle(
                fontSize: 101,
                forceStrutHeight: true,
              ),
              // textHeightBehavior: TextHeightBehavior(
              //   applyHeightToFirstAscent: true,
              //   applyHeightToLastDescent: false,
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircButton(IconData ico, bool selected) {
    // Icons.ac_unit
    return Opacity(
      opacity: selected ? 1 : 0.2,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? pinkColor : Colors.transparent,
          border: Border.all(
              color: selected ? pinkColor : Colors.white70, width: 1.2),
        ),
        child: Icon(
          ico,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }
}
