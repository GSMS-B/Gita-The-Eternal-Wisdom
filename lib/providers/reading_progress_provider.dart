import 'package:flutter/material.dart';
import '../data/repository/settings_repository.dart';

class ReadingProgressProvider with ChangeNotifier {
  final SettingsRepository _repository = SettingsRepository();
  
  List<String> _readVerses = [];
  String? _lastReadVerseId;

  List<String> get readVerses => _readVerses;
  String? get lastReadVerseId => _lastReadVerseId;

  Future<void> loadProgress() async {
    _readVerses = await _repository.getReadVerses();
    _lastReadVerseId = await _repository.getLastReadVerseId();
    notifyListeners();
  }

  Future<void> markAsRead(String verseId) async {
    if (!_readVerses.contains(verseId)) {
      _readVerses.add(verseId);
      await _repository.markVerseAsRead(verseId);
      notifyListeners();
    }
  }

  Future<void> unmarkAsRead(String verseId) async {
    if (_readVerses.contains(verseId)) {
      _readVerses.remove(verseId);
      await _repository.unmarkVerseAsRead(verseId);
      notifyListeners();
    }
  }

  Future<void> toggleReadStatus(String verseId) async {
    if (isRead(verseId)) {
      await unmarkAsRead(verseId);
    } else {
      await markAsRead(verseId);
    }
  }

  Future<void> updateLastRead(String verseId) async {
    _lastReadVerseId = verseId;
    await _repository.setLastReadVerseId(verseId);
    notifyListeners();
  }

  bool isRead(String verseId) {
    return _readVerses.contains(verseId);
  }
}
