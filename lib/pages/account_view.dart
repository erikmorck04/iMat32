import 'dart:math';

import 'package:api_test/app_theme.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/card_details.dart';
import 'package:api_test/widgets/customer_details.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  int _currentstep = 0;

  void _gotoNextStep() {
    setState(() {
      _currentstep = 1;
    });
  }

  void _gotoPreviousStep() {
    setState(() {
      _currentstep = 0;
    });
  }

  void _goToMain() {
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 250,
                  right: 250,
                  bottom: 120,
                ),
                child: _currentstep == 0 ? _personalInfo() : _cardInfo(),
              ),
            ),
          ),
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

  Widget _personalInfo() {
    return Container(
      color: AppTheme.customPanelColor,
      padding: const EdgeInsets.only(
        top: AppTheme.paddingHuge,
        left: AppTheme.paddingHuge,
        right: AppTheme.paddingHuge,
        bottom: AppTheme.paddingHuge,
      ),
      child: Column(children: [
        CustomerDetails(),
        SizedBox(height: 50),
        _actionButtons(),
      ],
      ),
    );
  }

  Widget _cardInfo() {
    return Container(
      color: AppTheme.customPanelColor,
      padding: const EdgeInsets.only(
        top: AppTheme.paddingHuge,
        left: AppTheme.paddingHuge,
        right: AppTheme.paddingHuge,
        bottom: AppTheme.paddingHuge,
      ),
      child: Column(
        children: [
          CardDetails(),
          SizedBox(height: 146),
          _actionButtons(),
        ],
      ),
    );
  }
  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentstep == 1) 
            ElevatedButton(
              onPressed: _gotoPreviousStep,
              child: Text('Tillbaka'),
            ),
          if (_currentstep == 0)
            ElevatedButton(
              onPressed: _gotoNextStep,
              child: Text('Nästa'),
            ),
          if (_currentstep == 1) 
            ElevatedButton(
              onPressed: _goToMain,
              child: Text('Spara'),
            ),
        ],
      ),
    );
  }
}