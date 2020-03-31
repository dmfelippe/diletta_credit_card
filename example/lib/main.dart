import 'package:flutter/material.dart';

import 'package:diletta_credit_card/dilettaCreditCard.dart';

void main() => runApp(
  MaterialApp(
    title: 'Diletta Credit Card Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: DemoCreditCard(title: 'Diletta Credit Card Demo'),
  )
);

class DemoCreditCard extends StatefulWidget {
  final String title;

  DemoCreditCard({@required this.title});

  @override
  _DemoCreditCardState createState() => _DemoCreditCardState();
}

class _DemoCreditCardState extends State<DemoCreditCard> {
  @override
  void initState() {
    super.initState();
    //Future.delayed(Duration(milliseconds: 500), () {setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Color(0xffff7753),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(40.0),
            child: DilettaCreditCard(
              number: '',
              holderName: '',
              expiryDate: '',
              cvv: '',
            ),
          ),
          _getNumberField(),
          _getHolderNameField(),
          _getExpiryDateField(),
          _getCvvField(),
          _cvv()
        ],
      ),
    );
  }

  Widget _getNumberField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Number'
        ),
        keyboardType: TextInputType.number,
        controller: CreditCardService().numberController,
      ),
    );
  }

  Widget _getHolderNameField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Nome'
        ),
        keyboardType: TextInputType.text,
        controller: CreditCardService().holderNameController,
      ),
    );
  }

  Widget _getExpiryDateField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Data Expiração'
        ),
        keyboardType: TextInputType.number,
        controller: CreditCardService().expiryDateController,
      ),
    );
  }

  Widget _getCvvField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'CVV'
        ),
        keyboardType: TextInputType.number,
        controller: CreditCardService().cvvController,
      ),
    );
  }

  Widget _cvv() {
    return InkWell(
      onTap: () {
        CreditCardService().changeCvv();
      },
      child: Container(width: 200.0, height: 40.0, color: Colors.amber),
    );
  }
}