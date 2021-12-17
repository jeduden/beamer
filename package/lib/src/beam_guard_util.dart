import 'package:flutter/material.dart';

import '../beamer.dart';
import 'utils.dart';


/// State of the route passed to [BeamDelegate.checkedRouteListener]
enum RouteCheckState {
  /// [targetRouteInfo] and [targetData] no [UpdateGuard] has rej
  accepted,

  /// the route has been rejected by a [UpdateGuard]
  rejected,
}


/// Matches [routeInformation] with [pathPatterns].
///
/// If asterisk is present, it is enough that the pre-asterisk substring is
/// contained within location's pathBlueprint.
/// Else, the path (i.e. the pre-query substring) of the location's uri
/// must be equal to the pathPattern.
bool patternsMatch(List<Pattern> pathPatterns,RouteInformation routeInformation) {
  for (final pathPattern in pathPatterns) {
    final path =
        Uri.parse(routeInformation.location ?? '/').path;
    if (pathPattern is String) {
      final asteriskIndex = pathPattern.indexOf('*');
      if (asteriskIndex != -1) {
        if (routeInformation.location
            .toString()
            .contains(pathPattern.substring(0, asteriskIndex))) {
          return true;
        }
      } else {
        if (pathPattern == path) {
          return true;
        }
      }
    } else {
      final regexp = Utils.tryCastToRegExp(pathPattern);
      return regexp.hasMatch(path);
    }
  }
  return false;
}