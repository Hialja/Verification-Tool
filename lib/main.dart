import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/models/verification.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(VerificationAdapter());
  await Hive.openBox<Verification>('verifications');
  runApp(const VerificationTool());
}

class VerificationTool extends StatelessWidget {
  const VerificationTool({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verification Tool',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}