import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:music/app/config/routes_app.dart';
import 'package:music/app/database/object_box.dart';
import 'package:music/l10n/l10n.dart';

final GetIt getItApp = GetIt.instance;
late ObjectBox objectbox;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        // useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: RoutesApp.routes,
    );
  }
}
