import 'package:flutter/material.dart';
import '../data/repository/settings_repository.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsRepository _repository = SettingsRepository();
  
  double _fontSize = 1.0;
  bool _isDarkMode = false;
  bool _showTransliteration = true;
  String _translationAuthor = 'prabhu';

  double get fontSize => _fontSize;
  bool get isDarkMode => _isDarkMode;
  bool get showTransliteration => _showTransliteration;
  String get translationAuthor => _translationAuthor;

  Future<void> loadSettings() async {
    _fontSize = await _repository.getFontSize();
    _isDarkMode = await _repository.getIsDarkMode();
    _showTransliteration = await _repository.getShowTransliteration();
    _translationAuthor = await _repository.getTranslationAuthor();
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    await _repository.setFontSize(size);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _repository.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }
  
  Future<void> toggleTransliteration() async {
    _showTransliteration = !_showTransliteration;
    await _repository.setShowTransliteration(_showTransliteration);
    notifyListeners();
  }

  Future<void> setTranslationAuthor(String authorKey) async {
    _translationAuthor = authorKey;
    await _repository.setTranslationAuthor(authorKey);
    notifyListeners();
  }
}
