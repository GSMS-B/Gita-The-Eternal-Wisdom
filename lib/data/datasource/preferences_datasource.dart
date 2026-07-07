import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/bookmark_model.dart';

class PreferencesDatasource {
  static const String keyBookmarks = 'bookmarks';
  static const String keyLastRead = 'last_read';
  static const String keyReadVerses = 'read_verses';
  static const String keyFontSize = 'font_size';
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyShowTransliteration = 'show_transliteration';
  static const String keyTranslationAuthor = 'translation_author';

  Future<SharedPreferences> get prefs async => await SharedPreferences.getInstance();

  // Bookmarks
  Future<List<BookmarkModel>> getBookmarks() async {
    final p = await prefs;
    final List<String> bookmarksStr = p.getStringList(keyBookmarks) ?? [];
    return bookmarksStr.map((str) => BookmarkModel.fromMap(jsonDecode(str))).toList();
  }

  Future<void> saveBookmarks(List<BookmarkModel> bookmarks) async {
    final p = await prefs;
    final List<String> bookmarksStr = bookmarks.map((b) => jsonEncode(b.toMap())).toList();
    await p.setStringList(keyBookmarks, bookmarksStr);
  }

  // Reading Progress
  Future<String?> getLastReadVerseId() async {
    final p = await prefs;
    return p.getString(keyLastRead);
  }

  Future<void> setLastReadVerseId(String verseId) async {
    final p = await prefs;
    await p.setString(keyLastRead, verseId);
  }

  Future<List<String>> getReadVerses() async {
    final p = await prefs;
    return p.getStringList(keyReadVerses) ?? [];
  }

  Future<void> markVerseAsRead(String verseId) async {
    final p = await prefs;
    List<String> readVerses = p.getStringList(keyReadVerses) ?? [];
    if (!readVerses.contains(verseId)) {
      readVerses.add(verseId);
      await p.setStringList(keyReadVerses, readVerses);
    }
  }

  Future<void> unmarkVerseAsRead(String verseId) async {
    final p = await prefs;
    List<String> readVerses = p.getStringList(keyReadVerses) ?? [];
    if (readVerses.contains(verseId)) {
      readVerses.remove(verseId);
      await p.setStringList(keyReadVerses, readVerses);
    }
  }

  // Settings
  Future<double> getFontSize() async {
    final p = await prefs;
    return p.getDouble(keyFontSize) ?? 1.0;
  }

  Future<void> setFontSize(double size) async {
    final p = await prefs;
    await p.setDouble(keyFontSize, size);
  }

  Future<bool> getIsDarkMode() async {
    final p = await prefs;
    return p.getBool(keyIsDarkMode) ?? false;
  }

  Future<void> setIsDarkMode(bool isDark) async {
    final p = await prefs;
    await p.setBool(keyIsDarkMode, isDark);
  }
  
  Future<bool> getShowTransliteration() async {
    final p = await prefs;
    return p.getBool(keyShowTransliteration) ?? true;
  }

  Future<void> setShowTransliteration(bool show) async {
    final p = await prefs;
    await p.setBool(keyShowTransliteration, show);
  }

  Future<String> getTranslationAuthor() async {
    final p = await prefs;
    return p.getString(keyTranslationAuthor) ?? 'prabhu';
  }

  Future<void> setTranslationAuthor(String authorKey) async {
    final p = await prefs;
    await p.setString(keyTranslationAuthor, authorKey);
  }
}
