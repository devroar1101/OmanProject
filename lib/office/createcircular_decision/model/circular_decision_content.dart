class CircularDecisionContent {
  final int? circularDecisionContentId;
  final String? content;
  final int? pageNumber;
  final String? objectId;
  final DateTime? timeStamp;
  final bool? isDeleted;

  CircularDecisionContent({
    this.circularDecisionContentId,
    this.content,
    this.pageNumber,
    this.objectId,
    this.timeStamp,
    this.isDeleted,
  });

  factory CircularDecisionContent.fromMap(Map<String, dynamic> map) {
    return CircularDecisionContent(
      circularDecisionContentId: map['id'],
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
      'content': content,
      'pageNumber': pageNumber,
      'objectId': objectId,
    };
  }
}