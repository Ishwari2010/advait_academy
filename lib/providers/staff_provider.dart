import "package:flutter/material.dart";
import "../models/staff_model.dart";
import "../models/salary_record_model.dart";
import "../services/supabase_service.dart";

class StaffProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = false;
  String _selectedCategory = "Teaching";

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addStaff(StaffModel staff) async {
    setLoading(true);
    try {
      await _supabaseService.addStaff(staff);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteStaff(String staffId) async {
    await _supabaseService.deleteStaff(staffId);
  }

  Future<void> addSalaryRecord(SalaryRecord record) async {
    setLoading(true);
    try {
      await _supabaseService.addSalaryRecord(record);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteSalaryRecord(String recordId) async {
    await _supabaseService.deleteSalaryRecord(recordId);
  }

  Stream<List<StaffModel>> getStaffStream() {
    return _supabaseService.getStaffByCategory(_selectedCategory);
  }

  Stream<List<SalaryRecord>> getSalaryRecordsStream(String staffId) {
    return _supabaseService.getSalaryRecords(staffId);
  }
}
