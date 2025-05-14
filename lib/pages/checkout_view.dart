import 'package:api_test/app_theme.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:flutter/material.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutView();
}

class _CheckoutView extends State<CheckoutView> {
  int _currentstep = 0;
  bool _isHovered = false; // State to track hover

  void _goToMain() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainView()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(context),
          Expanded(child: 
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 250, right: 250, bottom: 60), 
            child: _currentstep == 0 ? _personalInfo() : _cardInfo()
          ),

          )
        ],
          ),
    );
  }Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: AppTheme.paddingSmall, bottom: AppTheme.paddingSmall),
      color: AppTheme.customPanelColor,
      
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false), 
              child:
              GestureDetector(
                onTap: () {
                  _goToMain();
                },
                
                  child: Image.asset('assets/images/logoiMat-removebg-preview (1).png',height: 70,)
                ,
              ),
            )),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: ElevatedButton(onPressed: _goToMain, child: Text('Tillbaka')),
            )
          ],
        )
      ]
      ),
    );
  }
}