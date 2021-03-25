import 'package:graphx/graphx.dart';

final posts = <PostVo>[];

const _randomNames = [
  'Maria Legrand',
  'Felipinho Ralston',
  'Honora Stacey',
  'Yannis Sipos',
  'Behrouz Cullen',
  'Yoni Sloan',
  'Meltem Woodrow',
  'Max Sciacca',
  'Fernanda Christensen',
  'Zeno Michaels',
  'Normand Leonardsen',
  'Elisabed Bond',
  'Ioel Winterbottom',
  'Cephalus Knežević',
  'Leyla Fenn',
  'Minakshi Magorian',
  'Masashi Núñez',
  'Jessa Brzezicki',
  'Stefanu Petrosyan',
  'Aqissiaq Winther',
];

void buildPostData() {
  var list = List.generate(80, (index) => PostVo.random());
  posts.addAll(list);
}

enum Gender { male, female, any }

class PostVo {
  final String username;
  final String title;
  final String profileImageUrl;
  final String imageUrl;
  final String time;

  int? numLikes, numComments;
  late String shares;

  PostVo._(
    this.username,
    this.title,
    this.profileImageUrl,
    this.imageUrl,
    this.time,
  );

  static PostVo random() {
    var vo =  PostVo._(
      randomName(),
      randomTitle(),
      randomProfilePic(),
      randomImage(),
      randomTime(),
    );
    vo.numLikes=Math.randomRangeInt(2, 40);
    vo.numComments=Math.randomRangeInt(1, 234);
    vo.shares= '${Math.randomRangeInt(2, 500)} Shares';
    return vo;
  }

  static String randomTime() {
    final times = ['seconds', 'minutes', 'hours', 'days'];
    var value = Math.randomRangeInt(1, 40);
    return '$value ${Math.randomList(times)} ago.';
  }

  static String randomImage() {
    var w = 800;
    var h = 600;
    // ignore: lines_longer_than_80_chars
    return '${'https://source.unsplash.com/random/$w'}x${'$h'}?c=${Math.random()}';
  }

  static String randomName() => Math.randomList(_randomNames);

  static String randomProfilePic({Gender gender = Gender.any}) {
    var index = gender.index;
    if (gender == Gender.any) index = Math.randomRangeInt(0, 1);
    var value = ['men', 'women'][index];
    var id = Math.randomRangeInt(1, 90);
    return 'https://randomuser.me/api/portraits/$value/$id.jpg';
  }

  static String randomTitle(){
    var numWords = Math.randomRangeInt(5, 20);
    var offset = Math.randomRangeInt(0, _kLoremWords.length-22);
    var phrase = _kLoremWords.sublist(offset, offset+numWords).join(' ');
    return phrase[0].toUpperCase() + phrase.substring(1);
  }
}

final _kLoremWords = '''
Nullam sapien orci, sollicitudin at nisl vel, dignissim molestie lorem. Vestibulum rutrum sit amet tortor in porta. Nam non vulputate orci. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam eget sagittis nulla. Nunc venenatis urna et risus rutrum consectetur. In vestibulum luctus accumsan. Aenean laoreet dolor vel felis hendrerit, id rutrum mi efficitur. Suspendisse eget iaculis turpis. Phasellus ac luctus magna, sed molestie orci. Nulla cursus nulla sed pharetra vehicula. Duis quis mollis tellus. Mauris turpis metus, cursus ac nisi ut, faucibus facilisis elit. Morbi porta ut lacus eu dapibus. Cras pulvinar nulla felis, eget sollicitudin nulla hendrerit eget.
Etiam nec malesuada dolor. Cras auctor malesuada lorem vitae mollis. Fusce odio ex, laoreet ut mollis eu, euismod ut risus. Praesent finibus lacinia vulputate. Morbi finibus neque ac enim vulputate facilisis. Nulla ac ipsum nec justo dignissim pharetra non id lacus. Phasellus ornare convallis tortor eu auctor. Nulla facilisi.
Morbi fringilla lacus nunc, at blandit odio eleifend sit amet. Suspendisse scelerisque bibendum hendrerit. Duis suscipit dictum massa, pharetra fermentum sapien placerat a. Integer gravida aliquam congue. Morbi maximus in mauris eu consequat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nullam pulvinar massa eget pellentesque feugiat. Mauris interdum, massa et consequat tempus, neque nibh convallis odio, et tempus lorem erat eu quam. Maecenas condimentum dapibus orci, quis ultricies velit. Phasellus laoreet mattis elit eu facilisis. In id blandit nisl. Mauris posuere tellus in lectus ornare varius.
Vivamus nulla risus, mattis quis rutrum et, iaculis ut felis. Mauris lobortis dui vel metus dictum, eu auctor purus ullamcorper. Sed neque nulla, faucibus sed consequat in, rutrum sed felis. Suspendisse ut ligula dignissim, laoreet tellus sit amet, molestie eros. Nullam turpis tortor, rhoncus a nisi et, ornare euismod leo. Aliquam dictum, sapien et ultrices facilisis, quam orci interdum arcu, quis sodales sapien mauris non nibh. Aenean rutrum erat mi, at egestas neque vulputate a. Maecenas vel sollicitudin ipsum. Suspendisse varius tortor neque, vitae laoreet purus vulputate ut. Nulla pulvinar accumsan rhoncus.
Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus et faucibus turpis. Duis maximus enim lacus, vitae commodo leo ultrices non. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis tristique quam in dolor rhoncus laoreet. Fusce malesuada sit amet augue non facilisis. Phasellus vitae molestie sapien. Duis egestas sem vitae vestibulum euismod. Nunc vulputate luctus ipsum, a aliquam eros maximus ac. Praesent sit amet luctus erat. Phasellus et eleifend ipsum, non placerat purus. Donec convallis a arcu eu aliquam. Nullam sagittis, diam ac porta sodales, purus dui aliquet nisl, nec lobortis mi ex id sapien. Pellentesque id faucibus purus, nec ultricies tortor.
'''.split(' ');
