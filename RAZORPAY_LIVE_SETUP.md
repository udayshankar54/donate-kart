# DonateKart: Live Keys Setup & Production Configuration

## 🎯 Overview

This guide explains how to transition from **test mode** to **production** with live Razorpay keys.

## 📋 Prerequisites

Before switching to live keys, ensure:
- ✅ App is fully tested with test keys
- ✅ Payment flow works end-to-end
- ✅ All UI/UX is finalized
- ✅ Error handling is complete
- ✅ Firebase is configured for production

## 🔄 Step 1: Create Razorpay Business Account

### Sign Up
1. Go to: https://razorpay.com
2. Click "Sign Up" → Business Account
3. Enter email, set password
4. Verify email address

### Fill Business Details
1. Business name (NGO name or organization)
2. Business type (select "Non-Profit" if applicable)
3. Business address
4. Phone number
5. Website URL (your app's domain)

### KYC Verification (Know Your Customer)
1. Upload ID proof (Aadhar/PAN/Passport)
2. Upload address proof (utility bill/rental agreement)
3. Upload business registration (if applicable)
4. Wait for Razorpay verification (24-48 hours)

### Bank Account Setup
1. Add bank account details
2. Razorpay will deposit small amounts to verify
3. Confirm the amounts in your bank statement
4. Activation complete!

## 🔑 Step 2: Get Your Live API Keys

### Access API Keys Dashboard
1. Login to: https://dashboard.razorpay.com
2. Go to **Settings** → **API Keys**
3. You'll see two sections: **Test** and **Live**

### Copy Live Keys
```
Live Key ID:     rzp_live_XXXXXXXXXX
Live Key Secret: (keep this completely private!)
```

**Example:**
```
Live Key ID:     rzp_live_2Z0bYkl3qL5Ky9Jm
```

⚠️ **CRITICAL**: Live Secret should NEVER be exposed to client-side code!

## 🔧 Step 3: Update DonateKart Code

### Option A: Manual Update (Simple, less secure)

Edit `lib/services/payment_service.dart`:

**Line ~115:**
```dart
// BEFORE (Test)
'key': 'rzp_test_Su6JKatWTnd2Gd',

// AFTER (Live)
'key': 'rzp_live_2Z0bYkl3qL5Ky9Jm',  // Replace with YOUR live key
```

⚠️ **Warning**: This commits your live key to Git!

### Option B: Environment Variables (Recommended for Security)

1. **Create `.env` file** in project root:
```
RAZORPAY_TEST_KEY=rzp_test_Su6JKatWTnd2Gd
RAZORPAY_LIVE_KEY=rzp_live_YOUR_ACTUAL_KEY_HERE
APP_ENV=production
```

2. **Add to `.gitignore`:**
```
.env
.env.local
```

3. **Install `flutter_dotenv` package:**
```bash
flutter pub add flutter_dotenv
```

4. **Update `lib/main.dart`:**
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  
  // Initialize with env key
  final razorpayKey = dotenv.env['RAZORPAY_LIVE_KEY'];
  
  runApp(const MyApp());
}
```

5. **Update `pubspec.yaml`:**
```yaml
flutter:
  assets:
    - .env
```

## 🚀 Step 4: Build for Production

### Web Build
```bash
flutter build web --release
```

### Android Build
```bash
flutter build apk --release
# or AAB (for Play Store)
flutter build appbundle --release
```

### iOS Build
```bash
flutter build ios --release
```

## 📱 Step 5: Deploy to App Stores

### Google Play Store
1. Create developer account: https://play.google.com/console
2. Create new app
3. Upload `.aab` file (from `build/app/outputs/bundle/release/`)
4. Fill store listing, pricing, content rating
5. Submit for review (2-3 hours approval)

### Apple App Store
1. Create developer account: https://developer.apple.com
2. Use Xcode to archive and upload
3. Fill app information
4. Submit for review (1-2 days approval)

### Web Hosting
1. Upload built web files to hosting service
2. Configure domain/SSL certificate
3. Update website in Razorpay dashboard

## ✅ Live Keys Checklist

Before going live, verify:

- [ ] Razorpay account is fully verified
- [ ] KYC is approved
- [ ] Bank account is linked
- [ ] Live keys are generated
- [ ] Test payments still work with test keys
- [ ] Code updated with live key (or env variable)
- [ ] Release build is created
- [ ] Firebase is set to production
- [ ] SSL certificate is valid (HTTPS)
- [ ] Payment success/error handlers work
- [ ] Email notifications are configured
- [ ] Backup payment method is ready (UPI)
- [ ] Support email is functional
- [ ] Terms & Privacy policy are ready

## 🔒 Security Best Practices

### For Client-Side (Web/Mobile):
- ✅ Store only **Live Key ID** (public)
- ❌ NEVER store **Live Key Secret** on client
- ✅ Use environment variables
- ✅ Rotate keys periodically

### For Server-Side (Backend):
- Store **Live Key Secret** only on backend
- Use for payment verification
- Never expose in logs or errors
- Use GitHub Secrets for CI/CD

### General Security:
```bash
# Add to .gitignore
.env
.env.local
.env.*.local
*.pem
*.key
credentials.json
```

## 📊 Monitoring Live Payments

### Dashboard Monitoring
1. Go to: https://dashboard.razorpay.com
2. **Transactions** tab - view all payments
3. **Analytics** - donation trends
4. **Payouts** - settlement to bank account

### Handle Failed Payments
```dart
// In payment error handler
void _handlePaymentFailure(String error) {
  // Log to Firebase
  FirebaseAnalytics.instance.logEvent(
    name: 'payment_failed',
    parameters: {'error': error}
  );
  
  // Show user-friendly message
  _showErrorDialog(error);
  
  // Retry option
  _suggestRetryPayment();
}
```

### Refunds (if needed)
1. Go to transaction in dashboard
2. Click "Refund" button
3. Select refund amount
4. Confirm refund

## 🧪 Testing Live Keys in Sandbox

Razorpay offers a sandbox environment:

### Sandbox Cards
- **Success**: 4111 1111 1111 1111
- **Failure**: 4000 0000 0000 0002
- **OTP Required**: 4000 0000 0000 0051

### Switching Between Test/Live

In code:
```dart
// Determine based on environment
const bool isLiveMode = bool.fromEnvironment('LIVE_MODE', defaultValue: false);

final razorpayKey = isLiveMode 
    ? 'rzp_live_YOUR_KEY'
    : 'rzp_test_Su6JKatWTnd2Gd';
```

Build with flag:
```bash
# Test
flutter run

# Production/Live
flutter run --dart-define=LIVE_MODE=true
```

## 🆘 Troubleshooting

### Payment Modal Not Opening
- Verify Razorpay script is loaded: Check browser console
- Confirm API key is valid
- Check network requests in DevTools

### "Unauthorized" Error
- Verify live key is correct
- Check account status in dashboard
- Ensure KYC is approved

### Payments Not Appearing in Dashboard
- Check transaction status
- Verify API key is correct
- Check for network errors

### Settlement Issues
- Go to **Settings** → **Payouts**
- Verify bank account details
- Check payout status and scheduled dates

## 📞 Support

- **Razorpay Support**: https://razorpay.com/support/
- **Documentation**: https://razorpay.com/docs/
- **Email**: support@razorpay.com
- **Phone**: +91-80-4150-5555

## 🎉 Going Live Timeline

| Phase | Duration | Action |
|-------|----------|--------|
| Development | Ongoing | Test with test keys |
| KYC | 1-2 days | Submit documents |
| Verification | 24-48 hrs | Razorpay reviews |
| Setup | 1 day | Configure live keys |
| Testing | 1-2 days | Test with live keys |
| Build Release | 1 day | Create release build |
| App Store Review | 2-3 days | Play Store approval |
| App Store Review | 1-2 days | Apple Store approval |
| **LIVE** | ✅ | App goes live! |

---

**Your app is ready to accept real donations!** 🚀

Questions? Check PAYMENT_SETUP_GUIDE.md for technical details.
