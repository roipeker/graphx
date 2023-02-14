// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model.dart';
import 'router.dart';
import 'utils/utils.dart';

void main() {
  // doesn't work with surge.sh
  // usePathUrlStrategy();
  runApp(
    MaterialApp.router(
      title: 'GraphX Gallery',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xff241e30),
        appBarTheme: const AppBarTheme(color: Color(0xff241e30), elevation: 0),
      ),
      // home: const Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Color menuColor = const Color.fromARGB(255, 255, 255, 255);
    Color backgroundColor = const Color.fromARGB(255, 180, 180, 220);
    Color logoColor = const Color.fromARGB(255, 108, 103, 255);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: menuColor,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/graphx_logo.svg',
          height: 20,
        ),
        actions: [
          _GitLink(
            uri: Uri.parse('https://github.com/roipeker/graphx'),
            color: logoColor,
          ),
          _DartLink(
            uri: Uri.parse('https://pub.dev/packages/graphx'),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Container(
        color: backgroundColor,
        child: _gridView(),
        // child: _listView(),
      ),
    );
  }

  // GridView

  Widget _gridView() {
    double gridHorizontalInset = 16;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: gridHorizontalInset,
      ),
      itemCount: demos.length,
      itemBuilder: (context, index) {
        return _demoCard(context, demos[index]);
      },
    );
  }

  Widget _demoCard(
    BuildContext context,
    Scene demo,
  ) {
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
            launchUrl(demo.url);
            return;
          } else if (demo is SampleScene) {
            GoRouter.of(context).push(demo.path);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image
            if (demo.hash != null && kIsWeb)
              BlurHash(
                hash: demo.hash!,
                image: demo.thumbnail,
                duration: const Duration(milliseconds: 700),
                imageFit: BoxFit.cover,
              ),

            if (!kIsWeb)
              Image.asset(
                demo.thumbnail,
                fit: BoxFit.cover,
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
                child: _GitLink(
                  uri: demo.sourceUri!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ListView

  Widget _listView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        padding: const EdgeInsets.all(8),
        itemCount: demos.length,
        itemBuilder: (context, index) {
          return _demoCell(context, demos[index]);
        },
      ),
    );
  }

  Widget _demoCell(
    BuildContext context,
    Scene demo,
  ) {
    return Material(
      color: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        minVerticalPadding: 24,
        leading: demo.thumbnail.isNotEmpty == true
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  demo.thumbnail,
                  width: 128.0,
                  height: 508.0,
                  fit: BoxFit.cover,
                ),
              )
            : null,
        title: Text(
          demo.title.toUpperCase(),
          style: const TextStyle(
            color: Color.fromARGB(255, 127, 127, 127),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: demo is ExternalScene ? Text(demo.url.toString()) : null,
        onTap: () {
          if (demo is ExternalScene) {
            launchUrl(demo.url);
            return;
          }
          if (demo is SampleScene) {
            GoRouter.of(context).push(demo.path);
          }

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return Demo(
          //         text: demo.title,
          //         child: demo.build() as Widget,
          //       );
          //     },
          //   ),
          // );
        },
      ),
    );
  }
}

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
          title: Text(widget.text),
          elevation: 0,
        ),
        body: ClipRect(
          child: Center(
            child: Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

class _DartLink extends StatelessWidget {
  final Uri uri;
  final String tooltip;

  const _DartLink({super.key, required this.uri, this.tooltip = 'Dart package'});

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

class _GitLink extends StatelessWidget {
  final Uri uri;
  final Color color;
  final String tooltip;

  const _GitLink({super.key, required this.uri, this.color = Colors.white, this.tooltip = 'Source code'});

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
