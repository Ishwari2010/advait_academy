import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/staff_model.dart";
import "../models/salary_record_model.dart";
import "../providers/staff_provider.dart";
import "../widgets/add_salary_bottom_sheet.dart";

class StaffDetailScreen extends StatefulWidget {
  final StaffModel staff;

  const StaffDetailScreen({super.key, required this.staff});

  @override
  State<StaffDetailScreen> createState() => _StaffDetailScreenState();
}

class _StaffDetailScreenState extends State<StaffDetailScreen> {
  List<SalaryRecord> _records = [];
  bool _isLoadingRecords = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoadingRecords = true);
    try {
      final records = await context.read<StaffProvider>().fetchSalaryRecords(widget.staff.id);
      setState(() {
        _records = records;
        _isLoadingRecords = false;
      });
    } catch (e) {
      setState(() => _isLoadingRecords = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading records: $e")),
        );
      }
    }
  }

  String _getMonthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    if (month < 1 || month > 12) return "Unknown";
    return months[month - 1];
  }

  double get _totalPaid => _records.fold(0.0, (sum, item) => sum + item.calculatedSalary);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.staff.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDeleteStaff(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _isLoadingRecords 
              ? const Center(child: CircularProgressIndicator())
              : _buildRecordsList(context),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _showAddSalary(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
          child: const Text("Add Monthly Entry"),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.green[50],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.staff.category,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w600)),
              Text("Rate: \u{20B9}${widget.staff.hourlyRate.toInt()}/hr",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 15),
          Card(
            color: Colors.orange[100],
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.orange[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Total Salary Paid: ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text("\u{20B9}${_totalPaid.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList(BuildContext context) {
    if (_records.isEmpty) {
      return const Center(child: Text("No records found"));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${_getMonthName(record.month)} ${record.year}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                      onPressed: () => _confirmDeleteSalaryRecord(context, record),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem("Days", record.daysWorked.toString()),
                    _infoItem("Hrs/Day", record.hoursPerDay.toString()),
                    _infoItem("Total Hrs", record.totalHours.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rate: \u{20B9}${record.hourlyRate.toInt()}", style: const TextStyle(color: Colors.grey)),
                    Text("\u{20B9}${record.calculatedSalary.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showAddSalary(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddSalaryBottomSheet(
        staffId: widget.staff.id,
        hourlyRate: widget.staff.hourlyRate,
      ),
    );
    // Refresh list after modal closes
    _loadRecords();
  }

  void _confirmDeleteSalaryRecord(BuildContext context, SalaryRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Entry"),
        content: Text("Are you sure you want to delete the entry for ${_getMonthName(record.month)} ${record.year}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await context.read<StaffProvider>().deleteSalaryRecord(record.id);
              _loadRecords(); // Refresh list
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteStaff(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Staff"),
        content: Text("Are you sure you want to delete ${widget.staff.name}? This will also delete all salary records."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await Provider.of<StaffProvider>(context, listen: false).deleteStaff(widget.staff.id);
              if (context.mounted) {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to home
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
