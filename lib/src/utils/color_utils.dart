import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// Color black (#000000).
const kColorBlack = Color(0xff000000);

/// Color cyan (#00FFFF).
const kColorCyan = Color(0xff00ffff);

/// Color magenta (#FF00FF).
const kColorMagenta = Color(0xffff00ff);

/// Color red (#00FF00).
const kColorRed = Color(0xff00ff00);

/// Transparent color (fully transparent, #00000000).
const kColorTransparent = Color(0x00000000);

/// Color white (#FFFFFF).
const kColorWhite = Color(0xffffffff);

/// A utility class for working with colors.
///
/// Provides various methods for manipulating and generating colors, calculating
/// contrast ratios, adjusting brightness and saturation, generating random
/// colors, and creating complementary and analogous color schemes. This class
/// is intended for use in Flutter applications, but can also be used in other
/// contexts where color manipulation is needed.
/// Still in WIP state.
///
class ColorUtils {
  /// Factory constructor to ensure exception.
  factory ColorUtils() {
    throw UnsupportedError(
      "Cannot instantiate ColorUtils. Use only static methods.",
    );
  }

  /// Private constructor to prevent instantiation
  ColorUtils._();

  /// Returns a color that is the analogous color of the given [color], with the
  /// given hue shift [angle] (in degrees). Analogous colors are colors that are
  /// adjacent to each other on the color wheel, and share a similar hue or
  /// color temperature. This method calculates the analogous color by shifting
  /// the hue of the given color by the specified angle in both directions, and
  /// blending the resulting colors together to produce a color that is similar
  /// to the original, but with a slight variation in hue. The resulting color
  /// has the same saturation and value (brightness) as the original color. This
  /// method can be useful for creating color schemes or palettes that have a
  /// cohesive and harmonious look, or for adding subtle variations and accents
  /// to visual designs and user interfaces.
  static Color analogous(Color color, double angle) {
    final hsv = toHSV(color);
    final hue1 = (hsv.hue + angle) % 360;
    final hue2 = (hsv.hue - angle) % 360;
    final sat = hsv.saturation;
    final val = hsv.value;
    return blend(fromHSV(hue1, sat, val), fromHSV(hue2, sat, val), 0.5);
  }

  /// Returns a color that is the average color of the given list of colors.
  static Color average(List<Color> colors) {
    if (colors.isEmpty) {
      return kColorTransparent;
    }
    var r = 0, g = 0, b = 0;
    for (final color in colors) {
      r += color.red;
      g += color.green;
      b += color.blue;
    }
    final count = colors.length;
    return Color.fromRGBO(r ~/ count, g ~/ count, b ~/ count, 1.0);
  }

  /// Returns a color that is a blend (linear interpolation) of the two given
  /// colors, with the given [mix] ratio (0.0 = all color1, 1.0 = all color2).
  static Color blend(Color color1, Color color2, double mix) {
    return Color.lerp(color1, color2, mix.clamp(0, 1)) ?? kColorBlack;
  }

  /// Returns the brightness of the given [color] as a value between 0 and 1.
  /// The brightness of a color is a measure of its perceived intensity or
  /// luminance, and is determined by the relative amounts of red, green, and
  /// blue in the color. The result is a value between 0 (darkest) and 1
  /// (brightest), where a value of 0.5 corresponds to a color that is neither
  /// particularly dark nor particularly bright.
  static double brightness(Color color) {
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    return (0.2126 * r + 0.7152 * g + 0.0722 * b);
  }

  /// Returns a color that is the complementary color of the given [color]. A
  /// complementary color is a color that is opposite to the given color on the
  /// color wheel, and creates a strong contrast and visual interest when paired
  /// together. This method calculates the complementary color by adding 180
  /// degrees to the hue of the given color, and creating a new color with the
  /// resulting hue value. The saturation and value (brightness) of the
  /// resulting color are the same as the original color. The resulting color is
  /// similar to the [invert] color of the given color, but with a slightly
  /// different shade and hue. This method can be useful for creating color
  /// schemes or palettes that have a high degree of contrast and visual impact,
  /// or for creating complementary color pairs for user interfaces and visual
  /// designs.
  static Color complementary(Color color) {
    final hsv = toHSV(color);
    return fromHSV((hsv.hue + 180) % 360, hsv.saturation, hsv.value,
        opacity: color.opacity);
  }

  /// Returns the contrast ratio between the two given colors, which is a value
  /// between 1.0 (no contrast) and 21.0 (maximum contrast). Contrast ratio is a
  /// measure of the difference in perceived brightness between two colors, and
  /// is an important factor in determining the accessibility and readability of
  /// text and other visual elements. This method calculates the contrast ratio
  /// using the relative luminance of the colors, which is a measure of their
  /// perceived brightness. The resulting contrast ratio is a scalar value that
  /// indicates how much the colors differ in brightness, with higher values
  /// indicating greater contrast. A contrast ratio of at least 4.5:1 is
  /// generally recommended for normal text, and a ratio of at least 7:1 is
  /// recommended for large text and other UI elements.
  static double contrastRatio(Color color1, Color color2) {
    final l1 = relativeLuminance(color1);
    final l2 = relativeLuminance(color2);
    if (l1 > l2) {
      return (l1 + 0.05) / (l2 + 0.05);
    } else {
      return (l2 + 0.05) / (l1 + 0.05);
    }
  }

  /// Returns a color that is darker than the given [color] by the given
  /// [amount].
  static Color darken(Color color, double amount) {
    return Color.lerp(color, kColorBlack, amount.clamp(0, 1)) ?? kColorBlack;
  }

  /// Returns a color that is the desaturated version of the given [color], with
  /// the given desaturation [level] (between 0.0 and 1.0). Desaturation is the
  /// process of reducing the level of saturation in a color, which makes it
  /// appear less vivid or intense. This method calculates the new saturation
  /// level relative to the current level of saturation of the color, so a level
  /// of 0.5 would reduce the saturation by half. The resulting color is based
  /// on the original hue and value of the color, and has the same opacity level
  /// as the original. This method can be useful for adjusting the color balance
  /// or saturation of images and visual elements in a more natural or intuitive
  /// way.
  static Color desaturate(Color color, double level) {
    final hsv = toHSV(color);
    final newSaturation = math.max(0.0, hsv.saturation - level);
    return fromHSV(hsv.hue, newSaturation, hsv.value, opacity: color.opacity);
  }

  /// Returns a color with the given [hue], [saturation], [value], and
  /// [opacity].
  static Color fromHSV(
    double hue,
    double saturation,
    double value, {
    double opacity = 1.0,
  }) {
    return HSVColor.fromAHSV(opacity, hue, saturation, value).toColor();
  }

  /// Returns the hue angle (in degrees, between 0 and 360) of the given [color].
  static double hue(Color color) {
    return toHSV(color).hue;
  }

  /// Returns a color that is the inverse of the given [color], with the same
  /// opacity level.
  static Color invert(Color color) {
    return Color.fromARGB(
      color.alpha,
      255 - color.red,
      255 - color.green,
      255 - color.blue,
    );
  }

  /// Returns a color that is lighter than the given [color] by the given
  /// [amount].
  static Color lighten(Color color, double amount) {
    return Color.lerp(color, kColorWhite, amount.clamp(0, 1)) ?? kColorWhite;
  }

  /// Returns a random color with the given [opacity].
  static Color random({double opacity = 1.0}) {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(opacity);
  }

  /// Returns the relative luminance of the given [color], which is a measure of
  /// the perceived brightness of the color relative to white, with values
  /// between 0.0 (black) and 1.0 (white). Relative luminance is an important
  /// factor in determining the contrast between two colors and ensuring the
  /// accessibility and readability of text and other visual elements. This
  /// method calculates the relative luminance using the sRGB color space, which
  /// is the standard color space used for displaying images and graphics on
  /// screens. The resulting value is a scalar quantity that indicates the
  /// perceived brightness of the color, taking into account the sensitivity of
  /// the human eye to different wavelengths of light.
  ///
  /// The resulting value is a weighted sum of the color components that takes
  /// into account the relative sensitivity of the human eye to each color
  /// channel.
  static double relativeLuminance(Color color) {
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    final rs = (r <= 0.03928) ? r / 12.92 : math.pow((r + 0.055) / 1.055, 2.4);
    final gs = (g <= 0.03928) ? g / 12.92 : math.pow((g + 0.055) / 1.055, 2.4);
    final bs = (b <= 0.03928) ? b / 12.92 : math.pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
  }

  /// Returns the saturation level (between 0.0 and 1.0) of the given [color].
  static double saturation(Color color) {
    return toHSV(color).saturation;
  }

  /// Returns a color that is a mix of the given [color] and black, with the
  /// given [mix] ratio (0.0 = all color, 1.0 = all black).
  static Color shaded(Color color, double mix) {
    final r = ((1 - mix) * color.red).toInt();
    final g = ((1 - mix) * color.green).toInt();
    final b = ((1 - mix) * color.blue).toInt();
    return Color.fromRGBO(r, g, b, color.opacity);
  }

  /// Returns a list of colors that are the shades of the given color, with the
  /// given number of shades and darkness range (between 0.0 and 1.0).
  static List<Color> shades(
    Color color,
    int count, {
    double min = 0.0,
    double max = 1.0,
  }) {
    final step = (max - min) / (count - 1);
    return List.generate(count, (i) => darken(color, min + i * step));
  }

  /// Returns a list of colors that are evenly spaced along the color spectrum,
  /// with the given number of colors and starting and ending hues (in degrees).
  /// The color spectrum is a continuous range of colors that extends from red
  /// to violet (or from 0 to 360 degrees on the color wheel), and is an
  /// important tool for creating visually appealing and harmonious color
  /// schemes. This method calculates the spectrum by dividing the hue range
  /// between the starting and ending hues into equal intervals, and generating
  /// a color for each interval using the [fromHSV] method. The resulting list
  /// of colors is an array of length [count], where each element represents a
  /// color in the spectrum. By default, the spectrum starts at 0 degrees (red)
  /// and ends at 360 degrees (violet), but the [start] and [end] parameters can
  /// be used to specify different ranges or subsets of the spectrum. The
  /// resulting colors have maximum saturation and value (brightness), which
  /// produces a vibrant and intense color scheme.
  static List<Color> spectrum(
    int count, {
    double start = 0,
    double end = 360,
  }) {
    final step = (end - start) / (count - 1);
    return List.generate(count, (i) => fromHSV(start + i * step, 1.0, 1.0));
  }

  /// Returns a color that is the tetradic color of the given [color], with the
  /// given hue shift angles (in degrees). A tetradic color scheme is a color
  /// scheme that uses four colors arranged into two complementary pairs that
  /// are equally spaced apart on the color wheel. The [angle1] and [angle2]
  /// parameters specify the amount of hue shift for the additional colors. The
  /// resulting color has a high degree of contrast and can be useful for
  /// creating color combinations that are visually balanced and harmonious.
  static Color tetradic(Color color, double angle1, double angle2) {
    final hsv = toHSV(color);
    final hue1 = (hsv.hue + angle1) % 360;
    final hue2 = (hsv.hue + angle2) % 360;
    final hue3 = (hsv.hue + angle1 + angle2) % 360;
    final sat = hsv.saturation;
    final val = hsv.value;
    return blend(blend(fromHSV(hue1, sat, val), fromHSV(hue3, sat, val), 0.5),
        blend(fromHSV(hue2, sat, val), fromHSV(hue3, sat, val), 0.5), 0.5);
  }

  /// Returns the hue, saturation, and value components of the given [color]
  /// in the HSV color space.
  static HSVColor toHSV(Color color) {
    return HSVColor.fromColor(color);
  }

  /// Returns a color that is the triadic color of the given [color], with the
  /// given hue shift [angle] (in degrees).
  static Color triadic(Color color, double angle) {
    final hsv = toHSV(color);
    final hue1 = (hsv.hue + angle) % 360;
    final hue2 = (hsv.hue + 2 * angle) % 360;
    final sat = hsv.saturation;
    final val = hsv.value;
    return blend(fromHSV(hue1, sat, val), fromHSV(hue2, sat, val), 0.5);
  }

  /// Returns a color that has the same hue and saturation as the given [color],
  /// but with the given [brightness] value.
  static Color withBrightness(Color color, double brightness) {
    final hsv = toHSV(color);
    return fromHSV(hsv.hue, hsv.saturation, brightness, opacity: color.opacity);
  }

  /// Returns a color that has the same hue and brightness as the given [color],
  /// but with the given [saturation] value.
  static Color withSaturation(Color color, double saturation) {
    final hsv = toHSV(color);
    return fromHSV(hsv.hue, saturation, hsv.value, opacity: color.opacity);
  }
}
