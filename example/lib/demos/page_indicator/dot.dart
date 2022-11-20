import 'package:graphx/graphx.dart';

class PageDot extends GShape {
  int id;

  double? _baseSize;

  Color? _color;

  Color? get color => _color;

  set color(Color? value) {
    if (value == _color) return;
    _color = value;
    _invalidateDraw();
  }

  Color? _targetColor;

  Color? get targetColor => _targetColor;

  GTweenableColor? _colorTween;
  bool _invalidColor = false;

  set targetColor(Color? value) {
    if (value == _color) return;
    _targetColor = value;
    _invalidColor = true;
  }

  double? _size;
  double? targetSize;

  double get size => _size!;

  set size(double value) {
    if (value < _baseSize!) value = _baseSize!;
    if (value == _size) return;
    _size = value;
    _invalidateDraw();
    // _draw();
  }

  PageDot(this.id, double baseSize, Color color) {
    _color = color;
    targetSize = _size = _baseSize = baseSize;
    _invalidateDraw();
  }

  void _draw() {
    graphics
        .clear()
        .beginFill(_color!)
        .drawRoundRect(0, 0, _size!, _baseSize!, _baseSize! / 2)
        .endFill();
  }

  bool _isInvalid = true;

  void validate() {
    _isInvalid = false;
    _draw();
  }

  void _invalidateDraw() {
    if (_isInvalid) return;
    _isInvalid = true;
  }

  @override
  void update(double delta) {
    super.update(delta);

    /// We use the internal update() [same as stage.onEnterFrame()] as a
    /// validator to call methods in a lazy way.
    ///
    /// This is a lazy invalidation for properties... each time you set a
    /// property that changes this flags, it wait til the next TICK cycle to
    /// check if it has to run some "heavy" logic.
    ///
    /// For this Dot class, if you set:
    /// `for( var i=0;i<10;++i) dot.size = i * 10;`
    /// only the internal _size property will change, but the Dot will not
    /// be redraw until the next frame, this is a basic save in performance.
    ///

    if (_invalidColor) {
      // to run the internal tween
      _invalidColor = false;
      _applyColorTween();
    }
    if (_isInvalid) {
      _isInvalid = false;
      validate();
    }
  }

  void _applyColorTween() {
    _invalidColor = false;

    /// no need cause the object is recreated, but killing the tween
    /// will assure no more tween update cycles will be called for nothing
    /// on a dead instance.
    if (_colorTween != null) {
      GTween.killTweensOf(_colorTween);
    }
    _colorTween = _color!.twn;
    _colorTween!.tween(_targetColor!, duration: .3, onUpdate: () {
      color = _colorTween!.value;
    });
  }
}
