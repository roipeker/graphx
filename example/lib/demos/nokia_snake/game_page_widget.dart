import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'commands.dart';
import 'game_scene.dart';
import 'mobile_button_widget.dart';
import 'nokia_snake.dart';

class GamePage extends StatefulWidget {
  final int speed;

  const GamePage({Key? key, required this.speed}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String scroreTF = 'SCORE: 0';

  void updateScore(String score) {
    setState(() {
      scroreTF = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    mps.subscribe('Score', updateScore);
    return Scaffold(
      backgroundColor: SnakeGameScene.boardBackground,
      bottomNavigationBar: Container(
        color: const Color(0xFF9A9626),
        height: 50,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              scroreTF,
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 10,
                fontFamily: 'pressstart',
              ),
            ),
            scroreTF == 'PAUSED'
                ? IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => NokiaSnakeMain()),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mps.emit1('COMMAND', SnakeCommands.pause),
        backgroundColor: Theme.of(context).accentColor.withOpacity(.4),
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        child: Icon(
          scroreTF == 'PAUSED' ? Icons.play_arrow : Icons.pause,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SceneBuilderWidget(
              builder: () => SceneController(
                config: SceneConfig.games,
                back: SnakeGameScene(widget.speed),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  MobileControlButton.up(
                    () => mps.emit1('COMMAND', SnakeCommands.up),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      MobileControlButton.left(
                        () => mps.emit1('COMMAND', SnakeCommands.left),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      MobileControlButton.right(
                        () => mps.emit1('COMMAND', SnakeCommands.right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MobileControlButton.down(
                    () => mps.emit1('COMMAND', SnakeCommands.down),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
