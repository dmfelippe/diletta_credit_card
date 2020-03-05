import 'package:flutter/material.dart';

class Consts {

  Consts._();

  static const LinearGradient CARD_COLOR = LinearGradient(
    colors: [
      Color(0xffffffff), 
      Color(0xffededed)
    ]
  );

  static const LinearGradient INVALID_CARD_COLOR = LinearGradient(
    colors: [
      Color(0xffbb0000), 
      Color(0xffbb5555)
    ]
  );

  static const LinearGradient MASTER_CARD_COLOR = LinearGradient(
    colors: [
      Color(0xff865af8),
      Color(0xffbd6afa)
    ]
  );

  static const LinearGradient VISA_CARD_COLOR = LinearGradient(
    colors: [
      Color(0xff425dee),
      Color(0xff7c8ff2)
    ]
  );
}