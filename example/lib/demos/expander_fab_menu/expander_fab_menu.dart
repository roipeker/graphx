import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class ExpanderFabMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Custom Animation',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: null,
          ),
        ),
        body: MyMenu(
          child: ListView.builder(
            itemBuilder: (_, idx) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Item num $idx'),
                ),
                elevation: 2,
              );
            },
            itemCount: 50,
          ),
        ),
      ),
    );
  }
}

class MyMenu extends StatefulWidget {
  final Widget child;

  const MyMenu({Key key, this.child}) : super(key: key);

  @override
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> with TickerProviderStateMixin {
  bool isOpen = false;

  AnimationController anim;
  final GlobalKey mySuperKey = GlobalKey();
  final menuScene = MyCoolMenuScene();

  @override
  void initState() {
    super.initState();
    // anim = AnimationController(
    //   vsync: this,
    //   duration: dur,
    // );
    // anim.addListener(() {
    //   setState(() {});
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // getPosition();
    });
  }
  /*
  void getPosition() {
    var ro = mySuperKey.currentContext.findRenderObject() as RenderBox;
    var menuRO = context.findRenderObject() as RenderBox;
    var position = ro.localToGlobal(Offset.zero, ancestor: menuRO);
    menuScene.updatePosition(GRect.fromNative(position & ro.size));
  }
  */

  @override
  Widget build(BuildContext context) {
    final baseButton = IconButton(
      icon: Icon(Icons.android),
      onPressed: () {},
    );
    return SceneBuilderWidget(
      builder: () => SceneController(
        front: menuScene,
      ),
      child: Stack(
        children: [
          Container(
            // color: Colors.red,
            child: Column(
              children: [
                Expanded(child: widget.child),
                Container(
                  height: 60,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 12,
                        offset: Offset(0, -1),
                        spreadRadius: 2)
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      baseButton,
                      baseButton,
                      Container(
                        width: 40,
                        height: 40,
                        color: Colors.transparent,
                        key: mySuperKey,
                      ),
                      // Visibility(
                      //   visible: !isOpen,
                      //   child: myFav(),
                      // ),
                      baseButton,
                      baseButton,
                    ],
                  ),
                ),
              ],
            ),
          ),
          // buildMenu(),
          // buildAnimFab(),
        ],
      ),
    );
  }

// Widget buildAnimFab() {
//   print(isOpen);
//   print(anim.value);
//   print(pos);
//   if (!isOpen) {}
//   return Positioned(
//     top: pos.dy * (1 - anim.value),
//     left: pos.dx,
//     child: IconButton(
//       // key: mySuperKey,
//       icon: Icon(
//         Icons.accessibility,
//         color: Colors.red,
//       ),
//       // backgroundColor: Colors.white,
//       onPressed: () {
//         isOpen = !isOpen;
//         trace('pressed', isOpen);
//         if (isOpen) {
//           anim.forward();
//         } else {
//           anim.reverse();
//         }
//       },
//     ),
//   );
// }
}

class MyCoolMenuScene extends GSprite {
  MyButton button;

  bool isOpen = false;

  MyCoolMenuScene() {
    button = MyButton();
  }

  double buttonY;
  GShape curtain;

  void updatePosition(GRect position) {
    button.x = position.x + position.width / 2;
    button.y = buttonY = position.y + position.height / 2;
  }

  GSprite menuContainer;

  @override
  void addedToStage() {
    super.addedToStage();
    curtain = GShape();
    addChild(curtain);

    menuContainer = GSprite();
    addChild(menuContainer);
    _buildMenu();
    addChild(button);

    button.onMouseClick.add((event) {
      isOpen = !isOpen;
      button.open(isOpen);
      showMenuNow();
      if (isOpen) {
        curtain.tween(
          duration: .3,
          alpha: 1,
        );
        button.tween(
          duration: .95,
          rotation: deg2rad(45 * 6.0),
          ease: GEase.easeInOutExpo,
          y: button.height / 2 + 80,
          // scale: 1.5,
          onUpdate: () {
            if (button.y > sh * .5) {
              twnCurtainY = button.y;
              _renderCurt();
            } else {
              _bounceCurtain();
            }
          },
        );
      } else {
        curtain.tween(
          duration: .5,
          alpha: 0,
        );
        button.tween(
          duration: .75,
          rotation: deg2rad(0),
          ease: GEase.easeOutExpo,
          scale: 1,
          y: buttonY,
          // onUpdate: _updateButton,
        );
      }
    });
  }

  double get sw => stage.stageWidth;

  double get sh => stage.stageHeight;
  double twnCurtainY = 0.0;

  bool bounceCurtain = false;

  _bounceCurtain() {
    if (bounceCurtain) return;
    bounceCurtain = true;
    final myTween = twnCurtainY.twn;
    myTween.tween(
      sh,
      duration: 1,
      ease: GEase.easeOutQuad,
      onUpdate: () {
        twnCurtainY = myTween.value;
        _renderCurt();
      },
      onComplete: () {
        bounceCurtain = false;
      },
    );
  }

  void _renderCurt() {
    final g = curtain.graphics;

    g.clear();
    // g.lineStyle(2, Colors.black);
    g.beginFill(Colors.red);
    g.moveTo(0, sh);
    g.curveTo(button.x, sh, button.x, twnCurtainY);
    g.curveTo(button.x, sh, sw, sh);
    g.lineTo(sw, 0).lineTo(0, 0).closePath();
  }

  List<GText> items = [];

  void _buildMenu() {
    items = [];
    var list = ['Reminder', 'Camera', 'Attachment', 'Text Note'];
    for (var i = 0; i < list.length; ++i) {
      var itm = GText.build(
        text: list[i],
        color: Colors.white,
        fontSize: 20,
        doc: menuContainer,
      );
      itm.alignPivot();
      itm.alpha = 0;
      itm.y = i * 34.0;
      items.add(itm);
    }
    menuContainer.alignPivot();
    menuContainer.setPosition(sw / 2, sh / 2);
  }

  void showMenuNow() {
    var len = items.length;
    for (var i = 0; i < items.length; ++i) {
      var itm = items[i];
      itm.y = i * 34.0;
      var ta = isOpen ? 1 : 0;
      if (isOpen) {
        itm.tween(duration: .45, delay: .25 + ((len - 1) - i) * .09, alpha: ta);
      } else {
        itm.tween(duration: .12, delay: 0, alpha: 0, overwrite: 1);
      }
    }
  }
}

class MyButton extends GSprite {
  GShape bg;
  GIcon icon;
  double radius = 20;

  @override
  void addedToStage() {
    super.addedToStage();
    bg = GShape();
    addChild(bg);
    bg.graphics.beginFill(Colors.red).drawCircle(0, 0, radius).endFill();
    icon = GIcon(Icons.add);
    addChild(icon);
    icon.alignPivot();
    mouseChildren = false;
    useCursor = true;
    onMouseOver.add((event) {
      scale = sc * 1.2;
    });
    onMouseOut.add((event) {
      scale = sc * 1;
    });
  }

  double sc = 1.0;

  bool isOpen = false;

  void open(bool isOpen) {
    this.isOpen = isOpen;
    // sc = isOpen ? 1.5:1.0;
    bg.colorize = isOpen ? Colors.white : Colors.red;
    icon.color = isOpen ? Colors.red : Colors.white;
    // bg.tween(
    //   duration: .1,
    //   colorize: isOpen ? Colors.white : Colors.red,
    // );
    // icon.tween(
    //   duration: .1,
    //   colorize: isOpen ? Colors.red : Colors.white,
    // );
  }
}
