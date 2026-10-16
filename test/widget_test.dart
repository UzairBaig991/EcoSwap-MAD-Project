import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoswap/main.dart';

void main() {
  testWidgets('EcoSwap smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EcoSwapApp(),
      ),
    );
  });
}
