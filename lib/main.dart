```dart
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  double _secondOperand = 0;
  String _operator = '';
  bool _isOperatorPressed = false;
  bool _isResultShown = false;
  bool _isPercent = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_isResultShown) {
        _display = number;
        _expression = number;
        _isResultShown = false;
      } else {
        if (_display == '0' && number != '.') {
          _display = number;
          _expression = number;
        } else {
          _display += number;
          _expression += number;
        }
      }
      _isOperatorPressed = false;
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (_operator.isNotEmpty && !_isOperatorPressed) {
        _calculateResult();
      }
      _firstOperand = double.parse(_display);
      _operator = operator;
      _isOperatorPressed = true;
      _isResultShown = false;
      _isPercent = false;
      _expression += ' $operator ';
    });
  }

  void _calculateResult() {
    if (_operator.isEmpty) return;
    _secondOperand = double.parse(_display);
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand + _secondOperand;
        break;
      case '-':
        result = _firstOperand - _secondOperand;
        break;
      case 'Ã':
        result = _firstOperand * _secondOperand;
        break;
      case 'Ã·':
        if (_secondOperand == 0) {
          _display = 'Error';
          _expression = 'Error';
          _operator = '';
          _isResultShown = true;
          return;
        }
        result = _firstOperand / _secondOperand;
        break;
      case '%':
        result = _firstOperand * (_secondOperand / 100);
        break;
    }
    String resultStr = result == result.truncateToDouble()
        ? result.toInt().toString()
        : result.toStringAsFixed(2);
    _display = resultStr;
    _expression = resultStr;
    _operator = '';
    _isResultShown = true;
  }

  void _onPercentPressed() {
    setState(() {
      if (_display.isNotEmpty && _display != '0') {
        double value = double.parse(_display);
        value = value / 100;
        _display = value == value.truncateToDouble()
            ? value.toInt().toString()
            : value.toStringAsFixed(2);
        _expression = _display;
        _isPercent = true;
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0;
      _secondOperand = 0;
      _operator = '';
      _isOperatorPressed = false;
      _isResultShown = false;
      _isPercent = false;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
        _expression = _expression.substring(0, _expression.length - 1);
      } else {
        _display = '0';
        _expression = '';
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_display.contains('.')) {
        _display += '.';
        _expression += '.';
      }
    });
  }

  void _onEqualsPressed() {
    _calculateResult();
  }

  void _onSquareRootPressed() {
    setState(() {
      double value = double.parse(_display);
      if (value < 0) {
        _display = 'Error';
        _expression = 'Error';
        return;
      }
      double result = sqrt(value);
      _display = result == result.truncateToDouble()
          ? result.toInt().toString()
          : result.toStringAsFixed(2);
      _expression = 'â($value) = $_display';
      _isResultShown = true;
    });
  }

  void _onPowerPressed() {
    setState(() {
      double value = double.parse(_display);
      double result = value * value;
      _display = result == result.truncateToDouble()
          ? result.toInt().toString()
          : result.toStringAsFixed(2);
      _expression = '($value)Â² = $_display';
      _isResultShown = true;
    });
  }

  Widget _buildButton(String text, {Color? color, double fontSize = 24}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            switch (text) {
              case 'C':
                _onClearPressed();
                break;
              case 'â«':
                _onDeletePressed();
                break;
              case 'Ã·':
              case 'Ã':
              case '-':
              case '+':
                _onOperatorPressed(text);
                break;
              case '=':
                _onEqualsPressed();
                break;
              case '.':
                _onDecimalPressed();
                break;
              case '%':
                _onPercentPressed();
                break;
              case 'â':
                _onSquareRootPressed();
                break;
              case 'xÂ²':
                _onPowerPressed();
                break;
              default:
                _onNumberPressed(text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: color == null ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> buttons, {List<Color?>? colors}) {
    return Row(
      children: List.generate(buttons.length, (index) {
        return _buildButton(
          buttons[index],
          color: colors != null && index < colors.length ? colors[index] : null,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display area
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 8),
                Text(
                  _display,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
          const Divider(),
          // Buttons area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildRow(['C', 'â«', '%', 'Ã·'], colors: [
                    Theme.of(context).colorScheme.error,
                    Theme.of(context).colorScheme.error,
                    Theme.of(context).colorScheme.secondaryContainer,
                    Theme.of(context).colorScheme.tertiary,
                  ]),
                  _buildRow(['7', '8', '9', 'Ã'], colors: [
                    null, null, null,
                    Theme.of(context).colorScheme.tertiary,
                  ]),
                  _buildRow(['4', '5', '6', '-'], colors: [
                    null, null, null,
                    Theme.of(context).colorScheme.tertiary,
                  ]),
                  _buildRow(['1', '2', '3', '+'], colors: [
                    null, null, null,
                    Theme.of(context).colorScheme.tertiary,
                  ]),
                  _buildRow(['â', '0', '.', '='], colors: [
                    Theme.of(context).colorScheme.secondaryContainer,
                    null, null,
                    Theme.of(context).colorScheme.primary,
                  ]),
                  _buildRow(['xÂ²'], colors: [
                    Theme.of(context).colorScheme.secondaryContainer,
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```