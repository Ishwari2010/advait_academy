import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/staff_model.dart";
import "../providers/staff_provider.dart";
import "add_staff_screen.dart";
import "staff_detail_screen.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Advait Academy"),
          bottom: TabBar(
            onTap: (index) {
              final provider = context.read<StaffProvider>();
              provider.setCategory(index == 0 ? "Teaching" : "Non-Teaching");
            },
            tabs: const [
              Tab(text: "Teaching Staff"),
              Tab(text: "Non-Teaching Staff"),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: Consumer<StaffProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<List<StaffModel>>(
              stream: provider.getStaffStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                final staffList = snapshot.data ?? [];
                if (staffList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 80, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No staff added yet.", style: TextStyle(color: Colors.grey, fontSize: 18)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: staffList.length,
                  itemBuilder: (context, index) {
                    final staff = staffList[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[100],
                          child: Icon(Icons.person, color: Colors.green[800]),
                        ),
                        title: Text(staff.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${staff.category} - Hourly Rate: \u{20B9}${staff.hourlyRate.toInt()}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StaffDetailScreen(staff: staff),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddStaffScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
