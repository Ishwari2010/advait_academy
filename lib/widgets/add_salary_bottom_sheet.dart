import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/salary_record_model.dart";
import "../providers/staff_provider.dart";

class AddSalaryBottomSheet extends StatefulWidget {
  final String staffId;
  final String staffCategory;
  final double hourlyRate;

  const AddSalaryBottomSheet({
    super.key,
    required this.staffId,
    required this.staffCategory,
    required this.hourlyRate,
  });

  @override
  State<AddSalaryBottomSheet> createState() => _AddSalaryBottomSheetState();
}

class _AddSalaryBottomSheetState extends State<AddSalaryBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _daysOfMonthController = TextEditingController();
  final _daysWorkedController = TextEditingController();

  final _std9HoursController = TextEditingController();
  final _std10HoursController = TextEditingController();
  double _std9Amount = 0;
  double _std10Amount = 0;

  final _basicSalaryController = TextEditingController(text: "7000");
  final _extraHoursController = TextEditingController();
  double _perDayRate = 0;
  double _perHourRate = 0;
  double _basicEarned = 0;
  double _extraPay = 0;
  double _totalExtraHoursCount = 0;

  double _totalSalary = 0;

  @override
  void initState() {
    super.initState();
    _daysOfMonthController.addListener(_calculate);
    _daysWorkedController.addListener(_calculate);
    _std9HoursController.addListener(_calculate);
    _std10HoursController.addListener(_calculate);
    _basicSalaryController.addListener(_calculate);
    _extraHoursController.addListener(_calculate);
  }

  void _calculate() {
    final dom = double.tryParse(_daysOfMonthController.text) ?? 1;
    final dw = double.tryParse(_daysWorkedController.text) ?? 0;

    if (widget.staffCategory == "Teaching") {
      final s9h = double.tryParse(_std9HoursController.text) ?? 0;
      final s10h = double.tryParse(_std10HoursController.text) ?? 0;
      
      setState(() {
        _std9Amount = s9h * 100;
        _std10Amount = s10h * 200;
        _totalSalary = _std9Amount + _std10Amount;
      });
    } else {
      final basic = double.tryParse(_basicSalaryController.text) ?? 0;
      final totalH = double.tryParse(_extraHoursController.text) ?? 0;

      setState(() {
        _totalExtraHoursCount = totalH;
        _perDayRate = basic / (dom > 0 ? dom : 1);
        _perHourRate = _perDayRate / 3;
        _basicEarned = _perDayRate * dw;
        _extraPay = totalH * _perHourRate;
        _totalSalary = _basicEarned + _extraPay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTeaching = widget.staffCategory == "Teaching";

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
                "Add Salary Entry (${widget.staffCategory})",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.green[800]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              if (isTeaching) ..._buildTeachingFields() else ..._buildNonTeachingFields(),

              const SizedBox(height: 20),
              _buildCalculationSummary(isTeaching),
              const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: () => _saveRecord(context),
                child: const Text("Confirm & Save"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTeachingFields() {
    return [
      TextFormField(
        controller: _daysOfMonthController,
        decoration: const InputDecoration(labelText: "Days of Month", hintText: "e.g. 30"),
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: _daysWorkedController,
        decoration: const InputDecoration(labelText: "Days Worked", hintText: "e.g. 26"),
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _std9HoursController,
              decoration: const InputDecoration(labelText: "Std 9 Hrs", hintText: "Hours"),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _std10HoursController,
              decoration: const InputDecoration(labelText: "Std 10 Hrs", hintText: "Hours"),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildNonTeachingFields() {
    return [
      TextFormField(
        controller: _basicSalaryController,
        decoration: const InputDecoration(labelText: "Basic Salary (\u{20B9})", hintText: "7000"),
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _daysOfMonthController,
              decoration: const InputDecoration(labelText: "Days of Month"),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _daysWorkedController,
              decoration: const InputDecoration(labelText: "Days Worked"),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: _extraHoursController,
        decoration: const InputDecoration(
          labelText: "Total Extra Hours (Whole Month)", 
          hintText: "Total extra hours beyond 3hrs/day this month"
        ),
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    ];
  }

  Widget _buildCalculationSummary(bool isTeaching) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          if (isTeaching) ...[
            _summaryRow("Std 9 Amount", _std9Amount),
            _summaryRow("Std 10 Amount", _std10Amount),
          ] else ...[
            _summaryRow("Per Day Rate", _perDayRate),
            _summaryRow("Per Hour Rate", _perHourRate),
            _summaryRow("Basic Earned", _basicEarned),
            _summaryRow("Total Extra Hours", _totalExtraHoursCount),
            _summaryRow("Extra Hours Pay", _extraPay),
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Salary:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("\u{20B9}${_totalSalary.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value) {
    bool isMoney = label.contains("Amount") || label.contains("Pay") || label.contains("Salary") || label.contains("Rate") || label.contains("Earned");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(isMoney ? "\u{20B9}${value.toStringAsFixed(2)}" : "${value.toInt()} hrs", 
               style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _saveRecord(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final isTeaching = widget.staffCategory == "Teaching";

      final record = SalaryRecord(
        id: "",
        staffId: widget.staffId,
        month: isTeaching ? null : now.month,
        year: isTeaching ? null : now.year,
        daysWorked: double.parse(_daysWorkedController.text),
        createdAt: now,
        daysOfMonth: double.parse(_daysOfMonthController.text),
        std9Hours: double.tryParse(_std9HoursController.text),
        std10Hours: double.tryParse(_std10HoursController.text),
        std9Amount: _std9Amount,
        std10Amount: _std10Amount,
        basicSalary: double.tryParse(_basicSalaryController.text),
        extraHoursPerDay: double.tryParse(_extraHoursController.text),
        perDayRate: _perDayRate,
        perHourRate: _perHourRate,
        extraHoursPay: _extraPay,
        totalSalary: _totalSalary,
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
  }

  @override
  void dispose() {
    _daysOfMonthController.dispose();
    _daysWorkedController.dispose();
    _std9HoursController.dispose();
    _std10HoursController.dispose();
    _basicSalaryController.dispose();
    _extraHoursController.dispose();
    super.dispose();
  }
}
