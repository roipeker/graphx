import 'dart:ui' as ui;
import '../../../graphx.dart';

class GSimpleParticle {
  GSimpleParticle? $next;
  GSimpleParticle? $prev;

  double x = 0.0,
      y = 0.0,
      rotation = 0.0,
      scaleX = 0.0,
      scaleY = 0.0,
      alpha = 0.0,
      red = 0.0,
      green = 0.0,
      blue = 0.0;

  double velocityX = 0;
  double velocityY = 0;
  double accelerationX = 0;
  double accelerationY = 0;
  double energy = 0;
  double initialScale = 1;
  double endScale = 1;
  double initialVelocityX = 0;
  double initialVelocityY = 0;
  double initialVelocityAngular = 0;
  double initialAccelerationX = 0;
  double initialAccelerationY = 0;
  double initialAlpha = 0.0,
      initialRed = 0.0,
      initialBlue = 0.0,
      initialGreen = 0.0;
  double endAlpha = 0.0, endRed = 0.0, endBlue = 0.0, endGreen = 0.0;
  double alphaDif = 0.0, redDif = 0.0, blueDif = 0.0, greenDif = 0.0;
  late double scaleDif;
  double accumulatedEnergy = 0;

  GSimpleParticle? $nextInstance;
  int id = 0;

  GTexture? texture;
  static GSimpleParticle? $availableInstance;
  static int $instanceCount = 0;

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

  GSimpleParticle() {
    id = $instanceCount++;
  }

  static void precache(int count) {
    if (count < $instanceCount) return;
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

  void init(GSimpleParticleSystem emitter, [bool invalidate = true]) {
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

    redDif = endRed - initialRed;
    greenDif = endGreen - initialGreen;
    blueDif = endBlue - initialBlue;
    alphaDif = endAlpha - initialAlpha;
    scaleDif = endScale - initialScale;
  }

  void $update(GSimpleParticleSystem emitter, double delta) {
    accumulatedEnergy += delta;
    if (accumulatedEnergy >= energy) {
      emitter.$deactivateParticle(this);
      return;
    }

    var p = accumulatedEnergy / energy;
    velocityX += accelerationX * delta;
    velocityY += accelerationY * delta;

    red = redDif * p + initialRed;
    green = greenDif * p + initialGreen;
    blue = blueDif * p + initialBlue;
    alpha = alphaDif * p + initialAlpha;

    x += velocityX * delta;
    y += velocityY * delta;
    rotation += initialVelocityAngular * delta;
    scaleX = scaleY = scaleDif * p + initialScale;
  }

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
}
