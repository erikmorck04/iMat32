import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/order.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/widgets/buy_button.dart';
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
          SizedBox(height: AppTheme.paddingLarge),
          _header(context),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 300,
                  //height: 600,
                  // Creates the list to the left.
                  // When a user taps on an item the function _selectOrder is called
                  // The Material widget is need to make hovering pliancy effects visible
                  child: Material(
                    color: AppTheme.customPanelColor,
                    child: _ordersList(context, orders, _selectOrder),
                  ),
                ),
                // Creates the view to the right showing the
                // currently selected order.
                Expanded(child: _orderDetails(_selectedOrder)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      color: AppTheme.customPanelColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('iMat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Tillbaka'),
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
            color: Color.fromARGB(255, 228, 228, 228),
            width: 300,
            child: Column(
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
                          width: 50,
                          height: 50,
                          child: iMat.getImage(item.product),
                        ),
                        SizedBox(width: 40),

                        Text('${item.product.name}, ${item.amount}'),
                      ],
                    ),
                  ),
                SizedBox(height: AppTheme.paddingSmall),
                Text(
                  'Totalt: ${order.getTotal().toStringAsFixed(2)}kr',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
