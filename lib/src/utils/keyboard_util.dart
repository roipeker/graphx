import 'package:flutter/services.dart';

import '../../graphx.dart';

/// Utility class to work easily with keyboard events.
class GKeyboard {
  final LogicalKeyboardKey value;

  const GKeyboard._(this.value);

  static const up = GKeyboard._(LogicalKeyboardKey.arrowUp);
  static const left = GKeyboard._(LogicalKeyboardKey.arrowLeft);
  static const right = GKeyboard._(LogicalKeyboardKey.arrowRight);
  static const down = GKeyboard._(LogicalKeyboardKey.arrowDown);

  static const none = GKeyboard._(LogicalKeyboardKey.none);
  static const hyper = GKeyboard._(LogicalKeyboardKey.hyper);
  static const superKey = GKeyboard._(LogicalKeyboardKey.superKey);
  static const fnLock = GKeyboard._(LogicalKeyboardKey.fnLock);
  static const suspend = GKeyboard._(LogicalKeyboardKey.suspend);
  static const resume = GKeyboard._(LogicalKeyboardKey.resume);
  static const turbo = GKeyboard._(LogicalKeyboardKey.turbo);
  static const privacyScreenToggle =
      GKeyboard._(LogicalKeyboardKey.privacyScreenToggle);
  static const sleep = GKeyboard._(LogicalKeyboardKey.sleep);
  static const wakeUp = GKeyboard._(LogicalKeyboardKey.wakeUp);
  static const displayToggleIntExt =
      GKeyboard._(LogicalKeyboardKey.displayToggleIntExt);
  static const usbReserved = GKeyboard._(LogicalKeyboardKey.usbReserved);
  static const usbErrorRollOver =
      GKeyboard._(LogicalKeyboardKey.usbErrorRollOver);
  static const usbPostFail = GKeyboard._(LogicalKeyboardKey.usbPostFail);
  static const usbErrorUndefined =
      GKeyboard._(LogicalKeyboardKey.usbErrorUndefined);
  static const keyA = GKeyboard._(LogicalKeyboardKey.keyA);
  static const keyB = GKeyboard._(LogicalKeyboardKey.keyB);
  static const keyC = GKeyboard._(LogicalKeyboardKey.keyC);
  static const keyD = GKeyboard._(LogicalKeyboardKey.keyD);
  static const keyE = GKeyboard._(LogicalKeyboardKey.keyE);
  static const keyF = GKeyboard._(LogicalKeyboardKey.keyF);
  static const keyG = GKeyboard._(LogicalKeyboardKey.keyG);
  static const keyH = GKeyboard._(LogicalKeyboardKey.keyH);
  static const keyI = GKeyboard._(LogicalKeyboardKey.keyI);
  static const keyJ = GKeyboard._(LogicalKeyboardKey.keyJ);
  static const keyK = GKeyboard._(LogicalKeyboardKey.keyK);
  static const keyL = GKeyboard._(LogicalKeyboardKey.keyL);
  static const keyM = GKeyboard._(LogicalKeyboardKey.keyM);
  static const keyN = GKeyboard._(LogicalKeyboardKey.keyN);
  static const keyO = GKeyboard._(LogicalKeyboardKey.keyO);
  static const keyP = GKeyboard._(LogicalKeyboardKey.keyP);
  static const keyQ = GKeyboard._(LogicalKeyboardKey.keyQ);
  static const keyR = GKeyboard._(LogicalKeyboardKey.keyR);
  static const keyS = GKeyboard._(LogicalKeyboardKey.keyS);
  static const keyT = GKeyboard._(LogicalKeyboardKey.keyT);
  static const keyU = GKeyboard._(LogicalKeyboardKey.keyU);
  static const keyV = GKeyboard._(LogicalKeyboardKey.keyV);
  static const keyW = GKeyboard._(LogicalKeyboardKey.keyW);
  static const keyX = GKeyboard._(LogicalKeyboardKey.keyX);
  static const keyY = GKeyboard._(LogicalKeyboardKey.keyY);
  static const keyZ = GKeyboard._(LogicalKeyboardKey.keyZ);
  static const digit1 = GKeyboard._(LogicalKeyboardKey.digit1);
  static const digit2 = GKeyboard._(LogicalKeyboardKey.digit2);
  static const digit3 = GKeyboard._(LogicalKeyboardKey.digit3);
  static const digit4 = GKeyboard._(LogicalKeyboardKey.digit4);
  static const digit5 = GKeyboard._(LogicalKeyboardKey.digit5);
  static const digit6 = GKeyboard._(LogicalKeyboardKey.digit6);
  static const digit7 = GKeyboard._(LogicalKeyboardKey.digit7);
  static const digit8 = GKeyboard._(LogicalKeyboardKey.digit8);
  static const digit9 = GKeyboard._(LogicalKeyboardKey.digit9);
  static const digit0 = GKeyboard._(LogicalKeyboardKey.digit0);
  static const enter = GKeyboard._(LogicalKeyboardKey.enter);
  static const escape = GKeyboard._(LogicalKeyboardKey.escape);
  static const backspace = GKeyboard._(LogicalKeyboardKey.backspace);
  static const tab = GKeyboard._(LogicalKeyboardKey.tab);
  static const space = GKeyboard._(LogicalKeyboardKey.space);
  static const minus = GKeyboard._(LogicalKeyboardKey.minus);
  static const equal = GKeyboard._(LogicalKeyboardKey.equal);
  static const bracketLeft = GKeyboard._(LogicalKeyboardKey.bracketLeft);
  static const bracketRight = GKeyboard._(LogicalKeyboardKey.bracketRight);
  static const backslash = GKeyboard._(LogicalKeyboardKey.backslash);
  static const semicolon = GKeyboard._(LogicalKeyboardKey.semicolon);
  static const quote = GKeyboard._(LogicalKeyboardKey.quote);
  static const backquote = GKeyboard._(LogicalKeyboardKey.backquote);
  static const comma = GKeyboard._(LogicalKeyboardKey.comma);
  static const period = GKeyboard._(LogicalKeyboardKey.period);
  static const slash = GKeyboard._(LogicalKeyboardKey.slash);
  static const capsLock = GKeyboard._(LogicalKeyboardKey.capsLock);
  static const f1 = GKeyboard._(LogicalKeyboardKey.f1);
  static const f2 = GKeyboard._(LogicalKeyboardKey.f2);
  static const f3 = GKeyboard._(LogicalKeyboardKey.f3);
  static const f4 = GKeyboard._(LogicalKeyboardKey.f4);
  static const f5 = GKeyboard._(LogicalKeyboardKey.f5);
  static const f6 = GKeyboard._(LogicalKeyboardKey.f6);
  static const f7 = GKeyboard._(LogicalKeyboardKey.f7);
  static const f8 = GKeyboard._(LogicalKeyboardKey.f8);
  static const f9 = GKeyboard._(LogicalKeyboardKey.f9);
  static const f10 = GKeyboard._(LogicalKeyboardKey.f10);
  static const f11 = GKeyboard._(LogicalKeyboardKey.f11);
  static const f12 = GKeyboard._(LogicalKeyboardKey.f12);
  static const printScreen = GKeyboard._(LogicalKeyboardKey.printScreen);
  static const scrollLock = GKeyboard._(LogicalKeyboardKey.scrollLock);
  static const pause = GKeyboard._(LogicalKeyboardKey.pause);
  static const insert = GKeyboard._(LogicalKeyboardKey.insert);
  static const home = GKeyboard._(LogicalKeyboardKey.home);
  static const pageUp = GKeyboard._(LogicalKeyboardKey.pageUp);
  static const delete = GKeyboard._(LogicalKeyboardKey.delete);
  static const end = GKeyboard._(LogicalKeyboardKey.end);
  static const pageDown = GKeyboard._(LogicalKeyboardKey.pageDown);
  static const arrowRight = GKeyboard._(LogicalKeyboardKey.arrowRight);
  static const arrowLeft = GKeyboard._(LogicalKeyboardKey.arrowLeft);
  static const arrowDown = GKeyboard._(LogicalKeyboardKey.arrowDown);
  static const arrowUp = GKeyboard._(LogicalKeyboardKey.arrowUp);
  static const numLock = GKeyboard._(LogicalKeyboardKey.numLock);
  static const numpadDivide = GKeyboard._(LogicalKeyboardKey.numpadDivide);
  static const numpadMultiply = GKeyboard._(LogicalKeyboardKey.numpadMultiply);
  static const numpadSubtract = GKeyboard._(LogicalKeyboardKey.numpadSubtract);
  static const numpadAdd = GKeyboard._(LogicalKeyboardKey.numpadAdd);
  static const numpadEnter = GKeyboard._(LogicalKeyboardKey.numpadEnter);
  static const numpad1 = GKeyboard._(LogicalKeyboardKey.numpad1);
  static const numpad2 = GKeyboard._(LogicalKeyboardKey.numpad2);
  static const numpad3 = GKeyboard._(LogicalKeyboardKey.numpad3);
  static const numpad4 = GKeyboard._(LogicalKeyboardKey.numpad4);
  static const numpad5 = GKeyboard._(LogicalKeyboardKey.numpad5);
  static const numpad6 = GKeyboard._(LogicalKeyboardKey.numpad6);
  static const numpad7 = GKeyboard._(LogicalKeyboardKey.numpad7);
  static const numpad8 = GKeyboard._(LogicalKeyboardKey.numpad8);
  static const numpad9 = GKeyboard._(LogicalKeyboardKey.numpad9);
  static const numpad0 = GKeyboard._(LogicalKeyboardKey.numpad0);
  static const numpadDecimal = GKeyboard._(LogicalKeyboardKey.numpadDecimal);
  static const intlBackslash = GKeyboard._(LogicalKeyboardKey.intlBackslash);
  static const contextMenu = GKeyboard._(LogicalKeyboardKey.contextMenu);
  static const power = GKeyboard._(LogicalKeyboardKey.power);
  static const numpadEqual = GKeyboard._(LogicalKeyboardKey.numpadEqual);
  static const f13 = GKeyboard._(LogicalKeyboardKey.f13);
  static const f14 = GKeyboard._(LogicalKeyboardKey.f14);
  static const f15 = GKeyboard._(LogicalKeyboardKey.f15);
  static const f16 = GKeyboard._(LogicalKeyboardKey.f16);
  static const f17 = GKeyboard._(LogicalKeyboardKey.f17);
  static const f18 = GKeyboard._(LogicalKeyboardKey.f18);
  static const f19 = GKeyboard._(LogicalKeyboardKey.f19);
  static const f20 = GKeyboard._(LogicalKeyboardKey.f20);
  static const f21 = GKeyboard._(LogicalKeyboardKey.f21);
  static const f22 = GKeyboard._(LogicalKeyboardKey.f22);
  static const f23 = GKeyboard._(LogicalKeyboardKey.f23);
  static const f24 = GKeyboard._(LogicalKeyboardKey.f24);
  static const open = GKeyboard._(LogicalKeyboardKey.open);
  static const help = GKeyboard._(LogicalKeyboardKey.help);
  static const select = GKeyboard._(LogicalKeyboardKey.select);
  static const again = GKeyboard._(LogicalKeyboardKey.again);
  static const undo = GKeyboard._(LogicalKeyboardKey.undo);
  static const cut = GKeyboard._(LogicalKeyboardKey.cut);
  static const copy = GKeyboard._(LogicalKeyboardKey.copy);
  static const paste = GKeyboard._(LogicalKeyboardKey.paste);
  static const find = GKeyboard._(LogicalKeyboardKey.find);
  static const audioVolumeMute = GKeyboard._(LogicalKeyboardKey.audioVolumeMute);
  static const audioVolumeUp = GKeyboard._(LogicalKeyboardKey.audioVolumeUp);
  static const audioVolumeDown = GKeyboard._(LogicalKeyboardKey.audioVolumeDown);
  static const numpadComma = GKeyboard._(LogicalKeyboardKey.numpadComma);
  static const intlRo = GKeyboard._(LogicalKeyboardKey.intlRo);
  static const kanaMode = GKeyboard._(LogicalKeyboardKey.kanaMode);
  static const intlYen = GKeyboard._(LogicalKeyboardKey.intlYen);
  static const convert = GKeyboard._(LogicalKeyboardKey.convert);
  static const nonConvert = GKeyboard._(LogicalKeyboardKey.nonConvert);
  static const lang1 = GKeyboard._(LogicalKeyboardKey.lang1);
  static const lang2 = GKeyboard._(LogicalKeyboardKey.lang2);
  static const lang3 = GKeyboard._(LogicalKeyboardKey.lang3);
  static const lang4 = GKeyboard._(LogicalKeyboardKey.lang4);
  static const lang5 = GKeyboard._(LogicalKeyboardKey.lang5);
  static const abort = GKeyboard._(LogicalKeyboardKey.abort);
  static const props = GKeyboard._(LogicalKeyboardKey.props);
  static const numpadParenLeft = GKeyboard._(LogicalKeyboardKey.numpadParenLeft);
  static const numpadParenRight =
      GKeyboard._(LogicalKeyboardKey.numpadParenRight);
  static const numpadBackspace = GKeyboard._(LogicalKeyboardKey.numpadBackspace);
  static const numpadMemoryStore =
      GKeyboard._(LogicalKeyboardKey.numpadMemoryStore);
  static const numpadMemoryRecall =
      GKeyboard._(LogicalKeyboardKey.numpadMemoryRecall);
  static const numpadMemoryClear =
      GKeyboard._(LogicalKeyboardKey.numpadMemoryClear);
  static const numpadMemoryAdd = GKeyboard._(LogicalKeyboardKey.numpadMemoryAdd);
  static const numpadMemorySubtract =
      GKeyboard._(LogicalKeyboardKey.numpadMemorySubtract);
  static const numpadSignChange =
      GKeyboard._(LogicalKeyboardKey.numpadSignChange);
  static const numpadClear = GKeyboard._(LogicalKeyboardKey.numpadClear);
  static const numpadClearEntry =
      GKeyboard._(LogicalKeyboardKey.numpadClearEntry);
  static const controlLeft = GKeyboard._(LogicalKeyboardKey.controlLeft);
  static const shiftLeft = GKeyboard._(LogicalKeyboardKey.shiftLeft);
  static const altLeft = GKeyboard._(LogicalKeyboardKey.altLeft);
  static const metaLeft = GKeyboard._(LogicalKeyboardKey.metaLeft);
  static const controlRight = GKeyboard._(LogicalKeyboardKey.controlRight);
  static const shiftRight = GKeyboard._(LogicalKeyboardKey.shiftRight);
  static const altRight = GKeyboard._(LogicalKeyboardKey.altRight);
  static const metaRight = GKeyboard._(LogicalKeyboardKey.metaRight);
  static const info = GKeyboard._(LogicalKeyboardKey.info);
  static const closedCaptionToggle =
      GKeyboard._(LogicalKeyboardKey.closedCaptionToggle);
  static const brightnessUp = GKeyboard._(LogicalKeyboardKey.brightnessUp);
  static const brightnessDown = GKeyboard._(LogicalKeyboardKey.brightnessDown);
  static const brightnessToggle =
      GKeyboard._(LogicalKeyboardKey.brightnessToggle);
  static const brightnessMinimum =
      GKeyboard._(LogicalKeyboardKey.brightnessMinimum);
  static const brightnessMaximum =
      GKeyboard._(LogicalKeyboardKey.brightnessMaximum);
  static const brightnessAuto = GKeyboard._(LogicalKeyboardKey.brightnessAuto);
  static const kbdIllumUp = GKeyboard._(LogicalKeyboardKey.kbdIllumUp);
  static const kbdIllumDown = GKeyboard._(LogicalKeyboardKey.kbdIllumDown);
  static const mediaLast = GKeyboard._(LogicalKeyboardKey.mediaLast);
  static const launchPhone = GKeyboard._(LogicalKeyboardKey.launchPhone);
  static const programGuide = GKeyboard._(LogicalKeyboardKey.programGuide);
  static const exit = GKeyboard._(LogicalKeyboardKey.exit);
  static const channelUp = GKeyboard._(LogicalKeyboardKey.channelUp);
  static const channelDown = GKeyboard._(LogicalKeyboardKey.channelDown);
  static const mediaPlay = GKeyboard._(LogicalKeyboardKey.mediaPlay);
  static const mediaPause = GKeyboard._(LogicalKeyboardKey.mediaPause);
  static const mediaRecord = GKeyboard._(LogicalKeyboardKey.mediaRecord);
  static const mediaFastForward =
      GKeyboard._(LogicalKeyboardKey.mediaFastForward);
  static const mediaRewind = GKeyboard._(LogicalKeyboardKey.mediaRewind);
  static const mediaTrackNext = GKeyboard._(LogicalKeyboardKey.mediaTrackNext);
  static const mediaTrackPrevious =
      GKeyboard._(LogicalKeyboardKey.mediaTrackPrevious);
  static const mediaStop = GKeyboard._(LogicalKeyboardKey.mediaStop);
  static const eject = GKeyboard._(LogicalKeyboardKey.eject);
  static const mediaPlayPause = GKeyboard._(LogicalKeyboardKey.mediaPlayPause);
  static const speechInputToggle =
      GKeyboard._(LogicalKeyboardKey.speechInputToggle);
  static const bassBoost = GKeyboard._(LogicalKeyboardKey.bassBoost);
  static const mediaSelect = GKeyboard._(LogicalKeyboardKey.mediaSelect);
  static const launchWordProcessor =
      GKeyboard._(LogicalKeyboardKey.launchWordProcessor);
  static const launchSpreadsheet =
      GKeyboard._(LogicalKeyboardKey.launchSpreadsheet);
  static const launchMail = GKeyboard._(LogicalKeyboardKey.launchMail);
  static const launchContacts = GKeyboard._(LogicalKeyboardKey.launchContacts);
  static const launchCalendar = GKeyboard._(LogicalKeyboardKey.launchCalendar);
  static const launchApp2 = GKeyboard._(LogicalKeyboardKey.launchApp2);
  static const launchApp1 = GKeyboard._(LogicalKeyboardKey.launchApp1);
  static const launchInternetBrowser =
      GKeyboard._(LogicalKeyboardKey.launchInternetBrowser);
  static const logOff = GKeyboard._(LogicalKeyboardKey.logOff);
  static const lockScreen = GKeyboard._(LogicalKeyboardKey.lockScreen);
  static const launchControlPanel =
      GKeyboard._(LogicalKeyboardKey.launchControlPanel);
  static const selectTask = GKeyboard._(LogicalKeyboardKey.selectTask);
  static const launchDocuments = GKeyboard._(LogicalKeyboardKey.launchDocuments);
  static const spellCheck = GKeyboard._(LogicalKeyboardKey.spellCheck);
  static const launchKeyboardLayout =
      GKeyboard._(LogicalKeyboardKey.launchKeyboardLayout);
  static const launchScreenSaver =
      GKeyboard._(LogicalKeyboardKey.launchScreenSaver);
  static const launchAssistant = GKeyboard._(LogicalKeyboardKey.launchAssistant);
  static const launchAudioBrowser =
      GKeyboard._(LogicalKeyboardKey.launchAudioBrowser);
  static const newKey = GKeyboard._(LogicalKeyboardKey.newKey);
  static const close = GKeyboard._(LogicalKeyboardKey.close);
  static const save = GKeyboard._(LogicalKeyboardKey.save);
  static const print = GKeyboard._(LogicalKeyboardKey.print);
  static const browserSearch = GKeyboard._(LogicalKeyboardKey.browserSearch);
  static const browserHome = GKeyboard._(LogicalKeyboardKey.browserHome);
  static const browserBack = GKeyboard._(LogicalKeyboardKey.browserBack);
  static const browserForward = GKeyboard._(LogicalKeyboardKey.browserForward);
  static const browserStop = GKeyboard._(LogicalKeyboardKey.browserStop);
  static const browserRefresh = GKeyboard._(LogicalKeyboardKey.browserRefresh);
  static const browserFavorites =
      GKeyboard._(LogicalKeyboardKey.browserFavorites);
  static const zoomIn = GKeyboard._(LogicalKeyboardKey.zoomIn);
  static const zoomOut = GKeyboard._(LogicalKeyboardKey.zoomOut);
  static const zoomToggle = GKeyboard._(LogicalKeyboardKey.zoomToggle);
  static const redo = GKeyboard._(LogicalKeyboardKey.redo);
  static const mailReply = GKeyboard._(LogicalKeyboardKey.mailReply);
  static const mailForward = GKeyboard._(LogicalKeyboardKey.mailForward);
  static const mailSend = GKeyboard._(LogicalKeyboardKey.mailSend);
  static const keyboardLayoutSelect =
      GKeyboard._(LogicalKeyboardKey.keyboardLayoutSelect);
  static const showAllWindows = GKeyboard._(LogicalKeyboardKey.showAllWindows);
  static const gameButton1 = GKeyboard._(LogicalKeyboardKey.gameButton1);
  static const gameButton2 = GKeyboard._(LogicalKeyboardKey.gameButton2);
  static const gameButton3 = GKeyboard._(LogicalKeyboardKey.gameButton3);
  static const gameButton4 = GKeyboard._(LogicalKeyboardKey.gameButton4);
  static const gameButton5 = GKeyboard._(LogicalKeyboardKey.gameButton5);
  static const gameButton6 = GKeyboard._(LogicalKeyboardKey.gameButton6);
  static const gameButton7 = GKeyboard._(LogicalKeyboardKey.gameButton7);
  static const gameButton8 = GKeyboard._(LogicalKeyboardKey.gameButton8);
  static const gameButton9 = GKeyboard._(LogicalKeyboardKey.gameButton9);
  static const gameButton10 = GKeyboard._(LogicalKeyboardKey.gameButton10);
  static const gameButton11 = GKeyboard._(LogicalKeyboardKey.gameButton11);
  static const gameButton12 = GKeyboard._(LogicalKeyboardKey.gameButton12);
  static const gameButton13 = GKeyboard._(LogicalKeyboardKey.gameButton13);
  static const gameButton14 = GKeyboard._(LogicalKeyboardKey.gameButton14);
  static const gameButton15 = GKeyboard._(LogicalKeyboardKey.gameButton15);
  static const gameButton16 = GKeyboard._(LogicalKeyboardKey.gameButton16);
  static const gameButtonA = GKeyboard._(LogicalKeyboardKey.gameButtonA);
  static const gameButtonB = GKeyboard._(LogicalKeyboardKey.gameButtonB);
  static const gameButtonC = GKeyboard._(LogicalKeyboardKey.gameButtonC);
  static const gameButtonLeft1 = GKeyboard._(LogicalKeyboardKey.gameButtonLeft1);
  static const gameButtonLeft2 = GKeyboard._(LogicalKeyboardKey.gameButtonLeft2);
  static const gameButtonMode = GKeyboard._(LogicalKeyboardKey.gameButtonMode);
  static const gameButtonRight1 =
      GKeyboard._(LogicalKeyboardKey.gameButtonRight1);
  static const gameButtonRight2 =
      GKeyboard._(LogicalKeyboardKey.gameButtonRight2);
  static const gameButtonSelect =
      GKeyboard._(LogicalKeyboardKey.gameButtonSelect);
  static const gameButtonStart = GKeyboard._(LogicalKeyboardKey.gameButtonStart);
  static const gameButtonThumbLeft =
      GKeyboard._(LogicalKeyboardKey.gameButtonThumbLeft);
  static const gameButtonThumbRight =
      GKeyboard._(LogicalKeyboardKey.gameButtonThumbRight);
  static const gameButtonX = GKeyboard._(LogicalKeyboardKey.gameButtonX);
  static const gameButtonY = GKeyboard._(LogicalKeyboardKey.gameButtonY);
  static const gameButtonZ = GKeyboard._(LogicalKeyboardKey.gameButtonZ);
  static const fn = GKeyboard._(LogicalKeyboardKey.fn);
  static const shift = GKeyboard._(LogicalKeyboardKey.shift);
  static const meta = GKeyboard._(LogicalKeyboardKey.meta);
  static const alt = GKeyboard._(LogicalKeyboardKey.alt);
  static const control = GKeyboard._(LogicalKeyboardKey.control);

  static final Map<LogicalKeyboardKey, bool> _justReleased = {};
  static final Map<LogicalKeyboardKey, bool> _pressed = {};
  static final Map<GKeyboard, bool Function()> _metaKeys = {
    shift: () => isDown(shiftLeft) || isDown(shiftRight),
    meta: () => isDown(metaLeft) || isDown(metaRight),
    control: () => isDown(controlLeft) || isDown(controlRight),
    alt: () => isDown(altLeft) || isDown(altRight),
  };

  static Stage _stage;

  static bool justReleased(GKeyboard key) {
    return _justReleased[key] != null;
  }

  static bool isDown(GKeyboard key) {
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
