import 'dart:ui' as ui;

import '../../../graphx.dart';

/// A particle used in a [GSimpleParticleSystem].
/// This class is used internally by the [GSimpleParticleSystem] class and is
/// not intended for direct usage.
///
/// The rendering uses LinkedLists, so the particle is a node in a list.
///
class GSimpleParticle {
  /// A reference to the first available particle instance in the object pool.
  static GSimpleParticle? $availableInstance;

  /// The total number of particle instances created.
  static int $instanceCount = 0;

  /// A reference to the next particle in the particle list.
  GSimpleParticle? $next;

  /// A reference to the previous particle in the particle list.
  GSimpleParticle? $prev;

  /// A reference to the next available particle instance in the object pool.
  GSimpleParticle? $nextInstance;

  /// The x position of the particle.
  double x = 0.0;

  /// The y position of the particle.
  double y = 0.0;

  /// The rotation of the particle, in radians.
  double rotation = 0.0;

  /// The x scale of the particle.
  double scaleX = 0.0;

  /// The y scale of the particle.
  double scaleY = 0.0;

  /// The alpha (transparency) of the particle.
  double alpha = 0.0;

  /// The red color component of the particle.
  double red = 0.0;

  /// The green color component of the particle.
  double green = 0.0;

  /// The blue color component of the particle.
  double blue = 0.0;

  /// The x velocity of the particle.
  double velocityX = 0;

  /// The y velocity of the particle.
  double velocityY = 0;

  /// The x acceleration of the particle.
  double accelerationX = 0;

  /// The y acceleration of the particle.
  double accelerationY = 0;

  /// The amount of energy (lifetime) of the particle.
  double energy = 0;

  /// The initial scale of the particle.
  double initialScale = 1;

  /// The end scale of the particle.
  double endScale = 1;

  /// The initial x velocity of the particle.
  double initialVelocityX = 0;

  /// The initial y velocity of the particle.
  double initialVelocityY = 0;

  /// The initial angular velocity of the particle.
  double initialVelocityAngular = 0;

  /// The initial x acceleration of the particle.
  double initialAccelerationX = 0;

  /// The initial y acceleration of the particle.
  double initialAccelerationY = 0;

  /// The initial alpha (transparency) of the particle.
  double initialAlpha = 0.0;

  /// The initial red color component of the particle.
  double initialRed = 0.0;

  /// The initial blue color component of the particle.
  double initialBlue = 0.0;

  /// The initial green color component of the particle.
  double initialGreen = 0.0;

  /// The final alpha (transparency) of the particle.
  double endAlpha = 0.0;

  /// The final red color component of the particle.
  double endRed = 0.0;

  /// The final green color component of the particle.
  double endBlue = 0.0;

  /// The final green color component of the particle.
  double endGreen = 0.0;

  /// The difference between the end and initial alpha of the particle.
  double _alphaDif = 0.0;

  /// The difference between the end and initial red component of the particle.
  double _redDif = 0.0;

  /// The difference between the end and initial green component of the
  /// particle.
  double _blueDif = 0.0;

  /// The difference between the end and initial blue component of the particle.
  double _greenDif = 0.0;

  /// The difference between the end and initial scale of the particle.
  late double _scaleDif;

  /// The accumulated energy (lifetime) of the particle.
  double accumulatedEnergy = 0.0;

  /// The unique ID of the particle.
  int id = 0;

  /// The texture of the particle
  /// (is required to render something).
  GTexture? texture;

  /// Creates a new [GSimpleParticle] instance.
  ///
  /// The default values for all properties are 0.0, except for [initialScale]
  /// and [endScale], which are set to 1.0.
  GSimpleParticle() {
    id = $instanceCount++;
  }

  /// The color of the particle, calculated from its alpha, red, green, and blue
  /// properties.
  ui.Color get color {
    /// TODO: cache color transition if its not used.
    final a = (alpha * 0xff).toInt() << 24;
    final r = (red * 0xff).toInt() << 16;
    final g = (green * 0xff).toInt() << 8;
    final b = (blue * 0xff).toInt();
    return ui.Color(a + r + g + b);
//    (((a & 0xff) << 24) |
//    ((r & 0xff) << 16) |
//    ((g & 0xff) << 8)  |
//    ((b & 0xff) << 0)) & 0xFFFFFFFF;
  }

  /// (Internal usage)
  ///
  /// Initializes the particle with the given [emitter].
  ///
  /// This method is called by the [GSimpleParticleSystem] to initialize the
  /// particle with the emitter's properties. It calculates the particle's
  /// initial and end scales, velocities, accelerations, colors, and energy
  /// based on the emitter's properties and random variance.
  ///
  /// The [emitter] parameter is the emitter that the particle belongs to.
  ///
  /// The [invalidate] parameter is not used in the [GSimpleParticle] class.
  void $init(GSimpleParticleSystem emitter, [bool invalidate = true]) {
    accumulatedEnergy = 0;
    texture = emitter.texture;
    var ratioEnergy = 1000;
    energy = emitter.energy * ratioEnergy;
    if (emitter.energyVariance > 0) {
      energy += (emitter.energyVariance * ratioEnergy) * Math.random();
    }
    initialScale = emitter.initialScale;
    if (emitter.initialScaleVariance > 0) {
      initialScale += emitter.initialScaleVariance * Math.random();
    }
    endScale = emitter.endScale;
    if (emitter.endScaleVariance > 0) {
      endScale += emitter.endScaleVariance * Math.random();
    }

    double particleVelocityX, particleVelocityY;
    var v = emitter.initialVelocity;
    if (emitter.initialVelocityVariance > 0) {
      v += emitter.initialVelocityVariance * Math.random();
    }

    double particleAccelerationX, particleAccelerationY;
    var a = emitter.initialAcceleration;
    if (emitter.initialAccelerationVariance > 0) {
      a += emitter.initialAccelerationVariance * Math.random();
    }

    var vx = particleVelocityX = v;
    var vy = particleVelocityY = 0;
    var ax = particleAccelerationX = a;
    var ay = particleAccelerationY = 0;
    var rot = emitter.rotation;
    if (rot != 0) {
      var sin = Math.sin(rot);
      var cos = Math.cos(rot);
      vx = particleVelocityX = v * cos;
      vy = particleVelocityY = v * sin;
      ax = particleAccelerationX = a * cos;
      ay = particleAccelerationY = a * sin;
    }
    if (emitter.dispersionAngle != 0 || emitter.dispersionAngleVariance != 0) {
      var dispersionAngle = emitter.dispersionAngle;
      if (emitter.dispersionAngleVariance > 0) {
        dispersionAngle += emitter.dispersionAngleVariance * Math.random();
      }
      var sin = Math.sin(dispersionAngle);
      var cos = Math.cos(dispersionAngle);
      particleVelocityX = (vx * cos - vy * sin);
      particleVelocityY = (vy * cos + vx * sin);
      particleAccelerationX = (ax * cos - ay * sin);
      particleAccelerationY = (ay * cos + ay * sin);
    }

    var ratioVel = .001;

    initialVelocityX = velocityX = particleVelocityX * ratioVel;
    initialVelocityY = velocityY = particleVelocityY * ratioVel;

    initialAccelerationX = accelerationX = particleAccelerationX * ratioVel;
    initialAccelerationY = accelerationY = particleAccelerationY * ratioVel;

    initialVelocityAngular = emitter.initialAngularVelocity;
    if (emitter.initialAngularVelocityVariance > 0) {
      initialVelocityAngular +=
          emitter.initialAngularVelocityVariance * Math.random();
    }

    // print("Initial vel x: $initialVelocityX");
    initialAlpha = emitter.initialAlpha;
    if (emitter.initialAlphaVariance > 0) {
      initialAlpha += emitter.initialAlphaVariance * Math.random();
    }
    initialRed = emitter.initialRed;
    if (emitter.initialRedVariance > 0) {
      initialRed += emitter.initialRedVariance * Math.random();
    }
    initialGreen = emitter.initialGreen;
    if (emitter.initialGreenVariance > 0) {
      initialGreen += emitter.initialGreenVariance * Math.random();
    }
    initialBlue = emitter.initialBlue;
    if (emitter.initialBlueVariance > 0) {
      initialBlue += emitter.initialBlueVariance * Math.random();
    }

    endAlpha = emitter.endAlpha;
    if (emitter.endAlphaVariance > 0) {
      endAlpha += emitter.endAlphaVariance * Math.random();
    }
    endRed = emitter.endRed;
    if (emitter.endRedVariance > 0) {
      endRed += emitter.endRedVariance * Math.random();
    }
    endGreen = emitter.endGreen;
    if (emitter.endGreenVariance > 0) {
      endGreen += emitter.endGreenVariance * Math.random();
    }
    endBlue = emitter.endBlue;
    if (emitter.endBlueVariance > 0) {
      endBlue += emitter.endBlueVariance * Math.random();
    }

    _redDif = endRed - initialRed;
    _greenDif = endGreen - initialGreen;
    _blueDif = endBlue - initialBlue;
    _alphaDif = endAlpha - initialAlpha;
    _scaleDif = endScale - initialScale;
  }

  /// (Internal usage)
  /// Updates the particle's properties based on the elapsed time since
  /// creation.
  ///
  /// This method is called once per frame by the [GSimpleParticleSystem] to
  /// update the particle's position, rotation, scale, color, and velocity based
  /// on the elapsed time since creation.
  ///
  /// The [emitter] parameter is the emitter that the particle belongs to.
  ///
  /// The [delta] parameter is the delta time elapsed since the last tick.
  void $update(GSimpleParticleSystem emitter, double delta) {
    accumulatedEnergy += delta;
    // If the accumulated energy exceeds the particle's total energy, it has
    // run out of energy and should be deactivated.
    if (accumulatedEnergy >= energy) {
      emitter.$deactivateParticle(this);
      return;
    }

    // Update the particle's velocity based on its acceleration.
    velocityX += accelerationX * delta;
    velocityY += accelerationY * delta;

    // Calculate the progress of the particle's life cycle as a value between
    // 0.0 and 1.0, based on the accumulated energy.
    final percent = accumulatedEnergy / energy;

    // Calculate the particle's color as an interpolated value between its
    // initial and end color, based on the progress of its life cycle.
    red = _redDif * percent + initialRed;
    green = _greenDif * percent + initialGreen;
    blue = _blueDif * percent + initialBlue;
    alpha = _alphaDif * percent + initialAlpha;

    // Update the particle's position, rotation, and scale based on its
    // velocity and scale difference.
    x += velocityX * delta;
    y += velocityY * delta;
    rotation += initialVelocityAngular * delta;
    scaleX = scaleY = _scaleDif * percent + initialScale;
  }

  /// Disposes the particle and returns it to the object pool.
  ///
  /// This method is called by the [GSimpleParticleSystem] to dispose of the
  /// particle and return it to the object pool. It removes the particle from
  /// the particle list and adds it to the available instance list.
  void dispose() {
    if ($next != null) {
      $next!.$prev = $prev;
    }
    if ($prev != null) {
      $prev!.$next = $next;
    }
    $next = null;
    $prev = null;
    $nextInstance = $availableInstance;
    $availableInstance = this;
  }

  /// Returns an available [GSimpleParticle] instance.
  ///
  /// If there are any instances in the cache, this method removes the first one
  /// and returns it. Otherwise, it creates a new instance and returns it.
  static GSimpleParticle get() {
    var instance = $availableInstance;
    if (instance != null) {
      $availableInstance = instance.$nextInstance;
      instance.$nextInstance = null;
    } else {
      instance = GSimpleParticle();
    }
    return instance;
  }

  /// Caches [count] instances of [GSimpleParticle].
  ///
  /// If [count] is less than the number of instances that have already been
  /// created, this method does nothing. Otherwise, it creates additional
  /// instances of [GSimpleParticle] and adds them to the cache until there are
  /// [count] instances in total.
  static void precache(int count) {
    if (count < $instanceCount) {
      return;
    }
    GSimpleParticle? cached = get();
    while ($instanceCount < count) {
      var n = get();
      n.$prev = cached;
      cached = n;
    }
    while (cached != null) {
      var d = cached;
      cached = d.$prev;
      d.dispose();
    }
  }
}
