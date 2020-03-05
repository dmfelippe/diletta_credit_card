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
              isCvvFocused: false
            ),
          ),
          _getNumberField(),
          _getHolderNameField(),
          _getExpiryDateField()
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
}