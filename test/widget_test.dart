import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:temperature_converter/main.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());
    await tester.pumpAndSettle();
  }

  testWidgets('shows title, input, two conversion choices and placeholder',
      (tester) async {
    await pumpApp(tester);

    expect(find.text('Temperature Converter'), findsOneWidget);
    expect(find.byKey(const Key('temperatureInput')), findsOneWidget);
    expect(find.byKey(const Key('conversionDropdown')), findsOneWidget);
    expect(find.text('Convert'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);

    await tester.tap(find.byKey(const Key('conversionDropdown')));
    await tester.pumpAndSettle();
    expect(find.text('Celsius to Fahrenheit (°C → °F)'), findsWidgets);
    expect(find.text('Fahrenheit to Celsius (°F → °C)'), findsOneWidget);
  });

  testWidgets('converts Celsius to Fahrenheit', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byKey(const Key('temperatureInput')), '100');
    await tester.tap(find.byKey(const Key('convertButton')));
    await tester.pumpAndSettle();

    expect(find.text('212.00 °F'), findsOneWidget);
  });

  testWidgets('converts Fahrenheit to Celsius', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('conversionDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fahrenheit to Celsius (°F → °C)').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('temperatureInput')), '72');
    await tester.tap(find.byKey(const Key('convertButton')));
    await tester.pumpAndSettle();

    expect(find.text('22.22 °C'), findsOneWidget);
  });

  testWidgets('accepts negative decimal temperatures', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byKey(const Key('temperatureInput')), '-40.5');
    await tester.tap(find.byKey(const Key('convertButton')));
    await tester.pumpAndSettle();

    expect(find.text('-40.90 °F'), findsOneWidget);
  });

  testWidgets('shows an error for empty input', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('convertButton')));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a temperature.'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('shows an error for malformed numeric input', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byKey(const Key('temperatureInput')), '--');
    await tester.tap(find.byKey(const Key('convertButton')));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid number.'), findsOneWidget);
  });

  testWidgets('clears an old result when the input changes', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byKey(const Key('temperatureInput')), '100');
    await tester.tap(find.byKey(const Key('convertButton')));
    await tester.pumpAndSettle();
    expect(find.text('212.00 °F'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('temperatureInput')), '50');
    await tester.pumpAndSettle();
    expect(find.text('212.00 °F'), findsNothing);
    expect(find.text('—'), findsOneWidget);
  });
}
