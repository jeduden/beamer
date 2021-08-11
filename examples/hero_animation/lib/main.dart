import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

/*
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late final rootDelegate = BeamerDelegate(
    buildListener: (_, _2) => print("Rebuid"),
    locationBuilder: RoutesLocationBuilder(
        routes: /*doesnt work{
        '/': (context, state) => ElevatedButton(
            onPressed: () => context.beamToNamed('/2'),
            child: Hero(
                tag: "image",
                child: Image.network('https://picsum.photos/250?image=9'))),
        '/2': (context, state) => ElevatedButton(
              onPressed: () => context.beamBack(),
              child: Container(width:double.infinity,height:double.infinity,child: Hero(
                  tag: "image",
                  child: Image.network(
                    'https://picsum.photos/250?image=10',
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                  ))),
            ),
      },*/
            {
          '/': (context, state) =>
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () => context.beamToNamed('/2'),
                    child: Text("change")),
                Stack(children: [Hero(
                    tag: "image",
                    child: Image.network('https://picsum.photos/250?image=9',
                       width: 100,
                    height: 100,
                    ))])
              ]),
          '/2': (context, state) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => context.beamBack(),
                        child: Text("back")),
                    Stack(children: [Hero(
                        tag: "image",
                        child: Image.network(
                          
                          'https://picsum.photos/250?image=10',
                             width: 100,
                    height: 100,
                        ))])
                  ]),
        }),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: rootDelegate,
      routeInformationParser: BeamerParser(),
    );
  }
}*/


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late final rootDelegate = BeamerDelegate(
    buildListener: (_, _2) => print("Rebuid"),
    locationBuilder: RoutesLocationBuilder(
        routes: {
        '/': (context, state) => ElevatedButton(
            onPressed: () => context.beamToNamed('/2'),
            child: Container(width:100,height:100,child:Hero(
                tag: "image",
                child: Image.network('https://picsum.photos/250?image=9')))),
        '/2': (context, state) => ElevatedButton(
              onPressed: () => context.beamBack(),
              child: Container(width:2000,height:2000,child: Hero(
                  tag: "image",
                  child: Image.network(
                    'https://picsum.photos/250?image=10',
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                  ))),
            ),
      }),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: rootDelegate,
      routeInformationParser: BeamerParser(),
    );
  }
}

/* working. beamToBack breaks hero
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late final rootDelegate = BeamerDelegate(
    buildListener: (_, _2) => print("Rebuid"),
    locationBuilder: RoutesLocationBuilder(
        routes: {
          '/': (context, state) =>
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () => context.beamToNamed('/2'),
                    child: Text("change")),
                Stack(children: [Hero(
                    tag: "image",
                    child: Image.network('https://picsum.photos/250?image=9',
                       width: 100,
                    height: 100,
                    ))])
              ]),
          '/2': (context, state) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(//beamToBack ... breaks hero
                        onPressed: () => context.beamToNamed('/'),
                        child: Text("back")),
                    Stack(children: [Hero(
                        tag: "image",
                        child: Image.network(
                          
                          'https://picsum.photos/250?image=10',
                             width: 100,
                    height: 100,
                        ))])
                  ]),
        }),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: rootDelegate,
      routeInformationParser: BeamerParser(),
    );
  }
}*/
/*
main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Router(
        routerDelegate: MyRouterDelegate(),
      ),
    );
  }
}

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  int selectedIndex = 0;
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [
        HeroController()
      ], // Important to ensure that hero animations are displayed
      pages: [
        if (selectedIndex == 0)
          BeamPage(
            key: ValueKey('Page0'),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () => onNewIndexSelected(1),
                  child: Text("change")),
              Stack(children: [
                Hero(
                    tag: "image",
                    child: Image.network(
                      'https://picsum.photos/250?image=9',
                      width: 100,
                      height: 100,
                    ))
              ])
            ]),
          ),
        if (selectedIndex == 1)
          BeamPage(
            key: ValueKey('Page1'),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => onNewIndexSelected(0),
                      child: Text("back")),
                  Stack(children: [
                    Hero(
                        tag: "image",
                        child: Image.network(
                          'https://picsum.photos/250?image=10',
                          width: 100,
                          height: 100,
                        ))
                  ])
                ]),
          ),
      ],
      onPopPage: (route, result) {
        print('onPopPage NestedRouterDelegate');
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
}*/
/*
main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Router(
        routerDelegate: MyRouterDelegate(),
      ),
    );
  }
}

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  int selectedIndex = 0;
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Navigator 2.0 - Animations',
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        onTap: onNewIndexSelected,
      ),
      body: Navigator(
        key: navigatorKey,
        observers: [HeroController()], // Important to ensure that hero animations are displayed
        pages: [
          if (selectedIndex == 0)
            MaterialPage(
              key: ValueKey('ProfilePage'),
              child: ProfileWidget(
              ),
            ),
          if (selectedIndex == 1)
            MaterialPage(
              key: ValueKey('NestedNavigatorPage'),
              child: SettingWidget(),
            ),
        ],
        onPopPage: (route, result) {
          print('onPopPage NestedRouterDelegate');
          return false;
        },
      ),
    );
  }

  // We don't use named navigation so we don't use this
  @override
  Future<void> setNewRoutePath(configuration) async => null;

  void onNewIndexSelected(int value) {
    selectedIndex = value;
    notifyListeners();
  }
}*/
