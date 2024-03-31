import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastik_mobile/bloc/addKms/kms_bloc.dart';
import 'package:swastik_mobile/bloc/login/login_bloc.dart';
import 'package:swastik_mobile/ui/screens/intro_screen.dart';
import 'package:swastik_mobile/ui/screens/login.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;

  switch (settings.name) {
    case "/":
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => LoginBloc(),
                child: const Signin(),
              ));

    case "/visits":
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => KmsBloc(),
                child: const IntroScreen(),
              ));

    default:
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text("Page not found"),
          ),
        );
      });
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  Future<dynamic> navigateTo(String routeName, Object? arg) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arg);
  }

  Future<dynamic> navigateTopop(String routeName, Object? arg) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arg);
  }
}
