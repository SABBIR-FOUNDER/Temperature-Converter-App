/// The two supported temperature conversion directions.
enum ConversionType {
  celsiusToFahrenheit,
  fahrenheitToCelsius,
}

/// Converts [temperature] using the selected [conversionType].
///
/// The caller is responsible for validating that the input is finite.
double convertTemperature(double temperature, ConversionType conversionType) {
  switch (conversionType) {
    case ConversionType.celsiusToFahrenheit:
      return (temperature * 9 / 5) + 32;
    case ConversionType.fahrenheitToCelsius:
      return (temperature - 32) * 5 / 9;
  }
}

/// Returns the unit used by the result for the selected conversion.
String resultUnit(ConversionType conversionType) {
  switch (conversionType) {
    case ConversionType.celsiusToFahrenheit:
      return '°F';
    case ConversionType.fahrenheitToCelsius:
      return '°C';
  }
}
