import 'package:chatapp/common/CountryNames/country_parser.dart';
import 'package:chatapp/common/CountryNames/utils.dart';
import 'package:flutter/material.dart';

import 'country_localizations.dart';

///The country Model that has all the country
///information needed from the [country_picker]
///
class CountryFields {
  static final String time = 'time';
  static final String phoneCode = 'e164_cc';
  static final String countryCode = 'iso2_cc';
  static final String e164Sc = 'e164_sc';
  static final String geographic = 'geographic';
  static final String level = 'level';
  static final String name = 'name';
  static final String example = 'example';
  static final String displayName = 'display_name';
  static final String fullExampleWithPlusSign = 'full_example_with_plus_sign';
  static final String displayNameNoCountryCode = 'display_name_no_e164_cc';
  static final String e164Key = 'e164_key';
}

class Country {
  static Country worldWide = Country(
    createdTime: DateTime.now(),
    phoneCode: '',
    countryCode: 'WW',
    e164Sc: -1,
    geographic: 0,
    level: -1,
    name: 'World Wide',
    example: '',
    displayName: 'World Wide (WW)',
    displayNameNoCountryCode: 'World Wide',
    e164Key: '',
  );

  final DateTime? createdTime;

  ///The country phone code
  final String phoneCode;

  ///The country code, ISO (alpha-2)
  final String countryCode;
  final int e164Sc;
  final int geographic;
  final int level;

  ///The country name in English
  final String name;

  ///The country name localized
  late String? nameLocalized;

  ///An example of a telephone number without the phone code
  final String example;

  ///Country name (country code) [phone code]
  final String displayName;

  ///An example of a telephone number with the phone code and plus sign
  final String? fullExampleWithPlusSign;

  ///Country name (country code)

  final String displayNameNoCountryCode;
  final String e164Key;

  @Deprecated(
    'The modern term is displayNameNoCountryCode. '
    'This feature was deprecated after v1.0.6.',
  )
  String get displayNameNoE164Cc => displayNameNoCountryCode;

  String? getTranslatedName(BuildContext context) {
    return CountryLocalizations.of(context)
        ?.countryName(countryCode: countryCode);
  }

  Country({
    required this.createdTime,
    required this.phoneCode,
    required this.countryCode,
    required this.e164Sc,
    required this.geographic,
    required this.level,
    required this.name,
    this.nameLocalized = '',
    required this.example,
    required this.displayName,
    required this.displayNameNoCountryCode,
    required this.e164Key,
    this.fullExampleWithPlusSign,
  });

  Country.from({required Map<String, dynamic> json})
      : createdTime = json['createdTime'],
        phoneCode = json['e164_cc'],
        countryCode = json['iso2_cc'],
        e164Sc = json['e164_sc'],
        geographic = json['geographic'] == true ? 1 : 0,
        level = json['level'],
        name = json['name'],
        example = json['example'],
        displayName = json['display_name'],
        fullExampleWithPlusSign = json['full_example_with_plus_sign'],
        displayNameNoCountryCode = json['display_name_no_e164_cc'],
        e164Key = json['e164_key'];

  static Country parse(String country) {
    if (country == worldWide.countryCode) {
      return worldWide;
    } else {
      return CountryParser.parse(country);
    }
  }

  static Country? tryParse(String country) {
    if (country == worldWide.countryCode) {
      return worldWide;
    } else {
      return CountryParser.tryParse(country);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e164_cc'] = phoneCode;
    data['iso2_cc'] = countryCode;
    data['e164_sc'] = e164Sc;
    data['geographic'] = geographic;
    data['level'] = level;
    data['name'] = name;
    data['example'] = example;
    data['display_name'] = displayName;
    data['full_example_with_plus_sign'] = fullExampleWithPlusSign;
    data['display_name_no_e164_cc'] = displayNameNoCountryCode;
    data['e164_key'] = e164Key;
    return data;
  }

  bool startsWith(String query, CountryLocalizations? localizations) {
    String query0 = query;
    if (query.startsWith("+")) {
      query0 = query.replaceAll("+", "").trim();
    }
    return phoneCode.startsWith(query0.toLowerCase()) ||
        name.toLowerCase().startsWith(query0.toLowerCase()) ||
        countryCode.toLowerCase().startsWith(query0.toLowerCase()) ||
        (localizations
                ?.countryName(countryCode: countryCode)
                ?.toLowerCase()
                .startsWith(query0.toLowerCase()) ??
            false);
  }

  bool get iswWorldWide => countryCode == Country.worldWide.countryCode;

  @override
  String toString() => 'Country(countryCode: $countryCode, name: $name)';

  @override
  bool operator ==(Object other) {
    if (other is Country) {
      return other.countryCode == countryCode;
    }
    return super == other;
  }

  @override
  int get hashCode => countryCode.hashCode;

  /// provides country flag as emoji.
  /// Can be displayed using
  ///
  ///```Text(country.flagEmoji)```
  String get flagEmoji => Utils.countryCodeToEmoji(countryCode);

  static Country fromJson(Map<String, Object?> json) {
    print("geographic ${json['geographic']}");
    return Country(
      createdTime: DateTime.parse(json[CountryFields.time] as String),
      phoneCode: json['e164_cc'] as String,
      countryCode: json['iso2_cc'] as String,
      e164Sc: json['e164_sc'] as int,
      geographic: json['geographic'] as int,
      level: json['level'] as int,
      name: json['name'] as String,
      example: json['example'] as String,
      displayName: json['display_name'] as String,
      fullExampleWithPlusSign: json['full_example_with_plus_sign'] as String,
      displayNameNoCountryCode: json['display_name_no_e164_cc'] as String,
      e164Key: json['e164_key'] as String,
    );
  }
}
