import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorScreen());
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String equation = '';
  String result = '';
  String error = ''; // اضافه کردن متغیر error
  List<String> calculationStack = []; // استفاده از لیست به عنوان پشته

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        try {
          result = evaluateExpression();
          error = '';
        } catch (e) {
          result = '';
          error = 'Error: ${e.toString()}';
        }
      } else if (buttonText == 'C') {
        equation = '';
        result = '';
        error = '';
      } else {
        equation += buttonText;
        error = '';
      }
    });
  }

  String evaluateExpression() {
    String sanitizedEquation = equation.replaceAll(' ', '');

    calculationStack.add(sanitizedEquation);

    List<String> elements = [];
    String currentElement = '';
    for (int i = 0; i < sanitizedEquation.length; i++) {
      String char = sanitizedEquation[i];
      if (_isOperator(char) || char == '(' || char == ')') {
        if (currentElement.isNotEmpty) {
          elements.add(currentElement);
          currentElement = '';
        }
        elements.add(char);
      } else {
        currentElement += char;
      }
    }
    if (currentElement.isNotEmpty) {
      elements.add(currentElement);
    }
    var tt = _evaluateElements(elements);

    return tt;
  }

  String _evaluateElements(List<String> elements) {
    while (elements.contains('+') || elements.contains('-')) {
      int index =
          elements.indexWhere((element) => element == '+' || element == '-');
      String leftOperand = elements[index - 1];
      String operator = elements[index];
      String rightOperand = elements[index + 1];
      double result = _performOperation(leftOperand, operator, rightOperand);
      elements.replaceRange(index - 1, index + 2, [result.toString()]);
    }

    while (elements.contains('*') || elements.contains('/')) {
      int index =
          elements.indexWhere((element) => element == '*' || element == '/');
      String leftOperand = elements[index - 1];
      String operator = elements[index];
      String rightOperand = elements[index + 1];
      double result = _performOperation(leftOperand, operator, rightOperand);
      elements.replaceRange(index - 1, index + 2, [result.toString()]);
    }

    if (elements.length == 1) {
      return elements[0];
    } else {
      throw Exception('Invalid expression');
    }
  }

  bool _isOperator(String element) {
    return element == '*' || element == '/' || element == '+' || element == '-';
  }

  double _performOperation(
      String leftOperand, String operator, String rightOperand) {
    double left = double.parse(leftOperand);
    double right = double.parse(rightOperand);

    if (operator == '/' && right == 0) {
      throw Exception('Division by zero');
    }

    switch (operator) {
      case '*':
        return left * right;
      case '/':
        return left / right;
      case '+':
        return left + right;
      case '-':
        return left - right;
      default:
        throw Exception('Invalid operator');
    }
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: _onBackButtonPressed,
        child: const Text(
          'Back',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  void _onBackButtonPressed() {
    setState(() {
      if (calculationStack.isNotEmpty) {
        calculationStack.removeLast(); // حذف محاسبه جاری از پشته
        if (calculationStack.isNotEmpty) {
          equation = calculationStack.last; // بازگرداندن محاسبه قبلی از پشته
        } else {
          equation = '';
        }
      }
    });
  }

  bool isDarkMode = false;
  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fakhravari.Ir',
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Fakhravari.Ir'),
            actions: [
              IconButton(
                icon: const Icon(Icons.lightbulb),
                onPressed: _toggleTheme,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      equation,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      error == '' && result != ''
                          ? double.parse(result).toStringAsFixed(5)
                          : error,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Visibility(
                      visible: calculationStack.isNotEmpty,
                      child: _buildBackButton(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('8'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('9'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('/'),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('5'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('6'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('*'),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('2'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('3'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('-'),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    _buildButton('C'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('0'),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('='),
                    const SizedBox(
                      width: 5,
                    ),
                    _buildButton('+'),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
