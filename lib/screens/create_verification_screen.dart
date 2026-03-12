import 'package:flutter/material.dart';
import 'package:verification_tool/models/verification.dart';

class CreateVerificationScreen extends StatefulWidget {
  const CreateVerificationScreen({super.key});

  @override
  State<CreateVerificationScreen> createState() =>
      _CreateVerificationScreenState();
}

class _CreateVerificationScreenState extends State<CreateVerificationScreen> {

  final _formKey = GlobalKey<FormState>();

  final employeeController = TextEditingController();
  final companyController = TextEditingController();
  final addressController = TextEditingController();
  final respController = TextEditingController();
  final contactController = TextEditingController();
  final notesController = TextEditingController();

  void saveVerification() {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final verification = Verification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      employeeName: employeeController.text.trim(),
      companyName: companyController.text.trim(),
      companyAddress: addressController.text.trim(),
      respName: respController.text.trim(),
      contactNumber: contactController.text.trim(),
      notes: notesController.text.trim(),
      visitDate: DateTime.now(),
    );

    Navigator.pop(context, verification);
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number required";
    }

    if (!RegExp(r'^[0-9+\-\s]{6,20}$').hasMatch(value)) {
      return "Invalid phone number";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Verification'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [

              const Text(
                "Verification Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: employeeController,
                validator: requiredValidator,
                decoration: inputDecoration("Employee Name", Icons.person),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: companyController,
                validator: requiredValidator,
                decoration: inputDecoration("Company Name", Icons.business),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: addressController,
                validator: requiredValidator,
                decoration: inputDecoration("Company Address", Icons.location_on),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: respController,
                validator: requiredValidator,
                decoration: inputDecoration("Manager Name", Icons.badge),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: contactController,
                validator: phoneValidator,
                keyboardType: TextInputType.phone,
                decoration: inputDecoration("Manager Phone", Icons.phone),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: inputDecoration("Notes", Icons.note),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: saveVerification,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Verification"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}