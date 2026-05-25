import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../services/firestore_service.dart';
import '../models/payment_model.dart';
import '../models/user_model.dart';

class DonationPaymentScreen extends StatefulWidget {
  final String userId;
  final String? ngoId;
  final String? description;

  const DonationPaymentScreen({
    super.key,
    required this.userId,
    this.ngoId,
    this.description,
  });

  @override
  State<DonationPaymentScreen> createState() => _DonationPaymentScreenState();
}

class _DonationPaymentScreenState extends State<DonationPaymentScreen> {
  late PaymentService paymentService;
  late FirestoreService firestoreService;

  UserModel? userModel;
  bool isLoading = true;
  double amount = 500;
  String selectedAmount = '500';

  final predefinedAmounts = ['100', '500', '1000', '2500', '5000'];

  @override
  void initState() {
    super.initState();
    paymentService = PaymentService();
    firestoreService = FirestoreService();

    initializePayment();
    loadUserData();
  }

  Future<void> initializePayment() async {
    try {
      await paymentService.initialize(
        onSuccess: (PaymentModel payment) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful!')),
            );
            Navigator.of(context).pop({'success': true, 'payment': payment});
          }
        },
        onError: (String error) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> loadUserData() async {
    try {
      final user = await firestoreService.getUser(widget.userId);
      setState(() {
        userModel = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void processPayment() {
    if (userModel == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User data not loaded')));
      return;
    }

    paymentService.processPayment(
      paymentId: 'PAY_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      email: userModel!.email,
      phoneNumber: userModel!.phone ?? '+91XXXXXXXXXX',
      description: widget.description ?? 'Donation to DonateKart',
      metadata: {
        'userId': widget.userId,
        'ngoId': widget.ngoId,
        'type': 'donation',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Make a Donation')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Make a Donation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help Someone in Need',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your donation makes a difference in someone\'s life. Every donation counts!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Amount Section
            Text(
              'Select Amount',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                ...predefinedAmounts.map((amt) {
                  final isSelected = selectedAmount == amt;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmount = amt;
                        amount = double.parse(amt);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF059669)
                              : Colors.grey.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? const Color(0xFF059669).withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          '₹$amt',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFF059669)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                GestureDetector(
                  onTap: () => _showCustomAmountDialog(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Icon(Icons.add)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Custom Amount Input
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? amount;
                  selectedAmount = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Or Enter Custom Amount',
                hintText: 'Enter amount in rupees',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Amount Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Donation Summary',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Donation Amount:'),
                        Text(
                          '₹${amount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Processing Fee:'),
                        Text(
                          'Free',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF059669), width: 1),
              ),
              child: const Text(
                '✓ Your donation is secure and encrypted\n✓ Tax benefits available (80G exemption)\n✓ Instant donation confirmation',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Button
            ElevatedButton(
              onPressed: processPayment,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text(
                'Proceed to Payment',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),

            // Disclaimer
            Center(
              child: Text(
                'By proceeding, you agree to our Terms & Conditions',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomAmountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String customAmount = amount.toString();
        return AlertDialog(
          title: const Text('Enter Custom Amount'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => customAmount = value,
            decoration: const InputDecoration(
              hintText: 'Enter amount in rupees',
              prefixIcon: Icon(Icons.currency_rupee),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  amount = double.tryParse(customAmount) ?? amount;
                  selectedAmount = customAmount;
                });
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    paymentService.dispose();
    super.dispose();
  }
}
