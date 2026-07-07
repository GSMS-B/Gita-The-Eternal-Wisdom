import '../datasource/local_database.dart';
import '../models/chapter_model.dart';
import '../models/verse_model.dart';

class GitaRepository {
  final LocalDatabase _localDb = LocalDatabase();

  Future<List<ChapterModel>> getChapters() async {
    return await _localDb.getAllChapters();
  }

  Future<ChapterModel> getChapter(int chapterNumber) async {
    return await _localDb.getChapter(chapterNumber);
  }

  Future<List<VerseModel>> getVersesForChapter(int chapterNumber) async {
    return await _localDb.getVersesForChapter(chapterNumber);
  }

  Future<VerseModel> getVerse(String id) async {
    return await _localDb.getVerse(id);
  }

  Future<String?> getNextVerseId(String currentId) async {
    return await _localDb.getNextVerseId(currentId);
  }

  Future<List<VerseModel>> search(String query) async {
    return await _localDb.searchVerses(query);
  }

  Future<List<ChapterModel>> searchChapters(String query) async {
    return await _localDb.searchChapters(query);
  }
}
