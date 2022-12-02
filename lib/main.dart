import 'package:auto_size_text/auto_size_text.dart';
import 'package:epic_calculator/stack.dart';
import 'package:epic_calculator/expression_evaluator.dart';
import 'package:flutter/material.dart' hide Stack;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Epik Calculator',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Epik Calculator',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color orange = Color.fromARGB(255, 255, 174, 0);
  Color grey = Color.fromARGB(255, 77, 77, 77);
  Color white = Colors.white;

  String inputData = "";
  String secondaryInputData = "";

  bool isDigit(String c) {
    if (c == "") return false;
    return "0123456789".contains(c);
  }

  // Hello
  String reverseString(String s) {
    String result = "";
    for (var i = s.length - 1; i >= 0; i--) {
      result += s[i];
    }
    return result;
  }

  String selectAllUntilACharMet(String s, int index) {
    String chars = "(+-*/^";
    String result = "";
    for (var i = s.length - 1; i >= 0; i--) {
      for (var j = 0; j < chars.length; j++) {
        if (s[i] == chars[j]) return reverseString(result);
      }
      result += s[i];
    }
    return "";
  }

  bool outputPresent = false;
  void handleInKeyPress(String num) {
    if (inputData.length > 30) return;
    if (outputPresent) {
      outputPresent = false;
      inputData = "";
    }

    String lastChar = inputData.isEmpty ? "" : inputData[inputData.length - 1];

    if (!isDigit(num)) {
      if (!isDigit(lastChar) && lastChar != ")") {
        if (num != "-") return;
        if (lastChar != "" && lastChar != "(") return;
      }
    }

    String lastNum = selectAllUntilACharMet(inputData, inputData.length - 1);
    bool isFractional =
        lastNum.contains(".") || (inputData.contains(".") && lastNum.isEmpty);
    if (isFractional && num == ".") return;

    inputData += num;
    refresh();
  }

  Stack<String> parenthesis = Stack<String>();
  bool typedDigit = false;
  void addParenthesis() {
    bool lastCharIsDigit =
        inputData.isNotEmpty && isDigit(inputData[inputData.length - 1]);
    bool lastCharIsClosingParenthesis =
        inputData.isNotEmpty && inputData[inputData.length - 1] == ")";

    if (lastCharIsDigit) typedDigit = true;

    if (typedDigit && parenthesis.isNotEmpty) {
      parenthesis.pop();
      inputData += ")";
      refresh();
      return;
    }

    typedDigit = false;
    parenthesis.push("(");
    if (lastCharIsDigit || lastCharIsClosingParenthesis) {
      inputData += "*";
    }
    inputData += "(";
    refresh();
  }

  void resetParenthesis() {
    typedDigit = false;
    parenthesis = Stack<String>();
  }

  void refresh() {
    setState(() {
      inputData;
    });
  }

  void deleteLast() {
    if (inputData == "Error" || inputData == "Infinity") {
      inputData = "";
    }
    if (inputData.isNotEmpty) {
      String last = inputData[inputData.length - 1];
      inputData = inputData.replaceRange(inputData.length - 1, null, "");
      if (last == "(") {
        parenthesis.pop();
      }
      if (last == ")") {
        parenthesis.push("(");
      }
    }
    refresh();
  }

  void clearAll() {
    setState(() {
      inputData = "";
      secondaryInputData = "";
      resetParenthesis();
    });
  }

  void calculateResult() {
    if (double.tryParse(inputData) != null) return;
    if (inputData == "Error" || inputData == "Infinity" || inputData.isEmpty) {
      return;
    }
    secondaryInputData = inputData;
    inputData = ExpressionEvaluator.Evaluate(inputData);
    outputPresent = true;
    resetParenthesis();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 192, 118, 6),
      ),
      backgroundColor: Color.fromARGB(213, 9, 10, 14),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 10),
            child: AutoSizeText(
              secondaryInputData,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 40,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 10),
            child: AutoSizeText(
              inputData,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 85,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(
                onPressed: () => clearAll(),
                title: "C",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => deleteLast(),
                title: "",
                displayType: DisplayType.image,
                image: Image.asset("lib/resources/arrow.png"),
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("^"),
                title: "^",
                displayType: DisplayType.icon,
                icon: const Icon(
                  Icons.keyboard_arrow_up,
                  size: 35,
                ),
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("/"),
                title: "/",
                displayType: DisplayType.image,
                image: Image.asset("lib/resources/divide.png"),
                bgColor: orange,
                txtColor: white,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(
                onPressed: () => handleInKeyPress("7"),
                title: "7",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("8"),
                title: "8",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("9"),
                title: "9",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("*"),
                title: "x",
                displayType: DisplayType.icon,
                icon: const Icon(
                  Icons.close,
                  size: 35,
                ),
                bgColor: orange,
                txtColor: white,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(
                onPressed: () => handleInKeyPress("4"),
                title: "4",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("5"),
                title: "5",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("6"),
                title: "6",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("-"),
                title: "–",
                fontSize: 35,
                fontWeight: FontWeight.bold,
                bgColor: orange,
                txtColor: white,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(
                onPressed: () => handleInKeyPress("1"),
                title: "1",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("2"),
                title: "2",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("3"),
                title: "3",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("+"),
                title: "+",
                displayType: DisplayType.icon,
                icon: const Icon(
                  Icons.add,
                  size: 35,
                ),
                bgColor: orange,
                txtColor: white,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalcButton(
                onPressed: () => addParenthesis(),
                title: "( )",
                fontWeight: FontWeight.w600,
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("0"),
                title: "0",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => handleInKeyPress("."),
                title: ".",
                bgColor: grey,
                txtColor: white,
              ),
              CalcButton(
                onPressed: () => calculateResult(),
                title: "=",
                fontSize: 30,
                fontWeight: FontWeight.bold,
                bgColor: Color.fromARGB(255, 235, 38, 24),
                txtColor: white,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

enum DisplayType { text, icon, image }

class CalcButton extends StatelessWidget {
  CalcButton(
      {super.key,
      required this.title,
      required this.bgColor,
      required this.txtColor,
      required this.onPressed,
      this.displayType = DisplayType.text,
      this.image,
      this.icon,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 32,
      this.imageWidth = 23,
      this.imageHeight = 23});

  final String title;
  final Color bgColor;
  final Color txtColor;
  final Function? onPressed;
  DisplayType displayType = DisplayType.text;
  Image? image;
  Icon? icon;
  double imageWidth;
  double imageHeight;
  FontWeight fontWeight;
  double fontSize;

  Widget? contentWidget;

  @override
  Widget build(BuildContext context) {
    switch (displayType) {
      case DisplayType.icon:
        contentWidget = icon;
        break;
      case DisplayType.image:
        contentWidget = Container(
          width: imageWidth,
          height: imageHeight,
          child: image,
        );
        break;
      case DisplayType.text:
        contentWidget = Center(
          child: Text(
            title,
            style: TextStyle(
              color: txtColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      default:
    }

    return Container(
      width: 65,
      height: 65,
      child: ElevatedButton(
        onPressed: () => {onPressed?.call()},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: const CircleBorder(),
        ),
        child: Center(
          child: contentWidget,
        ),
      ),
    );
  }
}
