class LocalizedTexts {
  static const Map<String, Map<String, String>> texts = {
    'en': {
      'appBarTitle': 'Dashboard',
      'settings': 'Settings',
      'inbox': 'Inbox',
      'outbox': 'Outbox',
      'closedJobs': 'Closed Jobs',
      'cc': 'CC',
      'decision': 'Decision',
      'circular': 'Circular',
      'notifications': 'Notifications',
      'selectDg': 'Select DG',
      'selectSection': 'Select Section',
      'selectDepartment': 'select Department',
    },
    'ar': {
      'appBarTitle': 'لوحة التحكم',
      'settings': 'الإعدادات',
      'inbox': 'البريد الوارد',
      'outbox': 'البريد الصادر',
      'closedJobs': 'الوظائف المغلقة',
      'cc': 'نسخة كربونية',
      'decision': 'قرار',
      'circular': 'دائري',
      'notifications': 'إشعارات',
      'selectDg': 'اختر المدير العام',
      'selectSection': 'ختر القسم الفرعي',
      'selectDepartment': 'اختر القسم',
    },
  };

  static String getText(String langCode, String key) {
    return texts[langCode]?[key] ?? '';
  }
}
