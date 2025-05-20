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
  final ScrollController _scrollController = ScrollController();

  void _gotoNextStep() {
    setState(() {
      _currentstep += 1;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _gotoPreviousStep() {
    setState(() {
      _currentstep -= 1;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Steg i kassan',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStep(0, 'Din\nVarukorg'),
              _buildStepLine(0),
              _buildStep(1, 'Dina\nUppgifter'),
              _buildStepLine(1),
              _buildStep(2, 'Välj\nLeverans'),
              _buildStepLine(2),
              _buildStep(3, 'Dina\nBetalningsuppgifter'),
              _buildStepLine(3),
              _buildStep(4, 'Bekräfta\nKöp'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int step, String label) {
    bool isActive = _currentstep >= step;
    bool isCurrent = _currentstep == step;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCurrent ? Colors.green : (isActive ? Colors.white : Colors.grey[200]),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.green : Colors.grey[400]!,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isCurrent ? Colors.white : (isActive ? Colors.green : Colors.grey[600]),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.green : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 18,
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
        color: isActive ? Colors.green : Colors.grey[300],
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
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 370,
                  right: 370,
                  bottom: 60,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.customPanelColor3,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: _buildStepIndicator(),
                    ),
                    switch (_currentstep) {
                      0 => _shoppingCart(handler),
                      1 => _personalInfo(),
                      2 => _deliveryInfo(),
                      3 => _cardInfo(),
                      4 => _orderSummary(),
                      _ => _personalInfo(),
                    },
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Betalningsinformation',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Fyll i dina kortuppgifter nedan',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 30),
          CardDetails(),
          const SizedBox(height: 40),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _orderSummary() {
    final ImatDataHandler handler = Provider.of<ImatDataHandler>(context);
    final cart = handler.getShoppingCart();
    final items = cart.items;
    final total = cart.items.fold(0.0, (sum, item) => sum + (item.product.price * item.amount));

    return Container(
      color: AppTheme.customPanelColor3,
      padding: const EdgeInsets.only(
        top: AppTheme.paddingHuge,
        left: AppTheme.paddingHuge,
        right: AppTheme.paddingHuge,
        bottom: AppTheme.paddingHuge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bekräfta din beställning',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Kontrollera din beställning en sista gång innan du slutför köpet',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Din varukorg:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            '${item.amount}x',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              item.product.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            '${(item.product.price * item.amount).toStringAsFixed(2)} kr',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Totalt att betala:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${total.toStringAsFixed(2)} kr',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
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
            'Din Varukorg',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            'Här är varorna du har valt att köpa',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 2,
              height: 40,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: handler.getImage(item.product),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.product.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text(
                          'Antal',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.amount} st',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text(
                          'Pris',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.product.price} kr',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Text(
                  'Totalt att betala:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${handler.getShoppingCart().items.fold(0.0, (sum, item) => sum + (item.product.price * item.amount)).toStringAsFixed(2)} kr',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    String buttonText = _currentstep == 4 ? 'Slutför köp' : 'Nästa';
    IconData buttonIcon = _currentstep == 4 ? Icons.check_circle : Icons.arrow_forward;
    double horizontalPadding = _currentstep == 4 ? 40 : 30;
    double verticalPadding = _currentstep == 4 ? 20 : 15;
    double fontSize = _currentstep == 4 ? 24 : 20;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentstep > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: _gotoPreviousStep,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 24),
                    SizedBox(width: 8),
                    Text('Tillbaka'),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (_currentstep == 4) {
                  final handler = Provider.of<ImatDataHandler>(context, listen: false);
                  handler.placeOrder();
                  _goToMain();
                } else {
                  _gotoNextStep();
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(buttonText),
                  SizedBox(width: _currentstep == 4 ? 12 : 8),
                  Icon(buttonIcon, size: _currentstep == 4 ? 28 : 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}