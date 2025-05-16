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

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      color: AppTheme.customPanelColor3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(0, 'Varukorg'),
          _buildStepLine(0),
          _buildStep(1, 'Personlig Information'),
          _buildStepLine(1),
          _buildStep(2, 'Leverans'),
          _buildStepLine(2),
          _buildStep(3, 'Betalning'),
        ],
      ),
    );
  }

  Widget _buildStep(int step, String label) {
    bool isActive = _currentstep >= step;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey[400],
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.green : Colors.grey[400]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.green : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    bool isActive = _currentstep > step;
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.green : Colors.grey[400],
        margin: const EdgeInsets.symmetric(horizontal: 8),
      ),
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
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 120,
                  left: 370,
                  right: 370,
                  bottom: 60,
                ),
                child: switch (_currentstep) {
                  0 => _shoppingCart(handler),
                  1 => _personalInfo(),
                  2 => _deliveryInfo(),
                  3 => _cardInfo(),
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
      color: AppTheme.customPanelColor3,
      padding: const EdgeInsets.only(
        top: AppTheme.paddingHuge,
        left: AppTheme.paddingHuge,
        right: AppTheme.paddingHuge,
        bottom: AppTheme.paddingHuge,
      ),
      child: Column(
        children: [
          CustomerDetails(),
          SizedBox(height: 50),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _cardInfo() {
    return Container(
      color: AppTheme.customPanelColor3,
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

  Widget _deliveryInfo() {
    return Container(
      color: AppTheme.customPanelColor3,
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

  Widget _shoppingCart(ImatDataHandler handler) {
    final cart = handler.getShoppingCart();
    final items = cart.items;

    return Container(
      color: AppTheme.customPanelColor3,
      padding: const EdgeInsets.all(AppTheme.paddingHuge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Varukorg',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: handler.getImage(item.product),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.product.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.amount} st',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.product.price} kr',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Summa ${handler.getShoppingCart().items.fold(0.0, (sum, item) => sum + (item.product.price * item.amount)).toStringAsFixed(2)} kr',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
          if (_currentstep < 3)
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