
import 'package:currency_formatter/currency_formatter.dart';

class Formatter {
  // Method that returns formatted string with commas as thousand separators
  String formatCurrency(double amount) {
    const CurrencyFormat settings = CurrencyFormat(
      symbol: '', // No currency symbol
      symbolSide: SymbolSide.left,
      thousandSeparator: ',', // Comma for thousands
      decimalSeparator: '.', // Dot for decimals
      symbolSeparator: ' ',
    );
    
    return CurrencyFormatter.format(amount, settings);
  }
  
  // Alternative: Simple number formatter without currency dependency
  String formatNumber(double amount) {
    // Convert to string, remove decimals if they're .00
    String numStr;
    if (amount == amount.roundToDouble()) {
      numStr = amount.round().toString();
    } else {
      numStr = amount.toStringAsFixed(2);
    }
    
    // Split into integer and decimal parts
    List<String> parts = numStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';
    
    // Add thousand separators (commas)
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }
    
    // Return with or without decimal part
    if (decimalPart.isNotEmpty && decimalPart != '00') {
      return '$formattedInteger.$decimalPart';
    } else {
      return formattedInteger;
    }
  }
  
  // Your original method name for backward compatibility
  String converter(double amount) {
    return formatNumber(amount);
  }
}