import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:verification_tool/models/verification.dart';
import 'package:verification_tool/screens/verification_detail_screen.dart';

import '../widgets/verification_card.dart';
import 'create_verification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = Hive.box<Verification>('verifications');

  void addVerification(Verification verification) {
    box.add(verification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifications"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("New Verification"),
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateVerificationScreen(),
            ),
          );

          if (result != null) {
            addVerification(result);
          }
        },
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Verification> box, _) {

          final verifications = box.values.toList();

          /// EMPTY STATE
          if (verifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.assignment_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No verifications yet",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap the + button to create one",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          /// LIST
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: verifications.length,
              itemBuilder: (context, index) {

                final v = verifications[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VerificationDetailScreen(
                            verification: v,
                          ),
                        ),
                      );
                    },
                    child: VerificationCard(
                      verification: v,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}