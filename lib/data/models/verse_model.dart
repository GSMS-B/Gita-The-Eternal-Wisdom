import 'dart:convert';

class VerseModel {
  final String id;
  final int chapter;
  final int verse;
  final String slok;
  final String transliteration;
  final String translation;
  final String purport;
  final String title;
  final String topicTags;
  final Map<String, dynamic> translations;

  VerseModel({
    required this.id,
    required this.chapter,
    required this.verse,
    required this.slok,
    required this.transliteration,
    required this.translation,
    required this.purport,
    required this.title,
    required this.topicTags,
    required this.translations,
  });

  factory VerseModel.fromMap(Map<String, dynamic> map) {
    return VerseModel(
      id: map['id'],
      chapter: map['chapter'],
      verse: map['verse'],
      slok: map['slok'],
      transliteration: map['transliteration'],
      translation: map['translation'],
      purport: map['purport'],
      title: map['title'] ?? '',
      topicTags: map['topic_tags'] ?? '',
      translations: _parseTranslations(map['translations_json']),
    );
  }

  static Map<String, dynamic> _parseTranslations(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return {};
    }
  }

  String getTranslationFor(String authorKey) {
    if (translations.containsKey(authorKey)) {
      final authorData = translations[authorKey];
      // Try English, then Hindi, then Sanskrit
      if (authorData.containsKey('et')) return authorData['et'];
      if (authorData.containsKey('ht')) return authorData['ht'];
      if (authorData.containsKey('sc')) return authorData['sc'];
    }
    return translation; // fallback to default (Prabhupada)
  }

  String getPurportFor(String authorKey) {
    if (translations.containsKey(authorKey)) {
      final authorData = translations[authorKey];
      // Try English commentary, then Hindi, then Sanskrit
      if (authorData.containsKey('ec')) return authorData['ec'];
      if (authorData.containsKey('hc')) return authorData['hc'];
    }
    return purport; // fallback to default (Prabhupada) if not found, but we might want to return empty if the author specifically doesn't have it.
    // Actually, if the author doesn't have a purport, it's better to return empty string.
  }
  
  String getPurportForAuthor(String authorKey) {
    if (translations.containsKey(authorKey)) {
      final authorData = translations[authorKey];
      if (authorData.containsKey('ec')) return authorData['ec'];
      if (authorData.containsKey('hc')) return authorData['hc'];
      return ''; // Explicitly empty if this author has no commentary
    }
    return purport;
  }
  
  String getAuthorName(String authorKey) {
    if (translations.containsKey(authorKey)) {
      return translations[authorKey]['author'] ?? 'Unknown Author';
    }
    return 'A.C. Bhaktivedanta Swami Prabhupada';
  }
}
