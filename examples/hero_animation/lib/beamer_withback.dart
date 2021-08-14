import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
//  broken after beamBack. next beam does not animate hero. (actually no page transitioning is happening!)
main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late final rootDelegate = BeamerDelegate(
    buildListener: (_, _2) => print("Rebuid"),
    locationBuilder: RoutesLocationBuilder(
        routes: {
        '/': (context, state) => BeamPage(
              //key: ValueKey('Small'),
              title: "Small",
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    'Beamer using back - Small',
                  ),
                ),
                body: Hero(
                    tag: "image",
                    child: ElevatedButton(
                        onPressed: () => context.beamToNamed("/2"),
                        child: Image.network(
                            'https://picsum.photos/250?image=9',
                            width: 100,
                            height: 100))),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: () => context.beamToNamed("/2"),
                  child: Icon(Icons.ac_unit),
                ),
              )),
        '/2': (context, state) => BeamPage(
              title: "Big",
              //key: ValueKey('Big'),
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    'Beamer using back - Big',
                  ),
                ),
                body: Hero(
                    tag: "image",
                    child: ElevatedButton(
                        onPressed: () => context.beamBack(),
                        child: Image.network(
                            'https://picsum.photos/250?image=9',
                            width: 300,
                            height: 300))),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => context.beamBack(),
                  child: Icon(Icons.ac_unit),
                ),
              )),
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
