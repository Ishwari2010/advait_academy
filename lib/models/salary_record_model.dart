class SalaryRecord {
  final String id;
  final String staffId;
  final int? month;
  final int? year;
  final double daysWorked;
  final DateTime createdAt;

  // New Fields for Redesign
  final double? daysOfMonth;
  final double? std9Hours;
  final double? std10Hours;
  final double? std9Amount;
  final double? std10Amount;
  final double? basicSalary;
  final double? extraHoursPerDay;
  final double? perDayRate;
  final double? perHourRate;
  final double? extraHoursPay;
  final double? totalSalary;

  SalaryRecord({
    required this.id,
    required this.staffId,
    this.month,
    this.year,
    required this.daysWorked,
    required this.createdAt,
    this.daysOfMonth,
    this.std9Hours,
    this.std10Hours,
    this.std9Amount,
    this.std10Amount,
    this.basicSalary,
    this.extraHoursPerDay,
    this.perDayRate,
    this.perHourRate,
    this.extraHoursPay,
    this.totalSalary,
  });

  factory SalaryRecord.fromMap(Map<String, dynamic> map) {
    return SalaryRecord(
      id: map["id"]?.toString() ?? "",
      staffId: map["staff_id"]?.toString() ?? "",
      month: map["month"] as int?,
      year: map["year"] as int?,
      daysWorked: (map["days_worked"] ?? 0).toDouble(),
      createdAt: DateTime.parse(map["created_at"]),
      daysOfMonth: (map["days_of_month"] as num?)?.toDouble(),
      std9Hours: (map["std9_hours"] as num?)?.toDouble(),
      std10Hours: (map["std10_hours"] as num?)?.toDouble(),
      std9Amount: (map["std9_amount"] as num?)?.toDouble(),
      std10Amount: (map["std10_amount"] as num?)?.toDouble(),
      basicSalary: (map["basic_salary"] as num?)?.toDouble(),
      extraHoursPerDay: (map["extra_hours_per_day"] as num?)?.toDouble(),
      perDayRate: (map["per_day_rate"] as num?)?.toDouble(),
      perHourRate: (map["per_hour_rate"] as num?)?.toDouble(),
      extraHoursPay: (map["extra_hours_pay"] as num?)?.toDouble(),
      totalSalary: (map["total_salary"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "staff_id": staffId,
      "month": month,
      "year": year,
      "days_worked": daysWorked,
      "created_at": createdAt.toIso8601String(),
      if (daysOfMonth != null) "days_of_month": daysOfMonth,
      if (std9Hours != null) "std9_hours": std9Hours,
      if (std10Hours != null) "std10_hours": std10Hours,
      if (std9Amount != null) "std9_amount": std9Amount,
      if (std10Amount != null) "std10_amount": std10Amount,
      if (basicSalary != null) "basic_salary": basicSalary,
      if (extraHoursPerDay != null) "extra_hours_per_day": extraHoursPerDay,
      if (perDayRate != null) "per_day_rate": perDayRate,
      if (perHourRate != null) "per_hour_rate": perHourRate,
      if (extraHoursPay != null) "extra_hours_pay": extraHoursPay,
      if (totalSalary != null) "total_salary": totalSalary,
    };
  }
}
