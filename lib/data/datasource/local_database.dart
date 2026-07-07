import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/chapter_model.dart';
import '../models/verse_model.dart';

class LocalDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "gita.db");

    // Force overwrite for development to get latest JSON changes
    bool forceOverwrite = true;
    var exists = await databaseExists(path);

    if (!exists || forceOverwrite) {
      print("Creating new copy from asset (overwrite: $forceOverwrite)");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
        
      if (exists && forceOverwrite) {
        await deleteDatabase(path);
      }
        
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "data", "gita.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Opening existing database");
    }
    // open the database
    return await openDatabase(path, readOnly: true);
  }

  Future<List<ChapterModel>> getAllChapters() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chapters', orderBy: 'chapter_number ASC');
    return List.generate(maps.length, (i) {
      return ChapterModel.fromMap(maps[i]);
    });
  }

  Future<ChapterModel> getChapter(int chapterNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chapters',
      where: 'chapter_number = ?',
      whereArgs: [chapterNumber],
    );
    if (maps.isNotEmpty) {
      return ChapterModel.fromMap(maps.first);
    }
    throw Exception('Chapter not found');
  }

  Future<List<VerseModel>> getVersesForChapter(int chapterNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'verses',
      where: 'chapter = ?',
      whereArgs: [chapterNumber],
      orderBy: 'verse ASC'
    );
    return List.generate(maps.length, (i) {
      return VerseModel.fromMap(maps[i]);
    });
  }

  Future<VerseModel> getVerse(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'verses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return VerseModel.fromMap(maps.first);
    }
    throw Exception('Verse not found');
  }

  Future<String?> getNextVerseId(String currentId) async {
    final db = await database;
    
    final List<Map<String, dynamic>> current = await db.query(
      'verses',
      columns: ['chapter', 'verse'],
      where: 'id = ?',
      whereArgs: [currentId],
    );
    if (current.isEmpty) return null;
    
    int ch = current.first['chapter'];
    int v = current.first['verse'];
    
    final List<Map<String, dynamic>> nextInCh = await db.query(
      'verses',
      columns: ['id'],
      where: 'chapter = ? AND verse > ?',
      whereArgs: [ch, v],
      orderBy: 'verse ASC',
      limit: 1,
    );
    if (nextInCh.isNotEmpty) return nextInCh.first['id'] as String;
    
    final List<Map<String, dynamic>> nextCh = await db.query(
      'verses',
      columns: ['id'],
      where: 'chapter > ?',
      whereArgs: [ch],
      orderBy: 'chapter ASC, verse ASC',
      limit: 1,
    );
    if (nextCh.isNotEmpty) return nextCh.first['id'] as String;
    
    return null;
  }
  
  Future<List<VerseModel>> searchVerses(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'verses',
      where: 'translation LIKE ? OR slok LIKE ? OR purport LIKE ? OR title LIKE ? OR topic_tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%', '%$query%'],
      limit: 50
    );
    return List.generate(maps.length, (i) {
      return VerseModel.fromMap(maps[i]);
    });
  }

  Future<List<ChapterModel>> searchChapters(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chapters',
      where: 'name_translation LIKE ? OR name LIKE ? OR name_meaning LIKE ? OR chapter_summary LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      limit: 10
    );
    return List.generate(maps.length, (i) {
      return ChapterModel.fromMap(maps[i]);
    });
  }
}
