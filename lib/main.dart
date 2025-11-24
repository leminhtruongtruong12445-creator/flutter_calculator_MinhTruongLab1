import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

/// Ứng dụng chính của máy tính
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2D3142);
    const secondaryColor = Color(0xFF4F5D75);
    const accentColor = Color(0xFFEF8354);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: primaryColor,
        textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: 'Roboto')),
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          background: primaryColor,
          primary: accentColor,
          secondary: secondaryColor,
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}

/// Màn hình chính của máy tính (có state)
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Các biến state theo đề lab
  String _display = '0'; // giá trị đang hiển thị
  String _equation = ''; // phương trình phía trên
  double _num1 = 0; // số thứ nhất
  double _num2 = 0; // số thứ hai
  String _operation = ''; // phép toán hiện tại

  // Hàm xử lý khi bấm nút
  void _onButtonPressed(String value) {
    setState(() {
      if (_isDigit(value)) {
        _handleDigit(value);
      } else if (value == '.') {
        _handleDecimalPoint();
      } else if (value == 'C') {
        _clearAll();
      } else if (value == 'CE') {
        _clearEnd();
      } else if (value == '±') {
        _toggleSign();
      } else if (value == '%') {
        _percent();
      } else if (_isOperation(value)) {
        _setOperation(value);
      } else if (value == '=') {
        _calculateResult();
      }
    });
  }

  bool _isDigit(String value) => RegExp(r'^[0-9]$').hasMatch(value);

  bool _isOperation(String value) =>
      value == '+' || value == '-' || value == '×' || value == '÷';

  // Thêm số (0–9) vào màn hình
  void _handleDigit(String value) {
    if (_display == '0') {
      _display = value;
    } else {
      _display += value;
    }
  }

  // Thêm dấu thập phân
  void _handleDecimalPoint() {
    if (!_display.contains('.')) {
      _display += '.';
    }
  }

  // Nút C – xóa hết
  void _clearAll() {
    _display = '0';
    _equation = '';
    _num1 = 0;
    _num2 = 0;
    _operation = '';
  }

  // Nút CE – xóa 1 ký tự cuối
  void _clearEnd() {
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
  }

  // Nút ± – đổi dấu
  void _toggleSign() {
    if (_display == '0') return;
    if (_display.startsWith('-')) {
      _display = _display.substring(1);
    } else {
      _display = '-$_display';
    }
  }

  // Nút % – tính phần trăm
  void _percent() {
    final value = double.tryParse(_display) ?? 0;
    _display = (value / 100).toString();
    _trimDisplay();
  }

  // Lưu phép toán + số thứ nhất
  void _setOperation(String op) {
    _num1 = double.tryParse(_display) ?? 0;
    _operation = op;
    _equation = '$_display $op';
    _display = '0';
  }

  // Tính kết quả khi bấm =
  void _calculateResult() {
    if (_operation.isEmpty) return;
    _num2 = double.tryParse(_display) ?? 0;

    double result;

    switch (_operation) {
      case '+':
        result = _num1 + _num2;
        break;
      case '-':
        result = _num1 - _num2;
        break;
      case '×':
        result = _num1 * _num2;
        break;
      case '÷':
        if (_num2 == 0) {
          // chia cho 0
          _display = 'Error';
          _equation = '${_num1.toString()} ÷ 0';
          _operation = '';
          return;
        }
        result = _num1 / _num2;
        break;
      default:
        return;
    }

    _equation = '$_num1 $_operation $_num2 =';
    _display = result.toString();
    _trimDisplay();
    _operation = '';
  }

  // Rút gọn hiển thị: bỏ .0, giới hạn số ký tự
  void _trimDisplay() {
    if (_display.endsWith('.0')) {
      _display = _display.substring(0, _display.length - 2);
    }
    if (_display.length > 12) {
      _display = double.parse(_display).toStringAsPrecision(10);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2D3142);
    const secondaryColor = Color(0xFF4F5D75);
    const accentColor = Color(0xFFEF8354);

    // Danh sách nút theo lưới 4x5
    final buttonLabels = [
      'C',
      'CE',
      '%',
      '÷',
      '7',
      '8',
      '9',
      '×',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '±',
      '0',
      '.',
      '=',
    ];

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20), // screen padding 20px
          child: Column(
            children: [
              // Vùng hiển thị kết quả
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _equation,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18, // Roboto 18px
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _display,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32, // Medium 24+ cho result
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Lưới nút bấm
              Expanded(
                flex: 5,
                child: GridView.builder(
                  itemCount: buttonLabels.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16, // button spacing 16px
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final label = buttonLabels[index];
                    final isOperation =
                        _isOperation(label) ||
                        label == '=' ||
                        label == '%' ||
                        label == '±';
                    final isClear = label == 'C' || label == 'CE';

                    Color bgColor;
                    Color textColor = Colors.white;

                    if (isClear) {
                      bgColor = secondaryColor;
                    } else if (isOperation) {
                      bgColor = accentColor;
                    } else {
                      bgColor = const Color(0xFF41445A); // màu nền number
                    }

                    return CalculatorButton(
                      label: label,
                      backgroundColor: bgColor,
                      textColor: textColor,
                      onTap: () => _onButtonPressed(label),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget nút bấm máy tính
class CalculatorButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12), // border radius 12px
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
