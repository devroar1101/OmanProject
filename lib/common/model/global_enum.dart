import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';

enum Priority {
  normal(1, 'Normal', 'عادي', Colors.green, Icons.check),
  urgent(2, 'Urgent', 'عاجل', Colors.orange, Icons.warning),
  veryUrgent(3, 'Very Urgent', 'عاجل جداً', Colors.red, Icons.error);

  final int id;
  final String labelEnglish;
  final String labelArabic;
  final Color color;
  final IconData icon;

  const Priority(
      this.id, this.labelEnglish, this.labelArabic, this.color, this.icon);
  String getLabel(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl
        ? labelArabic
        : labelEnglish;
  }
}

enum Classification {
  general(1, 'General', 'مكتوم', Colors.blue, Icons.public),
  limited(2, 'Limited', 'محدود', Colors.teal, Icons.lock_open),
  secret(3, 'Secret', 'سري', Colors.amber, Icons.lock),
  topSecret(4, 'Top Secret', 'سري للغاية', Colors.red, Icons.lock_outline);

  final int id;
  final String labelEnglish;
  final String labelArabic;
  final Color color;
  final IconData icon;

  const Classification(
      this.id, this.labelEnglish, this.labelArabic, this.color, this.icon);

  String getLabel(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl
        ? labelArabic
        : labelEnglish;
  }
}

enum ActionType {
  assign(1, 'Assign', 'إحالة', Colors.blue, Icons.assignment),
  reply(2, 'Reply', 'رد', Colors.green, Icons.reply),
  transfer(3, 'Transfer', 'تحويل', Colors.purple, Icons.swap_horiz),
  followUp(4, 'Follow Up', 'متابعة', Colors.orange, Icons.follow_the_signs),
  suspend(5, 'Suspend', 'تأجيل', Colors.grey, Icons.pause),
  close(6, 'Close', 'إغلاق', Colors.red, Icons.close),
  archive(7, 'Archive', 'أرشيف', Colors.brown, Icons.archive),
  reopen(8, 'Re-Open', 'إعادة فتح', Colors.blueGrey, Icons.refresh),
  hide(9, 'Hide', 'إخفاء', Colors.black, Icons.visibility_off),
  borrow(10, 'Borrow', 'إستعارة', Colors.indigo, Icons.book),
  copy(11, 'Copy', 'نسخ', Colors.cyan, Icons.copy),
  returnBack(12, 'Return Back', 'إرجاع', Colors.deepOrange, Icons.undo),
  onlyView(13, 'Only View', 'إطلاع', Colors.lightBlue, Icons.visibility),
  newAssign(
      14, 'New/Assign', 'جديد/إحالة', Colors.lightGreen, Icons.new_releases),
  printAction(15, 'Print Action', 'طباعة', Colors.blueAccent, Icons.print),
  cc(16, 'CC', 'نسخة مع التحية', Colors.pink, Icons.group);

  final int id;
  final String labelEnglish;
  final String labelArabic;
  final Color color;
  final IconData icon;

  const ActionType(
      this.id, this.labelEnglish, this.labelArabic, this.color, this.icon);

  String getLabel(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl
        ? labelArabic
        : labelEnglish;
  }
}
