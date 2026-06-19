import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanedText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double value = double.parse(cleanedText) / 100;
    
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    String newText = formatter.format(value).trim();

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}