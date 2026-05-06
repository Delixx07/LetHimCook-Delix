import 'package:flutter_test/flutter_test.dart';
import 'package:tes_1/main.dart';

void main() {
  testWidgets('ChefPintar app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ChefPintarApp());

    // Verifikasi halaman input muncul
    expect(find.text('ChefPintar'), findsOneWidget);
    expect(find.text('Cari Resep'), findsOneWidget);
  });
}
