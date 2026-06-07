# DonateKart Payment Gateway Setup Guide

## Razorpay Configuration

### Test Environment (Current)
- **Test Key ID**: `rzp_test_Su6JKatWTnd2Gd`
- **Status**: Development & Testing
- **Features**: All payment methods available for testing

### Production Setup (Live)

#### Step 1: Get Your Razorpay Live Keys
1. Go to [Razorpay Dashboard](https://dashboard.razorpay.com)
2. Login to your Razorpay account
3. Navigate to **Settings → API Keys**
4. Copy your **Live Key ID** (starts with `rzp_live_`)
5. Copy your **Live Key Secret** (keep this secure!)

#### Step 2: Update Payment Service

Edit `/lib/services/payment_service.dart`:

```dart
// Line 113 - Replace test key with live key
'key': 'rzp_live_YOUR_LIVE_KEY_ID', // Replace with your actual live key
```

**Example:**
```dart
'key': 'rzp_live_2Z0bYkl3qL5Ky9Jm',
```

#### Step 3: Environment Variables (Recommended for Security)

Create a `.env` file in project root:
```
RAZORPAY_TEST_KEY=rzp_test_Su6JKatWTnd2Gd
RAZORPAY_LIVE_KEY=rzp_live_YOUR_KEY_HERE
APP_ENV=development
```

Then use in code:
```dart
final String razorpayKey = kReleaseMode 
    ? dotenv.env['RAZORPAY_LIVE_KEY']!
    : dotenv.env['RAZORPAY_TEST_KEY']!;
```

#### Step 4: Platform Configuration

**Android** (`android/app/build.gradle.kts`):
```kotlin
minSdk = 21 // Razorpay requires minimum SDK 21
```
✅ Already configured

**iOS** (`ios/Podfile`):
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'RAZORPAY_VERSION=1.4.5'
      ]
    end
  end
end
```

**Web** (`web/index.html`):
```html
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
```
✅ Already added

### Testing Payments

#### Test Mode Credentials
- **Card**: 4111 1111 1111 1111
- **Expiry**: Any future date (e.g., 12/25)
- **CVV**: Any 3 digits (e.g., 123)
- **Name**: Any name
- **Email**: test@example.com

#### Success Scenarios
- Complete the form and click Pay
- Payment auto-completes in test mode

#### Failure Scenarios
- Use card: 4000 0000 0000 0002 (will fail)
- Use any other invalid card format

### Payment Verification

#### On Web
- Check browser console for payment logs
- Verify payment status in success callback
- Check Razorpay Dashboard → Transactions

#### On Mobile
- Logs appear in Android Studio / Xcode console
- Check Razorpay Dashboard for transaction records
- Verify payment details in success callback

### Production Checklist

Before going live:
- [ ] Replace test key with live key in payment_service.dart
- [ ] Set `kReleaseMode` = true
- [ ] Remove all debug logs (or use debug flag)
- [ ] Test with real amounts on test server
- [ ] Verify SSL certificate (for web HTTPS)
- [ ] Set up payment success/failure callbacks to database
- [ ] Configure email notifications for payments
- [ ] Test payment failure scenarios
- [ ] Implement refund mechanism if needed
- [ ] Add fraud detection/verification

### Key Files Modified

1. **lib/services/payment_service.dart**
   - Line 113: Razorpay key configuration
   - Line 82-95: Platform detection (web vs mobile)

2. **web/index.html**
   - Line ~12: Razorpay checkout script

3. **android/app/build.gradle.kts**
   - minSdk = 21

### Support

- **Razorpay Docs**: https://razorpay.com/docs/
- **Flutter Package**: https://pub.dev/packages/razorpay_flutter
- **Test Keys Dashboard**: https://dashboard.razorpay.com/app/keys

### Security Notes

⚠️ **Never commit live keys to version control**
- Use environment variables
- Add `.env` to `.gitignore`
- Use GitHub Secrets for CI/CD
- Rotate keys periodically

### UPI Integration

Organization UPI: **7488126152@pytes** (Paytm account)
- User can transfer directly to this UPI
- No gateway fees for direct UPI
- Manual verification required
