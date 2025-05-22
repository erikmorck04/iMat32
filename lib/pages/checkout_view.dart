import 'dart:math';

import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/order.dart';
import 'package:api_test/model/imat/shopping_cart.dart';
import 'package:api_test/model/imat/shopping_item.dart';
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
  final GlobalKey<CustomerDetailsState> _customerFormKey = GlobalKey<CustomerDetailsState>();
  final GlobalKey<CardDetailsState> _cardFormKey = GlobalKey<CardDetailsState>();
  Order? _selectedOrder;
  List<ShoppingItem>? _confirmedItems;
  double? _confirmedTotal;
  final ScrollController _scrollController = ScrollController();

  void _gotoNextStep() {
    // Spara formulärdata innan vi går till nästa steg
    if (_currentstep == 1) {
      _customerFormKey.currentState?.saveCustomer();
    }
    
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
              _buildStep(3, 'Betalnings\nInformation'),
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
                    if (_currentstep != -1)
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.customPanelColor3,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: _buildStepIndicator(),
                      ),
                    if (_currentstep == -1) 
                      _purchaseConfirmation(handler)
                    else
                      switch (_currentstep) {
                        0 => _shoppingCart(handler),
                        1 => _personalInfo(),
                        2 => _deliveryInfo(),
                        3 => _cardInfo(),
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
          CustomerDetails(key: _customerFormKey),
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
          CardDetails(key: _cardFormKey),
          const SizedBox(height: 40),
          _actionButtons(),
        ],
      ),
    );
  }

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String _getDeliveryWindowText() {
    switch (_selectedTime?.hour) {
      case 8:
        return 'mellan kl 8:00-12:00';
      case 12:
        return 'mellan kl 12:00-15:00';
      case 15:
        return 'mellan kl 15:00-18:00';
      case 18:
        return 'mellan kl 18:00-21:00';
      default:
        return '';
    }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Välj Leveranstid',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Välj när du vill få dina varor levererade',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_selectedDate == null 
                          ? 'Välj datum' 
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                        onPressed: () async {
                          final now = DateTime.now();
                          final firstDate = now.add(const Duration(days: 1));
                          final lastDate = now.add(const Duration(days: 14));
                          
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? firstDate,
                            firstDate: firstDate,
                            lastDate: lastDate,
                          );
                          
                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Välj leveranstid',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _deliveryTimeButton('Förmiddag\n8:00-12:00', TimeOfDay(hour: 8, minute: 0)),
                              _deliveryTimeButton('Lunch\n12:00-15:00', TimeOfDay(hour: 12, minute: 0)),
                              _deliveryTimeButton('Eftermiddag\n15:00-18:00', TimeOfDay(hour: 15, minute: 0)),
                              _deliveryTimeButton('Kväll\n18:00-21:00', TimeOfDay(hour: 18, minute: 0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_selectedDate != null && _selectedTime != null) ...[
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Din leverans är planerad till ${_selectedDate!.day}/${_selectedDate!.month} ${_getDeliveryWindowText()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _deliveryTimeButton(String label, TimeOfDay time) {
    bool isSelected = _selectedTime?.hour == time.hour;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedTime = time;
        });
      },
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
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

  Widget _purchaseConfirmation(ImatDataHandler handler) {
    final items = _confirmedItems ?? [];
    final total = _confirmedTotal ?? 0.0;

    return Container(
      color: AppTheme.customPanelColor3,
      padding: const EdgeInsets.all(AppTheme.paddingHuge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Tack för ditt köp!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Din order har mottagits och behandlas nu',
            style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
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
                  'Ordersammanfattning:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      'Totalt:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${total.toStringAsFixed(2)} kr',
                      style: const TextStyle(
                        fontSize: 28,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            onPressed: _goToMain,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tillbaka till startsidan'),
                SizedBox(width: 12),
                Icon(Icons.home, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    String buttonText = _currentstep == 3 ? 'Slutför köp' : 'Nästa';
    IconData buttonIcon = _currentstep == 3 ? Icons.check_circle : Icons.arrow_forward;
    double horizontalPadding = _currentstep == 3 ? 40 : 30;
    double verticalPadding = _currentstep == 3 ? 20 : 15;
    double fontSize = _currentstep == 3 ? 24 : 20;

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
                onPressed: (){
                  _customerFormKey.currentState?.saveCustomer();
                  _cardFormKey.currentState?.saveCard();
                  _gotoPreviousStep();
                },
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
                if (_currentstep == 2 && (_selectedDate == null || _selectedTime == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vänligen välj både leveransdatum och tid'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (_currentstep == 3) {
                  final handler = Provider.of<ImatDataHandler>(context, listen: false);
                  final cart = handler.getShoppingCart();
                  setState(() {
                    _confirmedItems = List.from(cart.items);
                    _confirmedTotal = cart.items.fold(0.0, (sum, item) => sum! + (item.product.price * item.amount));
                    _customerFormKey.currentState?.saveCustomer();
                    _cardFormKey.currentState?.saveCard();
                  });

                  // Place the order and show confirmation
                  handler.placeOrder();
                  setState(() {
                    _currentstep = -1; // Show purchase confirmation
                  });
                } else {
                  _customerFormKey.currentState?.saveCustomer();
                  _cardFormKey.currentState?.saveCard();
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