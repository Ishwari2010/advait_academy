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
    if (!mounted) return;
    setState(() => _isLoadingRecords = true);
    try {
      final records = await context.read<StaffProvider>().fetchSalaryRecords(widget.staff.id);
      if (mounted) {
        setState(() {
          _records = records;
          _isLoadingRecords = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingRecords = false);
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

  double get _totalPaid => _records.fold(0.0, (sum, item) => sum + (item.totalSalary ?? 0.0));

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
              if (widget.staff.category == "Teaching")
                 const Text("Fixed Rates: Std 9 (\u{20B9}100), Std 10 (\u{20B9}200)")
              else
                 const Text("Base Salary: \u{20B9}7000 (Target)"),
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
        final isTeaching = widget.staff.category == "Teaching";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                if (isTeaching) 
                  _buildTeachingCardData(record)
                else 
                  _buildNonTeachingCardData(record),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Payout:", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("\u{20B9}${(record.totalSalary ?? 0).toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeachingCardData(SalaryRecord record) {
    return Column(
      children: [
        _dataRow("Std 9 Hours", "${record.std9Hours} hrs", "\u{20B9}${record.std9Amount?.toStringAsFixed(2)}"),
        const SizedBox(height: 4),
        _dataRow("Std 10 Hours", "${record.std10Hours} hrs", "\u{20B9}${record.std10Amount?.toStringAsFixed(2)}"),
        const SizedBox(height: 4),
        _dataRow("Days Worked", "${record.daysWorked.toInt()} / ${record.daysOfMonth?.toInt()}", ""),
      ],
    );
  }

  Widget _buildNonTeachingCardData(SalaryRecord record) {
    return Column(
      children: [
        _dataRow("Basic Salary", "\u{20B9}${record.basicSalary?.toStringAsFixed(2)}", ""),
        const SizedBox(height: 4),
        _dataRow("Days Worked", "${record.daysWorked.toInt()} / ${record.daysOfMonth?.toInt()}", "\u{20B9}${record.perDayRate?.toStringAsFixed(2)} / day"),
        const SizedBox(height: 4),
        _dataRow("Extra Hours", "${record.extraHoursPerDay} hrs/day", "\u{20B9}${record.extraHoursPay?.toStringAsFixed(2)}"),
      ],
    );
  }

  Widget _dataRow(String label, String value, String trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87)),
        Row(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (trailing.isNotEmpty) ...[
              const SizedBox(width: 10),
              Text(trailing, style: TextStyle(color: Colors.green[800], fontSize: 13)),
            ],
          ],
        ),
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
        staffCategory: widget.staff.category,
        hourlyRate: widget.staff.hourlyRate,
      ),
    );
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
              Navigator.pop(context);
              await context.read<StaffProvider>().deleteSalaryRecord(record.id);
              _loadRecords();
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
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
