import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../beamer.dart';

/// Types for how to route should be built.
enum BeamPageType {
  material,
  cupertino,
  fadeTransition,
  slideTransition,
  scaleTransition,
  noTransition,
}

/// A wrapper for screens in a navigation stack.
class BeamPage extends Page {
  const BeamPage({
    LocalKey? key,
    String? name,
    required this.child,
    this.title,
    this.onPopPage = pathSegmentPop,
    this.popToNamed,
    this.type = BeamPageType.material,
    this.routeBuilder,
    this.fullScreenDialog = false,
    this.keepQueryOnPop = false,
  }) : super(key: key, name: name);

  /// The default pop behavior for [BeamPage].
  ///
  /// Pops the last path segment from URI and calls [BeamerDelegate.update].
  static bool pathSegmentPop(
    BuildContext context,
    BeamerDelegate delegate,
    RouteInformationSerializable state,
    BeamPage poppedPage,
  ) {
    if (!delegate.navigator.canPop() ||
        delegate.beamingHistoryCompleteLength < 2) {
      return false;
    }

    // take the data in case we remove the BeamLocation from history
    // and generate a new one (but the same).
    final data = delegate.currentBeamLocation.data;

    // Take the history element that is being popped and the one before
    // as they will be compared later on to fine-tune the pop experience.
    final poppedHistoryElement = delegate.removeLastHistoryElement()!;
    final previousHistoryElement = delegate.beamingHistory.last.history.last;

    // Convert both to Uri as their path and query will be compared.
    final poppedUri = Uri.parse(
      poppedHistoryElement.state.routeInformation.location ?? '/',
    );
    final previousUri = Uri.parse(
      previousHistoryElement.state.routeInformation.location ?? '/',
    );

    final poppedPathSegments = poppedUri.pathSegments;
    final poppedQueryParameters = poppedUri.queryParameters;

    // Pop path is obtained via removing the last path segment from path
    // that is beaing popped.
    final popPathSegments = List.from(poppedPathSegments)..removeLast();
    final popPath = '/' + popPathSegments.join('/');
    var popUri = Uri(
      path: popPath,
      queryParameters: poppedPage.keepQueryOnPop
          ? poppedQueryParameters
          : (popPath == previousUri.path)
              ? previousUri.queryParameters
              : null,
    );

    // We need the routeState from the route we are trying to pop to.
    //
    // Remove the last history element if it's the same as the path
    // we're trying to pop to, because `update` will add it to history.
    // This is `false` in case we deep-linked.
    //
    // Otherwise, find the state with popPath in history.
    RouteInformationSerializable? lastState;
    if (popPath == previousUri.path) {
      lastState = delegate.removeLastHistoryElement()?.state;
    } else {
      // find the last
      bool found = false;
      for (var beamLocation in delegate.beamingHistory.reversed) {
        if (found) {
          break;
        }
        for (var historyElement in beamLocation.history.reversed) {
          final uri =
              Uri.parse(historyElement.state.routeInformation.location ?? '/');
          if (uri.path == popPath) {
            lastState = historyElement.state;
            found = true;
            break;
          }
        }
      }
    }

    delegate.update(
      configuration: delegate.configuration.copyWith(
        location: popUri.toString(),
        state: lastState?.routeInformation.state,
      ),
      data: data,
    );

    return true;
  }

  /// Pops the last route from history and calls [BeamerDelegate.update].
  static bool routePop(
    BuildContext context,
    BeamerDelegate delegate,
    RouteInformationSerializable state,
    BeamPage poppedPage,
  ) {
    if (delegate.beamingHistoryCompleteLength < 2) {
      return false;
    }

    delegate.removeLastHistoryElement();
    final previousHistoryElement = delegate.removeLastHistoryElement()!;

    delegate.update(
      configuration: previousHistoryElement.state.routeInformation.copyWith(),
    );

    return true;
  }

  /// The concrete Widget representing app's screen.
  final Widget child;

  /// The BeamPage's title. On the web, this is used for the browser tab title.
  final String? title;

  /// Overrides the default pop by executing an arbitrary closure.
  /// Mainly used to manually update the [delegate.currentBeamLocation] state.
  ///
  /// [poppedPage] is this [BeamPage].
  ///
  /// Return `false` (rarely used) to prevent **any** navigation from happening,
  /// otherwise return `true`.
  ///
  /// More powerful than [popToNamed].
  final bool Function(
    BuildContext context,
    BeamerDelegate delegate,
    RouteInformationSerializable state,
    BeamPage poppedPage,
  ) onPopPage;

  /// Overrides the default pop by beaming to specified URI string.
  ///
  /// Less powerful than [onPopPage].
  final String? popToNamed;

  /// The type to determine how a route should be built.
  ///
  /// See [BeamPageType] for available types.
  final BeamPageType type;

  /// A builder for custom [Route] to use in [createRoute].
  ///
  /// [settings] must be passed to [PageRoute.settings].
  /// [child] is the child of this [BeamPage]
  /// [context] is the build context.
  final Route Function(RouteSettings settings, Widget child, BuildContext context)? routeBuilder;

  /// Whether to present current [BeamPage] as a fullscreen dialog
  ///
  /// On iOS, dialog transitions animate differently and are also not closeable with the back swipe gesture
  final bool fullScreenDialog;

  /// When this [BeamPage] pops from [Navigator] stack, whether to keep the
  /// query parameters within current [BeamLocation].
  ///
  /// Defaults to `false`.
  final bool keepQueryOnPop;

  @override
  Route createRoute(BuildContext context) {
    if (routeBuilder != null) {
      return routeBuilder!(this, child,context);
    }
    switch (type) {
      case BeamPageType.cupertino:
        return CupertinoPageRoute(
          title: title,
          fullscreenDialog: fullScreenDialog,
          settings: this,
          builder: (context) => child,
        );
      case BeamPageType.fadeTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      case BeamPageType.slideTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: animation.drive(
                Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                    .chain(CurveTween(curve: Curves.ease))),
            child: child,
          ),
        );
      case BeamPageType.scaleTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      case BeamPageType.noTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          settings: this,
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );
      default:
        return MaterialPageRoute(
          fullscreenDialog: fullScreenDialog,
          settings: this,
          builder: (context) => child,
        );
    }
  }
}
