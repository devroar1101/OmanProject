class ListResponse {
  final List<DataList>? data;
  final int? totalCount;

  ListResponse({this.data, this.totalCount});

  factory ListResponse.fromMap(Map<String, dynamic> map) {
    return ListResponse(
      data: (map['data'] as List<dynamic>?)
          ?.map((item) => DataList.fromMap(item))
          .toList(),
      totalCount: map['totalCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((item) => item.toMap()).toList(),
      'totalCount': totalCount,
    };
  }
}

class DataList {
  final String? referenceNumber;
  final String? fromUser;
  final String? toUser;
  final int? status;
  final String? subject;
  final String? locationNameArabic;
  final String? locationNameEnglish;
  final String? letterObjectId;

  DataList({
    this.referenceNumber,
    this.fromUser,
    this.toUser,
    this.status,
    this.subject,
    this.locationNameArabic,
    this.locationNameEnglish,
    this.letterObjectId,
  });

  factory DataList.fromMap(Map<String, dynamic> map) {
    return DataList(
      referenceNumber: map['referenceNumber'],
      fromUser: map['fromUser'],
      toUser: map['toUser'],
      status: map['status'],
      subject: map['subject'],
      locationNameArabic: map['locationNameArabic'] ?? 'Tender Board',
      locationNameEnglish: map['locationNameEnglish'] ?? 'Tender Board',
      letterObjectId: map['letterObjectId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'referenceNumber': referenceNumber,
      'fromUser': fromUser,
      'toUser': toUser,
      'status': status,
      'subject': subject,
      'locationNameArabic': locationNameArabic,
      'locationNameEnglish': locationNameEnglish,
      'letterObjectId': letterObjectId,
    };
  }
}
