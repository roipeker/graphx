import 'package:just_audio/just_audio.dart';

class Player {
  Duration duration;

  Stream<Duration> positionStream;

  void init() async {
//    var duration = await player.setUrl('https://foo.com/bar.mp3');
//    var duration = await player.setAsset('path/to/asset.mp3');
  }

  AudioPlayer _player = AudioPlayer();

  stop() {
    _player.stop();
//    _player?.dispose();
  }

  Future<void> load() async {
    await _player?.dispose();
    _player = AudioPlayer();
    var url = '/Users/roi/Downloads/samples/pumpit.mp3';
//    var url = '/Users/roi/Downloads/samples/sharona.mp3';
//    var url = 'assets/sharona.mp3';
//    var url =
//        'https://roi-graphx-audio-wave.surge.sh/assets/assets/sharona.mp3';
//    var url = 'http://dev.roipeker.website/assets/sharona.mp3';

    _player.stop();
    duration = await _player.setFilePath(url);
//    duration = await _player.setAsset(url);
//    duration = await _player.setUrl(url);
//    print("Duration: $duration");
    _player.play();
//    await _player.seek(Duration(seconds: 10));
//
//    Stream<Duration> createPositionStream({
//      int steps = 800,
//      Duration minPeriod = const Duration(milliseconds: 200),
//      Duration maxPeriod = const Duration(milliseconds: 2a00),
//    }) {
//    duration.false50
    var steps = duration.inMilliseconds ~/ 100;
    positionStream = _player.createPositionStream(
      steps: steps,
      minPeriod: Duration(milliseconds: 100),
      maxPeriod: Duration(milliseconds: 100),
    );
//    stream.listen((event) {
//      print(event);
//    });
//    _player.positionStream.listen((event) {
//      print(event);
//    });
//    _player.playbackEventStream.listen((event) {
//      print(event);
//    });
//    _player.playerStateStream.listen((state) {
//      if (state.playing) {
//        print("State is:: ${state}");
//      }
//    });
//    var file = File(url);
//    print('file exists? ${file.exists()}');
  }
}
