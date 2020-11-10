import 'dart:math';
import 'dart:ui';

import '../../../graphx.dart';

class SimpleParticleSystem extends DisplayObject {
  static final _sHelperMatrix = GxMatrix();
  static final _sHelperPoint = GxPoint();
  static Random random = Random();

  bool useWorldSpace = false;

  BlendMode particleBlendMode = BlendMode.srcATop;

  BlendMode get blendMode => nativePaint.blendMode;
  set blendMode(BlendMode value) {
    nativePaint.blendMode = value;
  }

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    matrix.transformCoords(0, 0, _sHelperPoint);
    out ??= GxRect();
    out.setTo(_sHelperPoint.x, _sHelperPoint.y, 0, 0);
    return out;
  }

  /// ---- PROPERTIES.
  double initialScale = 1.0;
  double initialScaleVariance = 0.0;
  double endScale = 1.0;
  double endScaleVariance = 0.0;
  bool emit = false;
  bool burst = false;
  double energy = 0;
  double energyVariance = 0;

  /// how many particles to emit per [emissionTime].
  int emission = 1;

  /// how random the [emission] can be during [emissionTime].
  int emissionVariance = 0;

  /// how often we create [emission] particles.
  double emissionTime = 1;

  /// time gap between [emissionTime].
  double emissionDelay = 0;
  double initialVelocity = 0;
  double initialVelocityVariance = 0;
  double initialAcceleration = 0;
  double initialAccelerationVariance = 0;
  double initialAngularVelocity = 0;
  double initialAngularVelocityVariance = 0;
  double initialAngle = 0;
  double initialAngleVariance = 0;

  /// --- todo: find color way
  double initialAlpha = 1;
  double initialAlphaVariance = 0;
  double initialRed = 1, initialGreen = 1, initialBlue = 1;
  double initialRedVariance = 0,
      initialGreenVariance = 0,
      initialBlueVariance = 0;
  double endAlpha = 1;
  double endAlphaVariance = 0;
  double endRed = 1, endGreen = 1, endBlue = 1;
  double endRedVariance = 0, endGreenVariance = 0, endBlueVariance = 0;

  double dispersionXVariance = 0;
  double dispersionYVariance = 0;
  double dispersionAngle = 0;
  double dispersionAngleVariance = 0;
  bool paused = false;
  GTexture texture;

  int get initialColor {
    final r = (initialRed * 0xff).toInt() << 16;
    final g = (initialGreen * 0xff).toInt() << 8;
    final b = (initialBlue * 0xff).toInt();
    return r + g + b;
  }

  set initialColor(int value) {
    initialRed = (value >> 16 & 0xff) / 0xff;
    initialGreen = (value >> 8 & 0xff) / 0xff;
    initialBlue = (value & 0xff) / 0xff;
  }

  int get endColor {
    final r = (endRed * 0xff).toInt() << 16;
    final g = (endGreen * 0xff).toInt() << 8;
    final b = (endBlue * 0xff).toInt();
    return r + g + b;
  }

  set endColor(int value) {
    endRed = (value >> 16 & 0xff) / 0xff;
    endGreen = (value >> 8 & 0xff) / 0xff;
    endBlue = (value & 0xff) / 0xff;
  }

  double $accumulatedTime = 0;
  double $accumulatedEmission = 0;

  int $activeParticles = 0;
  double $lastUpdateTime = 0;

  SimpleParticle $firstParticle;
  SimpleParticle $lastParticle;

  void _setInitialParticlePosition(SimpleParticle p) {
    p.x = useWorldSpace ? x : 0;
    if (dispersionXVariance > 0) {
      p.x +=
          dispersionXVariance * random.nextDouble() - dispersionXVariance * .5;
    }
    p.y = useWorldSpace ? y : 0;
    if (dispersionYVariance > 0) {
      p.y +=
          dispersionYVariance * random.nextDouble() - dispersionYVariance * .5;
    }
    p.rotation = initialAngle;
    if (initialAngleVariance > 0) {
      p.rotation += initialAngleVariance * random.nextDouble();
    }
    p.scaleX = p.scaleY = initialScale;
    if (initialScaleVariance > 0) {
      var sd = initialScaleVariance * random.nextDouble();
      p.scaleX += sd;
      p.scaleY += sd;
    }
  }

  void init() {
    ///blend mode normal.
    ScenePainter.current.onUpdate.add(update);
  }

  void setup(
      [int maxCount = 0,
      int precacheCount = 0,
      bool disposeImmediately = true]) {
    $accumulatedTime = 0;
    $accumulatedEmission = 0;
    if (texture != null) {
      _setPivot();
    }
  }

  void _setPivot() {
    /// used (texture.width)...
    particlePivotX = texture.nativeWidth.toDouble() * .5;
    particlePivotY = texture.nativeHeight.toDouble() * .5;
  }

  double particlePivotX;
  double particlePivotY;

  void forceBurst() {
    var currentEmission =
        (emission + emissionVariance * random.nextDouble()).toInt();
    for (var i = 0; i < currentEmission; ++i) {
      activateParticle();
    }
    emit = false;
  }

  @override
  void update(double delta) {
    delta *= 1000;
    if (particlePivotX == null && texture != null) {
      _setPivot();
    }
    $lastUpdateTime = delta;
    if (paused) return;
    if (emit) {
      if (burst) {
        forceBurst();
      } else {
        $accumulatedTime += delta * .001;
        var time = $accumulatedTime % (emissionTime + emissionDelay);
        if (time <= emissionTime) {
          var updateEmission = emission.toDouble();
          if (emissionVariance > 0) {
            updateEmission += emissionVariance * random.nextDouble();
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

  @override
  void paint(Canvas canvas) {
    if (!$hasVisibleArea) return;
    if (useWorldSpace) {
      render(canvas);
    } else {
      super.paint(canvas);
    }
  }

  @override
  void $applyPaint(Canvas canvas) {
    render(canvas);
  }

  bool useAlphaOnColorFilter = false;

  void Function(Canvas, Paint) drawCallback;

  final nativePaint = Paint()
    ..color = Color(0xff000000)
    ..filterQuality = FilterQuality.low;

  void render(Canvas canvas) {
    if (texture == null) return;
    var particle = $firstParticle;
    while (particle != null) {
      var next = particle.$next;
      double tx, ty, sx, sy;
      tx = particle.x;
      ty = particle.y;
      sx = particle.scaleX / texture.scale;
      sy = particle.scaleY / texture.scale;
      if (useWorldSpace) {
        sx *= scaleX;
        sy *= scaleY;
      }

      /// calculate color... if needed
      final _color = particle.color;
      nativePaint.color = _color;
//      nativePaint.color = nativePaint.color.withOpacity(particle.alpha);
//      nativePaint.colorFilter = ColorFilter.mode(_color, BlendMode.srcATop);
//      nativePaint.colorFilter = ColorFilter.mode(_color, BlendMode.plus);
//      nativePaint.colorFilter = ColorFilter.mode(_color, BlendMode.colorBurn);
//      nativePaint.colorFilter = ColorFilter.mode(_color, BlendMode.src);
      var filterColor = useAlphaOnColorFilter ? _color : _color.withOpacity(1);
      nativePaint.colorFilter =
          ColorFilter.mode(filterColor, particleBlendMode);
      canvas.save();
      canvas.translate(tx, ty);
      canvas.rotate(particle.rotation);
      canvas.scale(sx, sy);
      canvas.translate(-particlePivotX, -particlePivotY);

      // $canvas.scale(particle.scaleX, particle.scaleY);
      // $canvas.rotate(particle.rotation);
      /// render in canvas.
      if (drawCallback != null) {
        drawCallback(canvas, nativePaint);
//        $canvas.drawImage(texture.source, Offset.zero, nativePaint);
      } else {
        canvas.drawImage(texture.root, Offset.zero, nativePaint);
      }
      // $canvas.drawImage(texture.source, Offset(tx, ty), nativePaint);
      canvas.restore();

      particle = next;
    }
  }

  void activateParticle() {
    var p = _createParticle();
    _setInitialParticlePosition(p);
    p.init(this);
  }

  SimpleParticle _createParticle() {
    var p = SimpleParticle.get();
    if ($firstParticle != null) {
      p.$next = $firstParticle;
      $firstParticle.$prev = p;
      $firstParticle = p;
    } else {
      $firstParticle = p;
      $lastParticle = p;
    }
    return p;
  }

  void $deactivateParticle(SimpleParticle particle) {
    if (particle == $lastParticle) $lastParticle = $lastParticle.$prev;
    if (particle == $firstParticle) $firstParticle = $firstParticle.$next;
    particle.dispose();
  }

  bool hasLivingParticles() => $firstParticle != null;

  @override
  void dispose() {
    while ($firstParticle != null) {
      $deactivateParticle($firstParticle);
    }
    ScenePainter.current.onUpdate.remove(update);
    super.dispose();
  }

  void clear() {
    while ($firstParticle != null) {
      $deactivateParticle($firstParticle);
    }
  }
}
