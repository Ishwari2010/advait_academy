class SalaryRecord {
  final String id;
  final String staffId;
  final int month; // Changed from String to int (1-12)
  final int year;
  final double daysWorked;
  final double hoursPerDay;
  final double totalHours;
  final double hourlyRate;
  final double calculatedSalary;
  final DateTime createdAt;

  SalaryRecord({
    required this.id,
    required this.staffId,
    required this.month,
    required this.year,
    required this.daysWorked,
    required this.hoursPerDay,
    required this.totalHours,
    required this.hourlyRate,
    required this.calculatedSalary,
    required this.createdAt,
  });

  factory SalaryRecord.fromMap(Map<String, dynamic> map) {
    return SalaryRecord(
      id: map["id"]?.toString() ?? "",
      staffId: map["staff_id"]?.toString() ?? "",
      month: map["month"] ?? 1,
      year: map["year"] ?? 0,
      daysWorked: (map["days_worked"] ?? 0).toDouble(),
      hoursPerDay: (map["hours_per_day"] ?? 0).toDouble(),
      totalHours: (map["total_hours"] ?? 0).toDouble(),
      hourlyRate: (map["hourly_rate"] ?? 0).toDouble(),
      calculatedSalary: (map["calculated_salary"] ?? 0).toDouble(),
      createdAt: DateTime.parse(map["created_at"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "staff_id": staffId,
      "month": month,
      "year": year,
      "days_worked": daysWorked,
      "hours_per_day": hoursPerDay,
      "total_hours": totalHours,
      "hourly_rate": hourlyRate,
      "calculated_salary": calculatedSalary,
      "created_at": createdAt.toIso8601String(),
    };
  }
}
