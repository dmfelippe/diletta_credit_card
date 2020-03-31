import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'consts.dart';
import 'enums.dart';
import 'creditCardService.dart';
import 'validations.dart';

class DilettaCreditCard extends StatefulWidget {
  final String number;
  final String holderName;
  final String expiryDate;
  final String cvv;
  final int animationDuration;

  DilettaCreditCard({
    @required this.number,
    @required this.holderName,
    @required this.expiryDate,
    @required this.cvv,
    this.animationDuration = 1000
  });

  @override
  State<StatefulWidget> createState() => _DilettaCreditCardState();
}

class _DilettaCreditCardState extends State<DilettaCreditCard> with SingleTickerProviderStateMixin {
  bool _isCvvFocused;
  String _number;
  String _holderName;
  String _expiryDate;
  String _cvv;
  CreditCardBrand _brand;
  CreditCardService _creditCardService;

  StreamSubscription _subscription;
  double _percentage;
  AnimationController _animationController;
  Animation<double> _frontCardRotation;
  Animation<double> _backCardRotation;

  @override
  void initState() {
    super.initState();

    _number = widget.number;
    _holderName = widget.holderName.toUpperCase();
    _expiryDate = widget.expiryDate;
    _cvv = widget.cvv;
    _isCvvFocused = false;
    _brand = CreditCardBrand.NONE;
    _creditCardService = CreditCardService();
    _creditCardService.setControllers(
      number: _number,
      holderName: _holderName,
      expiryDate: _expiryDate,
      cvv: _cvv,
      cardColor: _getCardColor()
    );

    _brand = Validations.getCreditCardBrand(_number);

    _animationController = AnimationController(duration: Duration(milliseconds: widget.animationDuration), vsync: this);

    _frontCardRotation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(_animationController);

    _backCardRotation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(_animationController);

    _creditCardService.numberController.addListener(() {
      setState(() {
        _number = _creditCardService.numberController.text;
        _brand = Validations.getCreditCardBrand(_number);
        _creditCardService.setCardBrandAndColor(_brand, _getCardColor());
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

    _creditCardService.cvvController.addListener(() {
      setState(() {
        _cvv = _creditCardService.cvvController.text;
      });
    });

    _subscription = _creditCardService.cvv.listen((data) {
      setState(() {
        _isCvvFocused = !_isCvvFocused;
      });

      if (_isCvvFocused)
        _animationController.forward();
      else
        _animationController.reverse();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCvvFocused)
      _animationController.forward();
    else
      _animationController.reverse();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        setResponsive(constraints);
        return Stack(
          children: [
            AnimationCard(
              animation: _frontCardRotation,
              child: _getFrontCard(constraints)
            ),
            AnimationCard(
              animation: _backCardRotation,
              child: _getBackCard(constraints)
            )
          ],
        );
      }
    );
  }

  Widget _getFrontCard(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxWidth * 0.65,
      padding: EdgeInsets.only(top: size(20.0)),
      decoration: BoxDecoration(
        gradient: _getCardColor(),
        borderRadius: BorderRadius.circular(12.0)
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

  Widget _getBackCard(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxWidth * 0.65,
      padding: EdgeInsets.only(top: size(28.0)),
      decoration: BoxDecoration(
        gradient: _getCardColor(),
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getBlackStripe(),
          _getCvvContainer(),
          _getCardBrand()
        ]
      )
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
          width: size(40.0),
          height: size(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Color(0xffeaebef)
          ),
        );
        break;
      case CreditCardBrand.INVALID:
        container = Container(
          width: size(40.0),
          height: size(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Color(0xffcc0000)
          ),
        );
        break;
      case CreditCardBrand.MASTERCARD:
        container = container = Container(
          width: size(40.0),
          height: size(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset(
              'assets/images/master.png',
              package: 'diletta_credit_card',
              width: size(40.0),
              height: size(30.0),
              fit: BoxFit.fitWidth
            ),
          ),
        );
        break;
      case CreditCardBrand.VISA:
        container = container = Container(
          width: size(40.0),
          height: size(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.asset(
              'assets/images/visa.png',
              package: 'diletta_credit_card',
              width: size(40.0),
              height: size(30.0),
              fit: BoxFit.fitWidth
            ),
          ),
        );
        break;
      default:
        container = Container(
          width: size(40.0),
          height: size(30.0),
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
        Container(width: size(20.0))
      ]
    );
  }

  Widget _getCardNumber() => Container(
    margin: EdgeInsets.fromLTRB(size(24.0), size(28.0), size(24.0), size(20.0)),
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
          margin: EdgeInsets.only(left: margin ? size(2.0) : 0.0),
          height: size(20.0),
          alignment: Alignment.center,
          child: Text(
            _number[index],
            style: TextStyle(
              fontFamily: 'ocra',
              package: 'diletta_credit_card',
              fontSize: size(14.0),
              color: Colors.white
            ),
          ),
        ));
      } else {
        digits.add(Container(
          margin: EdgeInsets.only(left: margin ? size(5.0) : 0.0),
          height: size(20.0),
          alignment: Alignment.center,
          child: Container(
            width: size(6.0),
            height: size(6.0),
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
      margin: EdgeInsets.symmetric(horizontal: size(24.0)),
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
          fontFamily: 'ocra',
          package: 'diletta_credit_card',
          fontSize: size(11.0),
          color: Color(0xff908e8e)
        ),
      );
    } else {
      name = Text(
        _holderName,
        style: TextStyle(
          fontFamily: 'ocra',
          package: 'diletta_credit_card',
          fontSize: size(11.0),
          color: _number.length > 0 ? Colors.white : Color(0xff3f3f3f),
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
      margin: EdgeInsets.only(left: size(10.0)),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'ocra',
            package: 'diletta_credit_card',
            fontSize: size(12.0),
            color: _number.length > 0 ? Colors.white : Color(0xff3f3f3f)
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

  Widget _getBlackStripe() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: size(24.0),
      color: Color(0xff000000),
    );
  }

  Widget _getCvvContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(size(34.0), size(16.0), size(56.0), size(24.0)),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size(124.0),
                height: size(6.0),
                color: Color(0xff898b8d),
              ),
              Container(
                margin: EdgeInsets.only(top: size(6.0)),
                width: size(124.0),
                height: size(6.0),
                color: Color(0xff898b8d),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              alignment: Alignment.center,
              width: size(45.0),
              height: size(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
              ),
              child: _getCvv(),
            ),
          )
        ]
      ),
    );
  }

  Widget _getCvv() {
    bool margin = false;
    List<Widget> cvv = List<Widget>();

    for (int index = 0; index < 3; index++) {
      if (_cvv.length > index) {
        cvv.add(Container(
          margin: EdgeInsets.only(left: margin ? size(2.0) : 0.0),
          height: size(20.0),
          alignment: Alignment.center,
          child: Text(
            _cvv[index],
            style: TextStyle(
              fontFamily: 'ocra',
              package: 'diletta_credit_card',
              fontSize: size(14.0),
              color: Color(0xff3f3f3f)
            ),
          ),
        ));
      } else {
        cvv.add(Container(
          margin: EdgeInsets.only(left: margin ? size(5.0) : 0.0),
          height: size(20.0),
          alignment: Alignment.center,
          child: Container(
            width: size(6.0),
            height: size(6.0),
            decoration: BoxDecoration(
              color: Color(0xffc6c5c5),
              borderRadius: BorderRadius.circular(90)
            ),
          ),
        ));
      }
      margin = true;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cvv
    );
  }

  void setResponsive(BoxConstraints constraints) {
    if (_percentage == null) {
      _percentage =  constraints.maxWidth / Consts.WIDTH;
    }
  }

  double size(double size) {
    return size * _percentage;
  }
}

class AnimationCard extends StatelessWidget {
  const AnimationCard({
    @required this.child,
    @required this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        final Matrix4 transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        transform.rotateY(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}