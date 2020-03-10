import 'package:flutter/material.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

class CreditCardService {
  static CreditCardService _instance;

  TextEditingController _numberController;
  TextEditingController _holderNameController;
  TextEditingController _expiryDateController;
  TextEditingController _cvvController;
  String _brand;
  LinearGradient _cardColor;

  factory CreditCardService() {
    _instance ??= CreditCardService._internal();
    return _instance;
  }

  CreditCardService._internal() {
    _numberController = MaskedTextController(mask: '0000 0000 0000 0000');
    _holderNameController = TextEditingController();
    _expiryDateController = MaskedTextController(mask: '00/00');
    _cvvController = MaskedTextController(mask: '000');
  }

  void setControllers({String number, String holderName, String expiryDate, String cvv, LinearGradient cardColor}) {
    _numberController = MaskedTextController(mask: '0000 0000 0000 0000', text: number);
    _holderNameController = TextEditingController(text: holderName);
    _expiryDateController = MaskedTextController(mask: '00/00', text: expiryDate);
    _cvvController = MaskedTextController(mask: '000', text: cvv);
    _brand = '';
    _cardColor = cardColor;
  }

  void setCardBrandAndColor(String brand, LinearGradient color) {
    _brand = brand;
    _cardColor = color;
  }

  TextEditingController get numberController => _numberController;
  TextEditingController get holderNameController => _holderNameController;
  TextEditingController get expiryDateController => _expiryDateController;
  TextEditingController get cvvController => _cvvController;
  String get cardBrand => _brand;
  LinearGradient get cardColor => _cardColor;
}