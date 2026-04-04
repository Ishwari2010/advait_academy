import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:provider/provider.dart";
import "providers/staff_provider.dart";
import "screens/home_screen.dart";
import "widgets/app_theme.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://gehyyxeoqmgqbwzusfxw.supabase.co",
    anonKey: "sb_publishable_GQ288hyL4GMpwwouyVmYpQ_KfNCHBj4",
  );

  runApp(const AdvaitAcademyApp());
}

class AdvaitAcademyApp extends StatelessWidget {
  const AdvaitAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StaffProvider()),
      ],
      child: MaterialApp(
        title: "Advait Academy",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
