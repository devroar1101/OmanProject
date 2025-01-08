import 'dart:convert';

class RoutingHistoryResult {
  final int? actionId;
  final String? fromUser;
  final String? toUser;
  final int? sequenceNo;
  final int? classificationId;
  final int? priorityId;
  final String? followedUpDate;
  final String? replyDate;
  final String? suspendTillDate;
  final String? comments;
  final String? isHidden;
  final String? objectId;
  final String? timeStamp;

  RoutingHistoryResult(
      {this.actionId,
      this.fromUser,
      this.toUser,
      this.sequenceNo,
      this.classificationId,
      this.priorityId,
      this.followedUpDate,
      this.replyDate,
      this.suspendTillDate,
      this.comments,
      this.isHidden,
      this.objectId,
      this.timeStamp});

  factory RoutingHistoryResult.fromMap(Map<String, dynamic> map) {
    return RoutingHistoryResult(
      actionId: map['actionId'] as int?,
      fromUser: map['fromUser'] as String?,
      toUser: map['toUser'] as String?,
      sequenceNo: map['sequenceNo'] as int?,
      classificationId: map['classificationId'] as int?,
      priorityId: map['priorityId'] as int?,
      followedUpDate: map['followedUpDate'] as String?,
      replyDate: map['replyDate'] as String?,
      suspendTillDate: map['suspendTillDate'] as String?,
      comments: map['comments'] as String?,
      isHidden: map['isHidden'] as String?,
      objectId: map['objectId'] as String?,
      timeStamp: map['TimeStamp'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'actionId': actionId,
      'fromUser': fromUser,
      'toUser': toUser,
      'sequenceNo': sequenceNo,
      'classificationId': classificationId,
      'priorityId': priorityId,
      'followedUpDate': followedUpDate,
      'replyDate': replyDate,
      'suspendTillDate': suspendTillDate,
      'comments': comments,
      'isHidden': isHidden,
      'objectId': objectId,
    };
  }

  String toJson() => json.encode(toMap());

  factory RoutingHistoryResult.fromJson(String source) =>
      RoutingHistoryResult.fromMap(json.decode(source));
}
