import '../datasource/preferences_datasource.dart';
import '../models/bookmark_model.dart';

class BookmarkRepository {
  final PreferencesDatasource _prefs = PreferencesDatasource();

  Future<List<BookmarkModel>> getBookmarks() async {
    return await _prefs.getBookmarks();
  }

  Future<void> addBookmark(String verseId) async {
    List<BookmarkModel> bookmarks = await _prefs.getBookmarks();
    if (!bookmarks.any((b) => b.verseId == verseId)) {
      bookmarks.add(BookmarkModel(verseId: verseId, timestamp: DateTime.now().millisecondsSinceEpoch));
      await _prefs.saveBookmarks(bookmarks);
    }
  }

  Future<void> removeBookmark(String verseId) async {
    List<BookmarkModel> bookmarks = await _prefs.getBookmarks();
    bookmarks.removeWhere((b) => b.verseId == verseId);
    await _prefs.saveBookmarks(bookmarks);
  }
  
  Future<bool> isBookmarked(String verseId) async {
    List<BookmarkModel> bookmarks = await _prefs.getBookmarks();
    return bookmarks.any((b) => b.verseId == verseId);
  }
}
