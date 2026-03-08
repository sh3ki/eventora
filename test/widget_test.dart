import 'package:flutter_test/flutter_test.dart';
import 'package:eventora/main.dart';

void main() {
  testWidgets('EventoraApp launches', (WidgetTester tester) async {
    await tester.pumpWidget(const EventoraApp());
    expect(find.byType(EventoraApp), findsOneWidget);
  });
}
