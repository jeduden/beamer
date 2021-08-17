import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

//beamer with custom page. back is using Navigator.pop.
void main() => runApp(MyApp());

class CustomPage extends BeamPage {
  const CustomPage({
    LocalKey? key,
    String? name,
    required this.child,
    this.title,
  }) : super(key: key, name: name, child: child);

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

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late final rootDelegate = BeamerDelegate(
    buildListener: (_, _2) => print("Rebuid"),
    locationBuilder: RoutesLocationBuilder(routes: {
      '/': (context, state) => CustomPage(
          title: "Page /",
          key: ValueKey("/"),
          child: Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text("CustomPage with Navigator.pop"),
                ElevatedButton(
                    onPressed: (){
                      print("Clicked on change");
                      context.beamToNamed('/2');
                    },
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
              ]))),
      '/2': (context, state) => CustomPage(
          title: "Page /2",
          key: ValueKey("/2"),
          child: Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                ElevatedButton(
                    //beamToBack ... breaks hero
                    onPressed: () {
                      print("Clicked on back");
                      rootDelegate.navigator.pop();
                    },
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
              ]))),
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
