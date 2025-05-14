import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/order.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/account_view.dart';
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
                      color: Colors.white,
                      child: _ordersList(context, orders, _selectOrder),
                    ),
                  ),
                ),
                // Creates the view to the right showing the
                // currently selected order.
                Expanded(child: _orderDetails(_selectedOrder)),
                Container(
                  width: 400,
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
      width: 300,
      constraints: BoxConstraints(
        minHeight:
            MediaQuery.of(context).size.height - AppTheme.paddingMedium * 2,
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
        children: [
          Text('Kundvagn'),
          Expanded(child: CartView()),
          ElevatedButton(
            onPressed: () {
              iMat.placeOrder();
            },
            child: Text('Köp!'),
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
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainView()),
                  );
                },

                child: Image.asset(
                  'assets/images/logoiMat-removebg-preview (1).png',
                  height: 70,
                ),
              ),
            ),
          ),
          Container(
            width: 700,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Sök produkter...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (value) {
                  var iMat = Provider.of<ImatDataHandler>(
                    context,
                    listen: false,
                  );
                  if (value.isEmpty) {
                    iMat.selectAllProducts();
                  } else {
                    iMat.selectSelection(iMat.findProducts(value));
                  }
                },
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryView()),
                  );
                },
                child: Text('Köphistorik'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountView()),
                  );
                },
                child: Text('Användare'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ordersList(BuildContext context, List<Order> orders, Function onTap) {
    return ListView(
      children: [for (final order in orders) _orderInfo(order, onTap)],
    );
  }

  Widget _orderInfo(Order order, Function onTap) {
    return ListTile(
      shape: Border(bottom: BorderSide(color: Colors.black)),
      onTap: () => onTap(order),
      title: Text('Order ${order.orderNumber}, ${_formatDateTime(order.date)}'),
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Order ${order.orderNumber}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: AppTheme.paddingSmall),
                for (final item in order.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: iMat.getImage(item.product),
                        ),
                        SizedBox(width: 40),

                        BuyButton(
                          onPressed: () {
                            iMat.shoppingCartAdd(ShoppingItem(item.product));
                          },
                        ),
                        SizedBox(width: 40),

                        Text(
                          '${item.product.name}, ${item.amount}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: AppTheme.paddingSmall),
                Text(
                  'Totalt: ${order.getTotal().toStringAsFixed(2)}kr',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(height: AppTheme.paddingMedium),
                BuyOrderButton(
                  onPressed: () {
                    for (final item in order.items) {
                      iMat.shoppingCartAdd(item);
                    }
                    ;
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }
}
