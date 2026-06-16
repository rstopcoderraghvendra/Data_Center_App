class MonthlyEntryData {
  final DateTime month;
  final int billEntries;
  final int surveyEntries;
  final String projectId;
  final String projectName;

  const MonthlyEntryData({
    required this.month,
    required this.billEntries,
    required this.surveyEntries,
    this.projectId = '',
    this.projectName = '',
  });

  int get totalEntries => billEntries + surveyEntries;

  String get projectKey {
    if (projectId.trim().isNotEmpty) {
      return projectId.trim();
    }

    if (projectName.trim().isNotEmpty) {
      return projectName.trim().toLowerCase();
    }

    return 'default_project';
  }

  String get monthKey {
    return '${month.year}-${month.month.toString().padLeft(2, '0')}';
  }

  String get monthLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[month.month - 1]} ${month.year}';
  }

  static List<MonthlyEntryData> parseList(dynamic raw) {
    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(MonthlyEntryData.fromJson)
        .toList();
  }

  factory MonthlyEntryData.fromJson(Map<String, dynamic> json) {
    final parsedMonth = _parseMonth(json);

    return MonthlyEntryData(
      month: parsedMonth,
      projectId: (json['project_id'] ??
          json['projectId'] ??
          json['bill_distribution_project_id'] ??
          '')
          .toString(),
      projectName: (json['project_name'] ??
          json['projectName'] ??
          json['project'] ??
          json['bill_distribution_project_name'] ??
          '')
          .toString(),
      billEntries: _toIntDynamic(
        json['bill_distribution_entery_count'] ??
            json['bill_distribution_entry_count'] ??
            json['bill_entries'] ??
            json['bill_count'] ??
            json['bill'] ??
            0,
      ),
      surveyEntries: _toIntDynamic(
        json['survey_data_entery_count'] ??
            json['survey_data_entry_count'] ??
            json['survey_entries'] ??
            json['survey_count'] ??
            json['survey'] ??
            0,
      ),
    );
  }

  static DateTime _parseMonth(Map<String, dynamic> json) {
    final now = DateTime.now();

    final year = _toIntDynamic(json['year']);
    final month = _toIntDynamic(json['month_number'] ?? json['month_no']);

    if (year > 0 && month >= 1 && month <= 12) {
      return DateTime(year, month);
    }

    final raw = (json['month'] ??
        json['entry_month'] ??
        json['date'] ??
        json['created_at'] ??
        '')
        .toString()
        .trim();

    if (raw.isEmpty) return DateTime(now.year, now.month);

    final numericMonth = int.tryParse(raw);

    if (numericMonth != null && numericMonth >= 1 && numericMonth <= 12) {
      return DateTime(year > 0 ? year : now.year, numericMonth);
    }

    final date = DateTime.tryParse(raw);

    if (date != null) {
      return DateTime(date.year, date.month);
    }

    final lower = raw.toLowerCase();

    const monthNames = {
      'january': 1,
      'jan': 1,
      'february': 2,
      'feb': 2,
      'march': 3,
      'mar': 3,
      'april': 4,
      'apr': 4,
      'may': 5,
      'june': 6,
      'jun': 6,
      'july': 7,
      'jul': 7,
      'august': 8,
      'aug': 8,
      'september': 9,
      'sep': 9,
      'october': 10,
      'oct': 10,
      'november': 11,
      'nov': 11,
      'december': 12,
      'dec': 12,
    };

    for (final entry in monthNames.entries) {
      if (lower.contains(entry.key)) {
        return DateTime(year > 0 ? year : now.year, entry.value);
      }
    }

    return DateTime(now.year, now.month);
  }

  static int _toIntDynamic(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}