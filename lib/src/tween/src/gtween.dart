part of gtween;

class GVars {
  EaseFunction ease;
  double delay;
  bool useFrames;
  int overwrite;
  Function onStart;
  CallbackParams onStartParams;
  Function onComplete;
  CallbackParams onCompleteParams;
  Function onUpdate;
  CallbackParams onUpdateParams;
  bool runBackwards;
  bool immediateRender;

  Map startAt;

  /// TODO: maybe in future use vars from this object.
//  Map vars;

  GVars({
    this.ease,
    this.delay,
    this.useFrames,
    this.overwrite,
    this.onStart,
    this.onComplete,
    this.onUpdate,
    Object onStartParams,
    Object onCompleteParams,
    Object onUpdateParams,
    this.runBackwards,
    this.immediateRender,
    this.startAt,
  }) {
    /// For easy of use, you can send any Object to be parsed as function
    /// arguments...
    this.onStartParams = CallbackParams.parse(onStartParams);
    this.onCompleteParams = CallbackParams.parse(onCompleteParams);
    this.onUpdateParams = CallbackParams.parse(onUpdateParams);
  }

  void defaults() {
    ease ??= GTween.defaultEase;
    immediateRender ??= false;
    useFrames ??= false;
    runBackwards ??= false;
  }

  void _setTween(GTween gTween) {
    if (onStartParams != null) {
      _setCallbackParams(gTween, onStartParams);
    }
    if (onCompleteParams != null) {
      _setCallbackParams(gTween, onCompleteParams);
    }
    if (onUpdateParams != null) {
      _setCallbackParams(gTween, onUpdateParams);
    }
//    onStartParams?._setTween(gTween);
//    onCompleteParams?._setTween(gTween);
//    onUpdateParams?._setTween(gTween);
  }

  static const String selfTweenKey = '{self}';
  void _setCallbackParams(GTween twn, CallbackParams params) {
    final named = params.named;
    final positional = params.positional;
    if (named != null) {
      if (named.containsValue(selfTweenKey)) {
        for (var e in named.entries) {
          if (e.value == selfTweenKey) {
            named[e.key] = twn;
          }
        }
      }
    }
    if (positional != null) {
      if (positional.contains(selfTweenKey)) {
        params.positional = positional.map((e) {
          if (e == selfTweenKey) {
            return twn;
          }
          return e;
        }).toList();
      }
    }
  }
}

class GTween {
  /// BY default initializes the basic tweenable wraps for DisplayObject and
  /// Map types. GTween requires the [Tweenable] "proxy" to by pass the need
  /// of reflection (dart:mirrors)
  ///
  /// Code sample:
  /// ```dart
  /// CommonTweenWraps.registerCommonWraps(
  ///   [GTweenableDouble.wrap, GTweenableInt.wrap, GTweenableList]
  /// );
  /// ```
  static void registerCommonWraps([List<GxAnimatableBuilder> otherWraps]) {
    GTween.registerWrap(GTweenableDisplayObject.wrap);
    GTween.registerWrap(GTweenableMap.wrap);
    GTween.registerWrap(GTweenableDouble.wrap);
    GTween.registerWrap(GTweenableInt.wrap);
    GTween.registerWrap(GTweenableMap.wrap);
    GTween.registerWrap(GTweenableList.wrap);
//    GTween.registerWrap(GTweenableColor.wrap);
    otherWraps?.forEach(GTween.registerWrap);
  }

  static double _time = 0;
  static double _frame = 0;

  /// behaves like int.
  static EventSignal<double> ticker = EventSignal<double>();
  static EaseFunction defaultEase = GEase.easeOut;

  static final Set<GxAnimatableBuilder> _tweenableBuilders = {};

  static void registerWrap(GxAnimatableBuilder builder) =>
      _tweenableBuilders.add(builder);

  static Map _reservedProps;
  static GTween _first;
  static GTween _last;

  double _duration;
  Map vars;
  GVars nanoVars;
  double _startTime;

  Object target;

  /// the real target
  Object _animatableTarget;

  bool _useFrames;
  double ratio = 0;

  Function _ease;

//  Ease _rawEase;
  bool _inited = false;

  PropTween _firstPT;
  GTween _next;
  GTween _prev;
  List _targets;

  bool _gc = false;

  GTween(this.target, double duration, this.vars, [GVars myVars]) {
    if (_reservedProps == null) {
      _reservedProps = {
        'delay': 1,
        'ease': 1,
        'usedFrames': 1,
        'overwrite': 1,
        'onComplete': 1,
        'runBackwards': 1,
        'immediateRender': 1,
        'onUpdate': 1,
        'startAt': 1,
      };
      _time = getTimer() / 1000;
      _frame = 0;
      ticker.add(_updateRoot);
    }

    nanoVars = myVars ?? GVars();
    nanoVars.defaults();
    nanoVars._setTween(this);
    // this.vars = vars;

    _duration = duration;
    // this.target = target;

    if (target is List) {
      var targetList = target as List;
      if (targetList.first is Map<String, dynamic> ||
          targetList.first is GTweenable) {
        _targets = List.of(target);
      }

      /// TODO : add wrap support.
    } else if (target is GTweenable) {
      _animatableTarget = (target as GTweenable).target;
    } else {
      if (target is Function || target is Map) {
        /// no process.
      } else {
        /// target can be a Function.
        GTweenable result;
        for (final builder in _tweenableBuilders) {
          result = builder(target);
          if (result != null) {
            break;
          }
        }
        target = result;
        _animatableTarget = result?.target;
      }
    }
//    _rawEase = nanoVars.ease;
//    _ease = _rawEase?.getRatio;
    _ease = nanoVars.ease;
    _useFrames = nanoVars.useFrames ?? false;
    _startTime = (_useFrames ? _frame : _time) + (nanoVars.delay ?? 0);

    if (nanoVars.overwrite == 1) {
      if (_animatableTarget != null) {
        killTweensOf(_animatableTarget);
      } else {
        killTweensOf(target);
      }
    }
    _prev = _last;
    if (_last != null) {
      _last._next = this;
    } else {
      _first = this;
    }
    _last = this;

    if (nanoVars.immediateRender ||
        (duration == 0 &&
            nanoVars.delay == 0 &&
            nanoVars.immediateRender != false)) {
      _render(0);
    }
  }

  void _init() {
    if (nanoVars.startAt != null) {
      var newVars = GVars()..immediateRender = true;
      GTween.to(target, 0, nanoVars.startAt, newVars);
//      GTween.to(target, 0, nanoVars.startAt.vars, nanoVars.startAt);
    }
    if (_targets != null) {
      var i = _targets.length;
      while (--i > -1) {
        _initProps(_targets[i]);
      }
    } else {
      _initProps(target);
    }
    if (nanoVars.runBackwards) {
      var pt = _firstPT;
      while (pt != null) {
        pt.s += pt.c;
        pt.c = -pt.c;
        pt = pt._next;
      }
    }
    _inited = true;
  }

  /// initialiazes the PropTween to be used in the target Object.
  void _initProps(Object target) {
    if (target == null) return;
    for (final key in vars.keys) {
      final prop = '$key';
      if (!_reservedProps.containsKey(prop)) {
        _firstPT = PropTween(target: target, property: key, next: _firstPT);
        var startVal = _getStartValue(target, key);
        _firstPT.s = startVal;
        var endValue = _getEndValue(vars, key, _firstPT.s);
        _firstPT.cObj = vars[key];
        _firstPT.c = endValue;
        _firstPT.t.setTweenProp(_firstPT);
        if (_firstPT._next != null) {
          _firstPT._next._prev = _firstPT;
        }
      }
    }
  }

  /// Can be tweening a List asMap(), so `prop` is better to be
  /// dynamic.
  double _getEndValue(Map pvars, dynamic prop, double start) {
    dynamic val = pvars[prop];
    if (val is num) {
      double v = val + 0.0;
      return v - start;
    } else if (val is String) {
      if (val.length > 2 && val[1] == '=') {
        var multiplier = double.tryParse('${val[0]}1') ?? 1;
        var factor = double.tryParse(val.substring(2));
        return multiplier * factor;
      } else {
        return double.tryParse(val);
      }
    }
    return 0;
  }

  void _setCurrentValue(PropTween pt, double ratio) {
    var value = pt.c * ratio + pt.s;
    if (pt.t is GTweenable) {
      pt.t.setProperty(pt.p, value);
    } else {
      pt.t[pt.p] = value;
    }
  }

  double _getStartValue(Object t, dynamic prop) {
    if (t is GTweenable) {
      return t.getProperty(prop);
    } else if (t is Map) {
      return t[prop];
    }
    throw 'error';
  }

  void _render(double time) {
    if (!_inited) {
      _init();
      time = 0;
    }
    var prevTime = time;
    if (time >= _duration) {
      time = _duration;
      ratio = 1;
    } else if (time <= 0) {
      if (prevTime == 0) {
        _signal(nanoVars.onStart, nanoVars.onStartParams);
      }
      ratio = 0;
    } else {
//      ratio = _ease.getRatio(time / _duration);
      ratio = _ease(time / _duration);
    }

    var pt = _firstPT;
    while (pt != null) {
      _setCurrentValue(pt, ratio);
      pt = pt._next;
    }
    _signal(nanoVars.onUpdate, nanoVars.onUpdateParams);
    if (time == _duration) {
      kill();
      if (nanoVars.onCompleteParams == null) {
        nanoVars.onComplete?.call();
      } else {
        _signal(nanoVars.onComplete, nanoVars.onCompleteParams);
      }
    }
  }

  void _signal(Function callback, CallbackParams params) {
    if (callback != null) {
      /// It's a very slow approach.
      Function.apply(callback, params?.positional, params?.named);
    }
  }

  Object _getAnimatable(Object searchTarget) {
    if (_animatableTarget == searchTarget) return target;
    if (_targets != null) {
      for (var t in _targets) {
        if (t is GTweenable) {
          if (t.target == searchTarget) return t;
        }
      }
    }
    return null;
  }

  void kill([Object tg]) {
    tg ??= _targets ?? target;
    var pt = _firstPT;
    if (tg is List) {
      var targetList = tg;
      if (targetList.first is Map<String, dynamic> ||
          targetList.first is GTweenable) {
        var i = targetList.length;
        while (--i > -1) {
          kill(targetList[i]);
        }
        return;
      }
    } else if (_targets != null) {
      var i = _targets.length;
      if (tg is! GTweenable) {
        tg = _getAnimatable(tg);
      }
      while (--i > -1) {
        if (tg == _targets[i]) {
          _targets.removeAt(i);
        }
      }
      while (pt != null) {
        if (pt.t == tg) {
          if (pt._next != null) {
            pt._next._prev = pt._prev;
          }
          if (pt._prev != null) {
            pt._prev._next = pt._next;
          } else {
            _firstPT = pt._next;
          }
        }
        pt = pt._next;
      }
    }
    if (_targets == null || _targets.isEmpty) {
      _gc = true;
      if (_prev != null) {
        _prev._next = _next;
      } else if (this == _first) {
        _first = _next;
      }
      if (_next != null) {
        _next._prev = _prev;
      } else if (this == _last) {
        _last = _prev;
      }
      if (target is GTweenable) {
        (target as GTweenable).dispose();
      }
//      nanoVars = null;
//      vars = null;
      _next = _prev = null;
    }
  }

  /// Kills all running tweens.
  static void killAll(){
    var t = _first;
    while (t != null) {
      var next = t._next;
      t.kill();
      t = next;
    }
  }

  /// Shortcut to start a tween on an `target`.
  static GTween to(Object target, double duration, Map vars, [GVars nanoVars]) {
    nanoVars ??= GVars();
    return GTween(target, duration, vars, nanoVars);
  }

  /// Shortcut to start a tween on an `target`, start from the end values
  /// to the start values, this option flips the tweens.
  static GTween from(Object target, double duration, Map vars,
      [GVars nanoVars]) {
    nanoVars ??= GVars();
    nanoVars.runBackwards = true;
    nanoVars.immediateRender ??= true;
    return GTween(target, duration, vars, nanoVars);
  }

  /// Similar to Future.delayed(), but `GTween.delayedCall` runs with the
  /// `Ticker` provider used by GTween, and also allows you to kill the delay
  /// in the `target` Function.
  static GTween delayedCall(
    double delay,
    Function callback, {
    Object params,
    bool useFrames = false,
  }) {
    var props = GVars()
      ..delay = delay
      ..useFrames = useFrames
      ..onComplete = callback
      ..onCompleteParams = CallbackParams.parse(params);
    return GTween(
      callback,
      0,
      {},
      props,
    );
  }

  static double timeScale = 1;

  /// Main ticker function that updates all the Tweens pool
  static void _updateRoot(double delta) {
    _frame += 1;
    // _time = getTimer() * .001;
    if (delta <= 0) delta = .016;
    _time += delta * timeScale;
    var tween = _first;
    while (tween != null) {
      var next = tween._next;
      var t = tween._useFrames ? _frame : _time;
      if (t >= tween._startTime && !tween._gc) {
        tween._render(t - tween._startTime);
      }
      tween = next;
    }
  }

  /// Removes a Tween based on the the target object.
  static void killTweensOf(Object target) {
    var t = _first;
    while (t != null) {
      var next = t._next;
      if (t.target == target || t._animatableTarget == target) {
        t.kill();
      } else if (t._targets != null) {
        t.kill(target);
      }
      t = next;
    }
  }
}

typedef GxAnimatableBuilder = GTweenable Function(Object target);
