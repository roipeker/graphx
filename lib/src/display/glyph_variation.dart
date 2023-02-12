import 'dart:ui';

class GlyphVariations {
  /// The fill for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `FILL` [FontVariation]
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be between 0.0 (unfilled) and 1.0 (filled),
  /// inclusive.
  ///
  /// Can be used to convey a state transition for animation or interaction.
  ///
  /// See also:
  ///  * [weight], for controlling stroke weight.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * [opticalSize], for controlling optical size.
  double? _fill;

  /// The stroke weight for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `wght` [FontVariation]
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be greater than 0.
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * [opticalSize], for controlling optical size.
  ///  * https://fonts.google.com/knowledge/glossary/weight_axis
  double? _weight;

  /// The grade (granular stroke weight) for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `GRAD` [FontVariation]
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Can be negative.
  ///
  /// Grade and [weight] both affect a symbol's stroke weight (thickness), but
  /// grade has a smaller impact on the size of the symbol.
  ///
  /// Grade is also available in some text fonts. One can match grade levels
  /// between text and symbols for a harmonious visual effect. For example, if
  /// the text font has a -25 grade value, the symbols can match it with a
  /// suitable value, say -25.
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [weight], for controlling stroke weight in a less granular way.
  ///  * [opticalSize], for controlling optical size.
  ///  * https://fonts.google.com/knowledge/glossary/grade_axis
  double? _grade;

  /// The optical size for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `opsz` [FontVariation]
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be greater than 0.
  ///
  /// For an icon to look the same at different sizes, the stroke weight
  /// (thickness) must change as the icon size scales. Optical size offers a way
  /// to automatically adjust the stroke weight as icon size changes.
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [weight], for controlling stroke weight.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * https://fonts.google.com/knowledge/glossary/optical_size_axis
  double? _opticalSize;

  /// Internal callback that invalidates the style on [GIcon] and [GText]
  Function? onUpdate;

  GlyphVariations({
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
  })  : _fill = fill,
        _weight = weight,
        _grade = grade,
        _opticalSize = opticalSize;

  bool $isValid() =>
      _fill != null ||
      _weight != null ||
      _grade != null ||
      _opticalSize != null;

  List<FontVariation>? _data;
  List<FontVariation>? get data => _data;
  void _invalidateModel() {
    if (!$isValid()) {
      _data = null;
    } else {
      _data = <FontVariation>[
        if (_fill != null) FontVariation('FILL', _fill!),
        if (_weight != null) FontVariation('wght', _weight!),
        if (_grade != null) FontVariation('GRAD', _grade!),
        if (_opticalSize != null) FontVariation('opsz', _opticalSize!),
      ];
    }
    onUpdate?.call();
  }

  double? get fill => _fill;

  set fill(double? value) {
    if (_fill == value) return;
    _fill = value;
    _invalidateModel();
  }

  double? get weight => _weight;

  set weight(double? value) {
    if (_weight == value) return;
    _weight = value;
    _invalidateModel();
  }

  double? get opticalSize => _opticalSize;

  set opticalSize(double? value) {
    if (_opticalSize == value) return;
    _opticalSize = value;
    _invalidateModel();
  }

  double? get grade => _grade;

  set grade(double? value) {
    if (_grade == value) return;
    _grade = value;
    _invalidateModel();
  }
}
