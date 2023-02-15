// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_svg/flutter_svg.dart';

import 'model.dart';
import 'router.dart';
import 'utils/utils.dart';
import 'widgets.dart';

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
    double gridHorizontalInset = 16;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: menuColor,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/graphx_logo.svg',
          height: 20,
        ),
        actions: [
          GitLink(
            uri: Uri.parse('https://github.com/roipeker/graphx'),
            color: logoColor,
          ),
          DartLink(
            uri: Uri.parse('https://pub.dev/packages/graphx'),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding:
            EdgeInsets.symmetric(vertical: 8, horizontal: gridHorizontalInset),
        itemCount: demos.length,
        itemBuilder: (context, index) => GridItemCard(demo: demos[index]),
      ),
    );
  }
}
