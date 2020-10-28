import 'dart:math';
import 'dart:ui';

import 'package:graphx/graphx/render/particles/simple_particle_system.dart';
import 'package:graphx/graphx/textures/base_texture.dart';

class SimpleParticle {
  SimpleParticle $next;
  SimpleParticle $prev;

  double x, y, rotation, scaleX, scaleY, alpha, red, green, blue;

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
  double initialAlpha, initialRed, initialBlue, initialGreen;
  double endAlpha, endRed, endBlue, endGreen;
  double alphaDif, redDif, blueDif, greenDif;
  double scaleDif;
  double accumulatedEnergy = 0;

  SimpleParticle $nextInstance;
  int id = 0;

  GxTexture texture;
  static SimpleParticle $availableInstance;
  static int $instanceCount = 0;

  Color get color {
    /// TODO: cache color transition if its not used.
    final a = (alpha * 0xff).toInt() << 24;
    final r = (red * 0xff).toInt() << 16;
    final g = (green * 0xff).toInt() << 8;
    final b = (blue * 0xff).toInt();
    final rgb = a + r + g + b;
    final _color = Color(rgb);
    return _color;
//    (((a & 0xff) << 24) |
//    ((r & 0xff) << 16) |
//    ((g & 0xff) << 8)  |
//    ((b & 0xff) << 0)) & 0xFFFFFFFF;
  }

  SimpleParticle() {
    id = $instanceCount++;
  }

  static void precache(int count) {
    if (count < $instanceCount) return;
    SimpleParticle cached = get();
    while ($instanceCount < count) {
      SimpleParticle n = get();
      n.$prev = cached;
      cached = n;
    }
    while (cached != null) {
      SimpleParticle d = cached;
      cached = d.$prev;
      d?.dispose();
    }
  }

  static SimpleParticle get() {
    SimpleParticle instance = $availableInstance;
    if (instance != null) {
      $availableInstance = instance.$nextInstance;
      instance.$nextInstance = null;
    } else {
      instance = SimpleParticle();
    }
    return instance;
  }

  Random get random => SimpleParticleSystem.random;

  void init(SimpleParticleSystem emitter, [bool invalidate = true]) {
    accumulatedEnergy = 0;
    texture = emitter.texture;
    double ratioEnergy = 1000;
    energy = emitter.energy * ratioEnergy;
    if (emitter.energyVariance > 0) {
      energy += (emitter.energyVariance * ratioEnergy) * random.nextDouble();
    }

    initialScale = emitter.initialScale;
    if (emitter.initialScaleVariance > 0) {
      initialScale += emitter.initialScaleVariance * random.nextDouble();
    }
    endScale = emitter.endScale;
    if (emitter.endScaleVariance > 0) {
      endScale += emitter.endScaleVariance * random.nextDouble();
    }

    double particleVelocityX, particleVelocityY;
    double v = emitter.initialVelocity;
    if (emitter.initialVelocityVariance > 0) {
      v += emitter.initialVelocityVariance * random.nextDouble();
    }

    double particleAccelerationX, particleAccelerationY;
    double a = emitter.initialAcceleration;
    if (emitter.initialAccelerationVariance > 0) {
      a += emitter.initialAccelerationVariance * random.nextDouble();
    }

    double vx = particleVelocityX = v;
    double vy = particleVelocityY = 0;
    double ax = particleAccelerationX = a;
    double ay = particleAccelerationY = 0;
    double rot = emitter.rotation;
    if (rot != 0) {
      double _sin = sin(rot);
      double _cos = cos(rot);
      vx = particleVelocityX = v * _cos;
      vy = particleVelocityY = v * _sin;
      ax = particleAccelerationX = a * _cos;
      ay = particleAccelerationY = a * _sin;
    }

    if (emitter.dispersionAngle != 0 || emitter.dispersionAngleVariance != 0) {
      double rangle = emitter.dispersionAngle;
      if (emitter.dispersionAngleVariance > 0) {
        rangle += emitter.dispersionAngleVariance * random.nextDouble();
      }
      double _sin = sin(rangle);
      double _cos = cos(rangle);
      particleVelocityX = (vx * _cos - vy * _sin);
      particleVelocityY = (vy * _cos + vx * _sin);
      particleAccelerationX = (ax * _cos - ay * _sin);
      particleAccelerationY = (ay * _cos + ay * _sin);
    }

    double ratioVel = .001;

    initialVelocityX = velocityX = particleVelocityX * ratioVel;
    initialVelocityY = velocityY = particleVelocityY * ratioVel;

    initialAccelerationX = accelerationX = particleAccelerationX * ratioVel;
    initialAccelerationY = accelerationY = particleAccelerationY * ratioVel;

    initialVelocityAngular = emitter.initialAngularVelocity;
    if (emitter.initialAngularVelocityVariance > 0)
      initialVelocityAngular +=
          emitter.initialAngularVelocityVariance * random.nextDouble();

    // print("Initial vel x: $initialVelocityX");
    initialAlpha = emitter.initialAlpha;
    if (emitter.initialAlphaVariance > 0) {
      initialAlpha += emitter.initialAlphaVariance * random.nextDouble();
    }
    initialRed = emitter.initialRed;
    if (emitter.initialRedVariance > 0) {
      initialRed += emitter.initialRedVariance * random.nextDouble();
    }
    initialGreen = emitter.initialGreen;
    if (emitter.initialGreenVariance > 0) {
      initialGreen += emitter.initialGreenVariance * random.nextDouble();
    }
    initialBlue = emitter.initialBlue;
    if (emitter.initialBlueVariance > 0) {
      initialBlue += emitter.initialBlueVariance * random.nextDouble();
    }

    endAlpha = emitter.endAlpha;
    if (emitter.endAlphaVariance > 0) {
      endAlpha += emitter.endAlphaVariance * random.nextDouble();
    }
    endRed = emitter.endRed;
    if (emitter.endRedVariance > 0) {
      endRed += emitter.endRedVariance * random.nextDouble();
    }
    endGreen = emitter.endGreen;
    if (emitter.endGreenVariance > 0) {
      endGreen += emitter.endGreenVariance * random.nextDouble();
    }
    endBlue = emitter.endBlue;
    if (emitter.endBlueVariance > 0) {
      endBlue += emitter.endBlueVariance * random.nextDouble();
    }

    redDif = endRed - initialRed;
    greenDif = endGreen - initialGreen;
    blueDif = endBlue - initialBlue;
    alphaDif = endAlpha - initialAlpha;
    scaleDif = endScale - initialScale;
  }

  void $update(SimpleParticleSystem emitter, double delta) {
    accumulatedEnergy += delta;
    // print("acc energ: $accumulatedEnergy /// $energy");
    if (accumulatedEnergy >= energy) {
      emitter.$deactivateParticle(this);
      return;
    }

    double p = accumulatedEnergy / energy;
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
      $next.$prev = $prev;
    }
    if ($prev != null) {
      $prev.$next = $next;
    }
    $next = null;
    $prev = null;
    $nextInstance = $availableInstance;
    $availableInstance = this;
  }
}
