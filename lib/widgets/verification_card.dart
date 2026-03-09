import 'package:flutter/material.dart';
import '../models/verification.dart';

class VerificationCard extends StatelessWidget {
  final Verification verification;

  const VerificationCard({super.key, required this.verification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.verified, size: 40, color: Colors.blue,),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(verification.companyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),

                  const SizedBox(height: 4,),

                  Text(
                    verification.employeeName,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 4,),

                  Text(
                    "Date: ${verification.visitDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16,)
          ],
        ),
      ),
    );
  }
}
