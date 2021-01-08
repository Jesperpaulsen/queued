import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/providers/auth_provider.dart';
import 'package:queued/router/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AuthProvider.signIn();
  runApp(ProviderScope(child: Queued()));
}

class Queued extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(
      title: 'Queued',
      theme: ThemeData(
        primarySwatch: AppColors.primary,
        accentColor: AppColors.secondary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: AppColors.secondary,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => ErrorRoute().generatePage().builder(context),
        );
      },
      onGenerateRoute: (settings) => RouteGenerator().generateRoute(settings),
    );
  }
}
