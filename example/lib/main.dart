import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lit_localization_service/lit_localization_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lit Localization Service Demo',
      home: ParsingStateBuilder(),
      debugShowCheckedModeBanner: false,
      // Pass all available localization delegates, include the material, widget and
      // cupertino delegates to access
      localizationsDelegates: [
        // The LitLocalizationServiceDelegate will be passed here.
        LitLocalizationServiceDelegate(
          // Set your asset url
          jsonAssetURL: 'assets/json/localized_strings.json',
          // Set all language code whose localization are available on the json file
          supportedLanguages: ['en', 'de'],
          // State whether to output logs.
          debug: true,
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// Supported languages
      supportedLocales: [
        // English (no contry code)
        const Locale('en', ''),
        // German (no contry code)
        const Locale('de', '')
      ],
    );
  }
}

/// A loading screen.
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading localizations ..."),
      ),
    );
  }
}

/// A widget to either build the [LoadingScreen] or the [MyHomeScreen] depending on the
/// current state of the JSON parsing.
///
/// The localizations must be initialized using a future function in order to obtain the
/// current state. Once the json parsing is completed, the actual widget can be displayed.
/// If not, a loading screen should be displayed as long as the parsing is still ongoing.
class ParsingStateBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LitLocalizationController()
          .initLocalizations('assets/json/localized_strings.json'),
      builder: (context, localizatonsInitalization) {
        return localizatonsInitalization.connectionState ==
                ConnectionState.waiting
            ? LoadingScreen()
            : MyHomeScreen();
      },
    );
  }
}

/// The home screen displaying the localized strings.
class MyHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lit Localization Service Demo"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LitLocalizations.of(context).getLocalizedValue("hello")),
          Text(LitLocalizations.of(context).getLocalizedValue("world")),
        ],
      )),
    );
  }
}
