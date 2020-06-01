import 'dart:async';

import 'package:diletta_credit_card/src/enums.dart';
import 'package:flutter/material.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

class CreditCardService {
  static CreditCardService _instance;

  TextEditingController _numberController;
  TextEditingController _holderNameController;
  TextEditingController _expiryDateController;
  TextEditingController _cvvController;
  TextEditingController _controllerNick;
  CreditCardBrand _brand;
  LinearGradient _cardColor;
  StreamController _cvvStream;

  factory CreditCardService() {
    _instance ??= CreditCardService._internal();
    return _instance;
  }

  CreditCardService._internal() {
    _numberController = MaskedTextController(mask: '0000 0000 0000 0000');
    _holderNameController = TextEditingController();
    _expiryDateController = MaskedTextController(mask: '00/00');
    _cvvController = MaskedTextController(mask: '000');
    _controllerNick = TextEditingController();
    _cvvStream = StreamController.broadcast();
  }

  void setControllers(
      {String number,
      String holderName,
      String expiryDate,
      String cvv,
      LinearGradient cardColor,
      String nick}) {
    _numberController.text = number;
    _holderNameController.text = holderName;
    _expiryDateController.text = expiryDate;
    _cvvController.text = cvv;
    _brand = CreditCardBrand.NONE;
    _cardColor = cardColor;
    _controllerNick.text = nick;
  }

  void setCardBrandAndColor(CreditCardBrand brand, LinearGradient color) {
    _brand = brand;
    _cardColor = color;
  }

  void cvvStreamDispose() {
    _cvvStream.close();
  }

  void changeCvv() {
    _cvvStream.add(true);
  }

  TextEditingController get numberController => _numberController;
  TextEditingController get holderNameController => _holderNameController;
  TextEditingController get expiryDateController => _expiryDateController;
  TextEditingController get cvvController => _cvvController;
  TextEditingController get nickController => _controllerNick;
  String get cardBrand {
    switch (_brand) {
      case CreditCardBrand.VISA:
        return 'VISA';
      case CreditCardBrand.MASTERCARD:
        return 'MASTER';
      case CreditCardBrand.INVALID:
        return '';
      case CreditCardBrand.NONE:
        return '';
      default:
        return '';
    }
  }

  LinearGradient get cardColor => _cardColor;
  Stream get cvv => _cvvStream.stream;
}
