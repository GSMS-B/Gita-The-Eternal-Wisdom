import 'package:flutter/material.dart';
import '../data/models/bookmark_model.dart';
import '../data/repository/bookmark_repository.dart';

class BookmarksProvider with ChangeNotifier {
  final BookmarkRepository _repository = BookmarkRepository();
  List<BookmarkModel> _bookmarks = [];
  bool _isLoading = false;

  List<BookmarkModel> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;

  Future<void> loadBookmarks() async {
    _isLoading = true;
    notifyListeners();

    _bookmarks = await _repository.getBookmarks();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleBookmark(String verseId) async {
    bool exists = await _repository.isBookmarked(verseId);
    if (exists) {
      await _repository.removeBookmark(verseId);
    } else {
      await _repository.addBookmark(verseId);
    }
    await loadBookmarks();
  }

  bool isBookmarked(String verseId) {
    return _bookmarks.any((b) => b.verseId == verseId);
  }
}
