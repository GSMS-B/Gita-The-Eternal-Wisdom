class BookmarkModel {
  final String verseId;
  final int timestamp; // milliseconds since epoch

  BookmarkModel({
    required this.verseId,
    required this.timestamp,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      verseId: map['verseId'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verseId': verseId,
      'timestamp': timestamp,
    };
  }
}
