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
      appBar: AppBar(title: const Text("Verifications")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Verification> box, _) {

          final verifications = box.values.toList();

          return ListView.builder(
            itemCount: verifications.length,
            itemBuilder: (context, index) {

              final v = verifications[index];

              return GestureDetector(
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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
    );
  }
}
