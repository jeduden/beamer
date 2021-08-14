import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late final rootDelegate = BeamerDelegate(
    buildListener: (_, _2) => print("Rebuid"),
    locationBuilder: RoutesLocationBuilder(
        routes: {
          '/': (context, state) =>
              Scaffold(body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () => context.beamToNamed('/2'),
                    child: Text("change")),
                Stack(children: [Hero(
                    tag: "image",
                    child: Image.network('https://picsum.photos/250?image=9',
                       width: 100,
                    height: 100,
                    ))])
              ])),
          '/2': (context, state) => Scaffold(body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(//beamToBack ... breaks hero
                        onPressed: () => context.beamBack(),
                        child: Text("back")),
                    Stack(children: [Hero(
                        tag: "image",
                        child: Image.network(
                          
                          'https://picsum.photos/250?image=10',
                             width: 100,
                    height: 100,
                        ))])
                  ])),
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