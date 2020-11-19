# Drawing with GraphX™

In **GraphX™** we have a couple of classes for rendering things.
These are `Shape` and `Sprite`.

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

Then the `moveTo(x,y)` property allow us to move the *pencil* to a particular place to start drawing, from there, we can use the `lineTo(x,y)`.
```dart
@override
void addedToStage() {
graphics.lineStyle(4.0, Colors.green.value)
    ..moveTo(100, 100)
    ..lineTo(100, 200)
    ..endFill();
}
```
![basic_line](https://user-images.githubusercontent.com/44511181/99682895-7f8a6200-2a5e-11eb-97c9-718a552d26c1.jpg)


