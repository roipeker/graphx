import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:graphx/graphx.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model.dart';
import 'router.dart';

class Demo extends StatefulWidget {
  const Demo({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  void dispose() {
    SystemChrome.setApplicationSwitcherDescription(
      const ApplicationSwitcherDescription(label: 'GraphX Gallery'),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return child;
    return Title(
      title: 'GraphX Gallery | ${widget.text}',
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          leading: !appRouter.canPop()
              ? IconButton(
                  onPressed: () {
                    appRouter.go('/');
                  },
                  tooltip: 'Gallery Home',
                  icon: SvgPicture.asset(
                    'assets/gx_logo.svg',
                    height: 24,
                    semanticsLabel: 'GraphX Logo',
                    // color: Colors.white,
                  ),
                )
              : null,
          title: Text(widget.text),
          elevation: 0,
        ),
        body: ClipRect(
          child: Center(
            child: Navigator(
              onGenerateRoute: (settings) =>
                  MaterialPageRoute(builder: (context) => widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

class DartLink extends StatelessWidget {
  final Uri uri;
  final String tooltip;

  const DartLink({super.key, required this.uri, this.tooltip = 'Dart package'});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () {
        launchUrl(uri);
      },
      icon: SvgPicture.asset(
        'assets/dart_logo.svg',
        semanticsLabel: 'Dart logo',
      ),
    );
  }
}

class GitLink extends StatelessWidget {
  final Uri uri;
  final Color color;
  final String tooltip;

  const GitLink(
      {super.key,
      required this.uri,
      this.color = Colors.white,
      this.tooltip = 'Source code'});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () {
        launchUrl(uri);
      },
      icon: SvgPicture.asset(
        'assets/github_logo.svg',
        color: color,
        semanticsLabel: 'Github logo',
      ),
    );
  }
}

class Thumbnail extends StatelessWidget {
  final String assetId;
  final String? hash;

  const Thumbnail({
    super.key,
    required this.assetId,
    this.hash,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && hash != null) {
      return BlurHash(
        hash: hash!,
        image: assetId,
        duration: const Duration(milliseconds: 700),
        imageFit: BoxFit.cover,
      );
    }
    return Image.asset(
      assetId,
      fit: BoxFit.cover,
    );
  }
}

/// == GRID CARD ==
class GridItemCard extends StatelessWidget {
  final Scene demo;

  const GridItemCard({
    super.key,
    required this.demo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        // Rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        // Soft shadow
        shadows: [
          BoxShadow(
            color: Color.fromARGB(32, 0, 0, 0),
            blurRadius: 6,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (demo is ExternalScene) {
            launchUrl((demo as ExternalScene).url);
            return;
          } else if (demo is SampleScene) {
            GoRouter.of(context).push((demo as SampleScene).path);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image
            Thumbnail(
              assetId: demo.thumbnail,
              hash: demo.hash,
            ),

            // Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.5,
                    0.8,
                    1.0,
                  ],
                  colors: [
                    Color.fromARGB(32, 0, 0, 0),
                    Color.fromARGB(96, 0, 0, 0),
                    Color.fromARGB(192, 0, 0, 0),
                  ],
                ),
              ),
            ),
            // Text
            Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  demo.title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 231, 231, 231),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // External hint
            Visibility(
              visible: demo is ExternalScene,
              child: const Positioned(
                top: 4,
                right: 8,
                child: Icon(
                  Icons.link_sharp,
                  color: Colors.white,
                ),
              ),
            ),

            // github source link,
            if (demo.source != null)
              Positioned(
                top: -4,
                left: -4,
                child: GitLink(
                  uri: demo.sourceUri!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
