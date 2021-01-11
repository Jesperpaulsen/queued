import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/providers/user_provider.dart';
import 'package:queued/router/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kIsWeb)
    await FirebaseFirestore.instance.enablePersistence();
  else
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  await UserProvider.signIn();
  await DotEnv().load('.env');
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
        textTheme: ThemeData.light().textTheme.copyWith(
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
