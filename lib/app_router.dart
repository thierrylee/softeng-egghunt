import 'package:flutter/material.dart';
import 'package:softeng_egghunt/ask_username/ask_username_page.dart';
import 'package:softeng_egghunt/scan_code/scan_code_page.dart';
import 'package:softeng_egghunt/score_list/score_list_page.dart';

abstract class AppRouter {
  static MaterialPageRoute<dynamic> handleRoute(RouteSettings settings) {
    final screen = switch (settings.name) {
      AskUsernamePage.routeName => const AskUsernamePage(),
      ScoreListPage.routeName => const ScoreListPage(),
      ScanCodePage.routeName => const ScanCodePage(),
      String() => null,
      null => null,
    };

    if (screen == null) throw Exception("Invalid route: ${settings.name}");
    return MaterialPageRoute<dynamic>(
      builder: (final context) {
        return screen;
      },
      settings: settings,
    );
  }
}
