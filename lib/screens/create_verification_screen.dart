import 'package:flutter/material.dart';
import 'package:verification_tool/models/verification.dart';



class CreateVerificationScreen extends StatefulWidget {
  const CreateVerificationScreen({super.key});

  @override
  State<CreateVerificationScreen> createState() => _CreateVerificationScreenState();
}

class _CreateVerificationScreenState extends State<CreateVerificationScreen> {

  final employeeController = TextEditingController();
  final companyController = TextEditingController();
  final addressController = TextEditingController();
  final respController = TextEditingController();
  final contactController = TextEditingController();
  final notesController = TextEditingController();

  void saveVerification() {
    final verification = Verification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      employeeName: employeeController.text,
      companyName: companyController.text,
      companyAddress: addressController.text,
      respName: respController.text,
      contactNumber: contactController.text,
      notes: notesController.text,
      visitDate: DateTime.now(),
    );

    Navigator.pop(context, verification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: employeeController, decoration: const InputDecoration(labelText: "Employee Name")),
            TextField(controller: companyController, decoration: const InputDecoration(labelText: "Company Name")),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "Company Address")),
            TextField(controller: respController, decoration: const InputDecoration(labelText: "Manager Name")),
            TextField(controller: contactController, decoration: const InputDecoration(labelText: "Manager Phone")),
            TextField(controller: notesController, decoration: const InputDecoration(labelText: "Notes")),
            
            const SizedBox(height: 20),
            
            ElevatedButton(onPressed: saveVerification, child: const Text('Save')),


          ],

        ),

      ),

    );
  }
}
