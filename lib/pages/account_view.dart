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
          SizedBox(height: AppTheme.paddingSmall),
          _header(context),
          SizedBox(height: AppTheme.paddingSmall),
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

  Container _header(BuildContext context) {
    return Container(
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
            )
            ),
            SizedBox(width: 32),
          Container(width: 700,
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
            ),),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: AppTheme.colorScheme.primary, width: 1),
          ),
        ),
        icon: Icon(Icons.home, size: 32, color: AppTheme.colorScheme.primary),
        label: Text(
          'Hem',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainView()),);
        },
      ),
    ),
    SizedBox(width: 32),
              SizedBox(
      height: 50, // Match your search bar height
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: AppTheme.colorScheme.primary, width: 1),
          ),
        ),
        icon: Icon(Icons.history, size: 32, color: AppTheme.colorScheme.primary),
        label: Text(
          'Köphistorik',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryView()),);
        },
      ),
    ),
              SizedBox(width: 32),
    SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: AppTheme.colorScheme.primary, width: 1),
          ),
        ),
        icon: Icon(Icons.person, size: 32, color: AppTheme.colorScheme.primary),
        label: Text(
          'Användare',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountView()),);
        },
      ),
    ),
    
    SizedBox(width: 100)
            ],
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
        CustomerDetails(key: customerKey),
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
          CardDetails(key: cardKey),
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
              onPressed: () {
              customerKey.currentState?.saveCustomer();
              _gotoNextStep();           
              },
              child: Text('Nästa'),
            ),
          if (_currentstep == 1) 
            ElevatedButton(
              onPressed: (){
                cardKey.currentState?.saveCard();
                _goToMain();
              },
              child: Text('Spara'),
            ),
        ],
      ),
    );
  }
}