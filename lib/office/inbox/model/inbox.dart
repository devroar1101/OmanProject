// InboxModel Class
class LetterInbox {
  final String? referenceNumber;
  final String? systemName;
  final String? subject;
  final String? locationNameArabic;
  final String? locationNameEnglish;
  final String? letterObjectId;

  LetterInbox({
    this.referenceNumber,
    this.systemName,
    this.subject,
    this.locationNameArabic,
    this.locationNameEnglish,
    this.letterObjectId,
  });

  factory LetterInbox.fromMap(Map<String, dynamic> map) {
    return LetterInbox(
      referenceNumber: map['referenceNumber'],
      systemName: map['systemName'],
      subject: map['subject'],
      locationNameArabic: map['locationNameArabic'],
      locationNameEnglish: map['locationNameEnglish'],
      letterObjectId: map['letterObjectId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'referenceNumber': referenceNumber,
      'systemName': systemName,
      'subject': subject,
      'locationNameArabic': locationNameArabic,
      'locationNameEnglish': locationNameEnglish,
      'objectId': letterObjectId,
    };
  }
}
