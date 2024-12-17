// LetterAction Class
class LetterAction {
  final int? letterActionId;
  final int? fromUserId;
  final int? fromDGId;
  final int? locationId;
  final int? actionId;
  final int? fromDepartmentId;
  final int? fromSectionId;
  final int? sequenceNo;
  final int? classificationId;
  final int? priorityId;
  final DateTime? follwedUpDate;
  final DateTime? replyDate;
  final DateTime? suspendTillDate;
  final String? pageSelected;
  final int? toUserId;
  final int? toDgId;
  final int? toDepartmentId;
  final int? toSectionId;
  final String? comments;
  final bool? isHidden;
  final DateTime? timeStamp;
  final bool? isDeleted;
  final String? objectId;

  LetterAction({
    this.letterActionId,
    this.fromUserId,
    this.fromDGId,
    this.locationId,
    this.actionId,
    this.fromDepartmentId,
    this.fromSectionId,
    this.sequenceNo,
    this.classificationId,
    this.priorityId,
    this.follwedUpDate,
    this.replyDate,
    this.suspendTillDate,
    this.pageSelected,
    this.toUserId,
    this.toDgId,
    this.toDepartmentId,
    this.toSectionId,
    this.comments,
    this.isHidden,
    this.timeStamp,
    this.isDeleted,
    this.objectId,
  });

  factory LetterAction.fromMap(Map<String, dynamic> map) {
    return LetterAction(
      letterActionId: map['letterActionId'],
      fromUserId: map['fromUserId'],
      fromDGId: map['fromDGId'],
      locationId: map['locationId'],
      actionId: map['actionId'],
      fromDepartmentId: map['fromDepartmentId'],
      fromSectionId: map['fromSectionId'],
      sequenceNo: map['sequenceNo'],
      classificationId: map['classificationId'],
      priorityId: map['priorityId'],
      follwedUpDate: map['follwedUpDate'] != null
          ? DateTime.parse(map['follwedUpDate'])
          : null,
      replyDate:
          map['replyDate'] != null ? DateTime.parse(map['replyDate']) : null,
      suspendTillDate: map['suspendTillDate'] != null
          ? DateTime.parse(map['suspendTillDate'])
          : null,
      pageSelected: map['pageSelected'],
      toUserId: map['toUserId'],
      toDgId: map['toDgId'],
      toDepartmentId: map['toDepartmentId'],
      toSectionId: map['toSectionId'],
      comments: map['comments'],
      isHidden: map['isHidden'],
      timeStamp:
          map['timeStamp'] != null ? DateTime.parse(map['timeStamp']) : null,
      isDeleted: map['isDeleted'],
      objectId: map['objectId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'letterActionId': letterActionId,
      'fromUserId': fromUserId,
      'fromDGId': fromDGId,
      'locationId': locationId,
      'actionId': actionId,
      'fromDepartmentId': fromDepartmentId,
      'fromSectionId': fromSectionId,
      'sequenceNo': sequenceNo,
      'classificationId': classificationId,
      'priorityId': priorityId,
      'follwedUpDate': follwedUpDate?.toIso8601String(),
      'replyDate': replyDate?.toIso8601String(),
      'suspendTillDate': suspendTillDate?.toIso8601String(),
      'pageSelected': pageSelected,
      'toUserId': toUserId,
      'toDgId': toDgId,
      'toDepartmentId': toDepartmentId,
      'toSectionId': toSectionId,
      'comments': comments,
      'isHidden': isHidden,
      'timeStamp': timeStamp?.toIso8601String(),
      'isDeleted': isDeleted,
      'objectId': objectId,
    };
  }
}
