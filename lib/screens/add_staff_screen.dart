import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/staff_model.dart";
import "../providers/staff_provider.dart";

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedCategory = "Teaching";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Staff")),
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
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: "Teaching", child: Text("Teaching Staff")),
                  DropdownMenuItem(value: "Non-Teaching", child: Text("Non-Teaching Staff")),
                ],
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 40),
              Consumer<StaffProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              // Force rate to 100 as per new requirements
                              final staff = StaffModel(
                                id: "",
                                name: _nameController.text,
                                category: _selectedCategory,
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
