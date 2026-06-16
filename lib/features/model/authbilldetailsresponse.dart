class AuthBillDetailsResponse {
  final bool status;
  final AuthBillFilters filters;
  final AuthBillSummary summary;
  final List<DayWiseDistribution> dayWiseDistribution;

  const AuthBillDetailsResponse({
    required this.status,
    required this.filters,
    required this.summary,
    required this.dayWiseDistribution,
  });

  factory AuthBillDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AuthBillDetailsResponse(
      status: _toBool(json['status']),
      filters: AuthBillFilters.fromJson(
        Map<String, dynamic>.from(json['filters'] ?? {}),
      ),
      summary: AuthBillSummary.fromJson(
        Map<String, dynamic>.from(json['summary'] ?? {}),
      ),
      dayWiseDistribution: (json['day_wise_distribution'] is List)
          ? (json['day_wise_distribution'] as List)
          .whereType<Map>()
          .map((item) => DayWiseDistribution.fromJson(
        Map<String, dynamic>.from(item),
      ))
          .toList()
          : [],
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final str = value?.toString().toLowerCase().trim() ?? '';
    return str == 'true' || str == '1' || str == 'yes';
  }
}

class AuthBillFilters {
  final String? selectedProjectId;
  final String? dateFilter;
  final String? fromDate;
  final String? toDate;

  const AuthBillFilters({
    this.selectedProjectId,
    this.dateFilter,
    this.fromDate,
    this.toDate,
  });

  factory AuthBillFilters.fromJson(Map<String, dynamic> json) {
    return AuthBillFilters(
      selectedProjectId: json['selected_project_id']?.toString(),
      dateFilter: json['date_filter']?.toString(),
      fromDate: json['from_date']?.toString(),
      toDate: json['to_date']?.toString(),
    );
  }
}

class AuthBillSummary {
  final int totalDistribution;
  final int todayDistribution;
  final int thisMonthDistribution;
  final int filteredDistribution;

  const AuthBillSummary({
    required this.totalDistribution,
    required this.todayDistribution,
    required this.thisMonthDistribution,
    required this.filteredDistribution,
  });

  factory AuthBillSummary.fromJson(Map<String, dynamic> json) {
    return AuthBillSummary(
      totalDistribution: _toInt(json['total_distribution']),
      todayDistribution: _toInt(json['today_distribution']),
      thisMonthDistribution: _toInt(json['this_month_distribution']),
      filteredDistribution: _toInt(json['filtered_distribution']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}

class DayWiseDistribution {
  final String date;
  final int count;
  final String? frontViewUrl;
  final String? sideViewUrl;
  final String? additionalUrl;
  final String? locationUrl;

  const DayWiseDistribution({
    required this.date,
    required this.count,
    this.frontViewUrl,
    this.sideViewUrl,
    this.additionalUrl,
    this.locationUrl,
  });

  factory DayWiseDistribution.fromJson(Map<String, dynamic> json) {
    return DayWiseDistribution(
      date: json['date']?.toString() ?? '',
      count: _toInt(json['count']),
      frontViewUrl: _cleanUrl(json['front_view_url']),
      sideViewUrl: _cleanUrl(json['side_view_url']),
      additionalUrl: _cleanUrl(json['additional_url']),
      locationUrl: _cleanUrl(json['location_url']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static String? _cleanUrl(dynamic value) {
    final url = value?.toString().trim() ?? '';
    if (url.isEmpty || url.toLowerCase() == 'null') return null;
    return url;
  }
}