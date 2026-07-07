import 'package:flutter/material.dart';
import '../data/models/chapter_model.dart';
import '../data/repository/gita_repository.dart';

class ChaptersProvider with ChangeNotifier {
  final GitaRepository _repository = GitaRepository();
  List<ChapterModel> _chapters = [];
  bool _isLoading = false;

  List<ChapterModel> get chapters => _chapters;
  bool get isLoading => _isLoading;

  Future<void> loadChapters() async {
    _isLoading = true;
    notifyListeners();

    _chapters = await _repository.getChapters();
    
    _isLoading = false;
    notifyListeners();
  }
}
