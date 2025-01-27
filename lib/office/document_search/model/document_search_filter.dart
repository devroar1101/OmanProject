// DocumentSearchFilter Class
import 'package:tenderboard/common/utilities/current_user.dart';

class DocumentSearchFilter {
  String? referenceNumber;
  String? letterNumber;
  String? subject;
  String? direction;
  String? directionType;
  String? externalLocation;
  String? objectId;
  String? tenderNumber;
  int? year;
  DateTime? dateOnLetter;
  DateTime? letterDate;
  DateTime? receviedDate;
  String? folderPermission;

  DocumentSearchFilter(
      {this.referenceNumber,
      this.letterNumber,
      this.subject,
      this.direction,
      this.directionType,
      this.externalLocation,
      this.objectId,
      this.tenderNumber,
      this.year,
      this.dateOnLetter,
      this.letterDate,
      this.receviedDate,
      String? permissions})
      : folderPermission = permissions ?? CurrentUser().folderPermissions;

  Map<String, dynamic> toMap() {
    return {
      'referenceNumber': referenceNumber,
      'letterNumber': letterNumber,
      'subject': subject,
      'direction': direction,
      'directionType': directionType,
      'externallocation': externalLocation,
      'objectId': objectId,
      'tenderNumber': tenderNumber,
      'year': year,
      'receviedDate': receviedDate?.toIso8601String(),
      'dateOnLetter': dateOnLetter?.toIso8601String(),
      'letterDate': letterDate?.toIso8601String(),
      "folderPermissions": folderPermission,
    }..removeWhere((key, value) => value == null);
  }

  factory DocumentSearchFilter.fromMap(Map<String, dynamic> map) {
    return DocumentSearchFilter(
      referenceNumber: map['referenceNumber'] as String?,
      letterNumber: map['letterNumber'] as String?,
      subject: map['subject'] as String?,
      direction: map['direction'] as String?,
      directionType: map['directionType'] as String?,
      externalLocation: map['externallocation'] as String?,
      objectId: map['objectId'] as String?,
      tenderNumber: map['tenderNumber'] as String?,
      year: map['year'] as int?,
      dateOnLetter: map['dateOnLetter'] != null
          ? DateTime.parse(map['dateOnLetter'] as String)
          : null,
      receviedDate: map['receviedDate'] != null
          ? DateTime.parse(map['receviedDate'] as String)
          : null,
      letterDate: map['letterDate'] != null
          ? DateTime.parse(map['letterDate'] as String)
          : null,
      permissions: CurrentUser().folderPermissions,
    );
  }
}
