import 'dart:math';

import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/order.dart';
import 'package:api_test/model/imat/shopping_cart.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/card_details.dart';
import 'package:api_test/widgets/customer_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  int _currentstep = 0;
  Order? _selectedOrder;


  void _gotoNextStep() {
    setState(() {
      _currentstep += 1;
    });
  }

  void _gotoPreviousStep() {
    setState(() {
      _currentstep -= 1;
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
    final ImatDataHandler handler = Provider.of<ImatDataHandler>(context);

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
                  top: 120,
                  left: 370,
                  right: 370,
                  bottom: 60,
                ),
                
                child: switch(_currentstep){
                  0 => _varukorg(handler),
                  1 => _deliveryInfo(),
                  2 => _cardInfo(),
                  3 => _personalInfo(),
                  _ => _personalInfo(),
                },
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

  Widget _deliveryInfo(){
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
          // Delivery details widget goes here
          SizedBox(height: 146),
          _actionButtons(),
        ],
      ),
    );
  }
  Widget _varukorg(ImatDataHandler handler) {
    final cart = handler.getShoppingCart();
    final items = cart.items;
    return Container(
      color: AppTheme.customPanelColor,
      padding: const EdgeInsets.only(
        top: AppTheme.paddingHuge,
        left: AppTheme.paddingHuge,
        right: AppTheme.paddingHuge,
        bottom: AppTheme.paddingHuge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Varukorg',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...items.map((item) {
            return ListTile(
              title: Text(item.product.name),
              trailing: Text('${item.product.price} kr'),
            );
          }).toList(),
          
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
          if (_currentstep > 0) 
            ElevatedButton(
              onPressed: _gotoPreviousStep,
              child: Text('Tillbaka'),
            ),
          if (_currentstep < 3 )
            ElevatedButton(
              onPressed: _gotoNextStep,
              child: Text('Nästa'),
            ),
          if (_currentstep == 3) 
            ElevatedButton(
              onPressed: _goToMain,
              child: Text('Betala'),
            ),
        ],
      ),
    );
  }


}