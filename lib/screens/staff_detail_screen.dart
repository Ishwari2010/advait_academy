import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/staff_model.dart";
import "../models/salary_record_model.dart";
import "../providers/staff_provider.dart";
import "../widgets/add_salary_bottom_sheet.dart";

class StaffDetailScreen extends StatelessWidget {
  final StaffModel staff;

  const StaffDetailScreen({super.key, required this.staff});

  String _getMonthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    if (month < 1 || month > 12) return "Unknown";
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(staff.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildRecordsList(context),
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
              Text(staff.category,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w600)),
              Text("Rate: \u{20B9}${staff.hourlyRate.toInt()}/hr",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 15),
          StreamBuilder<List<SalaryRecord>>(
            stream: context.read<StaffProvider>().getSalaryRecordsStream(staff.id),
            builder: (context, snapshot) {
              double totalPaid = 0;
              if (snapshot.hasData) {
                totalPaid = snapshot.data!.fold(0.0, (sum, item) => sum + item.calculatedSalary);
              }
              return Card(
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
                      Text("\u{20B9}${totalPaid.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList(BuildContext context) {
    return StreamBuilder<List<SalaryRecord>>(
      stream: context.read<StaffProvider>().getSalaryRecordsStream(staff.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final records = snapshot.data ?? [];
        if (records.isEmpty) {
          return const Center(child: Text("No records found"));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
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
                          icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                          onPressed: () => context.read<StaffProvider>().deleteSalaryRecord(record.id),
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

  void _showAddSalary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddSalaryBottomSheet(
        staffId: staff.id,
        hourlyRate: staff.hourlyRate,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Staff"),
        content: Text("Are you sure you want to delete ${staff.name}? This will also delete all salary records."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await Provider.of<StaffProvider>(context, listen: false).deleteStaff(staff.id);
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
