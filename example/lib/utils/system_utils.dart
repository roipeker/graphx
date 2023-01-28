import 'package:graphx/graphx.dart';

final isSkia = SystemUtils.usingSkia;
final isDesktop = (defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows);
final isWebDesktop = kIsWeb && isDesktop;

final isWebMobile = kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
