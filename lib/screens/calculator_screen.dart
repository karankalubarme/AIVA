import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";
  String result = "0";
  bool isDegree = true;

  void onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        result = "0";
      } else if (value == "DEL") {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == "=") {
        calculateResult();
      } else if (value == "RAD") {
        isDegree = false;
      } else if (value == "DEG") {
        isDegree = true;
      } else if (value == "π") {
        input += pi.toString();
      } else if (value == "e") {
        input += e.toString();
      } else if (value == "√") {
        input += "sqrt(";
      } else if (value == "%") {
        input += "/100";
      } else if (value == "sin" ||
          value == "cos" ||
          value == "tan") {
        input += "$value(";
      } else if (value == "log") {
        input += "log(";
      } else if (value == "ln") {
        input += "ln(";
      } else {
        input += value;
      }
    });
  }

  void calculateResult() {
    try {
      String exp = input
          .replaceAll("×", "*")
          .replaceAll("÷", "/");

      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();

      double eval = expression.evaluate(EvaluationType.REAL, cm);

      // Handle trig manually
      if (input.contains("sin") ||
          input.contains("cos") ||
          input.contains("tan")) {
        eval = handleTrig(input);
      }

      result = formatResult(eval);
    } catch (e) {
      result = "Error";
    }
  }

  double handleTrig(String expr) {
    RegExp reg = RegExp(r'(sin|cos|tan)\(([^)]+)\)');
    var match = reg.firstMatch(expr);

    if (match != null) {
      String func = match.group(1)!;
      double val = double.parse(match.group(2)!);

      if (isDegree) val = val * pi / 180;

      if (func == "sin") return sin(val);
      if (func == "cos") return cos(val);
      return tan(val);
    }
    return 0;
  }

  String formatResult(double val) {
    if (val % 1 == 0) {
      return val.toInt().toString();
    } else {
      return val.toStringAsFixed(6);
    }
  }

  Widget buildButton(String text,
      {Color bgColor = const Color(0xFF1E1E1E),
        Color textColor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () => onButtonPressed(text),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 40),

          // ✅ RIGHT ALIGNED DISPLAY (FIXED)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  input,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  result,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 SCIENTIFIC
          Container(
            color: const Color(0xFF3A3F44),
            child: Column(
              children: [
                Row(children: [
                  buildButton("sin"),
                  buildButton("cos"),
                  buildButton("tan"),
                  buildButton("log"),
                  buildButton("ln"),
                ]),
                Row(children: [
                  buildButton("("),
                  buildButton(")"),
                  buildButton("^"),
                  buildButton("√"),
                  buildButton("!"),
                ]),
                Row(children: [
                  buildButton("π"),
                  buildButton("e"),
                  buildButton("RAD",
                      bgColor:
                      !isDegree ? Colors.teal : const Color(0xFF1E1E1E)),
                  buildButton("DEG",
                      bgColor:
                      isDegree ? Colors.teal : const Color(0xFF1E1E1E)),
                ]),
              ],
            ),
          ),

          // 🔹 NUMPAD
          Container(
            color: Colors.black,
            child: Column(
              children: [
                Row(children: [
                  buildButton("C", textColor: Colors.teal),
                  buildButton("%", textColor: Colors.teal),
                  buildButton("DEL", textColor: Colors.teal),
                  buildButton("÷", textColor: Colors.teal),
                ]),
                Row(children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("×", textColor: Colors.teal),
                ]),
                Row(children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("-", textColor: Colors.teal),
                ]),
                Row(children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("+", textColor: Colors.teal),
                ]),
                Row(children: [
                  buildButton("00"),
                  buildButton("0"),
                  buildButton("."),
                  buildButton("=", textColor: Colors.teal),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}