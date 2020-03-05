import 'enums.dart';

class Validations {
  Validations._();

  static CreditCardBrand getCreditCardBrand(String number) {
    if (number.length == 0)
      return CreditCardBrand.NONE;
    if (number[0] == '4')
      return CreditCardBrand.VISA;
    if (number[0] == '5')
      return CreditCardBrand.MASTERCARD;
    return CreditCardBrand.INVALID;
  }
}