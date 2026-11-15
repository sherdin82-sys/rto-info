import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_strings.dart';
export '../theme/theme_provider.dart';

/// Supported Locales
enum SupportedLanguage {
  english('en', 'English'),
  hindi('hi', 'हिंदी');

  final String code;
  final String displayName;
  const SupportedLanguage(this.code, this.displayName);
}

/// Locale Notifier for dynamic English / Hindi switching
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  void setLocale(SupportedLanguage lang) {
    state = Locale(lang.code);
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      state = const Locale('hi');
    } else {
      state = const Locale('en');
    }
  }

  String translate(String key) {
    return AppStrings.get(key, state.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
