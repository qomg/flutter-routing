import 'package:flutter/material.dart';

import 'routing.dart';
import 'widgets/fade_transition_page.dart';

abstract class AppState<T extends StatefulWidget> extends State<T> {
  @protected
  final navigatorKey = GlobalKey<NavigatorState>();

  @protected
  late final RouteState routeState;
  @protected
  late final SimpleRouterDelegate routerDelegate;
  @protected
  late final TemplateRouteParser routeParser;

  @protected
  abstract List<String> allowedPaths;
  @protected
  abstract String initialRoute;
  @protected
  abstract ThemeData? themeData;

  @protected
  ThemeData get theme => (themeData ?? ThemeData.light()).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      );

  @protected
  String? findPage(LocalKey? key) {
    return null;
  }

  @protected
  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (route.settings is Page) {
      final page = findPage((route.settings as Page).key);
      if (page != null) {
        routeState.go(page);
      }
    }
    return route.didPop(result);
  }

  @protected
  Page wrapFadeTransition(LocalKey? key, Widget page) {
    return FadeTransitionPage<void>(key: key, child: page);
  }

  @protected
  Page wrapMaterial(LocalKey? key, Widget page) {
    return MaterialPage<void>(key: key, child: page);
  }

  @protected
  Future<ParsedRoute> guard(ParsedRoute from) async {
    return from;
  }

  @protected
  Widget builder(BuildContext context, GlobalKey<NavigatorState> navigatorKey) {
    final routeState = RouteStateScope.of(context);
    return Navigator(
      key: navigatorKey,
      onPopPage: onPopPage,
      pages: buildPages(routeState, routeState.route.pathTemplate),
    );
  }

  @protected
  List<Page<dynamic>> buildPages(RouteState routeState, String pathTemplate);

  @override
  void dispose() {
    routerDelegate.dispose();
    routeState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    routeParser = TemplateRouteParser(
      allowedPaths: allowedPaths,
      guard: guard,
      initialRoute: initialRoute,
    );
    routeState = RouteState(routeParser);
    routerDelegate = SimpleRouterDelegate(
      routeState: routeState,
      builder: (context) => builder(context, navigatorKey),
      navigatorKey: navigatorKey,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RouteStateScope(
      notifier: routeState,
      child: MaterialApp.router(
        routeInformationParser: routeParser,
        routerDelegate: routerDelegate,
        theme: theme,
      ),
    );
  }
}
