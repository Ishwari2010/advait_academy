import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/staff_model.dart";
import "../providers/staff_provider.dart";

class AddStaffScreen extends StatefulWidget {
  final String category;

  const AddStaffScreen({super.key, required this.category});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add ${widget.category} Staff")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Staff Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) => (val == null || val.isEmpty) ? "Please enter staff name" : null,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category, color: Colors.green),
                    const SizedBox(width: 12),
                    Text(
                      "Category: ${widget.category}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Consumer<StaffProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final staff = StaffModel(
                                id: "",
                                name: _nameController.text,
                                category: widget.category,
                                hourlyRate: 100.0,
                                createdAt: DateTime.now(),
                              );
                              try {
                                await provider.addStaff(staff);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Staff added successfully!")),
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
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Save Staff Details"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
