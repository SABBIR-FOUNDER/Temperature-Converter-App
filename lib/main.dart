import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'temperature_converter.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  static const Color _primaryBlue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryBlue,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF172033),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF172033),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
          hintStyle: const TextStyle(color: Color(0xFF9AA3B2)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD8DEE8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD8DEE8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primaryBlue, width: 1.5),
          ),
        ),
      ),
      home: const TemperatureConverterPage(),
    );
  }
}

class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  State<TemperatureConverterPage> createState() =>
      _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _headingColor = Color(0xFF172033);
  static const Color _mutedColor = Color(0xFF687386);

  final TextEditingController _temperatureController = TextEditingController();

  ConversionType _selectedType = ConversionType.celsiusToFahrenheit;
  String? _resultText;
  String? _errorMessage;

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  void _clearFeedback() {
    if (_resultText == null && _errorMessage == null) return;

    setState(() {
      _resultText = null;
      _errorMessage = null;
    });
  }

  void _convert() {
    FocusScope.of(context).unfocus();
    final inputText = _temperatureController.text.trim();

    if (inputText.isEmpty) {
      setState(() {
        _resultText = null;
        _errorMessage = 'Please enter a temperature.';
      });
      return;
    }

    final inputValue = double.tryParse(inputText);
    if (inputValue == null || !inputValue.isFinite) {
      setState(() {
        _resultText = null;
        _errorMessage = 'Please enter a valid number.';
      });
      return;
    }

    final convertedValue = convertTemperature(inputValue, _selectedType);
    if (!convertedValue.isFinite) {
      setState(() {
        _resultText = null;
        _errorMessage = 'This value is too large to convert.';
      });
      return;
    }

    // Avoid displaying negative zero after rounding to two decimal places.
    final roundedValue = convertedValue.abs() < 0.005 ? 0.0 : convertedValue;
    setState(() {
      _resultText = '${roundedValue.toStringAsFixed(2)} '
          '${resultUnit(_selectedType)}';
      _errorMessage = null;
    });
  }

  String _conversionLabel(ConversionType type) {
    switch (type) {
      case ConversionType.celsiusToFahrenheit:
        return 'Celsius to Fahrenheit (°C → °F)';
      case ConversionType.fahrenheitToCelsius:
        return 'Fahrenheit to Celsius (°F → °C)';
    }
  }

  Widget _buildTemperatureField() {
    return _buildFieldColumn(
      label: 'Degrees',
      child: TextField(
        key: const Key('temperatureInput'),
        controller: _temperatureController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
        ],
        onChanged: (_) => _clearFeedback(),
        onSubmitted: (_) => _convert(),
        decoration: const InputDecoration(hintText: 'Enter value'),
      ),
    );
  }

  Widget _buildConversionDropdown() {
    return _buildFieldColumn(
      label: 'Type',
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD8DEE8)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ConversionType>(
            key: const Key('conversionDropdown'),
            value: _selectedType,
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _mutedColor,
            ),
            style: const TextStyle(color: _headingColor, fontSize: 13),
            items: ConversionType.values
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(
                      _conversionLabel(type),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (type) {
              if (type == null) return;
              setState(() {
                _selectedType = type;
                _resultText = null;
                _errorMessage = null;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature Converter')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final inputControls = constraints.maxWidth < 360
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTemperatureField(),
                      const SizedBox(height: 16),
                      _buildConversionDropdown(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildTemperatureField()),
                      const SizedBox(width: 12),
                      Expanded(flex: 5, child: _buildConversionDropdown()),
                    ],
                  );

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      inputControls,
                      const SizedBox(height: 28),
                      const Text(
                        'Result',
                        style: TextStyle(
                          color: _headingColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        key: const Key('resultContainer'),
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 68),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9FC),
                          border: Border.all(color: const Color(0xFFE5EAF1)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _resultText ?? '—',
                          key: const Key('conversionResult'),
                          style: TextStyle(
                            color: _resultText == null
                                ? const Color(0xFF9AA3B2)
                                : _headingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          key: const Key('validationMessage'),
                          style: const TextStyle(
                            color: Color(0xFFB42318),
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          key: const Key('convertButton'),
                          onPressed: _convert,
                          style: FilledButton.styleFrom(
                            backgroundColor: _primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Convert'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldColumn({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _headingColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
