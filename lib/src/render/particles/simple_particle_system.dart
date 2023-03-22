import 'dart:ui' as ui;

import '../../../graphx.dart';

/// A simple particle system that emits particles based on given parameters.
///
/// The particle system can be configured to emit particles in a variety of ways
/// by setting parameters such as initial velocity, acceleration, angle, and
/// color. The particle system can be set up to emit particles in a burst or
/// continuously, and can be paused and resumed as needed.
///
/// The [GSimpleParticleSystem] can be rendered in world space or
/// in local space.
///
/// The "variance" properties are used to add some randomization to certain
/// particle properties. For example, the [initialVelocityVariance] property
/// allows the initial velocity of each particle to vary randomly within a
/// certain range around the [initialVelocity] value. This is what makes the
/// particle system look more natural and less mechanical.
///
/// Example code:
/// ```dart
///    // create a circle texture to use for particles.
///    final circ = await GTextureUtils.createCircle(
//       color: Colors.red,
//     );
//     final particles = GSimpleParticleSystem();
//     addChild(particles);
//     particles.texture = circ;
//     particles.setPosition(100, 100);
//     particles.emission = 40;
//     particles.endAlpha = 0;
//     particles.endScale = .1;
//     particles.endScaleVariance = .2;
//     particles.endRedVariance = .2;
//     particles.endRed = .5;
//     particles.initialScale = .1;
//     particles.initialScaleVariance = .6;
//     particles.initialAlphaVariance = 0.25;
//     particles.initialColor = Colors.yellow.value;
//     particles.initialVelocity = 200;
//     particles.initialAcceleration = -.4;
//     particles.dispersionAngle = Math.PI;
//     particles.dispersionAngleVariance = Math.PI / 2;
//     particles.useWorldSpace = true;
//     stage!.onMouseDown.add((event) {
//       particles.forceBurst();
//       stage!.onMouseUp.addOnce((event) {
//         particles.emit = true;
//       });
//     });
//     stage!.onMouseMove.add((event) {
//       particles.x = mouseX;
//       particles.y = mouseY;
//     });
/// ```
///
class GSimpleParticleSystem extends GDisplayObject {
  // Helper matrix used for calculations.
  static final _sHelperMatrix = GMatrix();

  // Helper point used for calculations.
  static final _sHelperPoint = GPoint();

  /// Whether to use world space for particle rendering.
  ///
  /// When `true`, the particle system will be rendered in world space
  /// (relative to the stage). When `false`, the particle system
  /// will be rendered in local space (relative to the parent [GDisplayObject]).
  bool useWorldSpace = false;

  /// The blend mode to use for particles.
  ///
  /// When rendering particles, this blend mode will be applied to the particle
  /// texture.
  ui.BlendMode particleBlendMode = ui.BlendMode.srcATop;

  /// ---- PROPERTIES ---

  /// The initial scale of the particles.
  double initialScale = 1.0;

  /// The variance in initial scale of the particles.
  double initialScaleVariance = 0.0;

  /// The end scale of the particles.
  double endScale = 1.0;

  /// The variance in end scale of the particles.
  double endScaleVariance = 0.0;

  /// Whether to emit particles or not.
  /// starts "on" by default.
  /// When you set [burst] to `true` or call [forceBurst], you have to manually
  /// set this to `true` again.
  bool emit = true;

  /// Whether to emit all particles in a burst.
  bool burst = false;

  /// The energy of the particles in seconds (how much it will live).
  double energy = 1.0;

  /// The variance of the energy of the particles emitted.
  double energyVariance = 0.1;

  /// The number of particles to emit per [emissionTime].
  int emission = 6;

  /// The variance of (how random) the number of particles to emit during
  /// [emissionTime].
  int emissionVariance = 0;

  /// The amount of seconds to emit [emission] particles,
  /// works next to [emissionDelay]...
  /// So if you wanna emit for 1 second, and stop for 1 second,
  /// and emit for 1 second again, you can set [emissionTime] to 1,
  /// and [emissionDelay] to 1.
  double emissionTime = 1.0;

  /// The amount of seconds to delay before starting the emission.
  double emissionDelay = 0.0;

  /// The initial velocity of the particles emitted.
  double initialVelocity = 10.0;

  /// The variance of the initial velocity of the particles emitted.
  double initialVelocityVariance = 1;

  /// The initial acceleration of the particles emitted.
  double initialAcceleration = 0.1;

  /// The variance of the initial acceleration of the particles emitted.
  double initialAccelerationVariance = 0;

  /// The initial angular velocity of the particles emitted.
  double initialAngularVelocity = 0;

  /// The variance of the initial angular velocity of the particles emitted.
  double initialAngularVelocityVariance = 0;

  /// The initial angle of the particles emitted.
  double initialAngle = 0;

  /// The variance of the initial angle of the particles emitted.
  double initialAngleVariance = 0;

  /// TODO: Maybe use a single Color instead?
  /// The initial alpha value of the particles.
  double initialAlpha = 1.0;

  /// The variance in the initial alpha value of the particles.
  double initialAlphaVariance = 0.0;

  /// The initial red value of the particles.
  double initialRed = 1.0;

  /// The initial green value of the particles.
  double initialGreen = 1.0;

  /// The initial blue value of the particles.
  double initialBlue = 1.0;

  /// The variance in the initial red value of the particles.
  double initialRedVariance = 0.0;

  /// The variance in the initial green value of the particles.
  double initialGreenVariance = 0.0;

  /// The variance in the initial blue value of the particles.
  double initialBlueVariance = 0.0;

  /// The end alpha value of the particles.
  double endAlpha = 1.0;

  /// The variance in the end alpha value of the particles.
  double endAlphaVariance = 0.0;

  /// The end red value of the particles.
  double endRed = 1.0;

  /// The end green value of the particles.
  double endGreen = 1.0;

  /// The end blue value of the particles.
  double endBlue = 1.0;

  /// The variance in the end red value of the particles.
  double endRedVariance = 0.0;

  /// The variance in the end green value of the particles.
  double endGreenVariance = 0.0;

  /// The variance in the end blue value of the particles.
  double endBlueVariance = 0.0;

  /// The amount of random horizontal movement for each particle.
  double dispersionXVariance = 0;

  /// The amount of random vertical movement for each particle.
  double dispersionYVariance = 0;

  /// The angle in radians of the emission arc.
  double dispersionAngle = 0;

  /// The variance of the angle in radians for the emission arc.
  double dispersionAngleVariance = 0;

  /// Whether the particle system is paused or not.
  bool paused = false;

  /// The image texture used for each particle.
  GTexture? texture;

  /// (Internal usage)
  /// The amount of time (in seconds) that has accumulated for the emitter.
  double $accumulatedTime = 0;

  /// (Internal usage)
  /// The number of particles that have been emitted so far.
  double $accumulatedEmission = 0;

  /// (Internal usage)
  /// The number of active particles.
  int $activeParticles = 0;

  /// (Internal usage)
  /// The last time (in seconds) that the emitter was updated.
  double $lastUpdateTime = 0;

  /// The first particle in the linked list of active particles.
  GSimpleParticle? $firstParticle;

  /// The last particle in the linked list of active particles.
  GSimpleParticle? $lastParticle;

  /// The x-coordinate of the particle pivot point relative to the particle's
  /// origin.
  double? particlePivotX;

  /// The y-coordinate of the particle pivot point relative to the particle's
  /// origin.
  double? particlePivotY;

  /// If set to true, [ColorFilter] alpha will be used to draw the particles.
  bool useAlphaOnColorFilter = false;

  /// Optional draw callback function to be executed before drawing the
  /// particles.
  void Function(ui.Canvas?, ui.Paint)? drawCallback;

  /// Native [Paint] instance used to draw the particles.
  final nativePaint = ui.Paint()
    ..color = kColorBlack
    ..filterQuality = ui.FilterQuality.low;

  /// The current blend mode applied to the particle system.
  ui.BlendMode get blendMode {
    return nativePaint.blendMode;
  }

  /// Sets the blend mode to use for the particle system. This blend mode will
  /// be applied to the particle texture when rendering particles.
  set blendMode(ui.BlendMode value) {
    nativePaint.blendMode = value;
  }

  /// Gets the [endColor] as a hex value.
  /// The [endRed], [endGreen], and [endBlue] values are converted to
  /// hex from [0, 255] range and combined to create the hex color
  /// with format 0xRRGGBB.
  int get endColor {
    final r = (endRed * 0xff).toInt() << 16;
    final g = (endGreen * 0xff).toInt() << 8;
    final b = (endBlue * 0xff).toInt();
    return r + g + b;
  }

  /// Sets the [endColor] as a hex value.
  /// The integer value is split into its red, green, and blue components,
  /// which are then converted to floats in the range [0, 1] and assigned to
  /// [endRed], [endGreen], and [endBlue] respectively.
  set endColor(int value) {
    endRed = (value >> 16 & 0xff) / 0xff;
    endGreen = (value >> 8 & 0xff) / 0xff;
    endBlue = (value & 0xff) / 0xff;
  }

  /// The initial color of the particle, represented as a 32-bit integer.
  /// The alpha channel is ignored. The default value is 0xffffff.
  int get initialColor {
    final r = (initialRed * 0xff).toInt() << 16;
    final g = (initialGreen * 0xff).toInt() << 8;
    final b = (initialBlue * 0xff).toInt();
    return r + g + b;
  }

  /// Sets the initial color of the particle based on a 32-bit integer.
  /// The alpha channel is ignored.
  set initialColor(int value) {
    initialRed = (value >> 16 & 0xff) / 0xff;
    initialGreen = (value >> 8 & 0xff) / 0xff;
    initialBlue = (value & 0xff) / 0xff;
  }

  /// (Internal usage)
  /// Renders the particle system onto the given [Canvas].
  ///
  /// This is the function that actually does the work of drawing each
  /// individual
  /// particle onto the canvas.
  @override
  void $applyPaint(ui.Canvas? canvas) {
    if (texture == null) {
      return;
    }
    var particle = $firstParticle;
    while (particle != null) {
      var next = particle.$next;
      double? tx, ty, sx, sy;
      tx = particle.x;
      ty = particle.y;
      sx = particle.scaleX / texture!.scale!;
      sy = particle.scaleY / texture!.scale!;
      if (useWorldSpace) {
        sx *= scaleX;
        sy *= scaleY;
      }

      /// Calculate color.
      final newColor = particle.color;
      nativePaint.color = newColor;
//      nativePaint.color = nativePaint.color.withOpacity(particle.alpha);
//      nativePaint.colorFilter = ColorFilter.mode(_color, BlendMode.srcATop);
//      nativePaint.colorFilter = ColorFilter.mode(_color, BlendMode.plus);
//      nativePaint.colorFilter = ColorFilter.mode(_color, BlendMode.colorBurn);
//      nativePaint.colorFilter = ColorFilter.mode(_color, BlendMode.src);
      var filterColor =
          useAlphaOnColorFilter ? newColor : newColor.withOpacity(1);
      nativePaint.colorFilter =
          ui.ColorFilter.mode(filterColor, particleBlendMode);
      canvas!.save();
      canvas.translate(tx, ty);
      canvas.rotate(particle.rotation);
      canvas.scale(sx, sy);
      canvas.translate(-(particlePivotX ?? 0), -(particlePivotY ?? 0));

      // $canvas.scale(particle.scaleX, particle.scaleY);
      // $canvas.rotate(particle.rotation);
      /// render in canvas.
      if (drawCallback != null) {
        drawCallback!(canvas, nativePaint);
//        $canvas.drawImage(texture.source, Offset.zero, nativePaint);
      } else {
        canvas.drawImage(texture!.root!, ui.Offset.zero, nativePaint);
      }
      // $canvas.drawImage(texture.source, Offset(tx, ty), nativePaint);
      canvas.restore();
      particle = next;
    }
  }

  /// Deactivates the given particle and removes it from the linked list of
  /// particles.
  void $deactivateParticle(GSimpleParticle particle) {
    if (particle == $lastParticle) {
      $lastParticle = $lastParticle!.$prev;
    }
    if (particle == $firstParticle) {
      $firstParticle = $firstParticle!.$next;
    }
    particle.dispose();
  }

  /// Creates and activates a new particle.
  void activateParticle() {
    var p = _createParticle();
    _setInitialParticlePosition(p);
    p.$init(this);
  }

  /// Clears all particles from the system.
  void clear() {
    while ($firstParticle != null) {
      $deactivateParticle($firstParticle!);
    }
  }

  /// Disposes all particles and removes the onUpdate callback.
  @override
  void dispose() {
    while ($firstParticle != null) {
      $deactivateParticle($firstParticle!);
    }
    super.dispose();
  }

  /// Emits particles immediately by creating [emission] particles and
  /// activating them. The [emit] flag is set to `false` after the burst, so
  /// remember to set it back to `true` if you want the particle system to
  /// continue emitting particles.
  void forceBurst() {
    var currentEmission = (emission + emissionVariance * Math.random()).toInt();
    for (var i = 0; i < currentEmission; ++i) {
      activateParticle();
    }
    emit = false;
  }

  /// Returns the bounds of the particle system in a given target space.
  ///
  /// This method returns the bounds of the particle system in a given target
  /// space. The bounds are returned as a [GRect], which can be provided as an
  /// optional [out] parameter or a new [GRect] will be created.
  ///
  /// The target space can be set to `null` to get the bounds in the local space
  /// of the particle system. If a target space is provided, the bounds will be
  /// transformed into that space using the transformation matrix between the
  /// particle system and the target space.
  @override
  GRect getBounds(GDisplayObject? targetSpace, [GRect? out]) {
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    matrix.transformCoords(0, 0, _sHelperPoint);
    out ??= GRect();
    out.setTo(_sHelperPoint.x, _sHelperPoint.y, 0, 0);
    return out;
  }

  /// Returns true if there are living particles in the linked list.
  bool hasLivingParticles() {
    return $firstParticle != null;
  }

  /// Called by GraphX rendering on each frame to render the particle system.
  @override
  void paint(ui.Canvas canvas) {
    if (!$hasVisibleArea) {
      return;
    }
    if (useWorldSpace) {
      /// Skips the matrix transform from the display list hierarchy
      $applyPaint(canvas);
    } else {
      super.paint(canvas);
    }
  }

  /// Sets up the particle system to start fresh.
  /// Should call [init] before to start the ticking.
  ///
  /// Parameters:
  ///
  /// - [maxCount]: The maximum number of particles that can be active at the
  /// same time.
  ///
  /// - [precacheCount]: The number of particles to create immediately so that
  /// they are ready to be activated when needed.
  ///
  /// - [disposeImmediately]: If set to `true`, particles will be disposed of
  /// immediately after they complete their lifecycle.
  void setup([
    int maxCount = 0,
    int precacheCount = 0,
    bool disposeImmediately = true,
  ]) {
    $accumulatedTime = 0;
    $accumulatedEmission = 0;
    if (texture != null) {
      _setPivot();
    }
  }

  /// (Internal usage)
  /// Called by GraphX on each frame to update the particle system.
  @override
  void update(double delta) {
    super.update(delta);
    delta *= 1000;
    if (particlePivotX == null && texture != null) {
      _setPivot();
    }
    $lastUpdateTime = delta;
    if (paused) {
      return;
    }
    if (emit) {
      if (burst) {
        forceBurst();
      } else {
        $accumulatedTime += delta * .001;
        var time = $accumulatedTime % (emissionTime + emissionDelay);
        if (time <= emissionTime) {
          var updateEmission = emission.toDouble();
          if (emissionVariance > 0) {
            updateEmission += emissionVariance * Math.random();
          }
          $accumulatedEmission += updateEmission * delta * .001;
          while ($accumulatedEmission > 0) {
            activateParticle();
            $accumulatedEmission--;
          }
        }
      }
    }
    var particle = $firstParticle;
    while (particle != null) {
      var next = particle.$next;
      particle.$update(this, $lastUpdateTime);
      particle = next;
    }
  }

  /// Creates a new particle and adds it to the linked list of particles.
  GSimpleParticle _createParticle() {
    var p = GSimpleParticle.get();
    if ($firstParticle != null) {
      p.$next = $firstParticle;
      $firstParticle!.$prev = p;
      $firstParticle = p;
    } else {
      $firstParticle = p;
      $lastParticle = p;
    }
    return p;
  }

  /// Sets the initial position and orientation of the [particle].
  void _setInitialParticlePosition(GSimpleParticle particle) {
    particle.x = useWorldSpace ? x : 0;
    if (dispersionXVariance > 0) {
      particle.x +=
          dispersionXVariance * Math.random() - dispersionXVariance * .5;
    }
    particle.y = useWorldSpace ? y : 0;
    if (dispersionYVariance > 0) {
      particle.y +=
          dispersionYVariance * Math.random() - dispersionYVariance * .5;
    }
    particle.rotation = initialAngle;
    if (initialAngleVariance > 0) {
      particle.rotation += initialAngleVariance * Math.random();
    }
    particle.scaleX = particle.scaleY = initialScale;
    if (initialScaleVariance > 0) {
      var sd = initialScaleVariance * Math.random();
      particle.scaleX += sd;
      particle.scaleY += sd;
    }
  }

  /// Calculates the pivot point for the particles based on the dimensions of
  /// the texture, and sets the [particlePivotX] and [particlePivotY] properties
  /// accordingly.
  void _setPivot() {
    /// used (texture.width)...
    particlePivotX = texture!.nativeWidth.toDouble() * .5;
    particlePivotY = texture!.nativeHeight.toDouble() * .5;
  }
}
