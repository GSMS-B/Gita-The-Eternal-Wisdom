class ChapterModel {
  final int id;
  final int chapterNumber;
  final String imageName;
  final String name;
  final String nameMeaning;
  final String nameTranslation;
  final String nameTransliterated;
  final int versesCount;
  final String chapterSummary;
  final String chapterSummaryHindi;

  ChapterModel({
    required this.id,
    required this.chapterNumber,
    required this.imageName,
    required this.name,
    required this.nameMeaning,
    required this.nameTranslation,
    required this.nameTransliterated,
    required this.versesCount,
    required this.chapterSummary,
    required this.chapterSummaryHindi,
  });

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id'],
      chapterNumber: map['chapter_number'],
      imageName: map['image_name'],
      name: map['name'],
      nameMeaning: map['name_meaning'],
      nameTranslation: map['name_translation'],
      nameTransliterated: map['name_transliterated'],
      versesCount: map['verses_count'],
      chapterSummary: map['chapter_summary'],
      chapterSummaryHindi: map['chapter_summary_hindi'],
    );
  }
}
