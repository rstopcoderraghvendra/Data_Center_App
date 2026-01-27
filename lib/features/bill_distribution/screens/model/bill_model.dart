class Bill {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;

  // Your provided fields
  final String customerName;
  final String propertyDetails;
  final String municipality;
  final String integratedPid;
  final String integratedOwner;
  final String areaOfAuthority;
  final String colony;
  final String address;
  final String mobile;
  final String category;
  final String totalArea;
  final String unit;
  final String authorizationStatus;

  Bill({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    this.customerName = '',
    this.propertyDetails = '',
    this.municipality = '',
    this.integratedPid = '',
    this.integratedOwner = '',
    this.areaOfAuthority = '',
    this.colony = '',
    this.address = '',
    this.mobile = '',
    this.category = '',
    this.totalArea = '',
    this.unit = '',
    this.authorizationStatus = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'customerName': customerName,
      'propertyDetails': propertyDetails,
      'municipality': municipality,
      'integratedPid': integratedPid,
      'integratedOwner': integratedOwner,
      'areaOfAuthority': areaOfAuthority,
      'colony': colony,
      'address': address,
      'mobile': mobile,
      'category': category,
      'totalArea': totalArea,
      'unit': unit,
      'authorizationStatus': authorizationStatus,
    };
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      customerName: json['customerName'] ?? '',
      propertyDetails: json['propertyDetails'] ?? '',
      municipality: json['municipality'] ?? '',
      integratedPid: json['integratedPid'] ?? '',
      integratedOwner: json['integratedOwner'] ?? '',
      areaOfAuthority: json['areaOfAuthority'] ?? '',
      colony: json['colony'] ?? '',
      address: json['address'] ?? '',
      mobile: json['mobile'] ?? '',
      category: json['category'] ?? '',
      totalArea: json['totalArea'] ?? '',
      unit: json['unit'] ?? '',
      authorizationStatus: json['authorizationStatus'] ?? '',
    );
  }

  Bill copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    String? customerName,
    String? propertyDetails,
    String? municipality,
    String? integratedPid,
    String? integratedOwner,
    String? areaOfAuthority,
    String? colony,
    String? address,
    String? mobile,
    String? category,
    String? totalArea,
    String? unit,
    String? authorizationStatus,
  }) {
    return Bill(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      municipality: municipality ?? this.municipality,
      integratedPid: integratedPid ?? this.integratedPid,
      integratedOwner: integratedOwner ?? this.integratedOwner,
      areaOfAuthority: areaOfAuthority ?? this.areaOfAuthority,
      colony: colony ?? this.colony,
      address: address ?? this.address,
      mobile: mobile ?? this.mobile,
      category: category ?? this.category,
      totalArea: totalArea ?? this.totalArea,
      unit: unit ?? this.unit,
      authorizationStatus: authorizationStatus ?? this.authorizationStatus,
    );
  }
}
