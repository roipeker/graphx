import 'dart:ui';

import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'model.dart';
import 'scene/menu_scene.dart';

const _kBlue = Color(0xff3578EA);

class FacebookReactionsMain extends StatelessWidget {
  FacebookReactionsMain() {
    if (posts.isEmpty) {
      buildPostData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        title: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 16,
            sigmaY: 16,
          ),
          child: Text(
            'Facebook Reactions (long press a photo!)',
            style: TextStyle(
              color: _kBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(.6),
        elevation: 0,
      ),
      backgroundColor: Color(0xffebebeb),
      body: SceneBuilderWidget(
        builder: () => SceneController(front: MenuScene()),
        child: Scrollbar(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 54, horizontal: 0),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) => InnerCardItem(data: posts[index]),
            itemCount: posts.length,
          ),
        ),
      ),
    );
  }
}

class InnerCardItem extends StatelessWidget {
  final PostVo? data;

  const InnerCardItem({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        highlightColor: kColorTransparent,
        splashColor: _kBlue.withOpacity(.2),
        hoverColor: _kBlue.withOpacity(.05),
        onLongPress: () {
          mps.emit1('showMenu', ContextUtils.getRenderObjectBounds(context));
        },
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.3),
                    radius: 24,

                    /// dev channel
                    // foregroundImage: NetworkImage(data.profileImageUrl),
                    child: Text(data!.username[0].toUpperCase()),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data!.username,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data!.time,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),

              Text(
                data!.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: .25,
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  data!.imageUrl,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  _IconReaction.likes(count: data!.numLikes),
                  const SizedBox(width: 12),
                  _IconReaction.comments(count: data!.numComments),
                  Spacer(),
                  Text(
                    data!.shares,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Text('asdfasdfsdf'),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconReaction extends StatelessWidget {
  final IconData? iconData;
  final Color color;
  final int? count;

  const _IconReaction({
    Key? key,
    this.iconData,
    this.color = Colors.black,
    this.count,
  }) : super(key: key);

  _IconReaction.likes({this.count})
      : iconData = Icons.favorite,
        color = const Color(0xffDB615C);

  _IconReaction.comments({this.count})
      : iconData = Icons.chat_bubble,
        color = const Color(0xff5B46F4);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 2),
        Text(
          '${count ?? 0}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            height: .9,
          ),
        )
      ],
    );
  }
}
