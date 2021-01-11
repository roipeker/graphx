import 'package:flutter/services.dart';

import '../../graphx.dart';

/// Utility class to work easily with keyboard events.
class Keyboard {
  final LogicalKeyboardKey value;

  const Keyboard._(this.value);

  static const up = Keyboard._(LogicalKeyboardKey.arrowUp);
  static const left = Keyboard._(LogicalKeyboardKey.arrowLeft);
  static const right = Keyboard._(LogicalKeyboardKey.arrowRight);
  static const down = Keyboard._(LogicalKeyboardKey.arrowDown);

  static const none = Keyboard._(LogicalKeyboardKey.none);
  static const hyper = Keyboard._(LogicalKeyboardKey.hyper);
  static const superKey = Keyboard._(LogicalKeyboardKey.superKey);
  static const fnLock = Keyboard._(LogicalKeyboardKey.fnLock);
  static const suspend = Keyboard._(LogicalKeyboardKey.suspend);
  static const resume = Keyboard._(LogicalKeyboardKey.resume);
  static const turbo = Keyboard._(LogicalKeyboardKey.turbo);
  static const privacyScreenToggle =
      Keyboard._(LogicalKeyboardKey.privacyScreenToggle);
  static const sleep = Keyboard._(LogicalKeyboardKey.sleep);
  static const wakeUp = Keyboard._(LogicalKeyboardKey.wakeUp);
  static const displayToggleIntExt =
      Keyboard._(LogicalKeyboardKey.displayToggleIntExt);
  static const usbReserved = Keyboard._(LogicalKeyboardKey.usbReserved);
  static const usbErrorRollOver =
      Keyboard._(LogicalKeyboardKey.usbErrorRollOver);
  static const usbPostFail = Keyboard._(LogicalKeyboardKey.usbPostFail);
  static const usbErrorUndefined =
      Keyboard._(LogicalKeyboardKey.usbErrorUndefined);
  static const keyA = Keyboard._(LogicalKeyboardKey.keyA);
  static const keyB = Keyboard._(LogicalKeyboardKey.keyB);
  static const keyC = Keyboard._(LogicalKeyboardKey.keyC);
  static const keyD = Keyboard._(LogicalKeyboardKey.keyD);
  static const keyE = Keyboard._(LogicalKeyboardKey.keyE);
  static const keyF = Keyboard._(LogicalKeyboardKey.keyF);
  static const keyG = Keyboard._(LogicalKeyboardKey.keyG);
  static const keyH = Keyboard._(LogicalKeyboardKey.keyH);
  static const keyI = Keyboard._(LogicalKeyboardKey.keyI);
  static const keyJ = Keyboard._(LogicalKeyboardKey.keyJ);
  static const keyK = Keyboard._(LogicalKeyboardKey.keyK);
  static const keyL = Keyboard._(LogicalKeyboardKey.keyL);
  static const keyM = Keyboard._(LogicalKeyboardKey.keyM);
  static const keyN = Keyboard._(LogicalKeyboardKey.keyN);
  static const keyO = Keyboard._(LogicalKeyboardKey.keyO);
  static const keyP = Keyboard._(LogicalKeyboardKey.keyP);
  static const keyQ = Keyboard._(LogicalKeyboardKey.keyQ);
  static const keyR = Keyboard._(LogicalKeyboardKey.keyR);
  static const keyS = Keyboard._(LogicalKeyboardKey.keyS);
  static const keyT = Keyboard._(LogicalKeyboardKey.keyT);
  static const keyU = Keyboard._(LogicalKeyboardKey.keyU);
  static const keyV = Keyboard._(LogicalKeyboardKey.keyV);
  static const keyW = Keyboard._(LogicalKeyboardKey.keyW);
  static const keyX = Keyboard._(LogicalKeyboardKey.keyX);
  static const keyY = Keyboard._(LogicalKeyboardKey.keyY);
  static const keyZ = Keyboard._(LogicalKeyboardKey.keyZ);
  static const digit1 = Keyboard._(LogicalKeyboardKey.digit1);
  static const digit2 = Keyboard._(LogicalKeyboardKey.digit2);
  static const digit3 = Keyboard._(LogicalKeyboardKey.digit3);
  static const digit4 = Keyboard._(LogicalKeyboardKey.digit4);
  static const digit5 = Keyboard._(LogicalKeyboardKey.digit5);
  static const digit6 = Keyboard._(LogicalKeyboardKey.digit6);
  static const digit7 = Keyboard._(LogicalKeyboardKey.digit7);
  static const digit8 = Keyboard._(LogicalKeyboardKey.digit8);
  static const digit9 = Keyboard._(LogicalKeyboardKey.digit9);
  static const digit0 = Keyboard._(LogicalKeyboardKey.digit0);
  static const enter = Keyboard._(LogicalKeyboardKey.enter);
  static const escape = Keyboard._(LogicalKeyboardKey.escape);
  static const backspace = Keyboard._(LogicalKeyboardKey.backspace);
  static const tab = Keyboard._(LogicalKeyboardKey.tab);
  static const space = Keyboard._(LogicalKeyboardKey.space);
  static const minus = Keyboard._(LogicalKeyboardKey.minus);
  static const equal = Keyboard._(LogicalKeyboardKey.equal);
  static const bracketLeft = Keyboard._(LogicalKeyboardKey.bracketLeft);
  static const bracketRight = Keyboard._(LogicalKeyboardKey.bracketRight);
  static const backslash = Keyboard._(LogicalKeyboardKey.backslash);
  static const semicolon = Keyboard._(LogicalKeyboardKey.semicolon);
  static const quote = Keyboard._(LogicalKeyboardKey.quote);
  static const backquote = Keyboard._(LogicalKeyboardKey.backquote);
  static const comma = Keyboard._(LogicalKeyboardKey.comma);
  static const period = Keyboard._(LogicalKeyboardKey.period);
  static const slash = Keyboard._(LogicalKeyboardKey.slash);
  static const capsLock = Keyboard._(LogicalKeyboardKey.capsLock);
  static const f1 = Keyboard._(LogicalKeyboardKey.f1);
  static const f2 = Keyboard._(LogicalKeyboardKey.f2);
  static const f3 = Keyboard._(LogicalKeyboardKey.f3);
  static const f4 = Keyboard._(LogicalKeyboardKey.f4);
  static const f5 = Keyboard._(LogicalKeyboardKey.f5);
  static const f6 = Keyboard._(LogicalKeyboardKey.f6);
  static const f7 = Keyboard._(LogicalKeyboardKey.f7);
  static const f8 = Keyboard._(LogicalKeyboardKey.f8);
  static const f9 = Keyboard._(LogicalKeyboardKey.f9);
  static const f10 = Keyboard._(LogicalKeyboardKey.f10);
  static const f11 = Keyboard._(LogicalKeyboardKey.f11);
  static const f12 = Keyboard._(LogicalKeyboardKey.f12);
  static const printScreen = Keyboard._(LogicalKeyboardKey.printScreen);
  static const scrollLock = Keyboard._(LogicalKeyboardKey.scrollLock);
  static const pause = Keyboard._(LogicalKeyboardKey.pause);
  static const insert = Keyboard._(LogicalKeyboardKey.insert);
  static const home = Keyboard._(LogicalKeyboardKey.home);
  static const pageUp = Keyboard._(LogicalKeyboardKey.pageUp);
  static const delete = Keyboard._(LogicalKeyboardKey.delete);
  static const end = Keyboard._(LogicalKeyboardKey.end);
  static const pageDown = Keyboard._(LogicalKeyboardKey.pageDown);
  static const arrowRight = Keyboard._(LogicalKeyboardKey.arrowRight);
  static const arrowLeft = Keyboard._(LogicalKeyboardKey.arrowLeft);
  static const arrowDown = Keyboard._(LogicalKeyboardKey.arrowDown);
  static const arrowUp = Keyboard._(LogicalKeyboardKey.arrowUp);
  static const numLock = Keyboard._(LogicalKeyboardKey.numLock);
  static const numpadDivide = Keyboard._(LogicalKeyboardKey.numpadDivide);
  static const numpadMultiply = Keyboard._(LogicalKeyboardKey.numpadMultiply);
  static const numpadSubtract = Keyboard._(LogicalKeyboardKey.numpadSubtract);
  static const numpadAdd = Keyboard._(LogicalKeyboardKey.numpadAdd);
  static const numpadEnter = Keyboard._(LogicalKeyboardKey.numpadEnter);
  static const numpad1 = Keyboard._(LogicalKeyboardKey.numpad1);
  static const numpad2 = Keyboard._(LogicalKeyboardKey.numpad2);
  static const numpad3 = Keyboard._(LogicalKeyboardKey.numpad3);
  static const numpad4 = Keyboard._(LogicalKeyboardKey.numpad4);
  static const numpad5 = Keyboard._(LogicalKeyboardKey.numpad5);
  static const numpad6 = Keyboard._(LogicalKeyboardKey.numpad6);
  static const numpad7 = Keyboard._(LogicalKeyboardKey.numpad7);
  static const numpad8 = Keyboard._(LogicalKeyboardKey.numpad8);
  static const numpad9 = Keyboard._(LogicalKeyboardKey.numpad9);
  static const numpad0 = Keyboard._(LogicalKeyboardKey.numpad0);
  static const numpadDecimal = Keyboard._(LogicalKeyboardKey.numpadDecimal);
  static const intlBackslash = Keyboard._(LogicalKeyboardKey.intlBackslash);
  static const contextMenu = Keyboard._(LogicalKeyboardKey.contextMenu);
  static const power = Keyboard._(LogicalKeyboardKey.power);
  static const numpadEqual = Keyboard._(LogicalKeyboardKey.numpadEqual);
  static const f13 = Keyboard._(LogicalKeyboardKey.f13);
  static const f14 = Keyboard._(LogicalKeyboardKey.f14);
  static const f15 = Keyboard._(LogicalKeyboardKey.f15);
  static const f16 = Keyboard._(LogicalKeyboardKey.f16);
  static const f17 = Keyboard._(LogicalKeyboardKey.f17);
  static const f18 = Keyboard._(LogicalKeyboardKey.f18);
  static const f19 = Keyboard._(LogicalKeyboardKey.f19);
  static const f20 = Keyboard._(LogicalKeyboardKey.f20);
  static const f21 = Keyboard._(LogicalKeyboardKey.f21);
  static const f22 = Keyboard._(LogicalKeyboardKey.f22);
  static const f23 = Keyboard._(LogicalKeyboardKey.f23);
  static const f24 = Keyboard._(LogicalKeyboardKey.f24);
  static const open = Keyboard._(LogicalKeyboardKey.open);
  static const help = Keyboard._(LogicalKeyboardKey.help);
  static const select = Keyboard._(LogicalKeyboardKey.select);
  static const again = Keyboard._(LogicalKeyboardKey.again);
  static const undo = Keyboard._(LogicalKeyboardKey.undo);
  static const cut = Keyboard._(LogicalKeyboardKey.cut);
  static const copy = Keyboard._(LogicalKeyboardKey.copy);
  static const paste = Keyboard._(LogicalKeyboardKey.paste);
  static const find = Keyboard._(LogicalKeyboardKey.find);
  static const audioVolumeMute = Keyboard._(LogicalKeyboardKey.audioVolumeMute);
  static const audioVolumeUp = Keyboard._(LogicalKeyboardKey.audioVolumeUp);
  static const audioVolumeDown = Keyboard._(LogicalKeyboardKey.audioVolumeDown);
  static const numpadComma = Keyboard._(LogicalKeyboardKey.numpadComma);
  static const intlRo = Keyboard._(LogicalKeyboardKey.intlRo);
  static const kanaMode = Keyboard._(LogicalKeyboardKey.kanaMode);
  static const intlYen = Keyboard._(LogicalKeyboardKey.intlYen);
  static const convert = Keyboard._(LogicalKeyboardKey.convert);
  static const nonConvert = Keyboard._(LogicalKeyboardKey.nonConvert);
  static const lang1 = Keyboard._(LogicalKeyboardKey.lang1);
  static const lang2 = Keyboard._(LogicalKeyboardKey.lang2);
  static const lang3 = Keyboard._(LogicalKeyboardKey.lang3);
  static const lang4 = Keyboard._(LogicalKeyboardKey.lang4);
  static const lang5 = Keyboard._(LogicalKeyboardKey.lang5);
  static const abort = Keyboard._(LogicalKeyboardKey.abort);
  static const props = Keyboard._(LogicalKeyboardKey.props);
  static const numpadParenLeft = Keyboard._(LogicalKeyboardKey.numpadParenLeft);
  static const numpadParenRight =
      Keyboard._(LogicalKeyboardKey.numpadParenRight);
  static const numpadBackspace = Keyboard._(LogicalKeyboardKey.numpadBackspace);
  static const numpadMemoryStore =
      Keyboard._(LogicalKeyboardKey.numpadMemoryStore);
  static const numpadMemoryRecall =
      Keyboard._(LogicalKeyboardKey.numpadMemoryRecall);
  static const numpadMemoryClear =
      Keyboard._(LogicalKeyboardKey.numpadMemoryClear);
  static const numpadMemoryAdd = Keyboard._(LogicalKeyboardKey.numpadMemoryAdd);
  static const numpadMemorySubtract =
      Keyboard._(LogicalKeyboardKey.numpadMemorySubtract);
  static const numpadSignChange =
      Keyboard._(LogicalKeyboardKey.numpadSignChange);
  static const numpadClear = Keyboard._(LogicalKeyboardKey.numpadClear);
  static const numpadClearEntry =
      Keyboard._(LogicalKeyboardKey.numpadClearEntry);
  static const controlLeft = Keyboard._(LogicalKeyboardKey.controlLeft);
  static const shiftLeft = Keyboard._(LogicalKeyboardKey.shiftLeft);
  static const altLeft = Keyboard._(LogicalKeyboardKey.altLeft);
  static const metaLeft = Keyboard._(LogicalKeyboardKey.metaLeft);
  static const controlRight = Keyboard._(LogicalKeyboardKey.controlRight);
  static const shiftRight = Keyboard._(LogicalKeyboardKey.shiftRight);
  static const altRight = Keyboard._(LogicalKeyboardKey.altRight);
  static const metaRight = Keyboard._(LogicalKeyboardKey.metaRight);
  static const info = Keyboard._(LogicalKeyboardKey.info);
  static const closedCaptionToggle =
      Keyboard._(LogicalKeyboardKey.closedCaptionToggle);
  static const brightnessUp = Keyboard._(LogicalKeyboardKey.brightnessUp);
  static const brightnessDown = Keyboard._(LogicalKeyboardKey.brightnessDown);
  static const brightnessToggle =
      Keyboard._(LogicalKeyboardKey.brightnessToggle);
  static const brightnessMinimum =
      Keyboard._(LogicalKeyboardKey.brightnessMinimum);
  static const brightnessMaximum =
      Keyboard._(LogicalKeyboardKey.brightnessMaximum);
  static const brightnessAuto = Keyboard._(LogicalKeyboardKey.brightnessAuto);
  static const kbdIllumUp = Keyboard._(LogicalKeyboardKey.kbdIllumUp);
  static const kbdIllumDown = Keyboard._(LogicalKeyboardKey.kbdIllumDown);
  static const mediaLast = Keyboard._(LogicalKeyboardKey.mediaLast);
  static const launchPhone = Keyboard._(LogicalKeyboardKey.launchPhone);
  static const programGuide = Keyboard._(LogicalKeyboardKey.programGuide);
  static const exit = Keyboard._(LogicalKeyboardKey.exit);
  static const channelUp = Keyboard._(LogicalKeyboardKey.channelUp);
  static const channelDown = Keyboard._(LogicalKeyboardKey.channelDown);
  static const mediaPlay = Keyboard._(LogicalKeyboardKey.mediaPlay);
  static const mediaPause = Keyboard._(LogicalKeyboardKey.mediaPause);
  static const mediaRecord = Keyboard._(LogicalKeyboardKey.mediaRecord);
  static const mediaFastForward =
      Keyboard._(LogicalKeyboardKey.mediaFastForward);
  static const mediaRewind = Keyboard._(LogicalKeyboardKey.mediaRewind);
  static const mediaTrackNext = Keyboard._(LogicalKeyboardKey.mediaTrackNext);
  static const mediaTrackPrevious =
      Keyboard._(LogicalKeyboardKey.mediaTrackPrevious);
  static const mediaStop = Keyboard._(LogicalKeyboardKey.mediaStop);
  static const eject = Keyboard._(LogicalKeyboardKey.eject);
  static const mediaPlayPause = Keyboard._(LogicalKeyboardKey.mediaPlayPause);
  static const speechInputToggle =
      Keyboard._(LogicalKeyboardKey.speechInputToggle);
  static const bassBoost = Keyboard._(LogicalKeyboardKey.bassBoost);
  static const mediaSelect = Keyboard._(LogicalKeyboardKey.mediaSelect);
  static const launchWordProcessor =
      Keyboard._(LogicalKeyboardKey.launchWordProcessor);
  static const launchSpreadsheet =
      Keyboard._(LogicalKeyboardKey.launchSpreadsheet);
  static const launchMail = Keyboard._(LogicalKeyboardKey.launchMail);
  static const launchContacts = Keyboard._(LogicalKeyboardKey.launchContacts);
  static const launchCalendar = Keyboard._(LogicalKeyboardKey.launchCalendar);
  static const launchApp2 = Keyboard._(LogicalKeyboardKey.launchApp2);
  static const launchApp1 = Keyboard._(LogicalKeyboardKey.launchApp1);
  static const launchInternetBrowser =
      Keyboard._(LogicalKeyboardKey.launchInternetBrowser);
  static const logOff = Keyboard._(LogicalKeyboardKey.logOff);
  static const lockScreen = Keyboard._(LogicalKeyboardKey.lockScreen);
  static const launchControlPanel =
      Keyboard._(LogicalKeyboardKey.launchControlPanel);
  static const selectTask = Keyboard._(LogicalKeyboardKey.selectTask);
  static const launchDocuments = Keyboard._(LogicalKeyboardKey.launchDocuments);
  static const spellCheck = Keyboard._(LogicalKeyboardKey.spellCheck);
  static const launchKeyboardLayout =
      Keyboard._(LogicalKeyboardKey.launchKeyboardLayout);
  static const launchScreenSaver =
      Keyboard._(LogicalKeyboardKey.launchScreenSaver);
  static const launchAssistant = Keyboard._(LogicalKeyboardKey.launchAssistant);
  static const launchAudioBrowser =
      Keyboard._(LogicalKeyboardKey.launchAudioBrowser);
  static const newKey = Keyboard._(LogicalKeyboardKey.newKey);
  static const close = Keyboard._(LogicalKeyboardKey.close);
  static const save = Keyboard._(LogicalKeyboardKey.save);
  static const print = Keyboard._(LogicalKeyboardKey.print);
  static const browserSearch = Keyboard._(LogicalKeyboardKey.browserSearch);
  static const browserHome = Keyboard._(LogicalKeyboardKey.browserHome);
  static const browserBack = Keyboard._(LogicalKeyboardKey.browserBack);
  static const browserForward = Keyboard._(LogicalKeyboardKey.browserForward);
  static const browserStop = Keyboard._(LogicalKeyboardKey.browserStop);
  static const browserRefresh = Keyboard._(LogicalKeyboardKey.browserRefresh);
  static const browserFavorites =
      Keyboard._(LogicalKeyboardKey.browserFavorites);
  static const zoomIn = Keyboard._(LogicalKeyboardKey.zoomIn);
  static const zoomOut = Keyboard._(LogicalKeyboardKey.zoomOut);
  static const zoomToggle = Keyboard._(LogicalKeyboardKey.zoomToggle);
  static const redo = Keyboard._(LogicalKeyboardKey.redo);
  static const mailReply = Keyboard._(LogicalKeyboardKey.mailReply);
  static const mailForward = Keyboard._(LogicalKeyboardKey.mailForward);
  static const mailSend = Keyboard._(LogicalKeyboardKey.mailSend);
  static const keyboardLayoutSelect =
      Keyboard._(LogicalKeyboardKey.keyboardLayoutSelect);
  static const showAllWindows = Keyboard._(LogicalKeyboardKey.showAllWindows);
  static const gameButton1 = Keyboard._(LogicalKeyboardKey.gameButton1);
  static const gameButton2 = Keyboard._(LogicalKeyboardKey.gameButton2);
  static const gameButton3 = Keyboard._(LogicalKeyboardKey.gameButton3);
  static const gameButton4 = Keyboard._(LogicalKeyboardKey.gameButton4);
  static const gameButton5 = Keyboard._(LogicalKeyboardKey.gameButton5);
  static const gameButton6 = Keyboard._(LogicalKeyboardKey.gameButton6);
  static const gameButton7 = Keyboard._(LogicalKeyboardKey.gameButton7);
  static const gameButton8 = Keyboard._(LogicalKeyboardKey.gameButton8);
  static const gameButton9 = Keyboard._(LogicalKeyboardKey.gameButton9);
  static const gameButton10 = Keyboard._(LogicalKeyboardKey.gameButton10);
  static const gameButton11 = Keyboard._(LogicalKeyboardKey.gameButton11);
  static const gameButton12 = Keyboard._(LogicalKeyboardKey.gameButton12);
  static const gameButton13 = Keyboard._(LogicalKeyboardKey.gameButton13);
  static const gameButton14 = Keyboard._(LogicalKeyboardKey.gameButton14);
  static const gameButton15 = Keyboard._(LogicalKeyboardKey.gameButton15);
  static const gameButton16 = Keyboard._(LogicalKeyboardKey.gameButton16);
  static const gameButtonA = Keyboard._(LogicalKeyboardKey.gameButtonA);
  static const gameButtonB = Keyboard._(LogicalKeyboardKey.gameButtonB);
  static const gameButtonC = Keyboard._(LogicalKeyboardKey.gameButtonC);
  static const gameButtonLeft1 = Keyboard._(LogicalKeyboardKey.gameButtonLeft1);
  static const gameButtonLeft2 = Keyboard._(LogicalKeyboardKey.gameButtonLeft2);
  static const gameButtonMode = Keyboard._(LogicalKeyboardKey.gameButtonMode);
  static const gameButtonRight1 =
      Keyboard._(LogicalKeyboardKey.gameButtonRight1);
  static const gameButtonRight2 =
      Keyboard._(LogicalKeyboardKey.gameButtonRight2);
  static const gameButtonSelect =
      Keyboard._(LogicalKeyboardKey.gameButtonSelect);
  static const gameButtonStart = Keyboard._(LogicalKeyboardKey.gameButtonStart);
  static const gameButtonThumbLeft =
      Keyboard._(LogicalKeyboardKey.gameButtonThumbLeft);
  static const gameButtonThumbRight =
      Keyboard._(LogicalKeyboardKey.gameButtonThumbRight);
  static const gameButtonX = Keyboard._(LogicalKeyboardKey.gameButtonX);
  static const gameButtonY = Keyboard._(LogicalKeyboardKey.gameButtonY);
  static const gameButtonZ = Keyboard._(LogicalKeyboardKey.gameButtonZ);
  static const fn = Keyboard._(LogicalKeyboardKey.fn);
  static const shift = Keyboard._(LogicalKeyboardKey.shift);
  static const meta = Keyboard._(LogicalKeyboardKey.meta);
  static const alt = Keyboard._(LogicalKeyboardKey.alt);
  static const control = Keyboard._(LogicalKeyboardKey.control);

  static final Map<LogicalKeyboardKey, bool> _justReleased = {};
  static final Map<LogicalKeyboardKey, bool> _pressed = {};
  static final Map<Keyboard, bool Function()> _metaKeys = {
    shift: () => isDown(shiftLeft) || isDown(shiftRight),
    meta: () => isDown(metaLeft) || isDown(metaRight),
    control: () => isDown(controlLeft) || isDown(controlRight),
    alt: () => isDown(altLeft) || isDown(altRight),
  };

  static Stage _stage;

  static bool justReleased(Keyboard key) {
    return _justReleased[key] != null;
  }

  static bool isDown(Keyboard key) {
    if (_metaKeys.containsKey(key)) {
      return _metaKeys[key]();
    }
    return _pressed[key.value] ?? false;
  }

  /// Initializer of the Keyboard utility class.
  static void init(Stage stage) {
    _stage = stage;
    _stage.keyboard.onDown.add(_onKey);
    _stage.keyboard.onUp.add(_onKey);
  }

  static void dispose() {
    _stage?.keyboard?.onDown?.remove(_onKey);
    _stage?.keyboard?.onUp?.remove(_onKey);
  }

  static void _onKey(KeyboardEventData input) {
    final k = input.rawEvent.logicalKey;
    if (input.type == KeyEventType.down) {
      _pressed[k] = true;
    } else {
      _justReleased[k] = true;
      _pressed.remove(k);
    }
  }
}
