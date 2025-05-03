import 'package:flutter/material.dart';
import '../global_keys.dart';

// ignore_for_file: must_be_immutable
class NavigatorService {
  static Future<dynamic> pushNamed(
    BuildContext context,
    String routeName, {
    dynamic arguments,
  }) async {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  static void goBack(BuildContext context) {
    return Navigator.of(context).pop();
  }

  static void goBackWithoutContext() {
    return rootNavigatorKey.currentState?.pop();
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
    BuildContext context,
    String routeName, {
    bool routePredicate = false,
    dynamic arguments,
  }) async {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => routePredicate,
        arguments: arguments);
  }

  static Future<dynamic> popAndPushNamed(
    BuildContext context,
    String routeName, {
    dynamic arguments,
  }) async {
    return Navigator.of(context)
        .popAndPushNamed(routeName, arguments: arguments);
  }
}
