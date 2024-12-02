import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:routing/app_state.dart';
import 'package:routing/routing/route_state.dart';

import 'home_page.dart';

void main() {
  enableFlutterDriverExtension();
  setHashUrlStrategy();

  runApp(App(key: UniqueKey()));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends AppState<App> {
  @override
  List<String> allowedPaths = [
    "/home",
    "/about",
    "/product",
    "/detail/:id",
  ];

  @override
  String initialRoute = "/home";

  @override
  ThemeData? themeData = ThemeData(colorScheme: const ColorScheme.light());

  @override
  List<Page> buildPages(RouteState routeState, String pathTemplate) {
    if (pathTemplate == "/home") {
      return [
        wrapFadeTransition(newKey("home"), HomePage(push: pushNamed)),
      ];
    } else if (pathTemplate == "/product") {
      return [
        wrapFadeTransition(newKey("product"), HomePage(push: pushNamed)),
      ];
    } else if (pathTemplate == "/detail") {
      return [
        wrapFadeTransition(newKey("detail"), HomePage(push: pushNamed)),
      ];
    } else if (pathTemplate == "/about") {
      return [
        wrapFadeTransition(newKey("about"), HomePage(push: pushNamed)),
      ];
    } else {
      // TODO
      return [];
    }
  }

  ValueKey<String> newKey(String value) => ValueKey(value);

  pushNamed(String routeName) {
    final navi = navigatorKey.currentState;
    if (navi != null) {
      navi.pushNamed(routeName);
    }
  }

  doPop() {
    final navi = navigatorKey.currentState;
    if (navi != null && navi.canPop()) {
      navi.pop();
    }
  }
}
