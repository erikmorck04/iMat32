import 'dart:math';

import 'package:api_test/app_theme.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/card_details.dart';
import 'package:api_test/widgets/customer_details.dart';
import 'package:flutter/material.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final GlobalKey<CustomerDetailsState> _customerDetailsKey =
      GlobalKey<CustomerDetailsState>();
  final GlobalKey<CardDetailsState> _cardDetailsKey = GlobalKey<CardDetailsState>();

  int _currentstep = 0;

  // Navigera till nästa steg
  void _gotoNextStep() {
    if (_currentstep == 0) {
      // Spara kundinformation innan vi går vidare
      _customerDetailsKey.currentState?.saveCustomer();
    }
    setState(() {
      _currentstep = 1;
    });
  }

  // Navigera till föregående steg
  void _gotoPreviousStep() {
    setState(() {
      _currentstep = 0;
    });
  }

  // Navigera tillbaka till "MainView"
  void _goToMain() {
    if (_currentstep == 1) {
      // Spara kortinformation innan vi avslutar
      _cardDetailsKey.currentState?.saveCard();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(context),
          ColoredBox(
            color: Colors.black,
            child: SizedBox(
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 60,
                left: 250,
                right: 250,
                bottom: 60,
              ),
              child: _currentstep == 0 ? _personalInfo() : _cardInfo(),
            ),
          ),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppTheme.paddingSmall,
        bottom: AppTheme.paddingSmall,
      ),
      color: AppTheme.customPanelColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: _goToMain,
              child: Image.asset(
                'assets/images/logoiMat-removebg-preview (1).png',
                height: 70,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: ElevatedButton(
              onPressed: _goToMain,
              child: Text('Tillbaka'),
            ),
          ),
        ],
      ),
    );
  }

  // Personlig information
  Widget _personalInfo() {
    return Container(
      color: AppTheme.customPanelColor,
      padding: const EdgeInsets.all(32),
      child: CustomerDetails(key: _customerDetailsKey),
    );
  }

  // Kortinformation
  Widget _cardInfo() {
    return Container(
      color: AppTheme.customPanelColor,
      padding: const EdgeInsets.all(32),
      child: CardDetails(key: _cardDetailsKey),
    );
  }

  // Knappar: Nästa, Tillbaka och Spara
  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentstep == 1) // Visa "Tillbaka"-knappen endast på steg 2
            ElevatedButton(
              onPressed: _gotoPreviousStep,
              child: Text('Tillbaka'),
            ),
          if (_currentstep == 0) // Visa "Nästa"-knappen endast på steg 1
            ElevatedButton(
              onPressed: _gotoNextStep,
              child: Text('Nästa'),
            ),
          if (_currentstep == 1) // Visa "Spara"-knappen på steg 2
            ElevatedButton(
              onPressed: _goToMain,
              child: Text('Spara'),
            ),
        ],
      ),
    );
  }
}