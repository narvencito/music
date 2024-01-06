// ignore_for_file: lines_longer_than_80_chars, strict_raw_type, directives_ordering
import 'package:flutter/material.dart';
import 'package:music/app/common/navigation_app/navigation_page.dart';
import 'package:music/app/modules/music/audio.dart';

class RoutesApp {
  // static const splash = '/';
  static const home = '/';
  static const audio = '/audio';
  static const audioList = '/audio-list';
  static const video = '/video';
  static const videoList = '/video-list';
  static const radio = '/radio';
  static const radioList = '/radio-list';

  static Route routes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => NavigationPage());
      case audio:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => AudioPage(filePath: args! as String),
          transitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        );
      // case audioList:
      //   return PageRouteBuilder(
      //     pageBuilder: (_, animation, secondaryAnimation) => const AudioListPage(),
      //     transitionDuration: const Duration(milliseconds: 1000),
      //     transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
      //   );

      case audioList:
        return MaterialPageRoute(builder: (_) => const AudioListPage());
      // case scholarship:
      //   return MaterialPageRoute(builder: (_) => ScholarshipPage());
      // case scholarshipPageThreeDetail:
      //   return MaterialPageRoute(
      //     builder: (context) => PageThreeDetail(data: args! as ModalidadEntity),
      //   );
      // case webview:
      //   return MaterialPageRoute(
      //     builder: (context) => AppWebView(url: args! as String),
      //   );
      // case history:
      //   return MaterialPageRoute(builder: (_) => HistoryPage());
      // case contact:
      //   return MaterialPageRoute(builder: (context) => ContactPage.create(context, null));
    }
    throw Exception('This route does not exists');
  }

  PageRouteBuilder transitionOpacity(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 1000),
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    );
  }
}
