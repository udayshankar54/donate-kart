import 'package:donate_kart/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DonateKart starts on splash and opens home', (tester) async {
    await tester.pumpWidget(const DonateKartApp());

    expect(find.text('DonateKart'), findsOneWidget);
    expect(find.text('Delivering Hope, Box by Box.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();

    expect(find.text('How would you like to help?'), findsOneWidget);
    expect(find.text('Browse Kits'), findsWidgets);
  });
}
