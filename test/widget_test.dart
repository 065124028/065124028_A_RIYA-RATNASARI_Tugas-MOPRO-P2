import 'package:flutter_test/flutter_test.dart';

import 'package:app1/main.dart';

void main() {
  testWidgets('Welcome page -> ketuk -> masuk ke Beranda', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Mulai Pesan'), findsOneWidget);

    await tester.tap(find.text('Mulai Pesan'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Menu Hari Ini'), findsOneWidget);
    expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
  });
}