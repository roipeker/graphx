import 'package:graphx/graphx/games/particles/gx_simple_particle_emitter.dart';
import 'package:graphx/graphx/textures/base_texture.dart';

class SimpleParticle {
  SimpleParticle $next;
  SimpleParticle $prev;

  double x, y, rotation, scaleX, scaleY, alpha;
  int color;
  double velX = 0, velY = 0;
  double accX = 0, accY = 0;
  double energy = 0;
  double initialScale = 0, endScale = 1.0;
  double initialVelX, initialVelY, initialVelAngular;

  double initialAccX, initialAccY;

  double initialColor, endColor;
  double initialAlpha, endAlpha;

  double $scaleDif;
  double accumulatedEnergy = 0;
  SimpleParticle $nextInstance;
  int id = 0;
  GxTexture texture;

  static SimpleParticle availableInstance;
  static int instanceCount = 0;

  SimpleParticle() {
    id = instanceCount++;
  }

  static SimpleParticle get() {
    SimpleParticle instance = availableInstance;
    if (instance != null) {
      availableInstance = instance.$nextInstance;
      instance.$nextInstance = null;
    } else {
      instance = SimpleParticle();
    }
    return instance;
  }

  void precache(int precacheCount) {
    if (precacheCount < instanceCount) return;
    SimpleParticle precached = get();
    while (instanceCount < precacheCount) {
      var n = get();
      n.$prev = precached;
      precached = n;
    }
    while (precached != null) {
      var d = precached;
      precached = d.$prev;
      d.dispose();
    }
  }

  void dispose() {
    if ($next != null) $next.$prev = $prev;
    if ($prev != null) $prev.$next = $next;
    $next = null;
    $prev = null;
    $nextInstance = availableInstance;
    availableInstance = this;
  }

//  void init (SimpleParticleEmitter emitter, bool invalidate=true){
//  accumulatedEnergy=0;
//  texture = emitter.texture;
//  energy=emitter.energy * 1000;
//  }

  void update(SimpleParticleEmitter emitter, double deltaTime) {
    accumulatedEnergy += deltaTime;
    if (accumulatedEnergy >= energy) {
      emitter.deactivateParticle(this);
      return;
    }
    var p = accumulatedEnergy / energy;
    velX += accX * deltaTime;
    velY += accY * deltaTime;
    // color change... mmm
    x += velX * deltaTime;
    y += velY * deltaTime;
    rotation += initialVelAngular * deltaTime;
    scaleX = scaleY = $scaleDif * p + initialScale;
  }
}
