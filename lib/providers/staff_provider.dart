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
    if (_selectedCategory == category) return;
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
      debugPrint("Error adding staff: $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteStaff(String staffId) async {
    try {
      await _supabaseService.deleteStaff(staffId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting staff: $e");
      rethrow;
    }
  }

  Future<List<SalaryRecord>> fetchSalaryRecords(String staffId) async {
    return await _supabaseService.getSalaryRecordsFuture(staffId);
  }

  Future<void> addSalaryRecord(SalaryRecord record) async {
    setLoading(true);
    try {
      await _supabaseService.addSalaryRecord(record);
      notifyListeners(); 
    } catch (e) {
      debugPrint("Error adding salary record: $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteSalaryRecord(String recordId) async {
    setLoading(true);
    try {
      await _supabaseService.deleteSalaryRecord(recordId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting salary record: $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Stream<List<StaffModel>> getStaffStream() {
    return _supabaseService.getStaffByCategory(_selectedCategory);
  }

  // Legacy stream for screens that still use it
  Stream<List<SalaryRecord>> getSalaryRecordsStream(String staffId) {
    return _supabaseService.getSalaryRecords(staffId);
  }
}
