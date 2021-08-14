import 'package:flutter/material.dart';

main() {
  runApp(MyApp());
}

class CustomPage extends Page {
  const CustomPage({
    LocalKey? key,
    String? name,
    required this.child,
    this.title,
  }) : super(key: key, name: name);

  /// The concrete Widget representing app's screen.
  final Widget child;

  /// The BeamPage's title. On the web, this is used for the browser tab title.
  final String? title;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        pageBuilder: (context, animation, secondary) => child,
        transitionsBuilder: (_, animation, secondary, child) {
          print(
              "$title: ${animation.value}/${animation.status} - ${secondary.value}/${secondary.status}");
          return FadeTransition(opacity: animation, child: child);
        });
  }
}

class Parser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) {
    return Future.value(routeInformation);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MaterialApp.router(
        routeInformationParser: Parser(),
        routerDelegate: MyRouterDelegate(),
      ),
    );
  }
}

class MyRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  int selectedIndex = 0;
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [
        //HeroController() // not required if material router is used.
      ], // Important to ensure that hero animations are displayed
      pages: [
        if (selectedIndex == 0)
          CustomPage(
              key: ValueKey('Small'),
              title: "Small",
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    'Navigator 2.0 - Small',
                  ),
                ),
                body: Hero(
                    tag: "image",
                    child: ElevatedButton(
                        onPressed: () => onNewIndexSelected(1),
                        child: Image.network(
                            'https://picsum.photos/250?image=9',
                            width: 100,
                            height: 100))),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: () => onNewIndexSelected(1),
                  child: Icon(Icons.ac_unit),
                ),
              )),
        if (selectedIndex == 1)
          CustomPage(
              title: "Big",
              key: ValueKey('Big'),
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    'Navigator 2.0 - Big',
                  ),
                ),
                body: Hero(
                    tag: "image",
                    child: ElevatedButton(
                        onPressed: () => onNewIndexSelected(0),
                        child: Image.network(
                            'https://picsum.photos/250?image=9',
                            width: 300,
                            height: 300))),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => onNewIndexSelected(0),
                  child: Icon(Icons.ac_unit),
                ),
              )),
      ],
      onPopPage: (route, result) {
        return false;
      },
    );
  }

  // We don't use named navigation so we don't use this
  @override
  Future<void> setNewRoutePath(configuration) async => null;

  void onNewIndexSelected(int value) {
    selectedIndex = value;
    notifyListeners();
  }
}
