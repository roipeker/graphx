import 'package:go_router/go_router.dart';

import 'main.dart';
import 'model.dart';

final appRouter = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const Home()),
  ...demos
      .whereType<SampleScene>()
      .map(
        (e) => GoRoute(
          path: e.path,
          name: e.title,
          builder: (context, state) => Demo(text: e.title, child: e.build()),
        ),
      )
      .toList(),
]);
