import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lit_localization_service/controller/lit_localization_controller.dart';

/// A controller class loading the JSON file content and enabling to get a specific
/// localized string by it's key on the JSON file.
class LitLocalizations {
  /// The device's [Locale].
  final Locale locale;

  /// The JSON file's location.
  final String jsonAssetURL;

  /// States whether to show debug output.
  final bool debug;

  /// Creates the [LitLocalizations].
  ///
  /// This constructor should ONLY be used on the [LitLocalizationServiceDelegate].
  ///
  /// The arguments are provided by the [LitLocalizationServiceDelegate].
  const LitLocalizations(
    this.locale, {
    @required this.jsonAssetURL,
    this.debug = false,
  });

  /// Returns the [LitLocalizations] found in the [BuildContext].
  ///
  /// This will be required to store one [LitLocalizations] instance exclusively
  /// in runtime. In order to retrieve a localized string use the [getLocalizedValue]
  /// method.
  static LitLocalizations of(BuildContext context) {
    return Localizations.of<LitLocalizations>(context, LitLocalizations);
  }

  /// The a local [LitLocalizationController] storing the `JSON`-fetched strings.
  static LitLocalizationController _localizationController =
      LitLocalizationController();

  /// Loads the `JSON` content from storage.
  Future<bool> loadFromAsset() async {
    return await _localizationController.loadFromAsset(jsonAssetURL);
  }

  /// States whether the retrieved JSON content has an error by checking if the initalized
  /// map has been modified.
  bool get _hasError {
    return _localizationController.localizedString.isEmpty;
  }

  /// States whether the provided key does link to an implemented key-value-pair in the JSON
  /// file.
  bool _keyValueImplemented(String key) {
    bool keyImplemented = _localizationController.localizedString[key] != null;

    return keyImplemented;
  }

  /// States whether the provided key does link to an implemented language in the JSON
  /// file.
  bool _languageImplemented(String key) {
    bool languageImplemented = _localizationController.localizedString[key]
            [locale.languageCode] !=
        null;

    return languageImplemented;
  }

  /// Retrieves a specific localized string by it's value from the JSON file.
  ///
  /// Retrieving values from a JSON file could result in errors. In order to provide
  /// feedback if something goes wrong while retrieving, feedback strings are returned.
  /// These strings are displayed on the UI instead of the requested localized string.
  ///
  /// If one of these cases occur, feedback strings are returned or exceptions are
  /// thown:
  ///
  /// * The JSON file is not found or its content is accessed while the parsing is ongoing.
  ///
  /// * The provided key-value pair has not been implemented in the JSON file.
  ///
  /// * The requested language is not implemented in the JSON string, but the
  ///   language was added to the supportedLanguages list on the delegate instance.
  String getLocalizedValue(String key) {
    if (_hasError) {
      if (debug) {
        print("LitLocalizationService: ERROR - JSON file not found");
      }
      throw Exception(
          "ERROR - JSON file not found or parsing still ongoing. Have you called the localized string before the LitLocalizationController has completed the parsing?\nPlease check your JSON location and ensure you have awaited the LitLocalizationController's loadFromAsset result on a FutureBuilder before calling localized strings.");
    } else {
      if (_keyValueImplemented(key)) {
        if (_languageImplemented(key)) {
          // The localized value will always be wrapped inside a string object to avoid any
          // exceptions to be displayed on the UI.
          return "${_localizationController.localizedString[key][locale.languageCode]}";
        } else {
          if (debug) {
            print(
                "LitLocalizationService: ERROR - Localization on '$key' for '${locale.languageCode}' not implemented");
          }
          return "ERROR: Localization on '$key' for '${locale.languageCode}' not implemented";
        }
      } else {
        if (debug) {
          print(
              "LitLocalizationService: ERROR - Key-value pair on '$key' not found");
        }
        return "ERROR: Key-value pair on '$key' not found";
      }
    }
  }
}
