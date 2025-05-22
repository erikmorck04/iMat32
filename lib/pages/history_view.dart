import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/order.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/account_view.dart';
import 'package:api_test/pages/checkout_view.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/buy_button.dart';
import 'package:api_test/widgets/cart_view.dart';
import 'package:api_test/widgets/buy_order_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Stateful eftersom man behöver komma ihåg vilken order som är vald
// När den valda ordern ändras så ritas gränssnittet om pga
// anropet till setState
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  Order? _selectedOrder;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Provider.of eftersom denna vy inte behöver veta något om
    // ändringar i iMats data. Den visar bara det som finns nu
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);

    // Hämta datan som ska visas
    var orders = iMat.orders;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppTheme.customPanelColor,

            child: Column(
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
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 300,
                  //height: 600,
                  // Creates the list to the left.
                  // When a user taps on an item the function _selectOrder is called
                  // The Material widget is need to make hovering pliancy effects visible
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Material(
                      color: AppTheme.customPanelColor3,
                      child: _ordersList(context, orders, _selectOrder),
                    ),
                  ),
                ),
                // Creates the view to the right showing the
                // currently selected order.
                Expanded(child: _orderDetails(_selectedOrder)),
                Container(
                  width: 370,
                  //color: Colors.blueGrey,
                  child: _shoppingCart(iMat),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shoppingCart(ImatDataHandler iMat) {
    return Container(
      width: 370,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - AppTheme.paddingMedium * 2,
      ),
      decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(-2, 0), // changes position of shadow
        ),
      ],

      ), 
      padding: EdgeInsets.all(AppTheme.paddingMedium),
      child: Column(
        children: [Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Varukorg', style: TextStyle(fontSize: 30),),
            SizedBox(width: 15,),
            Icon(Icons.shopping_cart, size: 35,),],),

        Expanded(child: CartView()),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.customPanelColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppTheme.colorScheme.primary, width: 2),
          ),
          height: 100,
          //padding: EdgeInsets.all(20),
          child: Row(
          
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(
                  '${iMat.getShoppingCart().items.length} produkter',
                          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
                          ),
                ),
                Text(
                          '${iMat.getShoppingCart().items.fold(0.0, (sum, item) => sum + (item.product.price * item.amount)).toStringAsFixed(2)} kr',
                          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
                          ),
                        ),],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton(
                onPressed: () {
                  iMat.shoppingCartClear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: AppTheme.colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: Text('Töm varukorg ', style: TextStyle(fontSize: 15),),
              ),
              SizedBox(height: AppTheme.paddingSmall),
              ElevatedButton(
            onPressed: () {
              if (iMat.getShoppingCart().items.isNotEmpty) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckoutView()));
              }
              
            },
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: AppTheme.colorScheme.primary,
                    width: 1,
                  ),
                ),
            child: Text('   Till kassan   ', style: TextStyle(fontSize: 15),),
          ),],),
              
            ],
          ),
        ),
        ],)
        
      ,
    );
  }

  Container _header(BuildContext context) {
    return Container(
      color: AppTheme.customPanelColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainView()));
                },
                child: Image.asset('assets/images/logoiMat-removebg-preview (1).png', height: 70),
              ),
            ),
          ),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainView()),
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
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
                    _showHistory(context);
                  },
                ),
              ),
              SizedBox(width: 16),
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
                    _showAccount(context);
                  },
                ),
              ),
              SizedBox(width: 32),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ordersList(BuildContext context, List<Order> orders, Function onTap) {
    return ListView(
      children: [for (final order in orders.reversed) _orderInfo(order, onTap)],
    );
  }

  Widget _orderInfo(Order order, Function onTap) {
    return ListTile(
      shape: Border(
        bottom: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      onTap: () => onTap(order),
      title: Text(
        'Order ${order.orderNumber}, ${_formatDateTime(order.date)}',
        style: TextStyle(fontSize: 19, color: AppTheme.colorScheme.primary),
      ),
    );
  }

  _selectOrder(Order order) {
    setState(() {
      //dbugPrint('select order ${order.orderNumber}');
      _selectedOrder = order;
    });
  }

  // This uses the package intl
  String _formatDateTime(DateTime dt) {
    final formatter = DateFormat('yyyy-MM-dd, HH:mm');
    return formatter.format(dt);
  }

  // THe view to the right.
  // When the history is shown the first time
  // order will be null.
  // In the null case the function returns SizedBox.shrink()
  // which is a what to use to create an empty widget.
  Widget _orderDetails(Order? order) {
    var iMat = context.watch<ImatDataHandler>();
    if (order != null) {
      return ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: AppTheme.paddingMedium),
                    Text(
                      'Order ${order.orderNumber}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: AppTheme.paddingSmall),
                    Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 32.0, bottom: 8.0),
      child: Text(
        'Lägg till i varukorg',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.colorScheme.primary,
        ),
      ),
    ),
  ),
                    for (final item in order.items.reversed)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          leading: SizedBox(
                            width: 70,
                            height: 70,
                            child: iMat.getImage(item.product),
                          ),
                          title: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  width: 1,
                                ),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 1,
                            ), // Adjust this value to control border length
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              '${item.product.name}, ${item.amount}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(0),
                              backgroundColor: AppTheme.customPanelColor,
                              iconColor: Colors.white,
                            ),
                            onPressed: () {
                              var newItem = ShoppingItem(
                                item.product,
                                amount: 1.0,
                              );
                              iMat.shoppingCartAdd(newItem);
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    SizedBox(height: AppTheme.paddingSmall),
                    Text(
                      'Totalt: ${order.getTotal().toStringAsFixed(2)}kr',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: AppTheme.paddingMedium),
                    BuyOrderButton(
                      onPressed: () {
                        for (final item in order.items) {
                          var newItem = ShoppingItem(
                            item.product,
                            amount: item.amount,
                          );
                          iMat.shoppingCartAdd(newItem);
                        }
                      },
                    ),
                    SizedBox(height: AppTheme.paddingMedium),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
    // Show this when no order is selected
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          'Vänligen välj ett tidigare köp till vänster.',
          style: TextStyle(
            fontSize: 24,
            color: AppTheme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

void _showAccount(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountView()),
    );
  }

  void _showHistory(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryView()),
    );
  }

}
