import 'package:flutter/material.dart';
import '../data/models/verse_model.dart';
import '../data/repository/gita_repository.dart';

class VerseProvider with ChangeNotifier {
  final GitaRepository _repository = GitaRepository();
  
  VerseModel? _currentVerse;
  List<VerseModel> _chapterVerses = [];
  bool _isLoading = false;

  VerseModel? get currentVerse => _currentVerse;
  List<VerseModel> get chapterVerses => _chapterVerses;
  bool get isLoading => _isLoading;

  Future<void> loadVersesForChapter(int chapterNumber) async {
    _isLoading = true;
    notifyListeners();

    _chapterVerses = await _repository.getVersesForChapter(chapterNumber);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadVerse(String verseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentVerse = await _repository.getVerse(verseId);
      // Ensure we have the chapter verses loaded for prev/next
      if (_chapterVerses.isEmpty || _chapterVerses.first.chapter != _currentVerse!.chapter) {
        _chapterVerses = await _repository.getVersesForChapter(_currentVerse!.chapter);
      }
    } catch (e) {
      print("Error loading verse: $e");
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void nextVerse() {
    if (_currentVerse == null || _chapterVerses.isEmpty) return;
    int currentIndex = _chapterVerses.indexWhere((v) => v.id == _currentVerse!.id);
    if (currentIndex < _chapterVerses.length - 1) {
      _currentVerse = _chapterVerses[currentIndex + 1];
      notifyListeners();
    }
  }

  void previousVerse() {
    if (_currentVerse == null || _chapterVerses.isEmpty) return;
    int currentIndex = _chapterVerses.indexWhere((v) => v.id == _currentVerse!.id);
    if (currentIndex > 0) {
      _currentVerse = _chapterVerses[currentIndex - 1];
      notifyListeners();
    }
  }

  bool get hasNext => _currentVerse != null && _chapterVerses.isNotEmpty && 
      _chapterVerses.last.id != _currentVerse!.id;

  bool get hasPrevious => _currentVerse != null && _chapterVerses.isNotEmpty && 
      _chapterVerses.first.id != _currentVerse!.id;
}
