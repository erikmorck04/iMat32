import 'package:api_test/app_theme.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/card_details.dart';
import 'package:api_test/widgets/customer_details.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});
  
    @override
  State<AccountView> createState() => _MainViewState();}

  class _MainViewState extends State<AccountView> {
  bool _isHovered = false; // State to track hover
  int _currentstep = 0;
  
  void _gotonextStep() {
    setState(() {
      _currentstep = 1;
    });

  }
    
  void _gotopreviousStep() {
    setState(() {
      _currentstep = 0;
    });

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
  }

  Widget _header(BuildContext context) {
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainView()));
                },
                
                  child: Image.asset('assets/images/logoiMat-removebg-preview (1).png',height: 70,)
                ,
              ),
            )),
          Row(
      children: [

        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Tillbaka'),
        ),
      ],
      )
      ]
      ),
    );
  }
  Widget _personalInfo() {
    return Container(
      color: Color.fromARGB(255, 154, 172, 134),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(child: CustomerDetails(onSave: _gotonextStep,)),
          //Align(alignment: Alignment.bottomCenter,
          //child: ElevatedButton(onPressed: _gotonextStep, child: Text('Nästa'))
          //)
        ]
      ),

    );
  }
    Widget _cardInfo() {
    return Container(
      color: Color.fromARGB(255, 124, 215, 223),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(child: CardDetails()),
          Align(alignment: Alignment.bottomCenter,
          child: ElevatedButton(onPressed: _gotopreviousStep, child: Text('Gå tillbaka'))
          )
        ]
      ),

    );
  }
}
