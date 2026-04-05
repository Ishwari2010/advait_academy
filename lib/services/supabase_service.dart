import "package:supabase_flutter/supabase_flutter.dart";
import "../models/staff_model.dart";
import "../models/salary_record_model.dart";

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // Staff Operations
  Stream<List<StaffModel>> getStaffByCategory(String category) {
    return _supabase
        .from("staff")
        .stream(primaryKey: ["id"])
        .eq("category", category)
        .order("created_at")
        .map((data) => data.map((json) => StaffModel.fromMap(json)).toList());
  }

  Future<void> addStaff(StaffModel staff) async {
    await _supabase.from("staff").insert(staff.toMap());
  }

  Future<void> deleteStaff(String staffId) async {
    await _supabase.from("staff").delete().eq("id", staffId);
  }

  // Salary Records Operations
  Stream<List<SalaryRecord>> getSalaryRecords(String staffId) {
    return _supabase
        .from("salary_records")
        .stream(primaryKey: ["id"])
        .eq("staff_id", staffId)
        .order("year", ascending: false)
        .order("month", ascending: false)
        .map((data) => data.map((json) => SalaryRecord.fromMap(json)).toList());
  }

  // Manual fetch for robust UI updates
  Future<List<SalaryRecord>> getSalaryRecordsFuture(String staffId) async {
    final response = await _supabase
        .from("salary_records")
        .select()
        .eq("staff_id", staffId)
        .order("year", ascending: false)
        .order("month", ascending: false);
    
    return (response as List).map((json) => SalaryRecord.fromMap(json)).toList();
  }

  Future<void> addSalaryRecord(SalaryRecord record) async {
    await _supabase.from("salary_records").insert(record.toMap());
  }

  Future<void> deleteSalaryRecord(String recordId) async {
    await _supabase.from("salary_records").delete().eq("id", recordId);
  }
}
