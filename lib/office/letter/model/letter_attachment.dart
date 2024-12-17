// LetterAttachment Class
class LetterAttachment {
  final int? letterAttachmentId;
  final String? attachementType;
  final String? displayName;
  final int? totalPage;
  final String? fileName;
  final String? fileExtention;
  final int? createdBy;
  final bool? isDeleted;
  final DateTime? timeStamp;
  final String? objectId;

  LetterAttachment({
    this.letterAttachmentId,
    this.attachementType,
    this.displayName,
    this.totalPage,
    this.fileName,
    this.fileExtention,
    this.createdBy,
    this.isDeleted,
    this.timeStamp,
    this.objectId,
  });

  factory LetterAttachment.fromMap(Map<String, dynamic> map) {
    return LetterAttachment(
      letterAttachmentId: map['letterAttachmentId'],
      attachementType: map['attachementType'],
      displayName: map['displayName'],
      totalPage: map['totalPage'],
      fileName: map['fileName'],
      fileExtention: map['fileExtention'],
      createdBy: map['createdBy'],
      isDeleted: map['isDeleted'],
      timeStamp:
          map['timeStamp'] != null ? DateTime.parse(map['timeStamp']) : null,
      objectId: map['objectId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'letterAttachmentId': letterAttachmentId,
      'attachementType': attachementType,
      'displayName': displayName,
      'totalPage': totalPage,
      'fileName': fileName,
      'fileExtention': fileExtention,
      'createdBy': createdBy,
      'isDeleted': isDeleted,
      'timeStamp': timeStamp?.toIso8601String(),
      'objectId': objectId,
    };
  }
}
