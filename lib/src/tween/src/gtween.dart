part of gtween;

/// A function that takes an [Object] target and returns a [GTweenable] object
/// that can be animated by [GTween].
typedef GAnimatableBuilder = GTweenable? Function(Object? target);

/// GTween is a simple and flexible animation library for GraphX.
///
/// GTween can animate almost any object property. It uses easing equations
/// to generate natural motion between two states of an object.
///
/// GTween is inspired by GreenSock's TweenLite/TweenMax library for JavaScript.
///
/// To create a new GTween animation, you need to provide a target object,
/// duration of the animation, and a `Map` of properties to tween.
///
/// Example:
///
/// ```dart
/// var myButton = SomeButton(); // create a button
///
/// // Tween its position over 2 seconds
/// myButton.tween(duration: 2.0, {'x': 100, 'y': 200});
///
/// ```
///
class GTween {
  /// The timestamp of the last frame processed by the ticker.
  static Duration _lastFrameTimeStamp = Duration.zero;

  /// Tracks whether the GTween engine has been initialized yet.
  static bool initializedEngine = false;

  /// Indicates whether common animatable wrappers have been registered.
  /// Once set to `true`, no further registration is allowed.
  static bool initializedCommonWraps = false;

  /// The current time in seconds, as determined by the [getTimer()] function.
  /// The time is updated every frame and is used to determine the progress of
  /// the animation.
  static double _time = 0;

  /// The current frame number. Incremented by 1 on every frame. Used to
  /// determine whether to use frames or seconds for time-based calculations.
  static double _frame = 0;

  /// A signal that gets dispatched on every tick of the GTween engine.
  static EventSignal<double> ticker = EventSignal<double>();

  /// The default easing function to be used in tweens when an easing function
  /// is not specified.
  static EaseFunction defaultEase = GEase.easeOut;

  /// A set of functions used to determine whether an object can be animated by
  /// GTween, and if so, how to create an animatable wrapper for the object.
  static final Set<GAnimatableBuilder> _tweenableBuilders = {};

  /// A map of reserved property names that cannot be tweened.
  static final Map _reservedProps = {
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

  /// The first GTween instance in the linked list of active tweens.
  static GTween? _first;

  /// The last GTween instance in the linked list of active tweens.
  static GTween? _last;

  /// The time scaling factor applied to all tweens.
  ///
  /// A value of 1 indicates normal speed, while values higher than 1 will speed
  /// up all tweens, and values lower than 1 will slow them down.
  ///
  /// By default, timeScale is set to 1, meaning all tweens play at normal
  /// speed. You can adjust timeScale to create slow-motion or fast-motion
  /// effects.
  ///
  /// Note that [timeScale] affects all tweens globally. If you want to adjust
  /// the speed of individual tweens, you can use the timeScale property of the
  /// tween itself.
  static double timeScale = 1.0;

  /// The duration of the animation, in seconds or frames depending on
  /// [_useFrames].
  ///
  /// This property determines how long the animation will run.
  /// Its value is set by the constructor and cannot be changed afterwards.
  late double _duration;

  /// The properties and values to be tweened.
  Map? vars;

  /// Additional options and parameters for the tween, such as easing and delay.
  late GVars nanoVars;

  /// The start time for this tween. It is set during the initialization process
  /// and is used to determine when the tween should start.
  late double _startTime;

  /// The object to be animated.
  Object? target;

  /// The real target object wrapped by GTween to enable animation.
  Object? _animatableTarget;

  /// Whether to use frames instead of seconds for time-based calculations.
  /// Default is `false`.
  late bool _useFrames;

  /// The current ratio of the animation progress, from 0 to 1.
  double? ratio = 0;

  /// The easing function used to calculate the animation progress.
  /// If not specified in [nanoVars], [defaultEase] will be used.
  late Function _ease;

  /// Whether the tween has been initialized, i.e. whether the properties to be
  /// animated have been identified.
  bool _inited = false;

  /// The first property tween of the animation.
  PropTween? _firstPT;

  /// The next GTween instance in the linked list of active tweens.
  GTween? _next;

  /// The previous GTween instance in the linked list of active tweens.
  GTween? _prev;

  /// A list of objects to be animated, if the target object is a list.
  List? _targets;

  /// A boolean value indicating whether the object is marked for garbage
  /// collection or not. If _gc is true, it means that the object is no longer
  /// needed and can be cleaned up by the garbage collector to free up memory.
  /// If _gc is false, the object is still in use and should not be collected.
  bool _gc = false;

  /// Creates a new [GTween] instance with the specified target object,
  /// duration, and variables.
  GTween(
    this.target,
    double duration,
    this.vars, [
    GVars? myVars,
  ]) {
    if (!GTween.initializedEngine) {
      GTween._initEngine();
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
        _targets = List.of(target as Iterable<dynamic>);
      }

      /// TODO : add wrap support.
    } else if (target is GTweenable) {
      _animatableTarget = (target as GTweenable).target;
    } else {
      if (target is Function || target is Map) {
        /// no process.
      } else {
        /// target can be a Function.
        GTweenable? result;
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
    _ease = nanoVars.ease ?? GTween.defaultEase;
    _useFrames = nanoVars.useFrames ?? false;
    _startTime = (_useFrames ? _frame : _time) + (nanoVars.delay ?? 0);

    if (nanoVars.overwrite == 1) {
      if (_animatableTarget != null) {
        killTweensOf(_animatableTarget);
      } else {
        killTweensOf(target);
      }
    }
    _prev = GTween._last;
    if (GTween._last != null) {
      GTween._last!._next = this;
    } else {
      GTween._first = this;
    }
    GTween._last = this;

    if (nanoVars.immediateRender! ||
        (duration == 0 &&
            nanoVars.delay == 0 &&
            nanoVars.immediateRender != false)) {
      _render(0.0);
    }
  }

  /// Removes a tween or a list of tweens from the timeline.
  ///
  /// This method removes a tween or a list of tweens from the timeline,
  /// stopping its execution and removing its reference.
  ///
  /// If [targets] is a list of maps or [GTweenable] targets, all tweens that
  /// target those objects will be removed. Otherwise, it will look for the
  /// first [GTweenable] associated with the [targets] and remove it from the
  /// timeline.
  ///
  /// If the tween doesn't have any other references, it will be garbage
  /// collected.
  ///
  /// If [targets] is not provided, the tween's target will be used as the
  /// target to kill.
  void kill([Object? targets]) {
    targets ??= _targets ?? target;
    var pt = _firstPT;
    if (targets is List) {
      var targetList = targets;
      if (targetList.first is Map<String, dynamic> ||
          targetList.first is GTweenable) {
        var i = targetList.length;
        while (--i > -1) {
          kill(targetList[i]);
        }
        return;
      }
    } else if (_targets != null) {
      var i = _targets!.length;
      if (targets is! GTweenable) {
        targets = _getAnimatable(targets!);
      }
      while (--i > -1) {
        if (targets == _targets![i]) {
          _targets!.removeAt(i);
        }
      }
      while (pt != null) {
        if (pt.t == targets) {
          if (pt._next != null) {
            pt._next!._prev = pt._prev;
          }
          if (pt._prev != null) {
            pt._prev!._next = pt._next;
          } else {
            _firstPT = pt._next;
          }
        }
        pt = pt._next;
      }
    }
    if (_targets == null || _targets!.isEmpty) {
      _gc = true;
      if (_prev != null) {
        _prev!._next = _next;
      } else if (this == _first) {
        _first = _next;
      }
      if (_next != null) {
        _next!._prev = _prev;
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

  /// Returns the animatable target that corresponds to the provided search
  /// target.
  ///
  /// If the [_animatableTarget] matches the [searchTarget], the [target] is
  /// returned. If `_targets` is not `null`, the function searches the list for
  /// the provided `searchTarget` and returns the corresponding animatable
  /// target.
  ///
  /// Returns `null` if no matching animatable target is found.
  Object? _getAnimatable(Object searchTarget) {
    if (_animatableTarget == searchTarget) return target;
    if (_targets != null) {
      for (var t in _targets!) {
        if (t is GTweenable) {
          if (t.target == searchTarget) return t;
        }
      }
    }
    return null;
  }

  /// Returns the value of the end point for a given property in a tween.
  ///
  /// The [variables] argument should be a map containing the properties and
  /// values for the tween.
  ///
  /// The [property] argument should be the name of the property to retrieve.
  ///
  /// The [start] argument should be the starting value of the property.
  ///
  /// If the value for the property is a [num], the method returns the value
  /// minus the starting value.
  ///
  /// If the value for the property is a [String], the method will attempt to
  /// parse the value as a [double]. If the string starts with a numeric
  /// character followed by an equals sign (e.g. "2x"), the method will return
  /// the value multiplied by the numeric character as a double. If the string
  /// is not in this format, the method will attempt to parse the string as a
  /// double directly.
  ///
  /// If the value for the property is not a [num] or a [String], the method
  /// will return 0.
  double? _getEndValue(
    Map variables,
    dynamic property,
    double? start,
  ) {
    /// Can be tweening a List asMap(), so `property` is better to be dynamic.
    dynamic val = variables[property];
    if (val is num) {
      var v = val + 0.0;
      return v - start!;
    } else if (val is String) {
      if (val.length > 2 && val[1] == '=') {
        var multiplier = double.tryParse('${val[0]}1') ?? 1;
        var factor = double.tryParse(val.substring(2))!;
        return multiplier * factor;
      } else {
        return double.tryParse(val);
      }
    }
    return 0;
  }

  /// Returns the start value of a property based on the provided [target]
  /// target and [property] property.
  ///
  /// If the target is a [GTweenable], the start value is retrieved using
  /// [GTweenable.getProperty()]. Otherwise, the start value is retrieved from
  /// the target map using the provided [property] key.
  ///
  /// Throws an error if the [property] is not found in the target object.
  double _getStartValue(Object target, dynamic property) {
    if (target is GTweenable) {
      return target.getProperty(property);
    } else if (target is Map) {
      return target[property];
    }
    throw 'GTween Error: property not found.';
  }

  /// Initializes the tween and sets up the properties and values.
  ///
  /// If [nanoVars.startAt] is set, creates a new [GVars] object with
  /// [immediateRender] set to true and initializes the tween with it.
  ///
  /// If `_targets` is not null, initializes the properties and values for each
  /// target. Otherwise, initializes the properties and values for `target`.
  ///
  /// If [nanoVars.runBackwards] is true, reverses the initial and change values
  /// for each property in the tween.
  ///
  /// Sets `_inited` to true when initialization is complete.
  void _init() {
    if (nanoVars.startAt != null) {
      var newVars = GVars()..immediateRender = true;
      GTween.to(target, 0, nanoVars.startAt, newVars);
//      GTween.to(target, 0, nanoVars.startAt.vars, nanoVars.startAt);
    }
    if (_targets != null) {
      var i = _targets!.length;
      while (--i > -1) {
        _initProps(_targets![i]);
      }
    } else {
      _initProps(target);
    }
    if (nanoVars.runBackwards!) {
      var pt = _firstPT;
      while (pt != null) {
        pt.s += pt.c!;
        pt.c = -pt.c!;
        pt = pt._next;
      }
    }
    _inited = true;
  }

  /// Initializes the properties of the [target] object with the values
  /// specified in the [vars] map. Creates a PropTween instance for each
  /// property that is not reserved and adds it to the linked list of
  /// PropTween instances, with the newly created instance being the first
  /// element of the list. Sets the start value of the PropTween instance,
  /// the end value computed by the [_getEndValue] method, and associates
  /// the instance with the target object.
  ///
  /// If [target] is null, returns immediately.
  ///
  /// The reserved properties are specified in the [_reservedProps] map.
  /// The method calls the [_getStartValue] method to get the start value
  /// of each property.
  /// So, initializes the [PropTween] to be used in the [target] Object.
  void _initProps(Object? target) {
    if (target == null) {
      return;
    }
    for (final key in vars!.keys) {
      final prop = '$key';
      if (!GTween._reservedProps.containsKey(prop)) {
        _firstPT = PropTween(
          target: target as GTweenable,
          property: key,
          next: _firstPT,
        );
        final startVal = _getStartValue(target, key);
        _firstPT!.s = startVal;
        var endValue = _getEndValue(vars!, key, _firstPT!.s);
        _firstPT!.cObj = vars![key];
        _firstPT!.c = endValue;
        _firstPT!.t!.setTweenProp(_firstPT!);
        if (_firstPT!._next != null) {
          _firstPT!._next!._prev = _firstPT;
        }
      }
    }
  }

  /// Renders the animation at a specific [time]. If the animation has not been
  /// initialized, it will initialize it.
  ///
  /// If the provided [time] parameter is greater than or equal to the
  /// animation's duration, it sets the ratio to 1. If [time] is less than or
  /// equal to 0, sets the ratio to 0. Otherwise, it calculates the ratio using
  /// the provided easing function.
  ///
  /// Then, it iterates through the animation's properties and sets their
  /// current value according to the calculated ratio.
  ///
  /// After setting the current values, the method triggers the `onUpdate`
  /// callback with any provided parameters.
  ///
  /// If the [time] parameter is equal to the animation's duration, it calls the
  /// [kill] method and triggers the `onComplete` callback with any provided
  /// parameters.
  ///
  /// Note that the `_signal` method is used to call the `onStart`, `onUpdate`,
  /// and `onComplete` callbacks with their respective parameters.
  void _render(double time) {
    if (!_inited) {
      _init();
      time = 0.0;
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
      _setCurrentValue(pt, ratio!);
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

  /// Sets the current value of a [PropTween] based on the provided [ratio] and
  /// updates the property accordingly.
  ///
  /// The [value] is calculated as the product of [propertyTween.c] and [ratio],
  /// plus [propertyTween.s]. If the target of the [PropTween] is a
  /// [GTweenable], then the [propertyTween.p] property is set to [value] using
  /// [GTweenable.setProperty()]. Otherwise, the [propertyTween.p] property of
  /// the target [t] is set to [value].
  void _setCurrentValue(PropTween propertyTween, double ratio) {
    var value = propertyTween.c! * ratio + propertyTween.s;
    if (propertyTween.t is GTweenable) {
      propertyTween.t!.setProperty(propertyTween.p!, value);
    } else {
      propertyTween.t![propertyTween.p as String] = value;
    }
  }

  /// Calls the given [callback] with the specified [positional] and [named]
  /// parameters extracted from the [params] object.
  void _signal(Function? callback, CallbackParams? params) {
    if (callback != null) {
      /// It's a very slow approach.
      Function.apply(callback, params?.positional, params?.named);
    }
  }

  /// Similar to [Future.delayed], yet [GTween.delayedCall] runs with the
  /// [Ticker] provider used by [GTween], and also allows you to kill the delay
  /// in the [target] Function.
  ///
  /// Creates a new [GTween] instance with a delay before the execution of the
  /// specified callback function.
  ///
  /// The [delay] parameter specifies the amount of time (in seconds or frames,
  /// depending on the useFrames parameter) before the callback function is
  /// executed.
  ///
  /// The [callback] parameter is the function that will be called when the
  /// delay expires. It can optionally take parameters, which can be passed
  /// using the params parameter.
  ///
  /// The [useFrames] parameter determines whether the delay is specified in
  /// seconds (false) or frames (true).
  ///
  /// The method returns the created GTween instance.
  static GTween delayedCall(
    double delay,
    Function callback, {
    Object? params,
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

  /// Shortcut to start a tween on an [target], start from the end values
  /// to the start values, this option basically flips the tweens.
  ///
  /// Creates a [GTween] animation that animates the [target] object from its
  /// current properties to the properties defined in [vars] over the given
  /// [duration]. If provided, [nanoVars] can be used to configure additional
  /// properties of the animation, such as running the animation backwards and
  /// rendering the target immediately. If [nanoVars] is not provided, a new
  /// instance of [GVars] will be used.
  ///
  /// Returns a new instance of the created GTween animation.
  static GTween from(
    Object target,
    double duration,
    Map vars, [
    GVars? nanoVars,
  ]) {
    nanoVars ??= GVars();
    nanoVars.runBackwards = true;
    nanoVars.immediateRender ??= true;
    return GTween(target, duration, vars, nanoVars);
  }

  /// Placeholder function for hot-reloading. Currently does nothing.
  static void hotReload() {
    /// todo: search a way to kill active.
    // if(!initialized) return ;
    // GTween.killAll();
    // initialized = false;
  }

  /// Returns whether the given [target] is currently being tweened. This method
  /// iterates through all active tweens and checks whether the target object
  /// matches the tween's target or animatable target.
  ///
  /// Returns true if the target is being tweened, false otherwise.
  static bool isTweening(Object target) {
    var t = _first;
    while (t != null) {
      var next = t._next;
      if (t.target == target || t._animatableTarget == target) {
        return true;
      }
      t = next;
    }
    return false;
  }

  /// Kills all running tweens.
  static void killAll() {
    var t = _first;
    while (t != null) {
      var next = t._next;
      t.kill();
      t = next;
    }
  }

  /// Removes all tweens associated with the given [target] object.
  ///
  /// This method iterates through all existing tweens and removes any that are
  /// associated with the given [target] object. A tween is considered
  /// associated with the [target] if its target or _animatableTarget property
  /// matches the [target], or if the [target] is one of the targets of a
  /// multi-target tween.
  static void killTweensOf(Object? target) {
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

  /// Processes a single tick of the GTween engine using the given [elapsed]
  /// time. Dispatches the [ticker] signal to update all registered GTween
  /// objects.
  static void processTick(double elapsed) {
    // TODO: This is a temporal solution, GTween must work per SceneController
    // or make GTicker global... being able to track unique refresh frames
    // is a must.
    final ts = SchedulerBinding.instance.currentFrameTimeStamp;
    if (_lastFrameTimeStamp == ts) return;
    GTween.ticker.dispatch(elapsed);
    _lastFrameTimeStamp = ts;
  }

  /// Registers common wraps for GTweenable objects. This includes the
  /// GTweenableDisplayObject, GTweenableMap, GTweenableDouble, GTweenableInt,
  /// GTweenableMap, and GTweenableList classes. Additionally, other wraps can
  /// be provided via the [otherWraps] parameter.
  ///
  /// By default initializes the basic tweenable wraps for DisplayObject and
  /// Map types. GTween requires the [GTweenable] "proxy" to by pass the need
  /// of reflection (dart:mirrors)
  ///
  /// Code sample:
  /// ```dart
  /// CommonTweenWraps.registerCommonWraps(
  ///   [GTweenableDouble.wrap, GTweenableInt.wrap, GTweenableList]
  /// );
  /// ```
  static void registerCommonWraps([List<GAnimatableBuilder>? otherWraps]) {
    if (initializedCommonWraps) {
      return;
    }
    GTween.registerWrap(GTweenableDisplayObject.wrap);
    GTween.registerWrap(GTweenableMap.wrap);
    GTween.registerWrap(GTweenableDouble.wrap);
    GTween.registerWrap(GTweenableInt.wrap);
    GTween.registerWrap(GTweenableMap.wrap);
    GTween.registerWrap(GTweenableList.wrap);
//    GTween.registerWrap(GTweenableColor.wrap);
    otherWraps?.forEach(GTween.registerWrap);
    initializedCommonWraps = true;
  }

  /// Registers a new GTweenableBuilder with the engine.
  static void registerWrap(GAnimatableBuilder builder) {
    _tweenableBuilders.add(builder);
  }

  /// Creates a [GTween] that animates the properties of the [target] object
  /// from its current values to the values specified in the [vars] map over the
  /// specified [duration]. Is a shortcut to start a tween on [target].
  ///
  /// If [nanoVars] is provided, the [GTween] will be initialized with the
  /// additional configuration options specified in [nanoVars].
  ///
  /// Returns the created [GTween] instance.
  static GTween to(
    Object? target,
    double duration,
    Map? vars, [
    GVars? nanoVars,
  ]) {
    nanoVars ??= GVars();
    return GTween(target, duration, vars, nanoVars);
  }

  /// Initializes the GTween engine by setting the _time to the current time
  /// returned by [getTimer] and getting a hook in the ticker.
  static void _initEngine() {
    initializedEngine = true;
    _time = getTimer() / 1000;
    _frame = 0;
    ticker.add(_updateRoot);
  }

  /// Updates all active tweens pool for the current frame.
  ///
  /// Increments the internal frame counter, updates the global time
  /// (taking into account time scale), and renders each tween that is
  /// not garbage collected and within its start and end time.
  ///
  /// If `delta` is less than or equal to 0, sets it to 0.016.
  ///
  /// This method is called on every frame update and should not be
  /// called directly by the user.
  static void _updateRoot(double delta) {
    _frame += 1;
    // _time = getTimer() * .001;
    if (delta <= 0) delta = .016;
    GTween._time += delta * GTween.timeScale;
    var tween = GTween._first;
    while (tween != null) {
      var next = tween._next;
      final t = tween._useFrames ? GTween._frame : GTween._time;
      if (t >= tween._startTime && !tween._gc) {
        tween._render(t - tween._startTime);
      }
      tween = next;
    }
  }
}
