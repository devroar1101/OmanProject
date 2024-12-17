// LetterContent Class
class LetterContent {
  final int? letterContentId;
  final String? content;
  final int? pageNumber;
  final String? objectId;
  final DateTime? timeStamp;
  final bool? isDeleted;

  LetterContent({
    this.letterContentId,
    this.content,
    this.pageNumber,
    this.objectId,
    this.timeStamp,
    this.isDeleted,
  });

  factory LetterContent.fromMap(Map<String, dynamic> map) {
    return LetterContent(
      letterContentId: map['letterContentId'],
      content: map['content'],
      pageNumber: map['pageNumber'],
      objectId: map['objectId'],
      timeStamp:
          map['timeStamp'] != null ? DateTime.parse(map['timeStamp']) : null,
      isDeleted: map['isDeleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'letterContentId': letterContentId,
      'content': content,
      'pageNumber': pageNumber,
      'objectId': objectId,
      'timeStamp': timeStamp?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}
