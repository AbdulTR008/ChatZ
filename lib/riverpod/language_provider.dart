import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en');

  pickedLanguage(newLanguage) {
    state = newLanguage;
  }
}

final selectedLanguageProvider =
    StateNotifierProvider<LanguageNotifier, String>(
        (ref) => LanguageNotifier());
