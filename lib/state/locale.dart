import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projex_app/i18n/translations.g.dart';
import 'package:projex_app/state/shared_perferences_provider.dart';

// A simple wrapper class to hold the state of the notifier.
class TranslationsContainer {
  final TranslationsEn translations;
  final AppLocale locale;

  const TranslationsContainer(this.translations, this.locale);
}

final _english = TranslationsContainer(
  TranslationsEn.build(),
  AppLocale.en,
);
final _arabic = TranslationsContainer(
  TranslationsAr.build(),
  AppLocale.ar,
);

class TranslationsNotifier extends StateNotifier<TranslationsContainer> {
  TranslationsNotifier(TranslationsContainer state, this.ref) : super(state);
  final Ref ref;
  Future<void> setTranslations(AppLocale other) async {
    switch (other) {
      case AppLocale.en:
        state = _english;
        break;
      case AppLocale.ar:
        state = _arabic;
        break;
    }
    final prefs = ref.read(sharedPerferencesProvider);
    // Save the current locale to SharedPreferneces for persistance.
    await prefs.setString("locale", other.name);
  }
}

// Provides the current/persisted locale to the widget tree
final translationProvider =
    StateNotifierProvider<TranslationsNotifier, TranslationsContainer>(
  (ref) {
    final prefs = ref.read(sharedPerferencesProvider);
    late AppLocale locale;
    if (prefs.containsKey("locale")) {
      locale = prefs.getString("locale")!.toAppLocale()!;
    } else {
      // Default to the devices locale if this is the first
      // time the application is lanched
      final defaultLocale = AppLocaleUtils.findDeviceLocale();
      prefs.setString("locale", defaultLocale.name);
      locale = defaultLocale;
    }
    // return the correct translation based on the persisted locale
    // in SharedPereferences.
    switch (locale) {
      case AppLocale.en:
        return TranslationsNotifier(_english, ref);
      case AppLocale.ar:
        return TranslationsNotifier(_arabic, ref);
    }
  },
); // set it
