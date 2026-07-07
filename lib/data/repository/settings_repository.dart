import '../datasource/preferences_datasource.dart';

class SettingsRepository {
  final PreferencesDatasource _prefs = PreferencesDatasource();

  Future<double> getFontSize() async => await _prefs.getFontSize();
  Future<void> setFontSize(double size) async => await _prefs.setFontSize(size);

  Future<bool> getIsDarkMode() async => await _prefs.getIsDarkMode();
  Future<void> setIsDarkMode(bool isDark) async => await _prefs.setIsDarkMode(isDark);

  Future<bool> getShowTransliteration() async => await _prefs.getShowTransliteration();
  Future<void> setShowTransliteration(bool show) async => await _prefs.setShowTransliteration(show);
  
  Future<List<String>> getReadVerses() async => await _prefs.getReadVerses();
  Future<void> markVerseAsRead(String verseId) async => await _prefs.markVerseAsRead(verseId);
  Future<void> unmarkVerseAsRead(String verseId) async => await _prefs.unmarkVerseAsRead(verseId);
  
  Future<String?> getLastReadVerseId() async => await _prefs.getLastReadVerseId();
  Future<void> setLastReadVerseId(String verseId) async => await _prefs.setLastReadVerseId(verseId);

  Future<String> getTranslationAuthor() async => await _prefs.getTranslationAuthor();
  Future<void> setTranslationAuthor(String authorKey) async => await _prefs.setTranslationAuthor(authorKey);
}
