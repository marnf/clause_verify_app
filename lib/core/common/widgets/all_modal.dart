// ==================== 1. LANGUAGE MODAL ====================
// File: lib/core/common/widgets/modals/language_modal.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ==================== 2. ANALYSIS LIMIT MODAL ====================
// File: lib/core/common/widgets/modals/analysis_limit_modal.dart

class AnalysisLimitModal extends StatelessWidget {
  final VoidCallback onUpgrade;

  const AnalysisLimitModal({
    Key? key,
    required this.onUpgrade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE8DCC4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 8),

            // Warning Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'OPPS!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            const Text(
              'You\'ve reached your analysis limit!\n\nUpgrade to Premium for 100 analyses per month, no ads, and full detailed reports.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Upgrade Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  onUpgrade();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade to Premium',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage:
/*
Get.dialog(
  AnalysisLimitModal(
    onUpgrade: () {
      Get.toNamed(AppRoute.premiumScreen);
    },
  ),
);
*/


// ==================== 3. PREMIUM SUBSCRIPTION MODAL ====================
// File: lib/core/common/widgets/modals/premium_subscription_modal.dart

class PremiumSubscriptionModal extends StatelessWidget {
  final VoidCallback onPayPerScan;
  final VoidCallback onUpgradeToPremium;

  const PremiumSubscriptionModal({
    Key? key,
    required this.onPayPerScan,
    required this.onUpgradeToPremium,
  }) : super(key: key);

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
            const SizedBox(height: 8),

            // Document Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Colors.black,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'PDF Report Available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Color(0xFFCCCCCC),
                  fontSize: 14,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: 'PDF reports are available only with\nthe '),
                  TextSpan(
                    text: 'Premium Analysis(\$5.49)',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' or with\na '),
                  TextSpan(
                    text: 'Premium Subscription',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pay-Per-Scan Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pay-Per-Scan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\$5.49',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Get Premium Analysis Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  onPayPerScan();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Premium Analysis',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Premium Subscription Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Premium Subscription',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\$11.99 or \$89.99',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Upgrade to Premium Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  onUpgradeToPremium();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade to Premium',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage:
/*
Get.dialog(
  PremiumSubscriptionModal(
    onPayPerScan: () {
      Get.toNamed(AppRoute.subscriptionScreen);
    },
    onUpgradeToPremium: () {
      Get.toNamed(AppRoute.subscriptionScreen);
    },
  ),
);
*/


// ==================== 4. FAIR USE POLICY MODAL ====================
// File: lib/core/common/widgets/modals/fair_use_policy_modal.dart

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

// Usage:
/*


// 2. Analysis Limit Modal
Get.dialog(
  AnalysisLimitModal(
    onUpgrade: () {
      Get.toNamed(AppRoute.premiumScreen);
    },
  ),
);

// 3. Premium Subscription Modal
Get.dialog(
  PremiumSubscriptionModal(
    onPayPerScan: () {
      Get.toNamed(AppRoute.subscriptionScreen);
    },
    onUpgradeToPremium: () {
      Get.toNamed(AppRoute.premiumScreen);
    },
  ),
);

// 4. Fair Use Policy Modal
Get.dialog(
  const FairUsePolicyModal(),
);
*/