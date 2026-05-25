import 'package:flutter/material.dart';
import '../main.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double amount;
  final String userEmail;
  final String userName;
  final VoidCallback onRazorpaySelected;
  final Function(String upiId) onUPISelected;

  const PaymentMethodScreen({
    Key? key,
    required this.amount,
    required this.userEmail,
    required this.userName,
    required this.onRazorpaySelected,
    required this.onUPISelected,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool _showUPIInput = false;
  bool _showQRDisplay = false;
  final TextEditingController _upiController = TextEditingController();

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showUPIInput) {
      return _buildUPIInputUI(context);
    }

    if (_showQRDisplay) {
      return _buildQRDisplayUI(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: AppColors.emerald,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Amount Summary
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.emeraldSoft,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.slate,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹ ${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'To: ${widget.userName}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Payment Methods
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Razorpay Method
                  _buildPaymentMethodCard(
                    title: 'Card / Wallet / Net Banking',
                    subtitle: 'Razorpay Payment Gateway',
                    icon: Icons.credit_card,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onRazorpaySelected();
                    },
                  ),
                  const SizedBox(height: 16),
                  // UPI Method
                  _buildPaymentMethodCard(
                    title: 'UPI Payment',
                    subtitle: 'Google Pay, PhonePe, Paytm',
                    icon: Icons.phone_android,
                    onTap: () {
                      setState(() => _showUPIInput = true);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Show UPI Details
                  _buildPaymentMethodCard(
                    title: 'DonateKart UPI',
                    subtitle: 'Our UPI: donatekartngo@ibl',
                    icon: Icons.info,
                    onTap: () {
                      setState(() => _showQRDisplay = true);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.slateLight.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.emeraldSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.emerald, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.slateLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.slateLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUPIInputUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your UPI ID'),
        backgroundColor: AppColors.emerald,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _showUPIInput = false),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blueSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.blue, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: const Text(
                        'Enter your UPI ID to complete the payment securely',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.slate,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Amount Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.emeraldSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment Amount:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.slate,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₹${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // UPI Input Field
              const Text(
                'Your UPI ID',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _upiController,
                decoration: InputDecoration(
                  hintText: 'username@upi',
                  hintStyle: const TextStyle(color: AppColors.slateLight),
                  prefixIcon: const Icon(
                    Icons.phone_android,
                    color: AppColors.emerald,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.slateLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.slateLight.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.emerald,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              const Text(
                'Format: username@bankname (e.g., john@okhdfcbank)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.slateLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 32),
              // Payment Methods Info
              const Text(
                'Common UPI Apps',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUPIAppInfo('Google Pay', Icons.payment),
                  _buildUPIAppInfo('PhonePe', Icons.wallet_membership),
                  _buildUPIAppInfo('Paytm', Icons.account_balance_wallet),
                ],
              ),
              const SizedBox(height: 32),
              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final upiId = _upiController.text.trim();
                    if (upiId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your UPI ID'),
                        ),
                      );
                      return;
                    }
                    if (!upiId.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid UPI ID format')),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    widget.onUPISelected(upiId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUPIAppInfo(String name, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.emerald, size: 32),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.slate,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQRDisplayUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DonateKart UPI'),
        backgroundColor: AppColors.emerald,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _showQRDisplay = false),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: 24),
              // Amount Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.emeraldSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Amount to Pay',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.slate,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '₹${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // UPI Details
              const Text(
                'UPI Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.emerald),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'donatekartngo@ibl',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: AppColors.emerald),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('UPI ID copied to clipboard'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Beneficiary Name
              const Text(
                'Beneficiary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.orangeSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'DonateKart NGO',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blueSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Open any UPI app (Google Pay, PhonePe, Paytm, etc.)\n'
                      '• Select "Send Money" or "Send to UPI ID"\n'
                      '• Enter: donatekartngo@ibl\n'
                      '• Enter amount: ₹${widget.amount.toStringAsFixed(2)}\n'
                      '• Complete the transaction with your PIN\n'
                      '• Your donation will be confirmed automatically',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.slate,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    widget.onUPISelected('donatekartngo@ibl');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm & Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
