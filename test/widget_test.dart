import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';
import 'package:campus_event_explorer/widgets/event_card.dart';

void main() {
  testWidgets('App loads and displays initial events and tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    expect(find.text('Keşfet'), findsWidgets);
    expect(find.text('Favoriler'), findsWidgets);
    expect(find.text('Etkinliklerim'), findsWidgets);
    expect(find.byType(EventCard), findsWidgets);
  });

  testWidgets('Search ignores case and surrounding spaces and can be cleared',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    // Search with surrounding spaces and lowercase
    await tester.enterText(searchField, '   iha   ');
    await tester.pumpAndSettle();

    expect(find.textContaining('Zirvesi', findRichText: true), findsOneWidget);

    // Empty search when typing nonsense
    await tester.enterText(searchField, 'non_existent_event_xyz');
    await tester.pumpAndSettle();

    expect(find.text('Eşleşen Etkinlik Yok'), findsOneWidget);
    expect(find.text('Aramayı ve Filtreleri Temizle'), findsOneWidget);

    // Clear search using empty state button
    await tester.tap(find.text('Aramayı ve Filtreleri Temizle'));
    await tester.pumpAndSettle();

    expect(find.byType(EventCard), findsWidgets);
  });

  testWidgets('Navigation to details screen displays all info and back navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Tap first event card
    final firstCard = find.byType(EventCard).first;
    await tester.tap(firstCard);
    await tester.pumpAndSettle();

    // Verify detail screen elements (all information)
    expect(find.text('Etkinlik Hakkında'), findsOneWidget);
    expect(find.text('Tarih & Saat'), findsOneWidget);
    expect(find.text('Mekan & Konum'), findsOneWidget);
    expect(find.text('Kontenjan Durumu'), findsOneWidget);
    expect(find.text('Etkinlik Kodu (ID)'), findsOneWidget);

    // Ensure action button is scrolled into view
    final actionButton = find.text('Etkinliğe Katıl');
    await tester.ensureVisible(actionButton);
    expect(actionButton, findsOneWidget);

    // Normal Back navigation
    final backButton = find.byType(BackButton);
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
    } else {
      await tester.tap(find.byTooltip('Back'));
    }
    await tester.pumpAndSettle();

    expect(find.text('ESTÜ Kampüs Keşfet'), findsOneWidget);
  });

  testWidgets('Full event cannot be joined', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusEventExplorerApp());
    await tester.pumpAndSettle();

    // Search for full event to bring it into view
    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'Rektörlük');
    await tester.pumpAndSettle();

    final fullEventFinder = find.textContaining('Rektörlük Kupası');
    expect(fullEventFinder, findsOneWidget);

    await tester.tap(fullEventFinder);
    await tester.pumpAndSettle();

    // Scroll down to the action button
    final fullButtonText = find.text('Kontenjan Doldu');
    await tester.ensureVisible(fullButtonText);
    expect(fullButtonText, findsOneWidget);

    // Verify that the button is disabled (onPressed is null)
    final disabledButtonFinder = find.byWidgetPredicate(
      (widget) => widget is ElevatedButton && widget.onPressed == null,
    );
    expect(disabledButtonFinder, findsOneWidget);
  });
}
