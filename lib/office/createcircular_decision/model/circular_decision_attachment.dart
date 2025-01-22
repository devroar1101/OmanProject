class CircularDecisionAttachment {
  final int? circularAttachmentId;
  final String? attachementType;
  final String? displayName;
  final int? totalPage;
  final String? fileName;
  final String? fileExtention;
  final int? createdBy;
  final bool? isDeleted;
  final DateTime? timeStamp;
  final String? objectId;

  CircularDecisionAttachment({
    this.circularAttachmentId,
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

  factory CircularDecisionAttachment.fromMap(Map<String, dynamic> map) {
    return CircularDecisionAttachment(
      circularAttachmentId: map['id'],
      attachementType: map['type'],
      displayName: map['displayName'],
      totalPage: map['totalPage'] ?? 1,
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
      'circularAttachmentId': circularAttachmentId,
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
