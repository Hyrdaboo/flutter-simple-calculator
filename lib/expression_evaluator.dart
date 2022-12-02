// ignore_for_file: non_constant_identifier_names

import 'dart:math';
import 'package:epic_calculator/stack.dart';

class ExpressionEvaluator {
  static bool _isDigit(String c) {
    return ".0123456789".contains(c);
  }

  static bool _isNumber(String num) {
    return double.tryParse(num) != null;
  }

  static double _SolveSimpleExpression(String num1, String num2, String op) {
    double n1 = double.parse(num1);
    double n2 = double.parse(num2);

    double result = double.nan;
    switch (op) {
      case "+":
        result = (n2 * 10 + n1 * 10) / 10;
        break;
      case "-":
        result = n2 - n1;
        break;
      case "*":
        result = n2 * n1;
        break;
      case "/":
        result = n2 / n1;
        break;
      case "^":
        result = pow(n2, n1) as double;
        break;
      default:
        break;
    }

    return result;
  }

  static final Map<String, int> _precedence = {
    '(': -1,
    '+': 0,
    '-': 0,
    '*': 1,
    '/': 1,
    '^': 2
  };

  static List<String> _Tokenize(String expression) {
    List<String> tokens = List.empty(growable: true);

    String digits = "";
    addDigit() => {if (digits != "") tokens.add(digits)};

    for (var i = 0; i < expression.length; i++) {
      String c = expression[i];
      bool prevIsChar = i == 0 || "(+-/*^".contains(expression[i - 1]);
      if (_isDigit(c) || (c == '-' && prevIsChar)) {
        digits += c;
        continue;
      }
      if (!"-+*/^()".contains(c)) {
        throw Exception("Error");
      }
      addDigit();
      digits = "";
      tokens.add(c);
    }
    addDigit();
    return tokens;
  }

  static List<String> _InfixToRPN(List<String> infixTokens) {
    Stack<String> operators = Stack<String>();
    Stack<String> output = Stack<String>();

    for (String token in infixTokens) {
      if (_isNumber(token)) {
        output.push(token);
        continue;
      }

      if (token == "(") {
        operators.push(token);
        continue;
      }
      if (token == ")") {
        for (int i = 0; i <= operators.length; i++) {
          String op = operators.pop();
          if (op == "(") break;
          output.push(op);
        }
        continue;
      }

      while (operators.length > 0) {
        if (_precedence[operators.peek]! >= _precedence[token]!) {
          output.push(operators.pop());
        } else {
          break;
        }
      }
      operators.push(token);
    }

    while (operators.length > 0) {
      output.push(operators.pop());
    }

    return output.getList;
  }

  static String _RPNSolver(List<String> rpnTokens) {
    Stack<String> output = Stack<String>();

    for (String token in rpnTokens) {
      if (_isNumber(token)) {
        output.push(token);
        continue;
      }

      String num1 = output.pop();
      String num2 = output.pop();
      output.push(_SolveSimpleExpression(num1, num2, token).toString());
    }

    return output.pop();
  }

  static String Evaluate(String expression) {
    expression = expression.trim();
    expression = expression.replaceAll(RegExp(r" "), "");

    try {
      var tokens = _Tokenize(expression);
      var rpnTokens = _InfixToRPN(tokens);
      var result = _RPNSolver(rpnTokens);

      return result;
    } catch (e) {
      return e.toString().replaceAll(RegExp(r'Exception: '), "");
    }
  }
}
