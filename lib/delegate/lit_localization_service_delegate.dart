import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../localization/lit_localizations.dart';

/// The [LitLocalizations]'s delegate class for the .
///
/// Retrieves the JSON content and extracts it's values to initalize the localizations.
///
/// Extention of [LocalizationsDelegate].
class LitLocalizationServiceDelegate
    extends LocalizationsDelegate<LitLocalizations> {
  final String jsonAssetURL;
  final List<String> supportedLanguages;
  final bool debug;

  /// Creates a [LitLocalizationServiceDelegate].
  ///
  /// This delegate is required to initialize the localizations. The localizations are
  /// extracted from the JSON file on the provided directory. This I/O operation will
  /// take a while, therefore the localized string will remain empty for about one
  /// second. This could be irritating to some users. To avoid empty text being
  /// displayed on startup, it's recommended to use constant values as localized strings
  /// inside a `.dart` file without using this package. [LitLocalizations] are used best
  /// when your app already requires I/O oparations on startup e.g. when accessing a
  /// database. This can then be covered up on a splash or loading screen.
  ///
  /// Keep in mind, that the [LitLocalizations] instance is stored on the [BuildContext].
  /// So in order to access the [LitLocalizations.of(context)] instance, you need to wrap
  /// your localized strings inside at least one custom [StatelessWidget]/ [StatefulWidget]
  /// to avoid the context not being available.
  ///
  /// The JSON file containing your localizations should be formatted as stated below:
  ///
  /// ```json
  /// {
  ///  "hello": {
  ///    "en": "hello",
  ///    "de": "Hallo"
  ///  },
  ///  "world": {
  ///    "en": "world",
  ///    "de": "Welt"
  ///  }
  /// }
  /// ```
  ///
  ///
  /// * [jsonAssetURL] provides the file's location relative to the app's directory.
  ///
  /// * [supportedLanguages] lists all languages that have been implemented
  ///   in the JSON file. This list should match the localizationsDelegates's
  ///   supportedLocales list specified on your [MaterialApp]/[CupertinoApp].
  const LitLocalizationServiceDelegate({
    @required this.jsonAssetURL,
    @required this.supportedLanguages,
    this.debug = false,
  });

  @override
  bool isSupported(Locale locale) =>
      supportedLanguages.contains(locale.languageCode);

  @override
  Future<LitLocalizations> load(Locale locale) async {
    SynchronousFuture<LitLocalizations> localizations;

    // Initialize the LitLocalizations instance.
    localizations = SynchronousFuture<LitLocalizations>(
      LitLocalizations(
        locale,
        jsonAssetURL: jsonAssetURL,
        debug: debug,
      ),
    );

    // Load the content of the file.
    await localizations
      ..loadFromAsset();

    /// Return the localizations.
    return localizations;
  }

  // Don't reload due to the resources not being changed in runtime.
  @override
  bool shouldReload(LitLocalizationServiceDelegate old) => false;
}
