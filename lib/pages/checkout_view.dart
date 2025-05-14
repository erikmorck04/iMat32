import 'package:flutter/material.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutView();
}

class _CheckoutView extends State<CheckoutView> {
  int _currentstep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(context),
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
        ],
      ),
    );
  }
}
