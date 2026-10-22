import 'package:flutter_test/flutter_test.dart';

import 'package:jelajah_malang/main.dart';

void main() {
  testWidgets('Aplikasi dapat dijalankan', (WidgetTester tester) async {
    await tester.pumpWidget(const JelajahMalangApp());
    expect(find.byType(JelajahMalangApp), findsOneWidget);
  });
}
