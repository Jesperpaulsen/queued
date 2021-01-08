import 'package:flutter/material.dart';
import 'package:queued/screens/home.dart';
import 'package:queued/screens/logged_out.dart';

abstract class AbstractRoute {
  MaterialPageRoute<dynamic> generatePage();
}

class LoggedOutRoute implements AbstractRoute {
  @override
  MaterialPageRoute<dynamic> generatePage() {
    return MaterialPageRoute(builder: (_) => LoggedOut());
  }

  static const path = '/logged-out';
}

class HomeRoute implements AbstractRoute {
  @override
  MaterialPageRoute generatePage() {
    return MaterialPageRoute(builder: (_) => Home());
  }

  static const path = '/home';
}

class ErrorRoute implements AbstractRoute {
  @override
  MaterialPageRoute<dynamic> generatePage() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: Center(
          child: Text("Not found"),
        ),
      );
    });
  }
}

Route<dynamic> routeMapper(String route) {
  switch (route) {
    case LoggedOutRoute.path:
      return LoggedOutRoute().generatePage();
    case HomeRoute.path:
      return HomeRoute().generatePage();
    default:
      return LoggedOutRoute().generatePage();
  }
}

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    return routeMapper(settings.name);
  }
}
