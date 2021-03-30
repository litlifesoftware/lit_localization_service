import 'dart:convert';

import 'package:flutter/services.dart';

/// A controller class to handle I/O operations required to load and parse the JSON file
/// containing the localized strings.
///
/// The [loadFromAsset] method must be called before localized strings can be displayed
/// on the UI.
///
/// [loadFromAsset] will called twice in general. It will be called first on the
/// initialization of the [LitLocalizationServiceDelegate]'s [LitLocalizations] object
/// in order to store the JSON parsed values inside the context to be accessible on the
/// UI. The second time it will be called on a [FutureBuilder] wrapping all UI widgets.
/// Once the parsing has been completed, the localized strings can be displayed on the
/// widget. As long as the parsing is ongoing, a fallback widget should be displayed in
/// order to update the view once the values are able to be read. Otherwise the widget
/// displaying the localized string gets no notification to update itself and therefore
/// no localizations are displayed.
class LitLocalizationController {
  /// States whether to show the debug output.
  final bool debug;

  /// Creates a [LitLocalizationController].
  ///
  /// * [debug] states wheter to show the debug output.
  const LitLocalizationController({
    this.debug = false,
  });

  /// Contains a local copy of the ``JSON`` content.
  static Map<String, dynamic>? _localizedStrings = Map<String, dynamic>();

  /// Returns the ``JSON`` content stored on inside a [Map].
  Map<String, dynamic>? get localizedString {
    return _localizedStrings;
  }

  /// Retrieves the content inside the ``JSON`` file and initalizes the [_localizedStrings]
  /// object using the retrieved data.
  ///
  /// The result of retrieving the data will either be true (successed) or false
  /// (failed).
  Future<bool> loadFromAsset(String jsonAssetURL) async {
    // Try to load the JSON asset.
    try {
      _localizedStrings = jsonDecode(await rootBundle.loadString(jsonAssetURL));

      // Retrieving the data was successful.
      return true;

      // Catch the exception if the file is either empty or non existing.
    } catch (e) {
      if (debug) {
        print(
            "LitLocalizationService: JSON file does not contain a valid format or does not exist. Please verify the JSON file´s existence inside the provided directory.");
      }

      // Retrieving the data failed.
      return false;
    }
  }

  /// Initializes the localizations by starting the I/O fetch.
  Future<void> initLocalizations(String jsonAssetURL) async {
    await loadFromAsset(jsonAssetURL);
  }
}
