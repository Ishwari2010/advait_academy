import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/salary_record_model.dart";
import "../providers/staff_provider.dart";

class AddSalaryBottomSheet extends StatefulWidget {
  final String staffId;
  final double hourlyRate;

  const AddSalaryBottomSheet({
    super.key,
    required this.staffId,
    required this.hourlyRate,
  });

  @override
  State<AddSalaryBottomSheet> createState() => _AddSalaryBottomSheetState();
}

class _AddSalaryBottomSheetState extends State<AddSalaryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _selectedMonthName = "January";
  int _selectedYear = 2024;
  final _daysController = TextEditingController();
  final _hoursController = TextEditingController();

  double _calculatedSalary = 0;
  double _totalHoursResult = 0;

  final List<String> _months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  final List<int> _years = [2023, 2024, 2025, 2026];

  void _calculate() {
    final days = double.tryParse(_daysController.text) ?? 0;
    final hours = double.tryParse(_hoursController.text) ?? 0;
    setState(() {
      _totalHoursResult = days * hours;
      _calculatedSalary = _totalHoursResult * widget.hourlyRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add Monthly Entry",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.green[800]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMonthName,
                      decoration: const InputDecoration(labelText: "Month"),
                      items: _months.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (val) => setState(() => _selectedMonthName = val!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedYear,
                      decoration: const InputDecoration(labelText: "Year"),
                      items: _years.map((y) => DropdownMenuItem(value: y, child: Text(y.toString()))).toList(),
                      onChanged: (val) => setState(() => _selectedYear = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _daysController,
                decoration: const InputDecoration(labelText: "Days Worked", hintText: "e.g. 26"),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
                validator: (val) => (val == null || val.isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(labelText: "Hours Per Day", hintText: "e.g. 8"),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
                validator: (val) => (val == null || val.isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  children: [
                    Text("Total Hours: ${_totalHoursResult.toStringAsFixed(1)}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(
                      "Calculated Salary: \u{20B9}${_calculatedSalary.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final record = SalaryRecord(
                      id: "",
                      staffId: widget.staffId,
                      month: _months.indexOf(_selectedMonthName) + 1, // Convert to 1-12 integer
                      year: _selectedYear,
                      daysWorked: double.parse(_daysController.text),
                      hoursPerDay: double.parse(_hoursController.text),
                      totalHours: _totalHoursResult,
                      hourlyRate: widget.hourlyRate,
                      calculatedSalary: _calculatedSalary,
                      createdAt: DateTime.now(),
                    );
                    try {
                      await context.read<StaffProvider>().addSalaryRecord(record);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Salary record added successfully!")),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.toString()}")),
                        );
                      }
                    }
                  }
                },
                child: const Text("Confirm & Save"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
