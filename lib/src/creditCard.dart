import 'package:diletta_credit_card/src/validations.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'enums.dart';
import 'creditCardService.dart';

class DilettaCreditCard extends StatefulWidget {
  final String number;
  final String holderName;
  final String expiryDate;
  final String cvv;
  final bool isCvvFocused;

  DilettaCreditCard({
    @required this.number,
    @required this.holderName,
    @required this.expiryDate,
    @required this.cvv,
    @required this.isCvvFocused
  });

  @override
  State<StatefulWidget> createState() => _DilettaCreditCardState();
}

class _DilettaCreditCardState extends State<DilettaCreditCard> {
  String _number;
  String _holderName;
  String _expiryDate;
  String _cvv;
  bool _isCvvFocused;
  CreditCardBrand _brand;
  CreditCardService _creditCardService;

  @override
  void initState() {
    super.initState();

    _number = widget.number;
    _holderName = widget.holderName;
    _expiryDate = widget.expiryDate;
    _brand = CreditCardBrand.NONE;
    _creditCardService = CreditCardService();
    _creditCardService.setControllers(
      number: _number
    );

    _creditCardService.numberController.addListener(() {
      setState(() {
        _number = _creditCardService.numberController.text;
        _brand = Validations.getCreditCardBrand(_number);
      });
    });

    _creditCardService.holderNameController.addListener(() {
      setState(() {
        _holderName = _creditCardService.holderNameController.text.toUpperCase();
      });
    });

    _creditCardService.expiryDateController.addListener(() {
      setState(() {
        _expiryDate = _creditCardService.expiryDateController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          decoration: BoxDecoration(
            gradient: _getCardColor(),
            borderRadius: BorderRadius.circular(6)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getCardBrand(),
              _getCardNumber(),
              _getInfo()
            ],
          ),
        );
      }
    );
  }

  LinearGradient _getCardColor() {
    switch (_brand) {
      case CreditCardBrand.NONE:
        return Consts.CARD_COLOR;
        break;
      case CreditCardBrand.INVALID:
        return Consts.INVALID_CARD_COLOR;
        break;
      case CreditCardBrand.MASTERCARD:
        return Consts.MASTER_CARD_COLOR;
        break;
      case CreditCardBrand.VISA:
        return Consts.VISA_CARD_COLOR;
        break;
      default:
        return Consts.CARD_COLOR;
    }
  }

  Widget _getCardBrand() {
    Container container;

    switch (_brand) {
      case CreditCardBrand.NONE:
        container = Container(
          width: 40.0,
          height: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Color(0xffeaebef)
          ),
        );
        break;
      case CreditCardBrand.INVALID:
        container = Container(
          width: 40.0,
          height: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Color(0xffcc0000)
          ),
        );
        break;
      case CreditCardBrand.MASTERCARD:
        container = container = Container(
          width: 40.0,
          height: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset(
              'assets/master.png',
              width: 40.0,
              height: 30.0,
              fit: BoxFit.fitWidth,
            ),
          ),
        );
        break;
      case CreditCardBrand.VISA:
        container = container = Container(
          width: 40.0,
          height: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset(
              'assets/visa.png',
              width: 40.0,
              height: 30.0,
              fit: BoxFit.fitWidth,
            ),
          ),
        );
        break;
      default:
        container = Container(
          width: 40.0,
          height: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Color(0xffeaebef)
          ),
        );
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        container,
        Container(width: 20.0)
      ]
    );
  }

  Widget _getCardNumber() => Container(
    margin: EdgeInsets.all(30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getNumberGroup(0),
        _getNumberGroup(5),
        _getNumberGroup(10),
        _getNumberGroup(15)
      ]
    ),
  );

  //Cada grupo é formado por 4 dígitos
  Widget _getNumberGroup(int index) {
    int finalIndex = index + 4;
    bool margin = false;
    List<Widget> digits = List<Widget>();

    while (index < finalIndex) {
      //Se esse index tem um número, mostra o número, senão, mostra uma bolinha
      if (_number.length > index) {
        digits.add(Container(
          margin: EdgeInsets.only(left: margin ? 2.0 : 0.0),
          height: 20.0,
          alignment: Alignment.center,
          child: Text(
            _number[index],
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xff3f3f3f)
            ),
          ),
        ));
      } else {
        digits.add(Container(
          margin: EdgeInsets.only(left: margin ? 5.0 : 0.0),
          height: 20.0,
          alignment: Alignment.center,
          child: Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(
              color: Color(0xffc6c5c5),
              borderRadius: BorderRadius.circular(90)
            ),
          ),
        ));
      }
      margin = true;
      index++;
    }
    return Row(
      children: digits
    );
  }

  Widget _getInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 16.0),
      child: Row(
        children: [
          _getName(),
          _getExpiry()
        ],
      ),
    );
  }

  Widget _getName() {
    Text name;

    if (_holderName.length == 0) {
      name = Text(
        'NOME E SOBRENOME',
        style: TextStyle(
          fontSize: 12.0,
          color: Color(0xff908e8e)
        ),
      );
    } else {
      name = Text(
        _holderName,
        style: TextStyle(
          fontSize: 12.0,
          color: Color(0xff3f3f3f)
        ),
        overflow: TextOverflow.ellipsis
      );
    }

    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: name
      ),
    );
  }

  Widget _getExpiry() {
    String pattern = 'MM/AA';
    String text = _expiryDate;

    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 13.0,
            color: Color(0xff3f3f3f)
          ),
          children: [
            TextSpan(
              text: text.length < pattern.length  ? pattern.substring(text.length) : '',
              style: TextStyle(
                color: Color(0xff908e8e)
              )
            )
          ]
        ),
      )
    );
  }
}