import 'dart:math';

import 'package:api_test/app_theme.dart';
import 'package:api_test/pages/history_view.dart';
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
  final GlobalKey<CustomerDetailsState> customerKey = GlobalKey();
  final GlobalKey<CardDetailsState> cardKey = GlobalKey();
  int _currentstep = 0;
  bool _isHovered = false;

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
            color: AppTheme.colorScheme.primary,
            child: SizedBox(
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 250,
                  right: 250,
                  bottom: 120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentstep == 0 ? 
                              'Dina Personuppgifter' : 
                              'Dina Betaluppgifter',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _currentstep == 0 ?
                              'Här kan du se och ändra dina personuppgifter' :
                              'Här kan du se och ändra dina betaluppgifter',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _currentstep == 0 ? _personalInfo() : _cardInfo(),
                  ],
                ),
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
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomerDetails(key: customerKey),
          const SizedBox(height: 50),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _cardInfo() {
    return Container(
      color: AppTheme.customPanelColor,
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardDetails(key: cardKey),
          const SizedBox(height: 50),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentstep == 1) 
            _buildActionButton(
              onPressed: _gotoPreviousStep,
              label: 'Tillbaka till Personuppgifter',
              icon: Icons.arrow_back,
            ),
          if (_currentstep == 0)
            _buildActionButton(
              onPressed: () {
                customerKey.currentState?.saveCustomer();
                _gotoNextStep();           
              },
              label: 'Gå till Betaluppgifter',
              icon: Icons.arrow_forward,
              isPrimary: true,
            ),
          if (_currentstep == 1) 
            _buildActionButton(
              onPressed: () {
                cardKey.currentState?.saveCard();
                _goToMain();
              },
              label: 'Spara och Avsluta',
              icon: Icons.check_circle,
              isPrimary: true,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    bool isPrimary = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.green : Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isPrimary) Icon(icon, size: 24),
            if (!isPrimary) const SizedBox(width: 8),
            Text(label),
            if (isPrimary) const SizedBox(width: 8),
            if (isPrimary) Icon(icon, size: 24),
          ],
        ),
      ),
    );
  }
}