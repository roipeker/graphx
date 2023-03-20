import 'dart:ui';

/// A class representing glyph variations, used to specify OpenType font variations.
///
/// [GlyphVariations] encapsulates a set of font variations, represented by doubles
/// that modify the default appearance of glyphs rendered with a given font.
///
/// This class is typically used to create a font variation axis for a custom font
/// to provide granular control over aspects like weight, width, slant, and other
/// attributes.
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

  /// This internal callback is called whenever the [GlyphVariations] data
  /// changes, and invalidates the style on [GIcon] and [GText]
  Function? onUpdate;

  /// Creates a new instance of [GlyphVariations].
  ///
  /// Each of the parameters represents a variation axis in the OpenType font
  /// format. If a value is not provided for a particular axis, it is considered
  /// unset.
  GlyphVariations({
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
  })  : _fill = fill,
        _weight = weight,
        _grade = grade,
        _opticalSize = opticalSize;

  /// Returns true if any variation value is not null.
  bool $isValid() =>
      _fill != null ||
      _weight != null ||
      _grade != null ||
      _opticalSize != null;

  List<FontVariation>? _data;

  /// Returns the [FontVariation] list based on the current variation values.
  List<FontVariation>? get data => _data;

  /// Invalidates the current instance, clearing any existing font variations
  /// and updating the [data] field with a new set of variations, based on the
  /// values of the various axes.
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

  /// The fill variation value. Null means no fill variation.
  double? get fill => _fill;

  /// Sets the fill variation value. Null means no fill variation.
  set fill(double? value) {
    if (_fill == value) return;
    _fill = value;
    _invalidateModel();
  }

  /// The [weight] variation value. Null means no weight variation.
  double? get weight => _weight;

  /// Sets the [weight] variation value. Null means no weight variation.
  set weight(double? value) {
    if (_weight == value) return;
    _weight = value;
    _invalidateModel();
  }

  /// The optical size variation value. Null means no optical size variation.
  double? get opticalSize => _opticalSize;

  /// Sets the optical size variation value. Null means no optical size variation.
  set opticalSize(double? value) {
    if (_opticalSize == value) return;
    _opticalSize = value;
    _invalidateModel();
  }

  /// The grade variation value. Null means no grade variation.
  double? get grade => _grade;

  /// Sets the grade variation value. Null means no grade variation.
  set grade(double? value) {
    if (_grade == value) return;
    _grade = value;
    _invalidateModel();
  }
}
