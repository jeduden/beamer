import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late final rootDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(routes: {
      '/': (context, state) => BeamPage(
          type: BeamPageType.fadeTransition,
          child: Scaffold(
              appBar: AppBar(
                title: Text("Home"),
              ),
              body: Center(child: ElevatedButton(
                  onPressed: () => context.beamToNamed('/zoomed'),
                  child: Hero(
                      tag: "image",
                      child: Image.network(
                        'https://picsum.photos/250?image=9',
                        width: 100,
                        height: 100,
                      )))))),
      '/zoomed': (context, state) => BeamPage(
          type: BeamPageType.fadeTransition,
          child: Scaffold(
              appBar: AppBar(
                title: Text("Zoomed"),
              ),
              body: Center(child: ElevatedButton(
                  onPressed: () => context.beamBack(),
                  child: Hero(
                      tag: "image",
                      child: Image.network('https://picsum.photos/250?image=9',
                          width: 300,
                          height: 300)))))),
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
