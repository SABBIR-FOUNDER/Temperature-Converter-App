import 'package:flutter_test/flutter_test.dart';
import 'package:temperature_converter/temperature_converter.dart';

void main() {
  group('convertTemperature', () {
    test('converts 0 Celsius to 32 Fahrenheit', () {
      expect(
        convertTemperature(0, ConversionType.celsiusToFahrenheit),
        32,
      );
    });

    test('converts 100 Celsius to 212 Fahrenheit', () {
      expect(
        convertTemperature(100, ConversionType.celsiusToFahrenheit),
        212,
      );
    });

    test('converts -40 Celsius to -40 Fahrenheit', () {
      expect(
        convertTemperature(-40, ConversionType.celsiusToFahrenheit),
        -40,
      );
    });

    test('converts 32 Fahrenheit to 0 Celsius', () {
      expect(
        convertTemperature(32, ConversionType.fahrenheitToCelsius),
        0,
      );
    });

    test('converts 72 Fahrenheit to approximately 22.22 Celsius', () {
      expect(
        convertTemperature(72, ConversionType.fahrenheitToCelsius),
        closeTo(22.2222222222, 0.0000001),
      );
    });

    test('converts 212 Fahrenheit to 100 Celsius', () {
      expect(
        convertTemperature(212, ConversionType.fahrenheitToCelsius),
        100,
      );
    });
  });

  group('resultUnit', () {
    test('returns Fahrenheit for Celsius-to-Fahrenheit', () {
      expect(resultUnit(ConversionType.celsiusToFahrenheit), '°F');
    });

    test('returns Celsius for Fahrenheit-to-Celsius', () {
      expect(resultUnit(ConversionType.fahrenheitToCelsius), '°C');
    });
  });
}
