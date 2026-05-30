import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FairUsePolicyModal extends StatelessWidget {
  const FairUsePolicyModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF5C5141),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            GestureDetector(
              onTap: () {
                // Optional: Navigate to full policy page
              },
              child: const Text(
                'fair use policy',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFD4AF37),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Policy Points
            _buildPolicyPoint(
              'Unlimited access is intended for personal and professional use within reasonable limits.',
            ),
            const SizedBox(height: 12),
            _buildPolicyPoint(
              'Excessive, automated, or abusive usage may be temporarily limited to ensure service quality for all users.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(
            Icons.circle,
            size: 6,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// কিভাবে ব্যবহার করবেন (GetX Style):
/*
Get.dialog(
  const FairUsePolicyModal(),
  barrierDismissible: true,
);
*/