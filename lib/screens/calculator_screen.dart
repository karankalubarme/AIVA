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
      } else if (value == "sin" || value == "cos" || value == "tan") {
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
      if (input.isEmpty) return;

      String exp = input.replaceAll("×", "*").replaceAll("÷", "/");

      // Auto-close parentheses
      int openParen = '('.allMatches(exp).length;
      int closeParen = ')'.allMatches(exp).length;
      while (openParen > closeParen) {
        exp += ")";
        closeParen++;
      }

      // Replace √ with sqrt
      exp = exp.replaceAll("√", "sqrt");

      // If degree mode, convert trig arguments from degrees to radians
      if (isDegree) {
        exp = exp.replaceAllMapped(RegExp(r'(sin|cos|tan)\(([^)]+)\)'), (match) {
          return '${match.group(1)}((${match.group(2)}) * ${pi / 180})';
        });
      }

      final p = Parser();
      final expression = p.parse(exp);
      final cm = ContextModel();

      final eval = expression.evaluate(EvaluationType.REAL, cm);

      setState(() {
        result = formatResult(eval);
      });
    } catch (e) {
      setState(() {
        result = "Error";
      });
    }
  }

  String formatResult(double val) {
    if (val.isInfinite || val.isNaN) return "Error";
    if (val % 1 == 0) {
      return val.toInt().toString();
    } else {
      String s = val.toStringAsFixed(8);
      while (s.contains('.') && (s.endsWith('0') || s.endsWith('.'))) {
        s = s.substring(0, s.length - 1);
      }
      return s;
    }
  }

  Widget buildButton(String text, {Color? bgColor, Color textColor = Colors.white}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? const Color(0xFF1E1E1E) : Colors.grey[200];
    final actualTextColor = textColor == Colors.white && !isDark ? Colors.black87 : textColor;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
          onTap: () => onButtonPressed(text),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: bgColor ?? defaultBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: actualTextColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text("Scientific Calculator"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Column(
        children: [
          // Display area with Gradient
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00ACC1), Color(0xFF007191)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00ACC1).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  input.isEmpty ? " " : input,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Text(
                  result,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                if (isDegree)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("DEG", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("RAD", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Scientific Row
                    Row(children: [
                      buildButton("sin", textColor: const Color(0xFF00ACC1)),
                      buildButton("cos", textColor: const Color(0xFF00ACC1)),
                      buildButton("tan", textColor: const Color(0xFF00ACC1)),
                      buildButton("log", textColor: const Color(0xFF00ACC1)),
                      buildButton("ln", textColor: const Color(0xFF00ACC1)),
                    ]),
                    Row(children: [
                      buildButton("(", textColor: const Color(0xFF00ACC1)),
                      buildButton(")", textColor: const Color(0xFF00ACC1)),
                      buildButton("^", textColor: const Color(0xFF00ACC1)),
                      buildButton("√", textColor: const Color(0xFF00ACC1)),
                      buildButton("!", textColor: const Color(0xFF00ACC1)),
                    ]),
                    Row(children: [
                      buildButton("π", textColor: const Color(0xFF00ACC1)),
                      buildButton("e", textColor: const Color(0xFF00ACC1)),
                      buildButton("RAD", bgColor: !isDegree ? const Color(0xFF00ACC1) : null),
                      buildButton("DEG", bgColor: isDegree ? const Color(0xFF00ACC1) : null),
                    ]),
                    const Divider(height: 30),
                    // Standard Numpad
                    Row(children: [
                      buildButton("C", textColor: Colors.redAccent),
                      buildButton("%", textColor: const Color(0xFF00ACC1)),
                      buildButton("DEL", textColor: Colors.redAccent),
                      buildButton("÷", textColor: const Color(0xFF00ACC1)),
                    ]),
                    Row(children: [
                      buildButton("7"),
                      buildButton("8"),
                      buildButton("9"),
                      buildButton("×", textColor: const Color(0xFF00ACC1)),
                    ]),
                    Row(children: [
                      buildButton("4"),
                      buildButton("5"),
                      buildButton("6"),
                      buildButton("-", textColor: const Color(0xFF00ACC1)),
                    ]),
                    Row(children: [
                      buildButton("1"),
                      buildButton("2"),
                      buildButton("3"),
                      buildButton("+", textColor: const Color(0xFF00ACC1)),
                    ]),
                    Row(children: [
                      buildButton("00"),
                      buildButton("0"),
                      buildButton("."),
                      buildButton("=", bgColor: const Color(0xFF00ACC1)),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
