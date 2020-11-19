# Drawing with GraphX™

In **GraphX™** we have a couple of classes for rendering things.
These are `Shape` and `Sprite` .

Those classes have a initial method wich is called when the object
is added to the stage, this method, is named by the way `addedToStage` .
In this method, we can handle the drawing of our object.

For example, a simple rendering of a square can be:

``` dart
@override
void addedToStage(){
  graphics.beginFill(0x0000ff, .6)
  ..drawRoundRect(100, 100, 40, 40, 4)
  ..endFill();

}
```

Output: 

![basic_square](https://user-images.githubusercontent.com/44511181/99677710-c8d7b300-2a58-11eb-849e-8a3a5e79f144.jpg)

Always when we want to draw a shape, we have to start with the
`beginFill()` property.

To draw a circle, is that simple 

``` dart
@override
void addedToStage() {
    graphics.beginFill(0x0000ff, .6)
    ..drawCircle(
        200,
        200,
        120,
    ).endFill();
}
```

Output: 

![basic_circle](https://user-images.githubusercontent.com/44511181/99679843-2a991c80-2a5b-11eb-95cb-0c77318dc9cd.jpg)

To draw a line, it changes a little bit, you don't need
to begin with the begin fill, but `lineStyle` where we configure the `thickness` and the `color` with the hex value.

``` dart
graphics.lineStyle(4.0, Colors.green.value);
```

Then the `moveTo(x,y)` property allow us to move the *pencil* to a particular place to start drawing, from there, we can use the `lineTo(x,y)` .

``` dart
@override
void addedToStage() {
graphics.lineStyle(4.0, Colors.green.value)
    ..moveTo(100, 100)
    ..lineTo(100, 200)
    ..endFill();
}
```

![basic_line](https://user-images.githubusercontent.com/44511181/99682895-7f8a6200-2a5e-11eb-97c9-718a552d26c1.jpg)

The `closePath()` property, provide us a way to close the shape.

This is a shape without the `closePath()`

``` dart
@override
void addedToStage() {
graphics.lineStyle(4.0, Colors.green.value)
    ..moveTo(100, 100)
    ..lineTo(100, 200)
    ..lineTo(200, 100)
    ..lineTo(100, 100)
    ..endFill();
 }

```
Output: 

![closePath](https://user-images.githubusercontent.com/44511181/99716119-7b723a80-2a86-11eb-8460-ad5aec26107e.jpg)

and with the `closePath()`
```dart
@override
void addedToStage() {
graphics.lineStyle(4.0, Colors.green.value)
    ..moveTo(100, 100)
    ..lineTo(100, 200)
    ..lineTo(200, 100)
    ..lineTo(100, 100)
    ..closePath()
    ..endFill();
}

```
Output: 

![closePathFinal](https://user-images.githubusercontent.com/44511181/99716537-fdfafa00-2a86-11eb-9167-e6e410320922.jpg)

### Handling multiples objects

For add multiples objects in the same scene, just need to create a `shape` and add it into the stage. This new shape have also a `graphics` property where we can draw.

```dart
@override
void addedToStage() {
    final shape1 = Shape();
    final shape2 = Shape();
    shape1.graphics
        .beginFill(
            Colors.deepOrange.value,
        )
        .drawStar(100, 100, 5, 60);
    shape2.graphics
        .beginFill(
            Colors.deepOrange.value,
        )
        .drawStar(200, 200, 5, 60);
    addChild(shape1);
    addChild(shape2);
}
```
Output:

![multipleObjects](https://user-images.githubusercontent.com/44511181/99721646-4c5fc700-2a8e-11eb-8445-1d8f1c1d68a8.jpg)

After the shape is created, we can change some properties, like
the 
* scale
* alpha
* etc.

```dart
@override
void addedToStage() {
    final shape1 = Shape();
    final shape2 = Shape();
    shape1.graphics
        .beginFill(
            Colors.deepOrange.value,
        )
        .drawStar(100, 100, 5, 60);
    shape2.graphics
        .beginFill(
            Colors.deepOrange.value,
        )
        .drawStar(200, 200, 5, 60);
    shape1.scale = 1.2;
    shape1.alpha = .9;
    shape2.x = 150;
    shape2.scaleY = 1.3;
    addChild(shape1);
    addChild(shape2);
}
```
Output:

![properties_changed](https://user-images.githubusercontent.com/44511181/99722706-cfcde800-2a8f-11eb-9999-2a0301f36e2b.jpg)


